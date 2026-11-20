import 'package:app/common/startup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for initial execution of setup logic before display child.
/// Observes setup-provider and returns child widget.
class AppInitializer extends ConsumerWidget {
  const AppInitializer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(setupProvider);

    return child;
  }
}
