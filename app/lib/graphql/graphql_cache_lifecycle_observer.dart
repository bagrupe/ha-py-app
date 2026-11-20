import 'dart:async';

import 'package:flutter/widgets.dart';

/// Flushes pending GraphQL cache writes before the application is suspended.
class GraphQLCacheLifecycleObserver extends WidgetsBindingObserver {
  /// Creates an observer backed by the provided asynchronous [flush] operation.
  GraphQLCacheLifecycleObserver({required this.flush});

  /// Persists all pending cache writes.
  final Future<void> Function() flush;

  Future<void>? _pendingFlush;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        return;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _flushCache();
    }
  }

  void _flushCache() {
    if (_pendingFlush != null) return;

    final operation = flush();
    _pendingFlush = operation;
    unawaited(_completeFlush(operation));
  }

  Future<void> _completeFlush(Future<void> operation) async {
    try {
      await operation;
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'GraphQL cache',
        ),
      );
    } finally {
      if (identical(_pendingFlush, operation)) {
        _pendingFlush = null;
      }
    }
  }
}
