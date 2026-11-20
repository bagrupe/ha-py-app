import 'dart:math';

import 'package:app/common/weather_utils.dart';
import 'package:app/graphql/__generated__/wettermesspunkte.graphql.dart';
import 'package:app/routes/aktuelles/components/weather_card/weather_card.dart';
import 'package:app/routes/aktuelles/components/weather_card_list/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ein Widget, das eine Liste von Wetterkarten für eine bestimmte Kommune anzeigt.
/// Reagiert auf [weatherProvider] und zeigt die Vorhersage des nächstgelegenen Messpunkts.
class WeatherCardList extends ConsumerWidget {
  const WeatherCardList({required this.kommuneId, super.key});

  /// Die ID der Kommune, für die die Wetterdaten geladen werden.
  final String kommuneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider(kommuneId));

    return weatherAsync.when(
      // Keep cards visible during pull-to-refresh / hourly reload.
      skipLoadingOnReload: true,
      loading: () => const Center(child: CircularProgressIndicator()),
      // Offline with empty cache: hide the weather section instead of spinning.
      error: (_, __) => const SizedBox.shrink(),
      data: _buildWeatherCards,
    );
  }

  Widget _buildWeatherCards(WeatherState weatherState) {
    final weatherMeasuringPointsList =
        weatherState.data.wettermesspunkteList?.docs ?? [];

    final lastKnownPosition = weatherState.lastKnownPosition;
    final closestWeatherMeasuringPoint =
        WeatherUtils.findClosestMeasuringPoint<
          Query_Wettermesspunkte_wettermesspunkteList_docs
        >(
          weatherMeasuringPointsList,
          lastKnownPosition != null
              ? [lastKnownPosition.longitude, lastKnownPosition.latitude]
              : [0.0, 0.0],
          (p) => p.location.cast<double>(),
        );

    if (closestWeatherMeasuringPoint == null) return const SizedBox.shrink();
    final weather = closestWeatherMeasuringPoint.weather
        .where(
          (wetter) =>
              wetter.date != null &&
              wetter.icon != null &&
              wetter.minTemp != null &&
              wetter.maxTemp != null,
        )
        .toList();
    if (weather.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final parentWidth = constraints.maxWidth;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(weather.length, (i) {
                  final wetter = weather[i];
                  final parsedDate = wetter.date!.toLocal();
                  return SizedBox(
                    width: max(parentWidth / weather.length, 100),
                    child: WeatherCard(
                      icon: wetter.icon!,
                      minTemp: wetter.minTemp!,
                      maxTemp: wetter.maxTemp!,
                      weekday: parsedDate.weekday,
                      locationName: closestWeatherMeasuringPoint.locationName,
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}
