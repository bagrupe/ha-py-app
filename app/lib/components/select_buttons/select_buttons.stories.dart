import 'package:app/components/select_buttons/select_buttons.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'ToggleButtons', type: SelectButtons)
Widget toggleButtons(BuildContext context) => const _InteractiveToggleButtons();

class _InteractiveToggleButtons extends StatefulWidget {
  const _InteractiveToggleButtons();

  @override
  State<_InteractiveToggleButtons> createState() =>
      _InteractiveToggleButtonsState();
}

class _InteractiveToggleButtonsState extends State<_InteractiveToggleButtons> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return SelectButtons<int>(
      selected: value,
      onSelectionChange: (n) => setState(() => value = n),
      options: List.generate(3, _exampleData),
    );
  }
}

SelectButtonData<int> _exampleData(int index) =>
    SelectButtonData(Text(index.toString()), index);
