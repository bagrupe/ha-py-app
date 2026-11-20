import 'package:flutter/material.dart';

/// Displays a reusable filter chip with application-specific styling.
class AppFilterChip extends StatelessWidget {
  /// Creates an application filter chip.
  const AppFilterChip({
    required this.label,
    required this.semanticLabel,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Visible chip label.
  final String label;

  /// Accessible label announced by screen readers.
  final String semanticLabel;

  /// Whether the filter is currently selected.
  final bool selected;

  /// Called when the chip is selected.
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = MediaQuery.textScalerOf(context).scale(28);

    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        child: FilterChip(
          selected: selected,
          label: Text(label),
          onSelected: (_) => onSelected(),
          showCheckmark: false,
          backgroundColor: colorScheme.surfaceContainerLow,
          selectedColor: colorScheme.primary,
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
