# Flutter Clean Architecture with SOLID Principles 🚀

A comprehensive guide to building scalable and maintainable Flutter applications using **Clean Architecture** pattern and **Solid Principle**.

For more details on specific commands and guidelines, refer to the following documents:

- [**Flutter Tips**](docs/flutter_tips.md): A collection of best practices for writing efficient, readable, and performant Flutter code.
- [**Flutter Commands Cheat Sheet**](docs/flutter_commands_cheat_sheet.md): A collection of essential and frequently used Flutter commands to boost your productivity.
- [**Flutter Configuration Guidelines**](docs/flutter_configuration_guidelines.md): Guidelines for setting up the Flutter environment, including activating pub commands, and managing the Java SDK location.
- [**Git Commands Cheat Sheet**](docs/git_commands_cheat_sheet.md): A collection of essential and frequently used git commands to boost your productivity.
- [**Testing Guide**](docs/testing.md): Conventions for unit, widget, and integration tests — mocking, `bloc_test`, `patrol_finders`, and how to test the Cubit/UI-separation pattern.

## Table of Contents 📌

- [Flutter Clean Architecture with SOLID Principles 🚀](#flutter-clean-architecture-with-solid-principles-)
  - [Table of Contents 📌](#table-of-contents-)
  - [Introduction](#introduction)
  - [What is Clean Architecture?](#what-is-clean-architecture)
    - [Core Layers](#core-layers)
    - [Dependency rules that must be enforced](#dependency-rules-that-must-be-enforced)
    - [Benefits](#benefits)
  - [SOLID Principles](#solid-principles)
  - [Visual Representation](#visual-representation)
  - [Project Features](#project-features)
  - [Getting Started 🚀](#getting-started-)
    - [Prerequisites](#prerequisites)
    - [Installation \& Setup](#installation--setup)
  - [Project Structure](#project-structure)
  - [State Management with Bloc (Cubit)](#state-management-with-bloc-cubit)
  - [App Flavors](#app-flavors)
  - [Responsiveness](#responsiveness)
  - [Core Clients \& Utilities](#core-clients--utilities)
    - [HTTP Client](#http-client)
    - [Internet Status](#internet-status)
    - [Navigation](#navigation)
    - [Session Management](#session-management)
    - [Image Picker](#image-picker)
    - [App Error Logging](#app-error-logging)
  - [Data States](#data-states)
  - [Error Handling Architecture](#error-handling-architecture)
  - [Data Handling Operations](#data-handling-operations)
  - [API Workflow Overview](#api-workflow-overview)
    - [Data Flow Summary](#data-flow-summary)
    - [Core Components](#core-components)
    - [Example: Login Flow](#example-login-flow)
      - [Internal Flow](#internal-flow)
    - [Debugging Tools](#debugging-tools)
  - [Feature Template Generation with Mason](#feature-template-generation-with-mason)
    - [How to Generate a Feature](#how-to-generate-a-feature)
    - [What Do `cubit_feature` \& `cubit_page` Do?](#what-do-cubit_feature--cubit_page-do)
    - [Configuration](#configuration)
  - [Testing](#testing)
    - [Running Tests](#running-tests)
      - [Unit \& Widget Tests](#unit--widget-tests)
      - [Integration Tests (Patrol)](#integration-tests-patrol)
  - [CI/CD \& Release](#cicd--release)
    - [GitHub Actions](#github-actions)
    - [Fastlane](#fastlane)
    - [Required Secrets](#required-secrets)

## Introduction

This project demonstrates how to structure Flutter applications using **Clean Architecture** and **SOLID Principles**. The goal is to create modular, testable, and maintainable codebases that scale with your application's growth.

## What is Clean Architecture?

**Clean Architecture** is a software design philosophy that promotes separation of concerns through clearly defined layers. Each layer has a specific responsibility, making the codebase modular, testable, and easier to maintain.

### Core Layers

1. **Presentation Layer**
   - Contains UI and state management (e.g., Cubits, Widgets, Pages).
   - Responsible for displaying data and handling user interactions.
   - May import domain/use-cases and core, but must NOT import feature data directly — always use repository interfaces / use-cases.

2. **Domain Layer**
   - The heart of the application. Contains **Entities**, **UseCases**, and **Repositories**.
   - Focuses purely on business logic, independent of frameworks.
   - Must not import from data or presentation.

3. **Data Layer**
   - Manages data sources (e.g., APIs, local databases).
   - Implements repositories to provide data to the domain layer.
   - May import domain to implement repository interfaces.

### Dependency rules that must be enforced

- Keep imports flowing inward only — Presentation -> Domain -> Data.
- Core is reusable library and should be independent of other layers but domain, data, presentation depends on core.
- Shared UI is reusable UI related library and It might depend on core but not other layers. Presentation layer depends on Shared UI.

### Benefits

- **Framework Independence**: Decouples business logic from frameworks, UI, and data sources.
- **Modularity**: Enables easier testing and maintenance.
- **Scalability**: Supports flexible and future-proof feature additions.

## SOLID Principles

**SOLID Principles** complement Clean Architecture by providing guidelines for writing clean, maintainable, and extensible code:

1. **Single Responsibility Principle (SRP)**  
   Each class should have only one reason to change.

2. **Open/Closed Principle (OCP)**  
   Classes should be open for extension but closed for modification.

3. **Liskov Substitution Principle (LSP)**  
   Subtypes must be substitutable for their base types without altering program correctness.

4. **Interface Segregation Principle (ISP)**  
   Classes should not be forced to implement interfaces they do not use.

5. **Dependency Inversion Principle (DIP)**  
   High-level modules should not depend on low-level modules; both should depend on abstractions.

For more detailed information and real-world examples, see the [**SOLID Principles documentation**](documentation/solid_principles.md).

## Visual Representation

![Clean Architecture With SOLID Principle](https://miro.medium.com/v2/resize:fit:720/format:webp/0*1w080Y72qaOdoC3W.png)

> This diagram highlights the modular and scalable structure of Clean Architecture, aligning with **SOLID principles** to ensure best development practices.

## Project Features

- 🛡️ **SOLID Principles**: Ensures scalable, maintainable, and testable code.
- 🏗️ **Clean Architecture**: Divides code into layers (Data, Domain, Presentation) for clear separation of concerns.
- 🧩 **Cubit/UI Separation**: Cubits never show toasts or navigate directly — they set a one-shot `BaseState.message`, and the page reacts to it (`useCubitMessageListener`) and to returned results (`NavigationUtil.I`).
- 🍴 **Build Flavors**: Supports Development, Staging, and Production environments.
- 🔧 **Robust Error Handling**: Centralized exception translation and normalization using `ErrorHandler`.
- 🐞 **App Error Logging**: Real-time tracking of uncaught framework and asynchronous errors with a dedicated UI for log inspection and management.
- 🔄 **Automated Request/Response Handling**: Includes token refreshing and request inspection.
- 📡 **Core Services**: Navigation, Internet, Local Database, Image Picker, App Error Logs, Toast Messages, and User Credential management.
- 🎨 **Reusable UI Components**: Customizable themes and reusable widgets.
- ⚙️ **Utilities**: Screen size handling, extensions, mixins, generics, and form validation utilities.

## Getting Started 🚀

Follow these steps to get the project up and running on your local machine.

### Prerequisites

Ensure you have the following software installed:

- Flutter SDK (version `3.47.7`, the version CI is pinned to)
- Dart SDK (version `3.13.5`, `>=3.12.0` is required for private named parameters)
- Android Studio (for Android development)
- Xcode (for iOS development)
- Java 17 (Recommended, but optional)
- Ruby + Bundler (only for releasing with [fastlane](#fastlane))
- Add Flutter's pub cache to your shell's `PATH`. For Zsh, add this to your `~/.zshrc` file: `export PATH="$PATH":"$HOME/.pub-cache/bin"`.

### Installation & Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/gaurishankar007/Flutter-Clean-Architecture.git
   cd Flutter-Clean-Architecture
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

## Project Structure

```
lib/
├── config/
│   ├── injector/
│   └── app_config.dart
├── core/
│   ├── clients/
│   │   ├── local/
│   │   └── remote/
│   │       └── http/
│   ├── constants/
│   ├── data/
│   │   ├── operations/
│   │   ├── states/
│   │   └── models/
│   ├── domain/
│   │   ├── entities/
│   │   └── use_cases/
│   ├── errors/
│   │   ├── error_recorders/
│   │   ├── error_translators/
│   │   └── error_handler.dart
│   ├── types/
│   │   └── types.dart
│   ├── utils/
│   │   ├── extensions/
│   │   └── image_picker_util.dart
│   └── app_initializer.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── data_sources/
│   │   │   │   ├── auth_local_data_source.dart
│   │   │   │   ├── auth_remote_data_source.dart
│   │   │   │   └── session_local_data_source.dart
│   │   │   └── repositories/
│   │   │       ├── auth_repository_impl.dart
│   │   │       └── session_repository_impl.dart
│   │   ├── domain/
│   │   └── presentation/
│   ├── dashboard/
│   └── ...
├── routing/
│   ├── helper/
│   │   └── navigation_client.dart
│   └── routes.dart
├── shared_ui/
│   ├── cubits/
│   ├── models/
│   ├── themes/
│   ├── ui/
│   ├── utils/
│   └── application.dart
├── main_dev.dart
├── main.dart
├── main_stg.dart
```

- **`config/`**: Environment and platform setup (flavor configs), dependency injection (`injector/`), and any Pigeon-generated platform bindings. `app_config.dart` holds flavor-specific values (base URLs, feature flags).
- **`core/`**: App-wide building blocks and reusable utilities. Contains constants, `DataState`/error types, core clients (HTTP client, local storage, connectivity (`ConnectivityClient`)), and general-purpose utilities. `types/types.dart` holds the shared typedefs (`FutureData<T>`, `FutureVoid`, `JsonMap`, etc.) used across every layer.
- **`features/`**: Each feature follows Clean Architecture and is self-contained with three layers:
  - **`data/`**: Remote and local data sources (including repository pattern for session management), DTOs/models, and concrete repository implementations that map to domain entities.
  - **`domain/`**: Pure business logic (entities, use cases/interactors, and abstract repository interfaces). No Flutter or external deps here.
  - **`presentation/`**: Uses **Bloc (Cubit)** for state management. Contains `cubit/` (Cubit classes and their `State` classes), `views/` (pages/screens), and feature-specific `widgets/`.
- **`routing/`**: Centralized navigation and route declarations. Includes `NavigationClient` for context-free navigation.
- **`shared_ui/`**: Shared presentation primitives — reusable widgets, UI models, themes, and optional global cubits (e.g., `ScreenObserverCubit`, `ThemeCubit`). `application.dart` composes the `MaterialApp`, provides global dependencies, and wires routing.
- **Entry Points**:
  - `main.dart` → Production entry that initializes DI and runs `application.dart`.
  - `main_dev.dart` → Development entry (dev flags, debug tools enabled).
  - `main_stg.dart` → Staging entry (staging config).

Notes:

- Dependency injection typically uses `get_it` + `injectable` and is wired in `config/injector` and `app_initializer.dart`.
- Presentation layer (Cubits) should only depend on domain use cases and navigation/UI utilities (not on feature data implementations). Data layer implements domain repository interfaces.

## State Management with Bloc (Cubit)

- The app uses **Bloc** (specifically Cubit) for state management within the Presentation Layer of its Clean Architecture.
- Every Cubit extends `BaseCubit<T>` (`shared_ui/cubits/base/base_cubit.dart`), and its state extends `BaseState`, which carries a `StateStatus` (`initial`/`loading`/`loaded`/`noInternet`/`error`) and a one-shot `StateMessage? message` (`SuccessMessage`/`ErrorMessage`/`WarningMessage`).
- **Cubits never show messages or navigate themselves** — both are UI-layer concerns. A Cubit reports an outcome by setting `state.message`, typically derived from a `DataState` via `stateMessageFromDataState(dataState, {message: '...'})`. A state's `copyWith`/constructor must **never** preserve the previous `message` (`message: message`, never `message ?? this.message`), so a message is shown exactly once.
- The page providing the Cubit wires `useCubitMessageListener(cubit)` (`shared_ui/utils/cubit_message_listener.dart`, a `flutter_hooks` hook) to actually display that message via `ToastUtil` — never a raw `SnackBar`. Use `NormalMessage` for a neutral, informational message.
- `ToastUtil` shows toasts one at a time (`flutter_sliding_toast`'s `ToastDisplayMode.oneByOne`): a new toast waits until the shown one closes, and one with the same text and type as the toast right before it is skipped. Tapping a toast opens its full message in a toast-styled dialog (`showDialogOnTap`), scrollable if long.
- A Cubit method that used to navigate itself instead returns a result — typically `Future<bool>` (did it succeed), or an `enum` for more than one outcome — and the calling widget awaits it and navigates via `NavigationUtil.I`. See `LoginCubit`/`LoginPage` (and `login_button.dart`) for a worked example, and [`docs/testing.md`](docs/testing.md) for how to test both halves of the split.

## App Flavors

The app supports three flavors: `production`, `staging`, and `development` for both Android and iOS.

- Uses `get_it` and `injectable` for dependency injection.
- Flavor-specific configuration (e.g., API base URL) is managed via `AppConfig`.
- See `Project Structure` for entry points (`main.dart`, `main_stg.dart`, `main_dev.dart`).

## Responsiveness

- Uses a custom `ScreenUtil` to manage screen size, types, and responsive values (e.g., width, padding).
- `ScreenObserverCubit`: A Bloc `cubit` that enhances responsiveness by observing screen size changes. It leverages `ScreenUtil` to determine the current screen type (e.g., mobile, tablet, desktop). To prevent unnecessary widget rebuilds during the build cycle, it updates its state only after the current frame has been rendered. This ensures that listeners are notified of screen type or desktop layout changes (e.g., switching from mobile to desktop view) efficiently, allowing widgets to rebuild selectively for optimized responsive UI adjustments.
- The root widget, `CleanArchitectureSample`, uses `WidgetsBindingObserver` to listen for `didChangeMetrics`. When the screen size changes, it schedules an update to the `ScreenObserverCubit` using `runAfterBuild` (`shared_ui/utils/frame_callback.dart`, a thin wrapper over `WidgetsBinding.instance.addPostFrameCallback` — use it instead of calling that directly), ensuring the UI is rebuilt safely and efficiently in response to layout changes.

```mermaid
graph TD
    subgraph Initialization
        A[Main Stateful Widget] -- initializes --> B[Screen Util]
    end

    subgraph "Runtime Update Cycle"
        A -- "on didChangeMetrics" --> C["runAfterBuild"]
        C -- "safely notifies" --> D[Screen Observer Cubit]
        D -- "1. updates" --> B
        D -- "2. emits new state" --> E((Rebuild UI))
        E -- triggers rebuild of --> F[Responsive Widget]
        B -- provides updated values --> F
    end
```

## Core Clients & Utilities

### HTTP Client

- `HttpClient` (using Dio) handles HTTP requests.
- `HttpAuthInterceptor` adds authentication tokens (unless the request already sets an `Authorization` header or passes `Options(extra: {HttpKeys.excludeAuth: true})`) and refreshes an expired token. It can be extended for caching or retries.
- Header names and per-request flags live in `HttpKeys` (`core/constants/http_keys.dart`) instead of raw strings; `MapDynamicExtension` (`core/utils/extensions/map_extension.dart`) reads them safely (`hasValue`, `getBool`, ...).
- Dio's adapter is chosen per platform by `createHttpClientAdapter()` (`core/clients/remote/http/http_client_adapter.dart`): `IOHttpClientAdapter` on mobile, and `BrowserHttpClientAdapter(enableCORSWarning: false)` on web. Every request sends `Content-Type: application/json`, so on web each one is CORS-preflighted by design; Dio's per-request "not a CORS simple request" warning is silenced, while a real CORS failure is still reported in the `DioException.connectionError` message.

### Internet Status

- `ConnectivityClient` tracks connectivity and exposes a stream for UI updates.
- API calls are blocked and return a network `FailureState` if offline.

### Navigation

- **Navigation**: Managed by `NavigationClient` (context-free navigation).
- **Routing**: Uses `auto_route` for declarative routing and guards to manage access based on user state.

### Session Management

- Session management is now part of the **Auth Feature** following the Repository pattern.
- `SessionRepository` manages user session and persists data using `LocalDatabase` clients (`IsarDbClient` or `LocalStorageClient`).
- Sensitive data, such as user details, is encrypted using AES-256 before being persisted. The `LocalStorageClient` handles this by using `EncryptionUtils` to ensure that data at rest on the device is secure.
- The `IsarDbClient` provides a robust NoSQL database for more complex data storage needs.

### Image Picker

- `ImagePickerUtil` provides an abstraction for selecting images from the gallery or camera, ensuring decoupling from specific plugin implementations.

### App Error Logging

- `AppErrorRecorder` captures and persists uncaught `FlutterError`s and asynchronous errors locally.
- A dedicated **App Error Logs** page in the dashboard allows developers to inspect stack traces, error details, and environment metadata (flavor, version) in real-time.

## Data States

- **DataState<T>**: A sealed class representing the state of a data operation. It has three main states: `SuccessState<T>`, `FailureState<T>`, and `LoadingState<T>`, which allows the UI to react consistently to different outcomes.

**State types location**: `lib/core/data/states` — `data_state.dart`, `failure_state.dart`, `loading_state.dart`, `success_state.dart`.

## Error Handling Architecture

- **ErrorHandler**: A centralized error-handling service composed of **ErrorTranslator**(s) and **ErrorRecorder**(s). Error translators map platform/library exceptions (e.g. Dio, FirebaseAuth) into `FailureState<T>` instances; error recorders report or record errors (Crashlytics, logs). The service is exposed via `ErrorHandlerProvider.I` and provides helpers such as `execute<T>()` (wraps async calls and returns `FailureState<T>` on error), `executeSafe()` and `executeSafeReturn()` for non-propagating logging.

**Implementations**: `lib/core/errors` — `error_handler.dart`.

## Data Handling Operations

- **ApiExecutor**: Handles the http requests and transforms the response into a `DataState` with api models. It provides standard response normalization and error mapping.

- **RepositoryFetcher**: Handles the data flow from the repository to the UI layer. It provides high-level utility methods like `fetchWithFallbackAndMap` that calls the api service or fallback to local service if offline, while coordinating DTO-to-Domain mapping.

**Implementations**: `lib/core/data/operations` — `api_executor.dart`, `repository_fetcher.dart`.

- Use `FutureVoid` (`Future<DataState<void>>`, from `core/types/types.dart`) for data source/repository/use-case methods whose result no caller reads — never `FutureBool` (`Future<DataState<bool>>`) just to signal "did it work" when the caller only checks `hasData`/`errorType`. Return `SuccessState.nil` (never `SuccessState(data: null)` or `SuccessState(data: true)`) as the success value for a `FutureVoid`-typed method.

## API Workflow Overview

```mermaid
flowchart TD
  Z["UI"] -- calls --> A["Cubit"]
  A -- calls --> B["UseCase"]
  B -- calls --> C["Repository"]
  C -- calls --> D["Remote DataSource"] & E["Local DataSource"]
  C -- uses --> F["Internet Client"]
  C -- handled by --> G1["Repository Fetcher"]
  G1 -- handles --> H["Data State"]
  D -- uses --> I["Http Client"]
  D -- handled by --> G2["Api Executor"]
  I -- sends --> J["API"]
  G2 -- uses --> M["Error Handler"]
  E -- handled by --> M
  M -- handles --> H
  E -- uses --> K["Isar / Local Storage Client"]
  K -- sends --> L["Local Database / Preferences"]
```

### Data Flow Summary

1. **UI calls Cubit, which calls UseCase**
2. **UseCase calls Repository**
3. **Repository coordinates data fetch** using `RepositoryFetcher`
4. **RepositoryFetcher checks Internet availability** using `ConnectivityClient`
5. If online (or using `fetchWithFallback`):
   - Calls `RemoteDataSource`
   - `RemoteDataSource` uses `ApiExecutor.call` to execute requests via `HttpClient`
   - `ApiExecutor` parses JSON into DTOs and handles API-specific errors
6. If offline (or fallback triggered):
   - Calls `LocalDataSource`
7. **RepositoryFetcher maps DTOs to Domain Entities** (if using `AndMap` variants)
8. **All outcomes are returned as `DataState<T>`**: `SuccessState`, or `FailureState`

### Core Components

- **Use Case**: Represents a single business action (e.g., `LoginUseCase`). It is called by the Presentation layer (Cubit) and orchestrates the flow of data by interacting with one or more Repositories. This encapsulates a specific piece of business logic, making it reusable and decoupled from the UI state management.

- **Repository**: Acts as the single source of truth for the domain layer. It coordinates data from one or more data sources (remote, local) and decides where to fetch data from, often using `RepositoryFetcher.fetchWithFallbackAndMap` to implement the offline-first strategy. It is also responsible for mapping Data Transfer Objects (DTOs) from the data layer into clean domain models for the UI layer.

- **Data Sources (`Remote`, `Local`)**:
  - **RemoteDataSource**: Handles communication with the backend REST API. It uses the `HttpClient` to make HTTP requests. Each method is wrapped in `ApiExecutor.call` to safely parse responses and handle API-specific errors.
  - **LocalDataSource**: Manages data persistence on the device (e.g., user session, cached data). It uses `IsarDbClient` or `LocalStorageClient` and wraps its methods in `ErrorHandler.execute` to ensure consistent error handling.

- **HttpClient**: An abstraction over the `Dio` HTTP client. It is configured with the base URL from `AppConfig` and includes interceptors. It provides standard methods like `get`, `post`, `put`, and `delete` for making API calls.

- **ApiExecutor, RepositoryFetcher & ErrorHandler**: These classes form the backbone of the application's error handling and data flow strategy.
  - **ApiExecutor**: Provides utility methods like `call` (to execute API requests, parse JSON, and wrap results in a `DataState`). It handles standard response structures and mapping to DTOs.
  - **RepositoryFetcher**: Provides high-level utility methods like `fetchWithFallbackAndMap` (to implement the offline-first strategy) and `fetchFromLocalAndMap` to coordinate between data sources and map DTOs to domain models.
  - **ErrorHandler**: A centralized utility that catches specific exceptions (`DioException`, `FormatException`, etc.) and converts them into a standardized `FailureState` with a user-friendly error message. This ensures that the UI layer receives consistent error objects regardless of the error's origin.

### Example: Login Flow

```dart
@injectable
class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit({required this._useCases})
    : super(const LoginState.initial());

  final LoginCubitUseCases _useCases;

  /// Returns whether login succeeded — the calling widget decides whether
  /// to navigate. Never called by the Cubit itself.
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final authentication = Authentication(username: username, password: password);
    final dataState = await _useCases.login.call(authentication);

    // Sets an ErrorMessage on failure (silent on success — the widget's
    // navigation is feedback enough); the page's `useCubitMessageListener`
    // shows it via `ToastUtil`.
    emit(state.copyWith(message: stateMessageFromDataState(dataState)));

    if (!dataState.hasData) {
      return false;
    }

    _useCases.setSession.call(dataState.data!);
    return true;
  }
}
```

The widget then reacts to the returned `bool`:

```dart
onTap: () async {
  final success = await context.read<LoginCubit>().login(
    username: usernameController.text,
    password: passwordController.text,
  );
  if (success) {
    await NavigationUtil.I.replaceAllRoute([const HomeRoute()]);
  }
},
```

#### Internal Flow

```mermaid
flowchart TD
    A[UI] --> B[Login Cubit]
    B --> C[Login UseCase] & D[Save UserData UseCase]
    C --> E[Auth Repository]
    D --> E

    subgraph "Remote Flow (Login)"
        E -- "uses Repository Fetcher" --> F{Has Internet?}
        F -- Yes --> G[Auth Remote DataSource]
        G -- "calls" --> H[Api Executor]
        H -- "1. executes" --> I[HttpClient]
        I -- "sends HTTP Request" --> J[API]
        H -- "2. parses & returns" --> K{Success?}
        K -- Yes --> L((Success State))
        K -- No --> M((Failure State))
        F -- No --> M
    end

    subgraph "Local Flow (Save User)"
        E -- "saveUserData (uses Error Handler)" --> N[Auth Local DataSource]
        N -- "calls" --> O[Error Handler]
        O -- "1. executes" --> P[Local Database Client]
        P -- "Write/Read" --> Q[(Local Database)]
        O -- "2. returns" --> K
    end
```

### Debugging Tools

- **Alice** integrated into `HttpClient` for easy request/response inspection.
- **App Error Logs**: In-app dashboard for viewing and managing application-level errors and stack traces.

## Feature Template Generation with Mason

This project uses **Mason** to generate feature templates for consistent and efficient development.

### How to Generate a Feature

1. **Activate the `mason_cli` globally**:

   ```bash
   dart pub global activate mason_cli
   ```

2. **Fetch the bricks for the project**:

   ```bash
   mason get
   ```

3. **Generate a new feature using the `cubit_feature` brick**:

   ```bash
   mason make cubit_feature -c config.json
   ```

4. **Generate a new cubit and page using the `cubit_page` brick**:

   ```bash
   mason make cubit_page -c config.json
   ```

### What Do `cubit_feature` \& `cubit_page` Do?

- **`cubit_feature`**: Generates a feature template following Clean Architecture, including:
  - **Data Layer**: Data Sources, Models, Repositories
  - **Domain Layer**: Entities, Repositories, Use Cases
  - **Presentation Layer**: Cubits, Pages, Widgets

- **`cubit_page`**: Generates a cubit and page template inside the specified feature's presentation layer.

### Configuration

The generation process relies on a `config.json` file, which includes details such as feature, cubit, and page names, as well as entity names and their variable types. Ensure that `config.json` is correctly defined before running the generation command.

## Testing

This project uses a multi-layered testing strategy to ensure robustness and maintainability. See [`docs/testing.md`](docs/testing.md) for the full conventions, including how to test the Cubit/UI-separation pattern (asserting on `state.message` rather than a mocked navigation/toast call, and keeping `StateMessage` subclasses `Equatable` so `blocTest`'s exact-state checks work).

- **Mocking with `mocktail`**: Dependencies are mocked using the `mocktail` package. This allows for testing each layer in isolation. For example, when testing a `Repository`, the `RemoteDataSource` and `LocalDataSource` are mocked. The tests demonstrate how to mock dependencies and stub method calls to return specific data or states.

- **Widget Testing with `patrol_finders`**: Widget tests use `patrol_finders` (part of the Patrol framework) to provide a more intuitive and powerful way to find and interact with widgets, making UI tests cleaner and more readable.

- **Integration Testing with `patrol`**: End-to-end tests are written using `patrol`, which extends `flutter_test` with features for controlling native UI elements (like permission dialogs).

  **Note**: Patrol requires a one-time setup for both native Android (`build.gradle`) and iOS (`Podfile`, `RunnerUITests.m`) projects. For detailed instructions, please refer to the official Patrol setup documentation.

- **Isolating Layers**: The architecture makes it easy to test components independently:
  - When testing a `UseCase`, the `Repository` is mocked.
  - When testing a `Cubit`, the `UseCase`s are mocked.
  - When testing a `DataSource`, the `HttpClient` or `Local Storage / Isar DB Client` is mocked.

### Running Tests

The project includes a suite of automated tests to ensure code quality and functionality.

#### Unit \& Widget Tests

- **Run all tests**:

  ```shell
  flutter test
  ```

- **Run a specific test file**:
  ```shell
  flutter test path/to/your/test_file.dart
  ```

#### Integration Tests (Patrol)

Ensure an emulator or physical device is running before executing these tests.

- **Run all integration tests**:
  ```shell
  patrol test
  ```
- **Run a specific integration test**:
  ```shell
  patrol test --target path/to/your/integration_test.dart
  ```

## CI/CD & Release

Builds reach testers through [Firebase App Distribution](https://firebase.google.com/docs/app-distribution) (Android) and TestFlight (iOS), either from GitHub Actions or locally with fastlane. Neither runs on push: a release is always started on purpose.

### GitHub Actions

- **Composite actions** (`.github/actions/`):
  - `setup-flutter`: sets up Java 17 and the pinned Flutter version, then runs `flutter pub get`.
  - `create-files`: writes `.env` from secrets, plus the Android signing files (`android/key.properties`, `android/app/upload-keystore.jks`) and `ios/ExportOptions.plist` when their secrets are given.
  - `flutter-test`: runs `flutter analyze` and `flutter test`.
- **Workflows** (`.github/workflows/`), both manual-only (`workflow_dispatch`) with `release_notes`, `skip_tests` and `platform` (`android`/`ios`/`all`, default `android`) inputs:
  - `staging_app_distribution.yml`: builds the `staging` flavor (`lib/main_stg.dart`).
  - `production_app_distribution.yml`: builds the `production` flavor (`lib/main.dart`); only runs from `master`.
  - Android: `flutter build apk` → Firebase App Distribution (`testers` group). iOS: manual signing with the certificate/provisioning profile secrets → `flutter build ipa` → TestFlight.
  - Release notes come from the `release_notes` input, or else the `RELEASE_NOTES` block in the workflow's `env:`.
- Keep `flutter-version` in `.github/actions/setup-flutter/action.yml` in sync with the local `flutter --version`.
- Release builds are signed with the key from `android/key.properties` when it exists, otherwise with the debug key (see `android/app/build.gradle.kts`). The debug key is fine for internal testers, but not for a store release.

### Fastlane

A local alternative to the workflows, sending the same builds with the same release notes (read from the workflow's `RELEASE_NOTES` block unless overridden).

1. Install the gems once: `bundle config set --local path vendor/bundle && bundle install`.
2. Copy `fastlane/.env.example` to `fastlane/.env` and fill it in. Put the key files in `fastlane/keys/`; both are gitignored.
3. Run a lane from a clean working tree:

   ```bash
   bundle exec fastlane android staging
   bundle exec fastlane ios production notes:"- Fixed ..."
   ```

   Options: `notes:"..."`, `allow_dirty:true`, `test:true` (runs `flutter analyze` and `flutter test` first), `skip_waiting:true` (iOS; TestFlight then won't show the notes).

The iOS lanes sign automatically with the App Store Connect API key, so the Xcode project isn't touched. Set your own bundle IDs and team in Xcode first.

### Required Secrets

Configure these under **Settings → Secrets and variables → Actions**:

| Secret | Purpose |
| --- | --- |
| `BASE_PRODUCTION_URL` | Production API base URL, written into `.env` (`BASE_PRODUCTION`) |
| `BASE_STAGING_URL` | Staging API base URL, written into `.env` (`BASE_STAGING`) |
| `BASE_DEVELOPMENT_URL` | Development API base URL, written into `.env` (`BASE_DEVELOPMENT`) |
| `ENCRYPTION_KEY` | AES key used by `EncryptionService`, written into `.env` |
| `FIREBASE_APP_ID_STAGING` | Firebase App ID for the staging Android app |
| `FIREBASE_APP_ID_PRODUCTION` | Firebase App ID for the production Android app |
| `CREDENTIAL_FILE_CONTENT` | Contents of a Firebase service account JSON with App Distribution access |
| `ANDROID_KEYSTORE_FILE` | *(Optional)* Base64 upload keystore (`.jks`) |
| `ANDROID_KEY_PROPERTIES_FILE` | *(Optional)* Base64 `key.properties` (`storeFile=upload-keystore.jks`, `storePassword`, `keyAlias`, `keyPassword`) |
| `APPLE_TEAM_ID` | *(iOS)* Apple Developer Team ID |
| `APPLE_IOS_STAGING_BUNDLE_ID` / `APPLE_IOS_PRODUCTION_BUNDLE_ID` | *(iOS)* Bundle ID per flavor |
| `APPLE_STAGING_PROVISIONING_PROFILE_NAME` / `APPLE_PRODUCTION_PROVISIONING_PROFILE_NAME` | *(iOS)* App Store provisioning profile name per flavor |
| `APPLE_STAGING_PROVISIONING_PROFILE_BASE64` / `APPLE_PRODUCTION_PROVISIONING_PROFILE_BASE64` | *(iOS)* Base64 provisioning profile per flavor |
| `APPLE_CERTIFICATE_BASE64` / `APPLE_CERTIFICATE_PASSWORD` | *(iOS)* Base64 Apple Distribution `.p12` and its password |
| `APP_STORE_CONNECT_API_KEY_ID` / `APP_STORE_CONNECT_ISSUER_ID` / `APP_STORE_CONNECT_API_PRIVATE_KEY` | *(iOS)* App Store Connect API key for the TestFlight upload |
