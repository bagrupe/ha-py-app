import 'package:flutter/material.dart';

/// Ein Button, der einen Filtertext anzeigt und beim Drücken ein modales Bottom Sheet mit Filteroptionen öffnet.
class TermineFilterButton extends StatelessWidget {
  /// Erstellt einen TermineFilterButton mit dem anzuzeigenden Text und dem Filter-Sheet.
  const TermineFilterButton({
    required this.filterText,
    required this.filterSheet,
    super.key,
  });

  /// Der Text, der auf dem Button angezeigt wird.
  final String filterText;

  /// Das Widget, das als modales Bottom Sheet angezeigt wird.
  final Widget filterSheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => showModalBottomSheet<String?>(
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return filterSheet;
        },
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(filterText, style: theme.textTheme.bodySmall),
          const Icon(Icons.expand_more),
        ],
      ),
    );
  }
}
