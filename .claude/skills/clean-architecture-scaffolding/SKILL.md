---
name: clean-architecture-scaffolding
description: Automates code scaffolding (Mason) for features and pages in this project
---

# Code Scaffolding Skill

This skill explains how to scaffold new features and pages in this project
using the **Mason** template engine. This ensures the generated code follows
the project's Clean Architecture + Cubit pattern.

## Prerequisites

Before running Mason templates, make sure the Mason CLI is installed and the
project's bricks are loaded:

```bash
dart pub global activate mason_cli
mason get
```

## Scaffolding Commands

### 1. Generate a New Feature

Generates a complete data/domain/presentation feature skeleton (data source,
repository, entity/model, use case, Cubit, page). Create/edit `config.json`
at the workspace root:

```json
{
  "feature": "dashboard",
  "entity": {
    "name": "dashboardSummary",
    "variables": [
      { "name": "id", "type": "int" },
      { "name": "title", "type": "String" }
    ]
  },
  "cubit": "dashboard",
  "page": "dashboard"
}
```

- `entity.name` becomes the generated domain entity/model class name.
- `entity.variables` becomes that entity/model's fields — each needs a
  `name` and a Dart `type`.

**Command:**

```bash
mason make cubit_feature -c config.json
```

### 2. Generate a New Page + Cubit Within an Existing Feature

Generates a single Cubit/state pair and a page, without the data/domain
scaffolding. Use this when adding a new screen to a feature that already
exists. `config.json` only needs `feature`, `cubit`, and `page`:

```json
{
  "feature": "dashboard",
  "cubit": "profileDetails",
  "page": "profileDetails"
}
```

**Command:**

```bash
mason make cubit_page -c config.json
```

## Important Notes

- Always review and update the values in `config.json` to match your
  intended names before executing any `mason make` command.
- The generated data source/repository/use-case files are skeletons with the
  correct client types wired in (`HttpClient`, `LocalStorageClient`,
  `InternetClient`) but empty/placeholder method bodies — fill in the actual
  endpoints and mapping logic. See the `api_integration` skill for the
  patterns to follow.
- After scaffolding, run the `codegen` skill if the new files involve
  injectable dependencies or new routes.
