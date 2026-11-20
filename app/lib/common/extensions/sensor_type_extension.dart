import 'package:app/graphql/__generated__/sensoren.graphql.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

/// Extension for Fragment_SensorFieldReading to provide UI data for the
/// sensor card. Implemented by both the `Sensor` and `ListSensoren` query
/// types, so this works for the sensor detail page and the favorites list.
extension SensorFieldUi on Fragment_SensorFieldReading {
  /// Returns the formatted main value.
  String get displayValue {
    final val = double.tryParse(currentValue ?? '0') ?? 0;
    return NumberFormat('#0.#').format(val);
  }

  /// Returns the unit.
  String get displayUnit => werteart?.einheit ?? '';

  /// Returns the icon based on the sensor type.
  IconData get displayIcon {
    if (isTemperature) return Symbols.thermostat;
    if (isRainIntensity) return Symbols.rainy_light;
    if (isPegel) return Icons.waves;
    if (isHumidity) return Icons.opacity;
    if (isPressure) return Icons.speed;
    return Icons.sensors;
  }

  /// Helper to identify temperature sensors.
  bool get isTemperature {
    final name = werteart?.name.toLowerCase() ?? '';
    return name.contains('temperatur');
  }

  /// Helper to identify pegel (water level) sensors.
  bool get isPegel {
    final name = werteart?.name.toLowerCase() ?? '';
    return name.contains('wasserstand') || name.contains('pegel');
  }

  /// Helper to identify humidity sensors.
  bool get isHumidity {
    final name = werteart?.name.toLowerCase() ?? '';
    return name.contains('feuchtigkeit');
  }

  /// Helper to identify rain intensity sensors.
  bool get isRainIntensity {
    final name = werteart?.name.toLowerCase() ?? '';
    return name.contains('regenintensität');
  }

  /// Helper to identify pressure sensors.
  bool get isPressure {
    final name = werteart?.name.toLowerCase() ?? '';
    return name.contains('luftdruck');
  }

  /// Helper to identify Glätte (road ice/slipperiness) sensors.
  bool get isGlaette {
    final name = werteart?.name.toLowerCase() ?? '';
    return name.contains('glätte') || name.contains('glaette');
  }

  /// Glätte reports only a categorical alarm status (SAFE/ADVISORY/...), not a number.
  bool get hasNumericValue => !isGlaette;
}

/// Configurable warning-level text (from the CMS, `SensorArt.warnstufeText1..4`).
typedef WarningLevelText = ({
  String? shortLabel,
  String? title,
  String? description,
});

/// Extension for Fragment_SensorDangerLevels to derive the danger level
/// (gauge/warning level). Implemented by both the `Sensor` and `ListSensoren`
/// query types, so this works for the sensor detail page and the favorites list.
extension SensorDangerLevelUi on Fragment_SensorDangerLevels {
  /// Index (0=safe .. 3=critical) of the current water-level danger level, if available.
  int? get waterLevelIndex => _waterLevelIndex(pegelGefahrenstufe);

  /// Index (0=safe .. 3=critical) of the current road-ice warning level, if available.
  int? get roadIceLevelIndex => _roadIceLevelIndex(glaetteAlarmLevel);
}

int? _waterLevelIndex(String? gefahrenstufe) {
  switch (gefahrenstufe) {
    case 'GRUEN':
      return 0;
    case 'GELB':
      return 1;
    case 'ORANGE':
      return 2;
    case 'ROT':
      return 3;
  }
  return null;
}

int? _roadIceLevelIndex(String? alarmLevel) {
  switch (alarmLevel) {
    case 'SAFE':
      return 0;
    case 'ADVISORY':
      return 1;
    case 'WARNING':
      return 2;
    case 'CRITICAL':
      return 3;
  }
  return null;
}

/// Extension for reading a sensor type's configured warning-level text.
/// Implemented by both the `Sensor` and `ListSensoren` query types, so this
/// works for the sensor detail page and the favorites list.
extension SensorTypeWarningLevelUi on Fragment_SensorFieldReading_werteart {
  /// Returns the CMS-configured text for the given level (0-3), if available.
  WarningLevelText? textForLevel(int? levelIndex) {
    switch (levelIndex) {
      case 0:
        return warnstufeText1 == null
            ? null
            : (
                shortLabel: warnstufeText1!.kurzlabel,
                title: warnstufeText1!.titel,
                description: warnstufeText1!.beschreibung,
              );
      case 1:
        return warnstufeText2 == null
            ? null
            : (
                shortLabel: warnstufeText2!.kurzlabel,
                title: warnstufeText2!.titel,
                description: warnstufeText2!.beschreibung,
              );
      case 2:
        return warnstufeText3 == null
            ? null
            : (
                shortLabel: warnstufeText3!.kurzlabel,
                title: warnstufeText3!.titel,
                description: warnstufeText3!.beschreibung,
              );
      case 3:
        return warnstufeText4 == null
            ? null
            : (
                shortLabel: warnstufeText4!.kurzlabel,
                title: warnstufeText4!.titel,
                description: warnstufeText4!.beschreibung,
              );
    }
    return null;
  }
}

/// Direction of a sensor field's value over its fetched history window.
enum SensorTrendDirection { rising, falling, stable }

/// Change in value between the oldest and newest history entry.
typedef SensorTrend = ({SensorTrendDirection direction, double delta});

/// Extension for Fragment_SensorFieldReading to derive a trend from its
/// last-24h history. Implemented by both the `Sensor` and `ListSensoren`
/// query types, so this works for the sensor detail page and the favorites
/// list.
extension SensorFieldTrendUi on Fragment_SensorFieldReading {
  /// Trend comparing the oldest to the newest history entry in the last 24h,
  /// or null if there isn't enough history to compare. Null for categorical
  /// fields (e.g. Glätte): their history is not a real number to trend on.
  SensorTrend? get trend {
    if (!hasNumericValue) return null;
    if (trendHistorie.length < 2) return null;
    final sorted = [...trendHistorie]..sort((a, b) => a.time.compareTo(b.time));
    final delta = sorted.last.value - sorted.first.value;
    final direction = delta > 0
        ? SensorTrendDirection.rising
        : delta < 0
        ? SensorTrendDirection.falling
        : SensorTrendDirection.stable;
    return (direction: direction, delta: delta);
  }
}

/// Extension for reading a trend direction's label and icon.
extension SensorTrendDirectionUi on SensorTrendDirection {
  /// Translated label for this direction (e.g. "Steigend").
  String get label {
    switch (this) {
      case SensorTrendDirection.rising:
        return 'application.sensor.favorite_card.trend_rising'.tr();
      case SensorTrendDirection.falling:
        return 'application.sensor.favorite_card.trend_falling'.tr();
      case SensorTrendDirection.stable:
        return 'application.sensor.favorite_card.trend_stable'.tr();
    }
  }

  /// Icon representing this direction.
  IconData get icon {
    switch (this) {
      case SensorTrendDirection.rising:
        return Icons.trending_up;
      case SensorTrendDirection.falling:
        return Icons.trending_down;
      case SensorTrendDirection.stable:
        return Icons.trending_flat;
    }
  }
}
