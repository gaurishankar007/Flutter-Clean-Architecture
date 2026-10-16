# Release Workflow

How a build actually reaches testers in this repo, so an agent doesn't invent
steps that don't exist. Nothing is distributed on push: a release always
starts on purpose, from the GitHub workflows or fastlane.

## How it works

- **GitHub Actions** (manual-only, `workflow_dispatch`):
  - `.github/workflows/staging_app_distribution.yml` builds the `staging`
    flavor (`lib/main_stg.dart`).
  - `.github/workflows/production_app_distribution.yml` builds the
    `production` flavor (`lib/main.dart`) and only runs from `master`.
  - Inputs: `release_notes` (overrides the file's `RELEASE_NOTES` block),
    `skip_tests`, and `platform` (`android`/`ios`/`all`, default `android`).
  - Android: `flutter build apk` → Firebase App Distribution (`testers`
    group). iOS: manual signing from the Apple secrets → `flutter build ipa`
    → TestFlight.
  - Both run `flutter analyze` and `flutter test` (the `flutter-test` action)
    unless `skip_tests` is set.
- **Fastlane** (local, `fastlane/Fastfile`):
  - `bundle exec fastlane <android|ios> <staging|production>`.
  - Reads the release notes from the matching workflow's `RELEASE_NOTES`
    block (unless `notes:"..."` is passed) and the credentials from
    `fastlane/.env` and `fastlane/keys/` (gitignored; see
    `fastlane/.env.example`).
  - Refuses to build from a dirty working tree unless `allow_dirty:true`.
- **Versioning:** `pubspec.yaml`'s `version:` is the single source; the iOS
  Runner target reads it through `$(FLUTTER_BUILD_NUMBER)`. Neither CI nor
  fastlane bumps it.
- **Signing:** Android release builds use `android/key.properties` when it
  exists (CI writes it from `ANDROID_KEYSTORE_FILE`/`ANDROID_KEY_PROPERTIES_FILE`),
  otherwise the debug key. Flag this if a task is about a real store
  release: don't assume release signing is configured.
- **Secrets:** see the README's "Required Secrets" table.

## When asked to prepare/ship a release

1. **Check Flutter version parity:** compare `flutter --version` with
   `flutter-version` in `.github/actions/setup-flutter/action.yml`, and update
   the action to match the local version exactly if they differ.
2. **Validate:** run `flutter analyze` and `flutter test`; both must be clean.
3. **Bump the version** only if the user wants one: increment the build
   number in `pubspec.yaml` (e.g. `1.0.0+1` → `1.0.0+2`). Ask how they want it
   handled if it's unclear; don't guess a scheme.
4. **Draft release notes** from the commits since the previous release.
   - Only include user-visible changes. Leave out refactors, dependency
     bumps, CI/tooling, tests, logging, and internal architecture/DI changes.
   - Start each line with `- `; the workflows write the notes to a file, so
     there's no YAML-list ambiguity.
   - **Show them to the user and wait for approval** before writing them
     anywhere, since testers see this text.
5. **Update `RELEASE_NOTES`** in both
   `.github/workflows/staging_app_distribution.yml` and
   `.github/workflows/production_app_distribution.yml`.
6. **Commit and push** only when the user asks for it, e.g.
   `chore: bump build number to <VERSION> and update release notes`.
7. **Distribute** only when the user explicitly asks, since this reaches
   real testers' devices:
   - With fastlane: from a clean tree at the pushed commit, run the lanes
     one after the other, **iOS first, then Android**
     (`bundle exec fastlane ios staging`, then
     `bundle exec fastlane android staging`).
   - Or with GitHub: `gh workflow run staging_app_distribution.yml -f platform=all`.
   - If a lane or run fails, stop and report the error instead of retrying
     or switching to the other route.
