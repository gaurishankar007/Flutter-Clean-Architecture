---
name: api_integration
description: Automates the integration of a new API endpoint through the data source, repository, and domain layers in this project.
---

# API Integration Skill

This skill guides integrating a new API endpoint into a feature, following the
project's Clean Architecture layering (data/domain/presentation).

## 1. Define the Endpoint

Add the endpoint constant to `lib/core/constants/api_endpoints.dart`, reusing
an existing base segment where the endpoint belongs to that resource, or
adding a new one otherwise:

```dart
class ApiEndpoints {
  ApiEndpoints._();

  static const foo = 'api/foo/';
  static const getFooDetails = '${foo}get-foo-details';
}
```

## 2. Models implement `DomainConvertible`, they don't extend the entity

Response models **implement `DomainConvertible<R>`** and provide `R toDomain()`
(see `core/data/models/domain_convertible.dart`) — they do not `extend` the
domain entity directly:

```dart
// domain/entities/foo.dart
class Foo extends Equatable {
  const Foo({required this.id, required this.name});
  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

// data/models/responses/foo_model.dart
class FooModel implements DomainConvertible<Foo> {
  const FooModel({required this.id, required this.name});
  final int id;
  final String name;

  factory FooModel.fromJson(JsonMap json) => FooModel(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
  );

  @override
  Foo toDomain() => Foo(id: id, name: name);
}
```

Request models live in `data/models/requests/` and expose a
`factory FooRequest.fromDomain(Foo foo)` plus `toJson()`.

## 3. `DataState` and shared typedefs

Everything in the data layer returns a `DataState<T>`
(`lib/core/data/states/data_state.dart`) — a sealed type with `SuccessState`,
`FailureState`, `LoadingState`. Use the typedefs from
`lib/core/types/types.dart` instead of spelling it out:

| Typedef         | Expands to                    |
| ---------------- | ------------------------------- |
| `FutureData<T>`  | `Future<DataState<T>>`          |
| `FutureList<T>`  | `Future<DataState<List<T>>>`    |
| `FutureVoid`     | `Future<DataState<void>>`       |
| `FutureBool`     | `Future<DataState<bool>>`       |
| `FutureString`   | `Future<DataState<String>>`     |
| `FutureInt`      | `Future<DataState<int>>`        |
| `JsonMap`        | `Map<String, dynamic>`          |

Use `FutureVoid` (not `FutureBool`) whenever no caller actually reads the
returned value — only `hasData`/`errorType` matters. Return `SuccessState.nil`
(never `SuccessState(data: null)` or `SuccessState(data: true)`) as the
success value for a `FutureVoid`-typed method.

## 4. Remote Data Sources — use `ApiExecutor`

Location: `lib/features/<feature>/data/data_sources/<feature>_remote_data_source.dart`.

`ApiExecutor` (`lib/core/data/operations/api_executor.dart`) wraps the request
in `ErrorHandlerProvider.I.execute`, unwraps the backend's standard
`{ success, msg, data }` envelope (treating `success: false` as a failure even
on an HTTP 200). `request` is a **positional** argument. Pick the method by
what the endpoint returns:

**`ApiExecutor.call`** — parse a payload into a model (works for a single
object or a list — `fromJson` is applied per-element automatically):

```dart
@override
FutureData<FooModel> getFoo(FooRequest request) {
  return ApiExecutor.call(
    () => _httpClient.post<dynamic>(ApiEndpoints.getFooDetails, data: request.toJson()),
    fromJson: FooModel.fromJson,
  );
}
```

**`ApiExecutor.voidCall`** — response body is irrelevant, for `FutureVoid`:

```dart
@override
FutureVoid deleteFoo(int id) => ApiExecutor.voidCall(
  () => _httpClient.post<dynamic>(ApiEndpoints.deleteFoo, data: {'id': id}),
);
```

**`ApiExecutor.staticCall`** — ignore the response, return a fixed value
(typically for a `FutureBool` "did it work" endpoint):

```dart
@override
FutureBool verifyFoo(FooRequest request) => ApiExecutor.staticCall(
  () => _httpClient.post<dynamic>(ApiEndpoints.verifyFoo, data: request.toJson()),
  staticData: true,
);
```

## 5. Repositories — use `RepositoryFetcher`

Location: `lib/features/<feature>/data/repositories/<feature>_repository_impl.dart`,
implementing `lib/features/<feature>/domain/repositories/<feature>_repository.dart`
(domain models only in the interface's signatures).

**Always** check connectivity via `InternetClient.isConnected` and pass it as
the **named** `isInternetConnected` argument:

```dart
@override
FutureData<Foo> getFoo(int fooId) {
  return RepositoryFetcher.fetchWithFallbackAndMap(
    isInternetConnected: _internet.isConnected,
    remoteCallback: () => _remoteDataSource.getFoo(FooRequest(id: fooId)),
  );
}
```

- `fetchWithFallback`/`fetchWithFallbackAndMap`/`fetchWithFallbackAndMapList`
  require the DTO type to implement `DomainConvertible<R>` — the `AndMap`
  variants call `.toDomain()` for you, no manual mapping callback needed.
- `fetchFromLocalAndMap`/`fetchFromLocalAndMapList` do the same for a
  local-only read.
- `onRemoteSuccess` (optional) runs only on a successful remote fetch — use
  it for a caching hook if the feature has a local data source.
  `localCallback` (optional) is the offline path; **if omitted, offline
  returns `FailureState.noInternet()`**. Only add one if the feature
  genuinely needs offline reads, and ask the user first if it's unclear
  whether that's wanted.

## 6. Dependency Injection

Use `@LazySingleton(as: InterfaceName)` for data sources and repository
implementations. After adding/changing any of these, run the `codegen` skill.

## Probing & Decision Making

- If it's unclear whether a new endpoint belongs to an existing repository or
  needs a new feature, **ASK the user**.
- If it's unclear whether an endpoint needs offline/local support, **ASK the
  user** — don't add a `localCallback` speculatively.

## Validation

1. Run the `codegen` skill.
2. Run `flutter analyze` — zero issues required.
3. Run `flutter test` — add/update tests per [`docs/testing.md`](../../../docs/testing.md).
