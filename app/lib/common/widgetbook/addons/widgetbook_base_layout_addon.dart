import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class WidgetbookBaseLayoutAddon extends WidgetbookAddon<void> {
  WidgetbookBaseLayoutAddon() : super(name: 'Base Layout');

  @override
  Widget buildUseCase(BuildContext context, Widget child, void setting) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: child,
      ),
    );
  }

  @override
  List<Field> get fields => [];

  @override
  void valueFromQueryGroup(Map<String, String> group) {}
}
