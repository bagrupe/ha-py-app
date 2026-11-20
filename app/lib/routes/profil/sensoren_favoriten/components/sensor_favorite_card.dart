import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/sensor_type_extension.dart';
import 'package:app/common/mapbox_reverse_geocoding/mapbox_reverse_geocoding.dart';
import 'package:app/graphql/__generated__/sensoren.graphql.dart';
import 'package:app/routes/karte/components/sensor_trend_pills.dart';
import 'package:app/routes/profil/sensoren_favoriten/components/sensor_location_pill.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/symbols.dart';

class SensorFavoriteCard extends ConsumerWidget {
  const SensorFavoriteCard({required this.sensor, super.key});

  final Query_ListSensoren_sensoren_docs sensor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final fields =
        sensor.felder
            ?.whereType<Query_ListSensoren_sensoren_docs_felder>()
            .where((f) => f.werteart != null)
            .toList() ??
        [];
    final field =
        fields.firstWhereOrNull((f) => f.isPegel || f.isGlaette) ??
        fields.firstOrNull;
    if (field == null) return const SizedBox.shrink();

    final levelIndex = field.isPegel
        ? sensor.waterLevelIndex
        : field.isGlaette
        ? sensor.roadIceLevelIndex
        : null;
    final description = field.werteart?.textForLevel(levelIndex)?.description;
    final trend = field.trend;

    final location = sensor.position.length >= 2
        ? ref
              .watch(
                mapboxReverseGeocodingProviderSensors(
                  LatLng(sensor.position[0], sensor.position[1]),
                ),
              )
              .value
        : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: DesignTokens.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DesignTokens.gray300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Symbols.bookmark_star,
                  size: 24,
                  fill: 1,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    field.werteart!.name,
                    style: textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (location != null) ...[
                  const SizedBox(width: 8),
                  SensorLocationPill(label: location),
                ],
              ],
            ),
            if (field.hasNumericValue) ...[
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    field.displayValue,
                    style: textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    field.displayUnit,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
            if (trend != null) ...[
              const SizedBox(height: 12),
              SensorTrendPills(
                trend: trend,
                fieldIcon: field.displayIcon,
                unit: field.displayUnit,
              ),
            ],
            if (description != null) ...[
              const SizedBox(height: 12),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.push('/karte/sensor/${sensor.id}'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'application.sensor.favorite_card.to_detail_page'.tr(),
                    style: textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
