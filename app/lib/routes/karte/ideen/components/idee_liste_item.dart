import 'package:app/common/app_config/app_config.dart';
import 'package:app/routes/ideas/common/idea.dart';
import 'package:app/routes/melder/components/report_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// List item for a submitted idea.
class IdeeListeItem extends ConsumerWidget {
  /// Creates a list item for the given idea.
  const IdeeListeItem({required this.idea, super.key});

  /// Idea displayed by this item.
  final Idea idea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = idea.image?.imageUrl(
      ref.watch(appConfigProvider).backendUrl,
      300,
    );
    final detailTexts =
        idea.address?.split(', ') ??
        [
          idea.coordinates?.latitude.toStringAsFixed(5) ?? '0.00000',
          idea.coordinates?.longitude.toStringAsFixed(5) ?? '0.00000',
        ];

    return ReportListItem(
      title: idea.title,
      detailTexts: detailTexts,
      imageUrl: imageUrl,
      onTap: () => context.push('/karte/ideen/detail/${idea.id}'),
    );
  }
}
