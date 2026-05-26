import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkStatus {
  const NetworkStatus({
    required this.results,
    this.isChecking = false,
  });

  final List<ConnectivityResult> results;
  final bool isChecking;

  bool get isOnline =>
      results.isNotEmpty && !results.contains(ConnectivityResult.none);
  bool get isOffline => !isOnline;

  NetworkStatus copyWith({
    List<ConnectivityResult>? results,
    bool? isChecking,
  }) {
    return NetworkStatus(
      results: results ?? this.results,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}

class NetworkStatusController extends StateNotifier<NetworkStatus> {
  NetworkStatusController(this._connectivity)
      : super(
          const NetworkStatus(
            results: [ConnectivityResult.none],
            isChecking: true,
          ),
        ) {
    _init();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      state = NetworkStatus(results: results, isChecking: false);
    });
  }

  final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    state = NetworkStatus(results: results, isChecking: false);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final networkStatusProvider =
    StateNotifierProvider<NetworkStatusController, NetworkStatus>((ref) {
  return NetworkStatusController(ref.watch(connectivityProvider));
});
