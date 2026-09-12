---
name: codegen
description: Automates code generation (build_runner) for this project
---

# Code Generation Skill

This skill explains how to run code generation for this Flutter project. Run
this command whenever you add or modify:

1. Routes (`@RoutePage` via `auto_route`)
2. Dependencies (`@injectable`, `@lazySingleton`, or `@singleton` via `injectable`)

## Instructions

### 1. Build Runner Generation

Run the following command in the workspace root to execute a one-time build
and regenerate routing (`lib/routing/routes.gr.dart`) and dependency
injection (`lib/config/injector/injector.config.dart`) configurations:

```bash
dart run build_runner build
```

_Note: Avoid running build_runner in watch mode inside short-lived agent
tasks unless executing a long-running interactive session._

### 2. Verify

After regenerating, run:

```bash
flutter analyze   # must report zero issues
flutter test       # must pass
```
