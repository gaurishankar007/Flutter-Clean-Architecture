import 'dart:async';

import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../testing/mocks/external/external_mocks.dart'
    show MockInternetConnection;

void main() {
  late MockInternetConnection mockInternetConnection;
  late InternetServiceImpl internetService;

  setUpAll(() {
    mockInternetConnection = MockInternetConnection();
    internetService = InternetServiceImpl(
      internetConnection: mockInternetConnection,
    );
  });

  group('checkConnection', () {
    test('returns true when hasInternetAccess is true', () async {
      when(
        () => mockInternetConnection.hasInternetAccess,
      ).thenAnswer((_) async => true);

      final result = await internetService.checkConnection();

      expect(result, true);
      verify(() => mockInternetConnection.hasInternetAccess).called(1);
    });

    test('returns false when hasInternetAccess is false', () async {
      when(
        () => mockInternetConnection.hasInternetAccess,
      ).thenAnswer((_) async => false);

      final result = await internetService.checkConnection();

      expect(result, false);
      verify(() => mockInternetConnection.hasInternetAccess).called(1);
    });
  });

  group('subscribeConnectivity', () {
    test('updates _connection on status change', () async {
      // Arrange: Create a stream controller for InternetStatus
      final controller = StreamController<InternetStatus>.broadcast();
      when(
        () => mockInternetConnection.onStatusChange,
      ).thenAnswer((_) => controller.stream);
      when(
        () => mockInternetConnection.hasInternetAccess,
      ).thenAnswer((_) async => false);

      // Act: Subscribe to connectivity
      await internetService.subscribeConnectivity();

      // Emit a status change
      controller.add(InternetStatus.disconnected);
      // Wait for the async listener to process
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(internetService.isConnected, false);

      // Clean up
      await controller.close();
    });
  });

  group('unSubscriptionConnectivity', () {
    test('cancels the subscription', () async {
      final controller = StreamController<InternetStatus>.broadcast();
      when(
        () => mockInternetConnection.onStatusChange,
      ).thenAnswer((_) => controller.stream);
      when(
        () => mockInternetConnection.hasInternetAccess,
      ).thenAnswer((_) async => true);

      await internetService.subscribeConnectivity();
      internetService.unSubscriptionConnectivity();

      // After cancelling, adding to the stream should not throw
      controller.add(InternetStatus.connected);
      await controller.close();
    });
  });

  group('connectivityStream', () {
    test('returns the broadcast stream', () async {
      final controller = StreamController<InternetStatus>.broadcast();
      when(
        () => mockInternetConnection.onStatusChange,
      ).thenAnswer((_) => controller.stream);

      await internetService.subscribeConnectivity();

      expect(internetService.connectivityStream, isNotNull);

      await controller.close();
    });
  });
}
