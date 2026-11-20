import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits whether the device currently has no active network interface.
final isOfflineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  yield _isOffline(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(_isOffline).distinct();
});

/// Returns whether [results] contain no active network interface.
bool _isOffline(List<ConnectivityResult> results) {
  return results.isEmpty ||
      results.every((result) => result == ConnectivityResult.none);
}
