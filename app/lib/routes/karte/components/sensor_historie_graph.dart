import 'dart:math';

import 'package:app/common/design_tokens.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/sensoren.graphql.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

typedef SensorFeld = Query_Sensor_sensor_felder;

/// Erlaubte Intervalle für die Achsenbeschriftung im Diagramm.
const _allowedIntervals = <double>[1, 2, 5, 10, 20, 50, 100, 200, 500];

const _minLabels = 2;
const _maxLabels = 5;

/// Bestimmt das beste Intervall für die Y-Achse basierend auf den gegebenen Werten.
/// [values] sind die Werte, für die das Intervall berechnet wird.
double _findBestInterval(List<double> values) {
  if (values.length < 2) return 1;

  final gap = values.max - values.min;
  final minInterval = gap / _minLabels;
  final maxInterval = gap / _maxLabels;

  final between = _allowedIntervals.firstWhereOrNull(
    (i) => i > minInterval && i < maxInterval,
  );
  if (between != null) return between;

  return _allowedIntervals.sorted((a, b) {
    final dA = min((a - minInterval).abs(), (a - maxInterval).abs());
    final dB = min((b - minInterval).abs(), (b - maxInterval).abs());

    return (dA - dB).sign.truncate();
  }).first;
}

/// Widget zur Darstellung eines Liniendiagramms mit historischen Sensordaten.
/// Zeigt die Werte eines Sensors über die Zeit an und passt die Achsenbeschriftung an den gewählten Zeitraum an.
class SensorHistorieGraph extends StatelessWidget {
  /// Erstellt ein neues SensorHistorieGraph-Widget mit den angegebenen Daten und Modus.
  const SensorHistorieGraph({
    required this.feld,
    required this.historyMode,
    super.key,
  });

  /// Das Sensordatenfeld mit historischen Werten.
  final SensorFeld feld;

  /// Der Modus der Historie, der den Zeitraum der Anzeige bestimmt.
  final Enum_HistoryMode historyMode;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    final werte = feld.historie.map((h) => h.value).toList();
    final yInterval = _findBestInterval(werte);

    return SizedBox(
      height: 140,
      child: feld.historie.isEmpty
          ? Center(child: Text('application.sensor.no_data_available'.tr()))
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: BoxBorder.all(color: DesignTokens.gray300),
              ),
              child: LineChart(
                duration: Duration.zero,
                LineChartData(
                  lineTouchData: LineTouchData(
                    getTouchedSpotIndicator: (a, b) => b
                        .map(
                          (e) => TouchedSpotIndicatorData(
                            const FlLine(
                              color: DesignTokens.gray900,
                              strokeWidth: 1.5,
                            ),
                            FlDotData(
                              getDotPainter: (_, __, ___, ____) =>
                                  FlDotCirclePainter(
                                    color: DesignTokens.gray900,
                                    radius: 5,
                                  ),
                            ),
                          ),
                        )
                        .toList(),
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (spots) => spots
                          .map(
                            (s) => LineTooltipItem(
                              '${DateFormat(historyMode == Enum_HistoryMode.LAST_DAY ? 'HH:mm' : 'dd.MM. HH:mm').format(DateTime.fromMillisecondsSinceEpoch(s.x.toInt()))}\n${s.y.toStringAsFixed(2)}${feld.werteart!.einheit}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                          .toList(),
                      getTooltipColor: (_) =>
                          Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: yInterval / 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: (value % yInterval) == 0
                          ? DesignTokens.gray300
                          : DesignTokens.gray100,
                      strokeWidth: 1.5,
                    ),
                  ),
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(),
                    topTitles: AxisTitles(),
                    leftTitles: AxisTitles(),
                    bottomTitles: AxisTitles(),
                  ),
                  maxY: werte.max + yInterval,
                  minY: werte.min - yInterval,
                  lineBarsData: [
                    LineChartBarData(
                      dotData: const FlDotData(show: false),
                      color: color,
                      isStrokeCapRound: true,
                      isStrokeJoinRound: true,
                      preventCurveOverShooting: true,
                      isCurved: true,
                      curveSmoothness: 0.1,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          // Colors.transparent causes the gradient to transition through gray
                          colors: [
                            color.withValues(alpha: 0.5),
                            color.withAlpha(0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      spots: feld.historie
                          .map(
                            (h) => FlSpot(
                              h.time.millisecondsSinceEpoch.toDouble(),
                              h.value,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
