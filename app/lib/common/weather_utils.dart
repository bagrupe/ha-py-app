import 'package:easy_localization/easy_localization.dart';

/// Utility for mapping weather icon codes to human-readable descriptions.
abstract final class WeatherUtils {
  /// Maps OpenWeatherMap icon codes to German descriptions.
  static String getDescription(String icon) {
    final code = icon.replaceAll('d', '').replaceAll('n', '');
    return switch (code) {
      '01' => 'application.weather.sunny'.tr(),
      '02' => 'application.weather.partly_cloudy'.tr(),
      '03' => 'application.weather.mostly_cloudy'.tr(),
      '04' => 'application.weather.cloudy'.tr(),
      '09' => 'application.weather.rain_showers'.tr(),
      '10' => 'application.weather.rain'.tr(),
      '11' => 'application.weather.thunderstorm'.tr(),
      '13' => 'application.weather.snow'.tr(),
      '50' => 'application.weather.fog'.tr(),
      _ => 'application.weather.unknown'.tr(),
    };
  }

  /// Returns the weather icon URL.
  static String getIconUrl(String icon) =>
      'https://openweathermap.org/img/wn/$icon@2x.png';

  /// Finds the closest weather measuring point to a given position.
  static T? findClosestMeasuringPoint<T>(
    List<T?> measuringPoints,
    List<double> position,
    List<double> Function(T) getPosition,
  ) {
    if (measuringPoints.isEmpty) return null;
    var nearest = measuringPoints[0];
    var shortestDistance = double.infinity;

    for (final point in measuringPoints) {
      if (point == null) continue;
      final pointPos = getPosition(point);
      final distance = _calculateDistance(
        position[0],
        position[1],
        pointPos[0],
        pointPos[1],
      );

      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearest = point;
      }
    }
    return nearest;
  }

  static double _calculateDistance(double x1, double y1, double x2, double y2) {
    return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
  }
}
