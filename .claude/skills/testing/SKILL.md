---
name: testing
description: Runs the unit, widget, regression, and Patrol integration test suites for this project
---

# Testing Skill

This skill explains how to run the automated test suites (unit, widget,
regression, and integration) for this project. See `docs/testing.md` for how
to write tests.

## 1. Unit & Widget Tests

Unit and widget tests mirror `lib/` under `test/`. The exception is issue
regression tests, which live in `test/regression/` (one
`issue_<number>_<name>_test.dart` per GitHub issue) and are tagged
`regression`.

- **Run all tests:**
  ```bash
  flutter test
  ```
- **Run all tests with detailed output:**
  ```bash
  flutter test -r expanded
  ```
- **Run only the regression tests / everything except them:**
  ```bash
  flutter test --tags regression
  flutter test --exclude-tags regression
  ```
- **Run a specific test file:**
  ```bash
  flutter test path/to/your/test_file.dart
  ```
- **Run web-only (`@TestOn('browser')`) tests:**
  ```bash
  flutter test --platform chrome path/to/your_web_test.dart
  ```

Always run `flutter analyze` too; it must report zero issues.

---

## 2. Integration Tests (Patrol)

Integration tests live in `patrol_test/` and use the `patrol` framework.
Start an emulator/simulator or connect a device first.

- **Mobile simulator/emulator:**
  ```bash
  patrol test --target patrol_test/login_test.dart
  ```
- **Mobile hot-restart development mode:**
  ```bash
  patrol develop --target patrol_test/login_test.dart
  ```
- **Web (Chrome):**
  ```bash
  patrol test --device chrome --target patrol_test/login_test.dart
  ```
- **Physical iOS device** (needs `--release`):
  ```bash
  patrol test --release --target patrol_test/login_test.dart
  ```
