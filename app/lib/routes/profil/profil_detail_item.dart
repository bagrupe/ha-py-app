import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ProfilDetailTapCallback = void Function(BuildContext, WidgetRef);

typedef ProfilDetailCountCallback = int? Function(WidgetRef ref);

class ProfilDetailItem {
  ProfilDetailItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.count,
  });

  final ProfilDetailTapCallback? onTap;

  final Widget icon;

  final String label;

  final ProfilDetailCountCallback? count;
}
