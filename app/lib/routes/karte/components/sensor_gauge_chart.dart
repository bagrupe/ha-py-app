import 'dart:math' as math;

import 'package:app/common/design_tokens.dart';
import 'package:app/routes/karte/components/sensor_level_pill.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

part 'sensor_gauge_painter.dart';

/// Shows a sensor's current reading as a gauge chart with four colored danger
/// zones (green/yellow/orange/red). Zone boundaries and the scale max come
/// from the sensor's thresholds; the current level (for needle color, pill,
/// and edge label) is computed server-side and only displayed here.
class SensorGaugeChart extends StatelessWidget {
  const SensorGaugeChart({
    required this.value,
    required this.greenThreshold,
    required this.yellowThreshold,
    required this.orangeThreshold,
    required this.scaleMax,
    required this.currentLevelIndex,
    required this.unit,
    this.currentLabel,
    super.key,
  });

  final double value;
  final double greenThreshold;
  final double yellowThreshold;
  final double orangeThreshold;
  final double scaleMax;
  final int currentLevelIndex;
  final String unit;
  final String? currentLabel;

  /// Diameter and bounding-box height of the gauge arc, in logical pixels
  /// matching the Figma design 1:1 (outer radius 90, sweeping 30° past the
  /// horizontal on each side, see `_GaugePainter`).
  static const _diameter = 180.0;
  static const _arcHeight = 135.0;
  static const _textZoneHeight = 60.0;

  /// Colors of the four danger zones (index 0=safe .. 3=critical), also used
  /// for sensors without a numeric scale (e.g. road-ice warning level).
  static const zoneColors = [
    DesignTokens.statusGreen500,
    DesignTokens.statusYellow500,
    DesignTokens.statusOrange500,
    DesignTokens.statusRed500,
  ];

  @override
  Widget build(BuildContext context) {
    if (scaleMax <= 0 ||
        greenThreshold <= 0 ||
        yellowThreshold <= greenThreshold ||
        orangeThreshold <= yellowThreshold ||
        scaleMax <= orangeThreshold) {
      return const SizedBox.shrink();
    }

    final color = zoneColors[currentLevelIndex.clamp(0, 3)];
    final formattedValue = NumberFormat('#0.#').format(value);
    final textScale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
    final textZoneHeight = _textZoneHeight * textScale;

    return Semantics(
      label: currentLabel == null
          ? 'application.sensor.semantics.gauge_value'.tr(
              namedArgs: {'value': formattedValue, 'unit': unit},
            )
          : 'application.sensor.semantics.gauge_value_with_level'.tr(
              namedArgs: {
                'value': formattedValue,
                'unit': unit,
                'level': currentLabel!,
              },
            ),
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              width: _diameter,
              height: _arcHeight + textZoneHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    child: CustomPaint(
                      size: const Size(_diameter, _arcHeight),
                      painter: _GaugePainter(
                        value: value,
                        greenThreshold: greenThreshold,
                        yellowThreshold: yellowThreshold,
                        orangeThreshold: orangeThreshold,
                        scaleMax: scaleMax,
                        zoneColors: zoneColors,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(textScaler: TextScaler.linear(textScale)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$formattedValue $unit',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                          if (currentLabel != null) ...[
                            const SizedBox(height: 4),
                            SensorLevelPill(color: color, label: currentLabel!),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
