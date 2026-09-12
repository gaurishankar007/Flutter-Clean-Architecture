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

## Conventions

- **Mock with `mocktail`** (`class MockX extends Mock implements X {}`) -
  never hit real services, HTTP, or platform channels from a unit test.
  This project does not use `mockito`/generated mocks.
- **Cubit tests use `bloc_test`** (`blocTest<TheCubit, TheState>(...)`).
- **Widget tests use `patrol_finders`** (`patrolWidgetTest`, the `$` finder)
  for more robust widget discovery than the plain `flutter_test` finders.
- Register fallback values (`registerFallbackValue`) in `setUpAll` for any
  argument type matched with `any()`.
- If test coverage requirements are ambiguous, ask rather than inventing a
  convention.

## Testing the Cubit/UI-separation pattern

Every `BaseCubit` reports outcomes via `BaseState.message`
(`SuccessMessage`/`ErrorMessage`/`WarningMessage`, see
`lib/shared_ui/cubits/base/base_state.dart`) instead of calling `ToastUtil` or
navigating directly - see the "Messages & Navigation" section in
[`architecture.md`](../cg-warehouse/docs/architecture.md) for the full
pattern. This changes what a cubit test should assert:

- **Assert on `state.message`**, not on a mocked navigation/toast call - a
  cubit method that changes state should be asserted with `blocTest`'s
  `expect: () => [...]`, checking the emitted `LoginState`/`FooState`
  including its `message` field.
- **`StateMessage` subclasses (`SuccessMessage`/`ErrorMessage`/
  `WarningMessage`) must stay `Equatable`** (they extend it in
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
  mockNavigationClient.replaceAllRoute(any())).called(1)`), since that's now
  the UI layer's responsibility. See
  `test/features/auth/presentation/pages/login_page_test.dart` and
  `test/features/auth/presentation/cubits/login_cubit_test.dart` for a
  worked example of both halves of this split.

## Running tests

```bash
flutter test               # unit + widget tests
flutter analyze            # static analysis, must be clean
patrol test                # E2E tests in patrol_test/
```
