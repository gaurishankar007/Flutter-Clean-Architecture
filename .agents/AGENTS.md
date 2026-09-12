# Clean Architecture Flutter — Agent Rules (AGENTS.md)

> These rules apply to every AI agent or assistant working in this workspace. Follow them strictly.

---

## 1. Project Identity

- **App Name:** Clean Architecture — a reference/template app demonstrating Feature-first Clean Architecture with SOLID principles.
- **Architecture:** Feature-first Clean Architecture (data/domain/presentation) using Flutter + `flutter_bloc` (Cubits).
- **Platforms:** Android, iOS, Web.
- **Flavors:** `development`, `staging`, `production`.
- **Entry Points:** `lib/main_dev.dart`, `lib/main_stg.dart`, `lib/main.dart`.

---

## 2. Mandatory Rules (Never Violate)

- **BEFORE** performing any task, **ALWAYS** consult `README.md` (Project Structure, State Management, Data Handling sections) and `docs/` (`testing.md` for test conventions, `solid_principles.md` for the SOLID rationale) for established patterns. Only read what's needed to minimize context usage.
- **NEVER** use relative imports. Always use package imports (enforced by the `always_use_package_imports` lint rule):
  ```dart
  // ✅ Correct
  import 'package:clean_architecture/core/clients/remote/http/http_client.dart';
  // ❌ Wrong
  import '../../core/clients/remote/http/http_client.dart';
  ```
- **NEVER** write business logic inside pages or widgets. Business logic belongs exclusively in Cubits (`presentation/cubits/`). This includes resolving a use case/repository directly from a widget — every flow needs a Cubit, even a trivial one, so it goes through the same state/message pattern as the rest of the app.
- **NEVER** access `LocalStorageClient`, `HttpClient`, or another feature's data source directly from a Cubit or widget. Go through the feature's own repository/use-case layer.
- **NEVER** use `void` as the return type of an `async` method. Use `Future<void>` (enforced by the `avoid_void_async` lint).
- **NEVER** show a toast/message or perform navigation from inside a Cubit. A Cubit only computes state; showing that state (via `ToastUtil`) and reacting to it (navigating) is the UI layer's job. See "Messages & Navigation" below.

---

## 3. Code Style

This project uses `leancode_lint` (see `analysis_options.yaml`) plus a few extra rules.

- **String literals:** Use single quotes (`'`).
- **Constants:** Prefer `const` constructors and declarations wherever possible.
- **Control flow:** Always put `if`, `for`, and `while` bodies on a new line.
- **Constructors:** Always sort constructors first in class declarations.
- **Lambdas:** Avoid unnecessary lambdas; prefer method tearoffs.
- **Comments:** Keep them short, straight to the point, and single-line wherever possible. Don't write multi-line prose explaining what the code already shows — only note the non-obvious "why" (an edge case, a workaround, a load-bearing ordering), and say it in as few words as it takes.

---

## 4. Architecture Rules

### State Management

- All Cubits must extend `BaseCubit<T>` (`shared_ui/cubits/base/base_cubit.dart`).
- All Cubit states must extend `BaseState`, using `StateStatus` (`initial`/`loading`/`loaded`/`noInternet`/`error`).
- UI layers must use `ToastUtil` to present messages; do not use `SnackBar` directly.

### Messages & Navigation (UI-only)

Cubits never call `ToastUtil` or navigate directly — both are UI-layer concerns:

- A Cubit reports outcomes by setting `BaseState.message` (a `StateMessage?`:
  `SuccessMessage`/`ErrorMessage`/`WarningMessage`). Derive it from a
  `DataState` with `stateMessageFromDataState(dataState, {message: '...'})`,
  or construct `SuccessMessage`/`ErrorMessage`/`WarningMessage` directly for a
  manual message. A state's `copyWith`/constructor must **never** preserve
  the previous `message` (`message: message`, never `message ?? this.message`)
  so a message is shown exactly once.
- The page that provides the Cubit wires `useCubitMessageListener(cubit)`
  (`shared_ui/utils/cubit_message_listener.dart`, a `flutter_hooks` hook) to
  actually show that message via `ToastUtil`. Get the cubit instance directly
  (e.g. via `useMemoized`) and pass it to both `BlocProvider.value` and the
  listener hook — see `login_page.dart`.
- A Cubit method that used to navigate itself instead returns a result —
  typically `Future<bool>` (did it succeed), or an `enum` for more than one
  outcome — and the calling widget awaits it and navigates via
  `NavigationUtil.I`. See `LoginCubit`/`login_button.dart` and
  `DashboardCubit`/its drawer/bottom-nav/setting-page call sites for worked
  examples.
- **`StateMessage` subclasses must stay `Equatable`** — this matters for
  testing (see `docs/testing.md`); don't remove that if you touch
  `base_state.dart`.

### UI / Widget Composition

Two layers, each with one job — don't blur them:

1. **Base widgets** (`shared_ui/ui/base/`) — app-wide, zero domain knowledge,
   pure styling (`BaseText`, `PrimaryButton`/`SecondaryButton`,
   `BaseTextField`, `BaseScaffold`, etc.). Before adding a new base widget,
   check whether an existing one can take a variant/parameter instead of
   creating a near-duplicate sibling.
2. **Feature-local widgets** (`features/*/presentation/widgets/`, or a
   page's own `widgets/` folder) — domain-aware, wire a Cubit's state into
   base widgets. Presentation only; see the business-logic rule above.

If a widget is reusable across features but still domain-aware, or a
feature-agnostic composed pattern (e.g. an empty-state placeholder) emerges,
give it its own home under `shared_ui/ui/` (outside `base/`) rather than
duplicating it per feature.

Other rules:

- **Text styling must go through `BaseText`'s factory constructors** — never
  construct a raw `TextStyle` inline in a feature or base widget.
- **Extract widgets as classes, not private methods.** A `StatefulWidget`
  with `Widget _buildFoo() => ...` helper methods should instead be
  `class _Foo extends StatelessWidget`. Private methods returning widgets
  don't get their own `Element`/subtree, so Flutter can't skip rebuilding
  them independently and they lose `const` opportunities.
- Pages (`@RoutePage()` files) should stay thin: lifecycle glue
  (`initState`/`dispose`) if `StatefulWidget`, otherwise just composing
  already-extracted widgets. Push conditionals/styling down into extracted
  widgets rather than growing the page's own `build()`.

### Dependency Injection

- Use `@LazySingleton`, `@injectable`, or `@singleton` annotations.
- **Always** run the build runner after adding or modifying any injectable class, repository implementation, or client:
  ```bash
  dart run build_runner build
  ```

### Data Layer

- Data models implement `DomainConvertible<R>` (`R toDomain()`, see
  `core/data/models/domain_convertible.dart`); repositories call
  `.toDomain()` on the fetched model to map it to the domain entity.
- Always check connectivity via `InternetClient.isConnected` before making
  API calls, and pass it to `RepositoryFetcher`.
- Use `ApiExecutor` for HTTP responses and `RepositoryFetcher.fetchWithFallback(And Map)` for offline-first data flows.
- **Always** use `SuccessState.nil` as the return value for `FutureVoid`-typed methods that succeed. **NEVER** use `SuccessState(data: null)` or `SuccessState(data: true)`.
- **Always** use `FutureVoid` (not `FutureBool`) for a method whose result no caller actually reads (only `hasData`/`errorType` matters to the caller). Reserve `FutureBool` for methods where the caller genuinely branches on the returned `bool` (e.g. `checkAuth()`).
- Import shared typedefs (`FutureData`, `FutureVoid`, `JsonMap`, etc.) from `core/types/types.dart` — there is no `core/utils/type_defs.dart` (removed).

---

## 5. Project Structure Rules

When creating new features or files, strictly follow this layout:

```
lib/features/<feature_name>/
    ├── data/
    │   ├── data_sources/
    │   ├── models/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── use_cases/       # optional
    └── presentation/
        ├── cubits/
        ├── pages/
        └── widgets/
```

**When to use Mason instead of writing manually:**

- New feature → `mason make cubit_feature -c config.json`
- New page + Cubit within an existing feature → `mason make cubit_page -c config.json`

---

## 6. Testing Rules

This project **has** a real test suite (`test/`, `testing/`, `patrol_test/`) —
see [`docs/testing.md`](docs/testing.md) before writing any tests. In short:

- Unit/widget tests live in `test/`, mirroring `lib/`'s directory structure.
- Mock with `mocktail` (never mockito/generated mocks); shared mocks live in
  `testing/mocks/`, shared helpers in `testing/helpers/`.
- Cubit tests use `bloc_test`; widget tests use `patrol_finders`
  (`patrolWidgetTest`), not the plain `flutter_test` finders.
- Integration tests live in `patrol_test/` using the Patrol framework.
- When testing a Cubit that follows the Messages & Navigation pattern above,
  assert on `state.message` and the returned value/use-case calls — not on a
  mocked `NavigationClient` call from inside the Cubit (that verification
  belongs in the **page**'s widget test instead, since navigation now
  happens there).
- If test coverage requirements are ambiguous, ask the user rather than
  inventing a convention.

---

## 7. Code Generation

Whenever routes or injectable registrations change, regenerate code:

```bash
dart run build_runner build
# or, while iterating:
flutter pub run build_runner watch
```

---

## 8. Available Custom Skills

The following agent skills are available in `.agents/skills/`:

- **`codegen`** — Runs `build_runner` code generation.
- **`scaffolding`** — Uses `mason` to scaffold features and pages.
- **`api_integration`** — Automates integrating a new API endpoint through the data source → repository → domain layers.

`.agents/workflows/release.md` documents how a release actually reaches
testers via the Firebase App Distribution CI — consult it before proposing
or invoking any release step (see the CI/CD section below).

---

## 9. CI/CD

- `.github/actions/build-android/action.yml`: composite action — sets up
  Java/Flutter, writes `.env` from secrets, runs `flutter analyze` and
  `flutter test`, then `flutter build apk --release --flavor <flavor>
  --target <entrypoint>`.
- `.github/workflows/firebase_app_distribution.yml`: on push to `staging`
  builds and distributes the staging APK; on push to `master` builds and
  distributes the production APK; both to Firebase App Distribution. Also
  runnable manually (`workflow_dispatch`) with custom release notes.
- Keep the workflow's pinned Flutter version in sync with the version this
  repo is actually developed against (check `flutter --version` locally
  before bumping it).

---

## 10. Code Quality, Analysis & Linting

This project strictly follows the linting rules provided by the `leancode_lint` package (configured in `analysis_options.yaml`).

- **Always** ensure your code passes `flutter analyze` with zero issues, and `flutter test` passes, after any code modification/creation in `.dart` files.
- If you are unsure about a specific rule, refer to the [leancode_lint documentation](https://pub.dev/packages/leancode_lint).

### Verification

```bash
flutter analyze
flutter test
```

---

## 11. What NOT to Do

| ❌ Don't                                          | ✅ Do Instead                                                                |
| -------------------------------------------------- | ------------------------------------------------------------------------------ |
| Write business logic in pages/widgets              | Put it in a Cubit                                                              |
| Use relative imports                                | Use `package:clean_architecture/...` imports                                   |
| Hardcode API URLs                                   | Use `AppConfig` via the flavor system                                          |
| Use `SnackBar` directly                             | Use `ToastUtil`                                                                |
| Show a toast or navigate from a Cubit               | Set `BaseState.message` / return a result and let the UI show it or navigate   |
| Create feature files manually                       | Use `mason make cubit_feature`/`cubit_page`                                    |
| Use bare `try`/`catch` in data code                 | Use `ErrorHandlerProvider.I.execute`/`executeSafe*`                            |
| Use `FutureBool` when no caller reads the bool      | Use `FutureVoid` + `SuccessState.nil`                                          |
| Import `core/utils/type_defs.dart`                  | Import `core/types/types.dart`                                                |
| Violate `leancode_lint` rules                       | Fix all analysis issues                                                       |
| Skip analysis/tests after changes                   | Run `flutter analyze` and `flutter test`                                       |
| Call a use case/repository from a widget            | Route it through a Cubit                                                      |
| Hardcode a `TextStyle` in a widget                  | Use `BaseText`'s factories                                                    |
| Extract a widget as a private `_buildX()` method    | Extract it as its own widget class                                            |
