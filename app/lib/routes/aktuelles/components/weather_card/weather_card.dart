import 'package:app/common/extensions/text_theme.dart';
import 'package:app/common/weather_utils.dart';
import 'package:app/components/images/loading_image.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';

/// Ein Widget, das eine Wetterkarte mit Standort, Wochentag, Wettericon und Temperaturen anzeigt.
class WeatherCard extends StatelessWidget {
  /// Erstellt eine neue Instanz von WeatherCard mit optionalen Parametern.
  const WeatherCard({
    super.key,
    this.icon = '11d',
    this.maxTemp = 30.0,
    this.minTemp = 23.0,
    this.locationName = 'Musterstadt',
    this.weekday = 0,
  });

  /// Der Name des Standorts.
  final String locationName;

  /// Der Icon-Code für das Wetterbild.
  final String icon;

  /// Die minimale Temperatur.
  final double minTemp;

  /// Die maximale Temperatur.
  final double maxTemp;

  /// Der Wochentag als Index.
  final int weekday;

  static const double borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final netWorkString = WeatherUtils.getIconUrl(icon);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                StringUtils.capitalize(
                  Weekdays.values[weekday].name.substring(0, 2),
                ),
                style: theme.colorTextTheme.bodyLarge,
              ),
              LoadingImage(imageUrl: netWorkString, height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${minTemp.round()}° | ${maxTemp.round()}°',
                    style: theme.colorTextTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Enum zur Darstellung der Wochentage mit einem Füllwert für korrekte Indizierung.
enum Weekdays {
  filler, // is needed, so that index of 'Mo' starts with 1
  mo,
  di,
  mi,
  don,
  fr,
  sa,
  so,
}
