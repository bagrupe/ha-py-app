import 'package:app/common/design_tokens.dart';
import 'package:app/routes/antraege/components/schritte/cascade_entry.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/formular_field_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CascadeSearchSelection extends StatelessWidget {
  const CascadeSearchSelection({
    required this.entry,
    required this.onEdit,
    required this.onClear,
    super.key,
    this.label,
  });

  final CascadeEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onClear;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: highlightedFieldBackground(theme),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.primaryColor),
        borderRadius: formularFieldBorderRadius,
      ),
      child: InkWell(
        borderRadius: formularFieldBorderRadius,
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (label case final label? when label.isNotEmpty)
                      Text(
                        label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: DesignTokens.gray900,
                        ),
                      ),
                    Text(
                      entry.pathLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: DesignTokens.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('cascade_search_selection_edit'),
                tooltip: 'application.antraege.formular_schritt.edit_category'
                    .tr(),
                onPressed: onEdit,
                color: theme.primaryColor,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                key: const Key('cascade_search_selection_clear'),
                tooltip: 'application.antraege.formular_schritt.clear_category'
                    .tr(),
                onPressed: onClear,
                color: DesignTokens.gray500,
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
