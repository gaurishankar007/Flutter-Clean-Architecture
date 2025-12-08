import '../../utils/type_defs.dart';

abstract interface class UseCase<T, P extends Object?> {
  FutureData<T> call(P request);
}

abstract interface class UseCaseNoParameter<T> {
  FutureData<T> call();
}
