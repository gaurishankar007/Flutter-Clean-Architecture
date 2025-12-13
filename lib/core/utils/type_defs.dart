import 'package:clean_architecture/core/data_states/data_state.dart';

// Data State Types
typedef FutureData<T> = Future<DataState<T>>;
typedef FutureList<T> = Future<DataState<List<T>>>;
typedef FutureBool = Future<DataState<bool>>;
typedef FutureNull = Future<DataState<Null>>;
typedef FutureString = Future<DataState<String>>;
typedef FutureInt = Future<DataState<int>>;

typedef MapDynamic = Map<String, dynamic>;
typedef MapString = Map<String, String>;
typedef MapBool = Map<String, bool>;
