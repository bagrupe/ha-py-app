import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';

class WidgetbookCustomizationAddon extends WidgetbookAddon<String> {
  WidgetbookCustomizationAddon({this.initialKommune})
    : super(name: 'Customization');
  final String? initialKommune;

  @override
  List<Field> get fields => [
    ObjectDropdownField<String>(
      name: 'kommune',
      values: kommuneIdByKommuneName.keys.toList(),
      initialValue: initialKommune ?? kommuneIdByKommuneName.keys.first,
      labelBuilder: (entry) => entry,
    ),
  ];

  @override
  String valueFromQueryGroup(Map<String, String> group) =>
      valueOf('kommune', group) as String;

  @override
  Widget buildUseCase(BuildContext context, Widget child, String setting) {
    return _CustomizationUpdater(
      kommuneId: kommuneIdByKommuneName[setting]!,
      child: child,
    );
  }
}

class _CustomizationUpdater extends ConsumerWidget {
  const _CustomizationUpdater({required this.child, required this.kommuneId});
  final Widget child;
  final String kommuneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(appConfigProvider.notifier).setKommune(kommuneId);
    });

    final theme = ref.watch(themeProvider);

    return Theme(
      data: theme,
      child: ColoredBox(color: theme.scaffoldBackgroundColor, child: child),
    );
  }
}
