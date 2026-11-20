import 'package:app/common/design_tokens.dart';
import 'package:app/graphql/__generated__/fragments.graphql.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// List item for a reporting execution history entry.
class ReportHistoryItem extends StatelessWidget {
  const ReportHistoryItem({required this.history, super.key});

  /// History entry displayed by this item.
  final Fragment_HistorieEintrag history;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final title =
        history.statusAenderungBeschreibung ??
        history.statusAenderung ??
        'application.melder.history_entry'.tr();

    return Semantics(
      label: title,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 7),
                decoration: const BoxDecoration(
                  color: DesignTokens.green500,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: textTheme.bodyLarge)),
          ],
        ),
      ),
    );
  }
}
