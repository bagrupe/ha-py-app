import 'package:app/common/app_config/app_config.dart';
import 'package:app/routes/maengel/common/mangel.dart';
import 'package:app/routes/melder/components/report_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// List item for a defect report.
class MaengelListeItem extends ConsumerWidget {
  /// Creates a list item for the given defect report.
  const MaengelListeItem({required this.mangel, super.key});

  /// Defect report displayed by this item.
  final Mangel mangel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conf = ref.watch(appConfigProvider);
    final imageUrl = mangel.bilderSlotId != null
        ? '${conf.backendUrl}/api/file/${mangel.bilderSlotId}/300'
        : null;
    final coordinates = mangel.coordinates;
    final detailTexts =
        mangel.adresse?.split(', ') ??
        [
          if (coordinates != null) ...[
            coordinates.latitude.toStringAsFixed(5),
            coordinates.longitude.toStringAsFixed(5),
          ],
        ];

    return ReportListItem(
      title: mangel.kategorie,
      detailTexts: detailTexts,
      imageUrl: imageUrl,
      onTap: () => context.push('/karte/maengel/detail/${mangel.id}'),
    );
  }
}
