import 'dart:async';

import 'package:clean_architecture/core/data/states/data_state.dart';

// <==================== Data State ====================>
/// A [DataState] containing a [List] of [T].
typedef DataList<T> = DataState<List<T>>;

/// An asynchronous operation that completes with a [DataState] containing [T].
typedef FutureData<T> = Future<DataState<T>>;

/// An asynchronous operation that completes with a [DataState] containing a [List] of [T].
typedef FutureList<T> = Future<DataList<T>>;

/// An asynchronous operation that completes with a [DataState] containing a [String].
typedef FutureString = Future<DataState<String>>;

/// An asynchronous operation that completes with a [DataState] containing a [bool].
typedef FutureBool = Future<DataState<bool>>;

/// An asynchronous operation that completes with a [DataState] containing an [int].
typedef FutureInt = Future<DataState<int>>;

/// An asynchronous operation that completes with a [DataState] containing `void` (no return payload).
typedef FutureVoid = Future<DataState<void>>;

/// A [DataState] representing an operation with no return payload (`void`).
typedef Void = DataState<void>;

/// A stream of [DataState] events containing [T].
typedef StreamData<T> = Stream<DataState<T>>;

/// A stream of [DataState] events containing a [List] of [T].
typedef StreamList<T> = Stream<DataList<T>>;

/// A stream subscription of [DataState] events containing [T].
typedef StreamDataSubscription<T> = StreamSubscription<DataState<T>>;

/// A stream subscription of [DataState] events containing a [List] of [T].
typedef StreamListSubscription<T> = StreamSubscription<DataList<T>>;

// <==================== Map ====================>
/// Represents a decoded JSON object or key-value request/response payload.
typedef JsonMap = Map<String, dynamic>;

/// Represents a list of JSON objects.
typedef JsonList = List<JsonMap>;

/// String key-value mapping (ideal for HTTP headers, query parameters, form fields).
typedef StringMap = Map<String, String>;

/// String-to-boolean flags or feature maps.
typedef BoolMap = Map<String, bool>;

/// A raw, loosely typed map with dynamic keys and values.
typedef DynamicMap = Map<dynamic, dynamic>;

/// A list of loosely typed [DynamicMap] elements.
typedef DynamicMapList = List<DynamicMap>;
