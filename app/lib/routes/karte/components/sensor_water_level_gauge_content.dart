import 'package:app/common/extensions/sensor_type_extension.dart';
import 'package:app/graphql/__generated__/sensoren.graphql.dart';
import 'package:app/routes/karte/components/sensor_gauge_chart.dart';
import 'package:app/routes/karte/components/sensor_level_hint.dart';
import 'package:app/routes/karte/components/sensor_trend_pills.dart';
import 'package:flutter/material.dart';

/// Gauge chart plus hint box for a water-level sensor field, shown in the
/// `SensorCard.belowContent` slot, if a danger level could be computed.
class SensorWaterLevelGaugeContent extends StatelessWidget {
  const SensorWaterLevelGaugeContent({
    required this.sensor,
    required this.field,
    super.key,
  });

  final Fragment_SensorDangerLevels sensor;
  final Fragment_SensorFieldReading field;

  @override
  Widget build(BuildContext context) {
    final levelIndex = sensor.waterLevelIndex;
    final green = sensor.grenzwertInfo1;
    final yellow = sensor.grenzwertInfo2;
    final orange = sensor.grenzwertInfo3;
    final scaleMax = sensor.grenzwertInfo4;
    final value = double.tryParse(field.currentValue ?? '');

    if (levelIndex == null ||
        green == null ||
        yellow == null ||
        orange == null ||
        scaleMax == null ||
        value == null) {
      return const SizedBox.shrink();
    }

    final valueType = field.werteart;
    final currentText = valueType?.textForLevel(levelIndex);
    final trend = field.trend;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SensorGaugeChart(
          value: value,
          greenThreshold: green,
          yellowThreshold: yellow,
          orangeThreshold: orange,
          scaleMax: scaleMax,
          currentLevelIndex: levelIndex,
          unit: field.displayUnit,
          currentLabel: currentText?.shortLabel,
        ),
        if (currentText != null) ...[
          const SizedBox(height: 12),
          SensorLevelHint(levelIndex: levelIndex, text: currentText),
        ],
        if (trend != null) ...[
          const SizedBox(height: 12),
          SensorTrendPills(
            trend: trend,
            fieldIcon: field.displayIcon,
            unit: field.displayUnit,
          ),
        ],
      ],
    );
  }
}
