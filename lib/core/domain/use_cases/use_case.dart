import 'package:clean_architecture/core/types/types.dart';

abstract interface class UseCase<T, P extends Object?> {
  FutureData<T> call(P request);
}

abstract interface class UseCaseNoParameter<T> {
  FutureData<T> call();
}
