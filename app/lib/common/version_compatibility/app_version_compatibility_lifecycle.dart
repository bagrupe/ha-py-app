import 'dart:async';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/version_compatibility/app_semver.dart';
import 'package:app/common/version_compatibility/app_version_compatibility_service.dart';
import 'package:app/common/version_compatibility/components/update_dialog.dart';
import 'package:app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Prüft bei jedem Fortsetzen der App die Mindestversion gegenüber dem Backend.
class AppVersionCompatibilityLifecycleHost extends ConsumerStatefulWidget {
  const AppVersionCompatibilityLifecycleHost({super.key, this.child});

  final Widget? child;

  @override
  ConsumerState<AppVersionCompatibilityLifecycleHost> createState() =>
      _AppVersionCompatibilityLifecycleHostState();
}

class _AppVersionCompatibilityLifecycleHostState
    extends ConsumerState<AppVersionCompatibilityLifecycleHost>
    with WidgetsBindingObserver {
  bool _dialogOpen = false;
  bool _checkInFlight = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkCompatibility());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_checkCompatibility());
    }
  }

  Future<void> _checkCompatibility() async {
    if (!mounted || _dialogOpen || _checkInFlight) {
      return;
    }
    _checkInFlight = true;
    try {
      final backendUrl = ref.read(appConfigProvider).backendUrl;
      final payload = await fetchAppVersionCompatibility(
        backendBaseUrl: backendUrl,
      );
      if (!mounted || payload == null) {
        return;
      }

      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;
      if (isAppVersionCompatible(
        appVersion,
        payload.minimumCompatibleAppVersion,
      )) {
        return;
      }

      if (!mounted || _dialogOpen) {
        return;
      }

      final navigatorContext = rootNavigatorKey.currentContext;
      if (navigatorContext == null || !navigatorContext.mounted) {
        return;
      }

      _dialogOpen = true;
      try {
        await showDialog<void>(
          context: navigatorContext,
          barrierDismissible: false,
          builder: (dialogContext) => PopScope(
            canPop: false,
            child: UpdateDialog(
              appVersion: appVersion,
              minimumCompatibleAppVersion: payload.minimumCompatibleAppVersion,
            ),
          ),
        );
      } finally {
        _dialogOpen = false;
      }
    } finally {
      _checkInFlight = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child ?? const SizedBox.shrink();
}
