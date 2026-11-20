import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/sensor_type_extension.dart';
import 'package:app/graphql/__generated__/sensoren.graphql.dart';
import 'package:app/routes/karte/components/sensor_gauge_chart.dart';
import 'package:app/routes/karte/components/sensor_level_hint.dart';
import 'package:app/routes/karte/components/sensor_level_pill.dart';
import 'package:app/routes/karte/components/sensor_trend_pills.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Level pill plus hint box for a road-ice sensor field, shown in the
/// `SensorCard.belowContent` slot, if a danger level could be computed.
class SensorRoadIceLevelContent extends StatelessWidget {
  const SensorRoadIceLevelContent({
    required this.sensor,
    required this.field,
    super.key,
  });

  final Fragment_SensorDangerLevels sensor;
  final Fragment_SensorFieldReading field;

  @override
  Widget build(BuildContext context) {
    final levelIndex = sensor.roadIceLevelIndex;

    if (levelIndex == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SensorLevelPill(
            color: DesignTokens.gray500,
            label: 'application.sensor.status_unknown_pill'.tr(),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DesignTokens.gray100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: DesignTokens.gray900,
                      size: 24,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'application.sensor.status_unknown_title'.tr(),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: DesignTokens.gray900),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'application.sensor.status_unknown_description'.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: DesignTokens.gray900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final text = field.werteart?.textForLevel(levelIndex);
    final trend = field.trend;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (text?.shortLabel != null) ...[
          SensorLevelPill(
            color: SensorGaugeChart.zoneColors[levelIndex.clamp(0, 3)],
            label: text!.shortLabel!,
          ),
          const SizedBox(height: 12),
        ],
        if (text != null) ...[
          SensorLevelHint(levelIndex: levelIndex, text: text),
          if (trend != null) const SizedBox(height: 12),
        ],
        if (trend != null)
          SensorTrendPills(
            trend: trend,
            fieldIcon: field.displayIcon,
            unit: field.displayUnit,
          ),
      ],
    );
  }
}
