# Release Workflow: Firebase App Distribution

This document describes how a release actually reaches testers today, so an
agent doesn't invent steps that don't exist in this repo's CI.

## How it works

`.github/workflows/firebase_app_distribution.yml` builds and distributes the
app automatically:

- **Trigger:** any push to the `staging` or `master` branch, or a manual
  `workflow_dispatch` run (optionally with a custom `release_notes` input).
- **`staging` branch** → builds the `staging` flavor
  (`flutter build apk --release --flavor staging --target lib/main_stg.dart`)
  and distributes it via Firebase App Distribution to the `testers` tester
  group, using `FIREBASE_APP_ID_STAGING`.
- **`master` branch** → builds the `production` flavor
  (`--flavor production --target lib/main.dart`) and distributes it the same
  way, using `FIREBASE_APP_ID_PRODUCTION`.
- Both jobs run `flutter analyze` and `flutter test` as part of the build
  action (`.github/actions/build-android/action.yml`) — a release build
  fails if analysis isn't clean or a test fails.
- Release notes come from the `release_notes` workflow-dispatch input if
  provided, otherwise from the static `RELEASE_NOTES` block in the workflow
  file's `env:` section — **that block needs to be updated by hand** before a
  push-triggered release if the notes should describe what actually changed.
  Use the `•` bullet character (not `-`), since a line starting with `-` can
  be misread as a new YAML list item by the release-notes action.
- Required secrets (`BASE_PRODUCTION_URL`, `BASE_STAGING_URL`,
  `BASE_DEVELOPMENT_URL`, `ENCRYPTION_KEY`, `FIREBASE_APP_ID_STAGING`,
  `FIREBASE_APP_ID_PRODUCTION`, `CREDENTIAL_FILE_CONTENT`) must be configured
  under **Settings → Secrets and variables → Actions** — see the README's
  "CI/CD & Release" section for what each one is for.
- There is **no automatic build-number/version bump** in CI. `pubspec.yaml`'s
  `version:` field is not touched by this workflow. If a release needs a new
  version, that's a manual step — **ask the user** how they want it handled
  if a task seems to require bumping it; don't guess a scheme.
- The distributed APK is currently signed with the **debug key**
  (`android/app/build.gradle.kts` has a `// TODO: Add your own signing
  config` placeholder) — fine for internal testers via App Distribution, but
  flag this if a task is about a real production release: don't assume
  release signing is already wired up.

## When asked to prepare/ship a release

1. Confirm the target branch (`staging` for a tester build, `master` for
   production) and get the release notes from the user — do not write your
   own summary of commits into `RELEASE_NOTES` without the user reviewing it
   first, since testers see this text.
2. Update the `RELEASE_NOTES` block in
   `.github/workflows/firebase_app_distribution.yml` if the push-triggered
   path is being used (skip this if the user will use the manual
   `workflow_dispatch` input instead).
3. Run `flutter analyze` and `flutter test` locally first — don't rely on CI
   to catch it.
4. Push to `staging`/`master` (or trigger the workflow manually) only once
   the user has explicitly asked for that push — this affects real testers'
   installed builds.
