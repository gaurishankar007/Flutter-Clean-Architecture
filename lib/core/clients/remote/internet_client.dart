import 'dart:async' show StreamSubscription;

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class InternetClient {
  bool get isConnected;
  Stream<InternetStatus>? get connectivityStream;
  Future<bool> checkConnection();
  Future<void> subscribeConnectivity();
  void unSubscriptionConnectivity();
}

@module
abstract class InternetClientModule {
  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();
}

/// Check whether the device is online or offline
@LazySingleton(as: InternetClient)
final class InternetClientImpl implements InternetClient {
  InternetClientImpl({required InternetConnection internetConnection})
    : _internetConnection = internetConnection;

  final InternetConnection _internetConnection;
  Stream<InternetStatus>? _connectivityStream;
  StreamSubscription<InternetStatus>? _subscription;
  bool _connection = true;

  @override
  bool get isConnected => _connection;

  @override
  Stream<InternetStatus>? get connectivityStream => _connectivityStream;

  @override
  Future<bool> checkConnection() => _internetConnection.hasInternetAccess;

  /// Creates a broadcast stream and updates internet status
  @override
  Future<void> subscribeConnectivity() async {
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
  void unSubscriptionConnectivity() => _subscription?.cancel();
}

/// A util class for accessing [InternetClient]
abstract final class InternetUtil {
  /// Returns the registered instance of [InternetClient] which is always the same
  static InternetClient get I => GetIt.I<InternetClient>();
}
