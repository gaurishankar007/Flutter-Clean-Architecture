import 'dart:async' show StreamSubscription;

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class InternetService {
  bool get isConnected;
  Stream<InternetStatus>? get connectivityStream;
  Future<bool> checkConnection();
  Future<void> subscribeConnectivity();
  void unSubscriptionConnectivity();
}

@module
abstract class InternetServiceModule {
  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();
}

/// Check whether the device is online or offline
@LazySingleton(as: InternetService)
final class InternetServiceImpl implements InternetService {
  final InternetConnection _internetConnection;
  Stream<InternetStatus>? _connectivityStream;
  StreamSubscription<InternetStatus>? _subscription;
  bool _connection = true;

  InternetServiceImpl({required InternetConnection internetConnection})
    : _internetConnection = internetConnection;

  @override
  bool get isConnected => _connection;

  @override
  Stream<InternetStatus>? get connectivityStream => _connectivityStream;

  @override
  Future<bool> checkConnection() async =>
      await _internetConnection.hasInternetAccess;

  /// Creates a broadcast stream and updates internet status
  @override
  subscribeConnectivity() async {
    /// Broadcasts a stream which can be listen multiple times
    _connectivityStream ??= _internetConnection.onStatusChange
        .asBroadcastStream();

    /// Listen to internet status changes
    _subscription ??= _connectivityStream?.listen((status) {
      _connection = status == InternetStatus.connected;
    });
  }

  /// Stop listening to the internet status changes
  @override
  unSubscriptionConnectivity() => _subscription?.cancel();
}

/// A util class for accessing [InternetService]
abstract final class InternetUtil {
  /// Returns the registered instance of [InternetService] which is always the same
  static InternetService get I => GetIt.I<InternetService>();
}
