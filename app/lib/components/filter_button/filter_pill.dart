import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

class FilterPill extends StatelessWidget {
  const FilterPill({
    required this.isSelected,
    required this.label,
    required this.value,
    required this.onSelectedChange,
    super.key,
  });

  final bool isSelected;
  final String label;
  final String value;
  final ValueSetter<String> onSelectedChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(8);
    return Semantics(
      selected: isSelected,
      label: label,
      value: value,
      onTap: () => onSelectedChange(value),
      excludeSemantics: true,
      child: Material(
        color: _backgroundColor(theme),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: theme.colorScheme.primary),
        ),
        child: InkWell(
          onTap: () => onSelectedChange(value),
          borderRadius: borderRadius,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _foregroundColor(theme),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(ThemeData theme) {
    if (isSelected) {
      return theme.colorScheme.primary;
    }
    return DesignTokens.white;
  }

  Color _foregroundColor(ThemeData theme) {
    if (isSelected) {
      return theme.colorScheme.onPrimary;
    }
    return theme.colorScheme.primary;
  }
}
