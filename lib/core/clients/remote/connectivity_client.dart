// © 2026 vAIolin LLC. All rights reserved.
//
// This software and its associated materials are the intellectual
// property of vAIolin LLC. Unauthorized copying, modification,
// distribution, or use of this code, in whole or in part, without
// express written permission from vAIolin LLC is strictly prohibited.
//
// For licensing inquiries, contact: snehesh@vaiolin.ai

import 'dart:async' show StreamSubscription;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

abstract interface class ConnectivityClient {
  bool get isConnected;
  Stream<List<ConnectivityResult>>? get connectivityStream;
  Future<void> subscribeConnectivity();
  void unSubscriptionConnectivity();
}

@module
abstract class ConnectivityClientModule {
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}

/// Check whether the device is online or offline
@LazySingleton(as: ConnectivityClient)
final class ConnectivityClientImpl implements ConnectivityClient {
  ConnectivityClientImpl({required Connectivity connectivity})
    : _connectivity = connectivity;

  final Connectivity _connectivity;
  Stream<List<ConnectivityResult>>? _connectivityStream;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _connection = true;

  @override
  bool get isConnected => _connection;

  @override
  Stream<List<ConnectivityResult>>? get connectivityStream =>
      _connectivityStream;

  /// Creates a broadcast stream and updates internet status
  @override
  Future<void> subscribeConnectivity() async {
    /// Broadcasts a stream which can be listen multiple times
    _connectivityStream ??= _connectivity.onConnectivityChanged
        .asBroadcastStream();

    /// Listen to internet status changes
    _subscription ??= _connectivityStream?.listen((results) {
      _connection =
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi);
    });
  }

  /// Stop listening to the internet status changes
  @override
  void unSubscriptionConnectivity() => _subscription?.cancel();
}

/// A util class for accessing [ConnectivityClient] singleton instance.
abstract final class ConnectivityProvider {
  /// Returns the [ConnectivityClient] singleton instance.
  static ConnectivityClient get I => GetIt.I<ConnectivityClient>();
}
