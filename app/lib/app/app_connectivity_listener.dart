import 'package:app/common/connectivity/connectivity_provider.dart';
import 'package:app/components/snackbar/app_snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays an app-wide notification while the device is offline.
class AppConnectivityListener extends ConsumerStatefulWidget {
  const AppConnectivityListener({required this.child, super.key});

  /// Content displayed below the connectivity listener.
  final Widget child;

  @override
  ConsumerState<AppConnectivityListener> createState() =>
      _AppConnectivityListenerState();
}

class _AppConnectivityListenerState
    extends ConsumerState<AppConnectivityListener> {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _controller;

  void _updateSnackBar(bool isOffline) {
    if (!isOffline) {
      _controller?.close();
      _controller = null;
      return;
    }

    if (_controller != null) {
      return;
    }

    final controller = ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar(
        context: context,
        message: 'application.error.network_unavailable'.tr(),
        duration: const Duration(days: 365),
      ),
    );
    _controller = controller;
    controller.closed.whenComplete(() {
      if (identical(_controller, controller)) {
        _controller = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(isOfflineProvider, (previous, next) {
      if (next case AsyncData(:final value)) {
        _updateSnackBar(value);
      }
    });

    return widget.child;
  }
}
