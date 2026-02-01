import 'dart:async';

import 'package:clean_architecture/core/clients/remote/internet_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../testing/mocks/external/external_mocks.dart'
    show MockInternetConnection;

void main() {
  late MockInternetConnection mockInternetConnection;
  late InternetClientImpl internetClient;

  setUpAll(() {
    mockInternetConnection = MockInternetConnection();
    internetClient = InternetClientImpl(
      internetConnection: mockInternetConnection,
    );
  });

  group('checkConnection', () {
    test('returns true when hasInternetAccess is true', () async {
      when(
        () => mockInternetConnection.hasInternetAccess,
      ).thenAnswer((_) async => true);

      final result = await internetClient.checkConnection();

      expect(result, true);
      verify(() => mockInternetConnection.hasInternetAccess).called(1);
    });

    test('returns false when hasInternetAccess is false', () async {
      when(
        () => mockInternetConnection.hasInternetAccess,
      ).thenAnswer((_) async => false);

      final result = await internetClient.checkConnection();

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
      await internetClient.subscribeConnectivity();

      // Emit a status change
      controller.add(InternetStatus.disconnected);
      // Wait for the async listener to process
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(internetClient.isConnected, false);

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

      await internetClient.subscribeConnectivity();
      internetClient.unSubscriptionConnectivity();

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

      await internetClient.subscribeConnectivity();

      expect(internetClient.connectivityStream, isNotNull);

      await controller.close();
    });
  });
}
