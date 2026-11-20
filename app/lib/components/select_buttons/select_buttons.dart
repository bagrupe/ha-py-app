import 'package:app/common/extensions/iterable.dart';
import 'package:app/components/buttons/toggle_style_button.dart';
import 'package:flutter/material.dart';

/// Repräsentiert die Daten eines Auswahlbuttons mit Anzeige und Wert.
class SelectButtonData<T> {
  /// Erstellt eine neue Instanz von [SelectButtonData] mit [label] und [value].
  const SelectButtonData(this.label, this.value);

  /// Das Widget, das als Beschriftung angezeigt wird.
  final Widget label;

  /// Der Wert, der mit diesem Button verbunden ist.
  final T value;
}

/// Ein Widget, das eine Reihe von Auswahlbuttons horizontal anzeigt und eine Auswahl ermöglicht.
class SelectButtons<T> extends StatelessWidget {
  /// Erstellt eine neue Instanz von [SelectButtons] mit den erforderlichen Parametern.
  const SelectButtons({
    required this.selected,
    required this.onSelectionChange,
    required this.options,
    super.key,
  });

  /// Der aktuell ausgewählte Wert.
  final T selected;

  /// Callback, das bei Auswahländerung mit dem neuen Wert aufgerufen wird.
  final void Function(T) onSelectionChange;

  /// Die Liste der verfügbaren Auswahloptionen.
  final List<SelectButtonData<T>> options;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: options
          .map<Widget>(
            (o) => ToggleStyleButton(
              isSelected: selected == o.value,
              onPressed: () => onSelectionChange(o.value),
              child: o.label,
            ),
          )
          .joinWithElement(const SizedBox(width: 10)),
    );
  }
}
