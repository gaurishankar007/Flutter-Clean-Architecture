# Testing Guide

This project has real test coverage (unit, widget, and E2E). Consult this doc
before writing new tests.

## Layout

- **Unit/widget tests** live in `test/`, mirroring `lib/`'s directory
  structure 1:1 (e.g. `lib/features/auth/domain/use_cases/login_use_case.dart`
  → `test/features/auth/domain/use_cases/login_use_case_test.dart`).
- **Shared mocks** live in `testing/mocks/` (`client_mocks.dart`,
  `data_source_mocks.dart`, `repository_mocks.dart`, `service_mocks.dart`,
  `use_case_mocks.dart`, `external/`), **shared test helpers** in
  `testing/helpers/` (e.g. `dio_response_helper.dart`). Add a new class's
  mock here rather than redefining it inline in a test file.
- **Integration tests** live in `patrol_test/` and use the
  [Patrol](https://pub.dev/packages/patrol) framework.
- **Issue regression tests** are the one exception to mirroring `lib/`: they
  live together in `test/regression/`. See [Regression tests](#regression-tests).

## Conventions

- **Mock with `mocktail`** (`class MockX extends Mock implements X {}`) -
  never hit real services, HTTP, or platform channels from a unit test.
  This project does not use `mockito`/generated mocks.
- **Cubit tests use `bloc_test`** (`blocTest<TheCubit, TheState>(...)`).
- **Widget tests use `patrol_finders`** (`patrolWidgetTest`, the `$` finder)
  for more robust widget discovery than the plain `flutter_test` finders.
- **Prefer text or type finders**: a text finder (`$('...')`) when the
  on-screen copy is unique, or a type finder (`find.byType(...)`, narrowed
  with `.at(index)` or an ancestor/descendant chain) when it isn't. Only add a
  `Key` to production code when a finder would otherwise be genuinely
  ambiguous (e.g. two same-type widgets with no distinguishing text, or an
  icon-only button).
- Register fallback values (`registerFallbackValue`) in `setUpAll` for any
  argument type matched with `any()`.
- If test coverage requirements are ambiguous, ask rather than inventing a
  convention.
- **Don't rewrite tests on every iteration**: while a change is still being
  reviewed or tweaked, get the implementation validated first, then update
  its tests in one pass. A self-contained task ("fix this bug and add a
  test") updates them right away.
- **Animated overlays (toasts)**: don't `pumpAndSettle` to wait for one to
  close - its progress bar keeps scheduling frames, so it also runs through
  the next queued toast. Pump frame by frame instead (see
  `test/shared_ui/utils/toast_util_test.dart`), and reset static state such
  as `ToastUtil.reset()` in `setUp`.

## Testing the Cubit/UI-separation pattern

Every `BaseCubit` reports outcomes via `BaseState.message`
(`SuccessMessage`/`ErrorMessage`/`WarningMessage`/`NormalMessage`, see
`lib/shared_ui/cubits/base/base_state.dart`) instead of calling `ToastUtil` or
navigating directly - see "State Management with Bloc (Cubit)" in the
[README](../README.md#state-management-with-bloc-cubit) for the full
pattern. This changes what a cubit test should assert:

- **Assert on `state.message`**, not on a mocked navigation/toast call - a
  cubit method that changes state should be asserted with `blocTest`'s
  `expect: () => [...]`, checking the emitted `LoginState`/`FooState`
  including its `message` field.
- **`StateMessage` subclasses (`SuccessMessage`/`ErrorMessage`/
  `WarningMessage`/`NormalMessage`) must stay `Equatable`** (they extend it in
  `base_state.dart`) so `blocTest`'s exact-state equality checks work. If you
  add a new `StateMessage` subclass, keep it `Equatable` too - this is easy
  to miss because `cg-warehouse` (the sibling reference app this pattern was
  ported from) has no test suite and never needed it.
- A cubit method that used to navigate itself now returns a result
  (typically `Future<bool>`, or an `enum` for more than one outcome) - assert
  that return value directly, and verify the *use case*/*repository* calls
  it triggers (e.g. `setSession`, `saveUserData`), not a `NavigationClient`
  call, since the cubit itself no longer navigates.
- A page wiring `useCubitMessageListener(cubit)` and navigating from a
  button's `onTap` (via `NavigationUtil.I`) should still assert the
  navigation in its **widget** test (mock `NavigationClient`, `verify(() =>
  mockNavigationClient.replaceAllRoute(any())).called(1)`, registering a
  `<PageRouteInfo>[]` fallback value), since that's now
  the UI layer's responsibility. See
  `test/features/auth/presentation/pages/login_page_test.dart` and
  `test/features/auth/presentation/cubits/login_cubit_test.dart` for a
  worked example of both halves of this split.

## Regression tests

Regression tests pin the fix (or the expected fixed behaviour) for a specific
GitHub issue so it can't silently break again. They are widget/unit tests,
but they don't mirror `lib/`: they live together in `test/regression/`, one
file per issue.

- **One file per issue**: name it `issue_<number>_<short_name>_test.dart`
  (e.g. `issue_42_login_button_state_test.dart`), so the issue number leads
  straight to its file. Don't mix two issues in one file.
- **Tag every file**: start it with `@Tags(['regression'])` followed by
  `library;`. The tag is declared in `dart_test.yaml`.
- **Group by issue**: wrap the tests in
  `group('Issue #<number> - <what is checked>', ...)`, and describe the
  reported symptom in the file's header comment.
- **Check the issue first**: reports are often just a screenshot. Read the
  issue and its attachments (`gh issue view <number>`) before writing the
  test, and assert on the actual cause where you can find it.
- **Share setup through `testing/helpers/`** when several issue files need
  the same setup, instead of copying it.
- **Open issues**: write the test against the expected fixed behaviour, then
  skip it so `flutter test` stays green:
  `group(..., skip: 'Open issue #<number>', ...)` (`patrolWidgetTest`'s
  `skip` only takes a `bool`, so put the reason on the group). The fix
  removes the `skip`.
- **Golden tests**: only when the visual problem actually shows up in a test
  render. Network images don't load in tests, so a geometry assertion
  (sizes, aspect ratios, overflow) is often more reliable.

## Running tests

```bash
flutter test                            # unit + widget tests
flutter test --tags regression          # only the issue regression tests
flutter test --exclude-tags regression  # everything except them
flutter analyze                         # static analysis, must be clean
patrol test                             # E2E tests in patrol_test/
```

Tests for `dart:js_interop`/`package:web` code are marked
`@TestOn('browser')`, so plain `flutter test` skips them. Run them in Chrome
with `flutter test --platform chrome path/to/your_web_test.dart`. Their fakes
can't import `testing/mocks/` files that pull in `dart:io`, since those don't
compile for web - define a small private fake in the test file instead.
