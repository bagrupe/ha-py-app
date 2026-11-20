import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Wrapper widget that provides localization support via EasyLocalization.
class LocalizedApp extends StatelessWidget {
  const LocalizedApp({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('de'),
      child: child,
    );
  }
}
