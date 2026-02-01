import 'package:clean_architecture/core/data/handlers/repository_handler.dart';
import 'package:clean_architecture/core/data/models/domain_convertible.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeDto implements DomainConvertible<String> {
  const FakeDto(this.value);
  final int value;

  @override
  String toDomain() => 'Mapped: $value';
}

void main() {
  group('RepositoryHandler.fetchWithFallback', () {
    test('returns remote data when online', () async {
      final result = await RepositoryHandler.fetchWithFallback<int>(
        isInternetConnected: true,
        remoteCallback: () async => const SuccessState(data: 42),
      );
      expect(result, isA<SuccessState<int>>());
      expect(result.data, 42);
    });

    test('calls onRemoteSuccess when data is present', () async {
      int? callbackValue;
      await RepositoryHandler.fetchWithFallback<int>(
        isInternetConnected: true,
        remoteCallback: () async => const SuccessState(data: 99),
        onRemoteSuccess: (data) => callbackValue = data,
      );
      expect(callbackValue, 99);
    });

    test('does not call onRemoteSuccess when data is null', () async {
      var wasCalled = false;
      await RepositoryHandler.fetchWithFallback<int>(
        isInternetConnected: true,
        remoteCallback: () async => const SuccessState(data: null),
        onRemoteSuccess: (data) => wasCalled = true,
      );
      expect(wasCalled, false);
    });

    test(
      'returns local data when offline and localCallback is provided',
      () async {
        final result = await RepositoryHandler.fetchWithFallback<String>(
          isInternetConnected: false,
          remoteCallback: () async => const SuccessState(data: 'remote'),
          localCallback: () async => const SuccessState(data: 'local'),
        );
        expect(result, isA<SuccessState<String>>());
        expect(result.data, 'local');
      },
    );

    test('returns NoInternetState when offline and no localCallback', () async {
      final result = await RepositoryHandler.fetchWithFallback<double>(
        isInternetConnected: false,
        remoteCallback: () async => const SuccessState(data: 1),
      );
      expect(result.message, kNoInternet);
    });

    test('returns remote failure state when remote call fails', () async {
      final result = await RepositoryHandler.fetchWithFallback<String>(
        isInternetConnected: true,
        remoteCallback: () async => const FailureState(message: 'Remote error'),
      );
      expect(result, isA<FailureState<String>>());
      expect(result.message, 'Remote error');
    });
  });

  group('RepositoryHandler.fetchWithFallbackAndMap', () {
    test('maps remote data successfully when online', () async {
      final result =
          await RepositoryHandler.fetchWithFallbackAndMap<FakeDto, String>(
            isInternetConnected: true,
            remoteCallback: () async => const SuccessState(data: FakeDto(42)),
          );
      expect(result, isA<SuccessState<String>>());
      expect(result.data, 'Mapped: 42');
    });

    test('calls onRemoteSuccess with raw data before mapping', () async {
      FakeDto? rawData;
      final result =
          await RepositoryHandler.fetchWithFallbackAndMap<FakeDto, String>(
            isInternetConnected: true,
            remoteCallback: () async => const SuccessState(data: FakeDto(99)),
            onRemoteSuccess: (data) => rawData = data,
          );
      expect(rawData?.value, 99);
      expect(result.data, 'Mapped: 99');
    });

    test('maps local data when offline', () async {
      final result =
          await RepositoryHandler.fetchWithFallbackAndMap<FakeDto, String>(
            isInternetConnected: false,
            remoteCallback: () async => const SuccessState(data: FakeDto(100)),
            localCallback: () async => const SuccessState(data: FakeDto(50)),
          );
      expect(result, isA<SuccessState<String>>());
      expect(result.data, 'Mapped: 50');
    });
  });

  group('RepositoryHandler.fetchWithFallbackAndMapList', () {
    test('maps remote list data successfully when online', () async {
      final result =
          await RepositoryHandler.fetchWithFallbackAndMapList<FakeDto, String>(
            isInternetConnected: true,
            remoteCallback: () async =>
                const SuccessState(data: [FakeDto(1), FakeDto(2)]),
          );
      expect(result, isA<SuccessState<List<String>>>());
      expect(result.data, ['Mapped: 1', 'Mapped: 2']);
    });

    test('calls onRemoteSuccess with raw list before mapping', () async {
      List<FakeDto>? rawData;
      final result =
          await RepositoryHandler.fetchWithFallbackAndMapList<FakeDto, String>(
            isInternetConnected: true,
            remoteCallback: () async => const SuccessState(data: [FakeDto(3)]),
            onRemoteSuccess: (data) => rawData = data,
          );
      expect(rawData?.length, 1);
      expect(rawData?.first.value, 3);
      expect(result.data, ['Mapped: 3']);
    });
  });

  group('RepositoryHandler.fetchFromLocalAndMap', () {
    test('maps local data successfully', () async {
      final result =
          await RepositoryHandler.fetchFromLocalAndMap<FakeDto, String>(
            localCallback: () async => const SuccessState(data: FakeDto(123)),
          );
      expect(result, isA<SuccessState<String>>());
      expect(result.data, 'Mapped: 123');
    });

    test('propagates local failure state', () async {
      final result =
          await RepositoryHandler.fetchFromLocalAndMap<FakeDto, String>(
            localCallback: () async =>
                const FailureState(message: 'Local storage error'),
          );
      expect(result, isA<FailureState<String>>());
      expect(result.message, 'Local storage error');
    });
  });

  group('RepositoryHandler.fetchFromLocalAndMapList', () {
    test('maps local list data successfully', () async {
      final result =
          await RepositoryHandler.fetchFromLocalAndMapList<FakeDto, String>(
            localCallback: () async =>
                const SuccessState(data: [FakeDto(5), FakeDto(6)]),
          );
      expect(result, isA<SuccessState<List<String>>>());
      expect(result.data, ['Mapped: 5', 'Mapped: 6']);
    });

    test('propagates local failure state for list', () async {
      final result =
          await RepositoryHandler.fetchFromLocalAndMapList<FakeDto, String>(
            localCallback: () async =>
                const FailureState(message: 'Local list error'),
          );
      expect(result, isA<FailureState<List<String>>>());
      expect(result.message, 'Local list error');
    });
  });
}
