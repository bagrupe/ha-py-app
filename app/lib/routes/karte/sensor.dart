import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/date_time.dart';
import 'package:app/common/extensions/sensor_type_extension.dart';
import 'package:app/common/extensions/text_theme.dart';
import 'package:app/common/mapbox_reverse_geocoding/mapbox_reverse_geocoding.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/select_buttons/select_buttons.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/sensoren.graphql.dart';
import 'package:app/graphql/__generated__/wettermesspunkte.graphql.dart';
import 'package:app/routes/karte/components/sensor_card.dart';
import 'package:app/routes/karte/components/sensor_favoriten_button.dart';
import 'package:app/routes/karte/components/sensor_historie_graph.dart';
import 'package:app/routes/karte/components/sensor_road_ice_level_content.dart';
import 'package:app/routes/karte/components/sensor_water_level_gauge_content.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Seite zur Anzeige der Details eines Sensors mit aktuellen Werten und historischen Daten.
/// Ermöglicht die Auswahl des Zeitraums für die Anzeige der Historie.
class KarteSensorPage extends ConsumerStatefulWidget {
  const KarteSensorPage({required this.id, super.key});

  /// Die ID des anzuzeigenden Sensors.
  final String id;

  @override
  ConsumerState<KarteSensorPage> createState() => _KarteSensorPageState();
}

/// Zustand der Sensor-Seite mit Verwaltung des ausgewählten Historienzeitraums.
class _KarteSensorPageState extends ConsumerState<KarteSensorPage> {
  Enum_HistoryMode _historyMode = Enum_HistoryMode.LAST_DAY;
  String? _selectedFieldId;
  Query_Sensor_sensor? _lastSensor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.sensor.title'.tr()),
        menu: false,
      ),
      body: Query_Sensor_Widget(
        options: Options_Query_Sensor(
          variables: Variables_Query_Sensor(
            sensorId: widget.id,
            duration: _historyMode,
          ),
        ),
        builder: (result, {fetchMore, refetch}) {
          final sensor = result.parsedData?.sensor ?? _lastSensor;

          if (result.isLoading && sensor == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (sensor == null) {
            return const SizedBox.shrink();
          }

          _lastSensor = sensor;

          final sensorData = sensor;
          final locationAsync = sensorData.position.length >= 2
              ? ref.watch(
                  mapboxReverseGeocodingProviderSensors(
                    LatLng(sensorData.position[0], sensorData.position[1]),
                  ),
                )
              : const AsyncValue<String?>.data(null);

          final shownFelder =
              sensorData.felder
                  ?.whereType<Query_Sensor_sensor_felder>()
                  .where((f) => f.werteart != null)
                  .toList() ??
              [];

          final historieFelder = shownFelder
              .where((f) => f.hasNumericValue)
              .toList();

          if (_selectedFieldId == null && historieFelder.isNotEmpty) {
            _selectedFieldId = historieFelder.first.id;
          } else if (_selectedFieldId != null &&
              !historieFelder.any((f) => f.id == _selectedFieldId)) {
            _selectedFieldId = historieFelder.firstOrNull?.id;
          }

          final letzteMessung = sensor.letzteMessungZeitpunkt == null
              ? null
              : DateTime.parse(sensor.letzteMessungZeitpunkt!);

          return Skeletonizer(
            enabled: result.isLoading,
            child: _buildContent(
              context,
              sensor,
              shownFelder,
              historieFelder,
              letzteMessung,
              null,
              locationAsync,
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Query_Sensor_sensor sensor,
    Iterable<Query_Sensor_sensor_felder> shownFelder,
    List<Query_Sensor_sensor_felder> historieFelder,
    DateTime? letzteMessung,
    Query_Wettermesspunkte_wettermesspunkteList_docs_weather? weather,
    AsyncValue<String?> locationAsync,
  ) {
    final colorTextTheme = Theme.of(context).colorTextTheme;
    final textTheme = Theme.of(context).textTheme;

    final formattedTime =
        letzteMessung?.toLocal().formatRelative(
          'E dd.MM.',
          "HH:mm '${'application.common.time_suffix'.tr()}'",
        ) ??
        'application.sensor.older_than_30_days'.tr();
    return SingleChildScrollView(
      key: PageStorageKey('sensor_${widget.id}'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Text(
              sensor.titel ?? sensor.name,
              style: colorTextTheme.bodySmall?.copyWith(
                color: DesignTokens.green500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: locationAsync.when(
                      data: (location) => Text(
                        location ?? '',
                        style: textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: DesignTokens.gray900,
                        ),
                      ),
                      loading: () => Skeletonizer(
                        child: Text(
                          'application.sensor.locality_placeholder'.tr(),
                          style: textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.gray900,
                          ),
                        ),
                      ),
                      error: (_, __) => Text(
                        sensor.position.join(', '),
                        style: textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: DesignTokens.gray900,
                        ),
                      ),
                    ),
                  ),
                ),
                SensorFavoritenButton(id: sensor.id),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text(
              'application.sensor.last_measured'.tr(
                namedArgs: {'time': formattedTime},
              ),
              style: textTheme.bodySmall?.copyWith(color: DesignTokens.gray500),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'application.sensor.current_values'.tr(),
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: DesignTokens.gray900,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: shownFelder
                  .map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SensorCard(
                        title: f.werteart!.name,
                        value: f.hasNumericValue ? f.displayValue : null,
                        unit: f.hasNumericValue ? f.displayUnit : null,
                        belowContent: f.isPegel
                            ? SensorWaterLevelGaugeContent(
                                sensor: sensor,
                                field: f,
                              )
                            : f.isGlaette
                            ? SensorRoadIceLevelContent(
                                sensor: sensor,
                                field: f,
                              )
                            : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          if (historieFelder.isNotEmpty) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'application.sensor.past_values'.tr(),
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: DesignTokens.gray900,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final selectedField = historieFelder.firstWhereOrNull(
                  (f) => f.id == _selectedFieldId,
                );
                final fieldName = selectedField?.werteart?.name ?? '';
                final fieldUnit = selectedField?.werteart?.einheit ?? '';
                final displayName = 'application.sensor.name_in_unit'.tr(
                  namedArgs: {'name': fieldName, 'unit': fieldUnit},
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: DesignTokens.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: DesignTokens.gray300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 8,
                          runSpacing: 12,
                          children: [
                            if (historieFelder.length > 1)
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 500,
                                ),
                                child: PopupMenuButton<String>(
                                  onSelected: (id) =>
                                      setState(() => _selectedFieldId = id),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context) => historieFelder
                                      .map(
                                        (f) => PopupMenuItem(
                                          value: f.id,
                                          child: Text(
                                            f.werteart!.name,
                                            style: textTheme.bodyLarge,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        selectedField?.displayIcon ??
                                            Icons.sensors,
                                        size: 20,
                                        color: DesignTokens.gray700,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          displayName,
                                          style: textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: DesignTokens.gray900,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.expand_more,
                                        color: DesignTokens.gray700,
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              )
                            else if (historieFelder.isNotEmpty)
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 150,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      historieFelder.first.displayIcon,
                                      size: 20,
                                      color: DesignTokens.gray700,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        displayName,
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: DesignTokens.gray900,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            SelectButtons<Enum_HistoryMode>(
                              selected: _historyMode,
                              onSelectionChange: (n) =>
                                  setState(() => _historyMode = n),
                              options: [
                                SelectButtonData(
                                  Text('application.sensor.mode_24h'.tr()),
                                  Enum_HistoryMode.LAST_DAY,
                                ),
                                SelectButtonData(
                                  Text('application.sensor.mode_week'.tr()),
                                  Enum_HistoryMode.LAST_WEEK,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (selectedField != null)
                          SensorHistorieGraph(
                            feld: selectedField,
                            historyMode: _historyMode,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
