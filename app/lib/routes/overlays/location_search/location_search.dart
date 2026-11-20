import 'package:app/common/extensions/position.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/location_service.dart';
import 'package:app/common/mapbox_search_suggestions/mapbox_search_suggestions.dart';
import 'package:app/common/mapbox_search_suggestions/models.dart';
import 'package:app/components/map/controls/map_control_button.dart';
import 'package:app/components/map/map_controller.dart';
import 'package:app/graphql/__generated__/pois.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/overlays/location_search/components/location_search_empty_state.dart';
import 'package:app/routes/overlays/location_search/components/location_search_item.dart';
import 'package:app/routes/overlays/location_search/components/poi_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart' show ErrorPolicy, FetchPolicy;
import 'package:latlong2/latlong.dart';

@immutable
/// Repräsentiert das Ergebnis einer Standortsuche mit Position und optionalen Markierung- und Filteroptionen.
class LocationSearchResult {
  /// Erstellt ein LocationSearchResult mit der gegebenen Position, optionaler Markierung und Filterüberschreibung.
  const LocationSearchResult(
    this.position, {
    this.shouldMark = false,
    this.overrideFilter,
  });
  final LatLng position;
  final bool shouldMark;
  final List<String>? overrideFilter;
}

/// Widget zur Suche von Orten mit Anzeige von Vorschlägen und Auswahlmöglichkeit.
class LocationSearch extends ConsumerStatefulWidget {
  const LocationSearch({super.key});

  /// Öffnet die Standortsuche als Overlay und gibt das ausgewählte Ergebnis zurück.
  static Future<LocationSearchResult?> open(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final mapCenter = ref
        .read(mapControllerProvider)
        .mapController
        .camera
        .center;

    return context.push<LocationSearchResult>(
      '/overlays/location-search',
      extra: mapCenter,
    );
  }

  @override
  ConsumerState<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends ConsumerState<LocationSearch> {
  final Debouncer _debounce = Debouncer();
  List<MapboxSuggestion> _mapboxSuggestions = [];
  List<PoiSearchQueryResult> _poiSuggestions = [];
  bool _loading = false;
  String _searchText = '';

  /// Lädt Vorschläge für die Suche basierend auf dem eingegebenen Suchtext.
  Future<void> _fetchSuggestions(String search) async {
    if (search.isEmpty) {
      setState(() {
        _mapboxSuggestions = [];
        _poiSuggestions = [];
      });

      return;
    }

    setState(() => _loading = true);

    final [mapboxSuggestions, poiSuggestions] = await Future.wait([
      _fetchMapboxSuggestions(search),
      _fetchPoiSuggestions(search),
    ]);

    setState(() {
      _mapboxSuggestions = mapboxSuggestions as List<MapboxSuggestion>;
      _poiSuggestions = poiSuggestions as List<PoiSearchQueryResult>;
      _loading = false;
    });
  }

  /// Holt Mapbox-Vorschläge für den Suchbegriff unter Berücksichtigung der aktuellen Position.
  Future<List<MapboxSuggestion>> _fetchMapboxSuggestions(String search) async {
    final mapboxSuggestions = ref.read(mapboxSearchSuggestions);

    final router = GoRouterState.of(context);
    var center = router.extra! as LatLng;

    try {
      center = (await LocationService.getCurrentPosition(
        request: false,
      )).toLatLng();
    } on Exception {
      // Permission not granted; the fallback is already set above
    }

    final suggestions = await mapboxSuggestions.getSuggestions(search, center);

    return suggestions.suggestions ?? [];
  }

  /// Holt POI-Vorschläge aus dem GraphQL-Backend basierend auf dem Suchbegriff und der Kommune.
  Future<List<PoiSearchQueryResult>> _fetchPoiSuggestions(String search) async {
    final client = ref.read(graphqlClientProvider);
    final kommune = await ref.read(kommuneProvider.future);

    final response = await client.query_PoiSearch(
      Options_Query_PoiSearch(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        errorPolicy: ErrorPolicy.all,
        variables: Variables_Query_PoiSearch(
          name: search,
          kommuneId: kommune.bereichBId,
        ),
      ),
    );

    final pois = response.parsedData?.pois?.docs.nonNulls.toList() ?? [];
    final sensoren =
        response.parsedData?.sensoren.docs.nonNulls.map(
          (s) => PoiSearchQueryResult(
            id: s.id,
            title: s.titel ?? s.name,
            position: s.position,
            category: PoiSearchCategory(
              title: 'Sensor',
              id: s.felder!.firstWhere((f) => f.werteart != null).werteart!.id,
              icon:
                  s.icon ??
                  s.felder!
                      .firstWhere((f) => f.werteart != null)
                      .werteart!
                      .icon!,
            ),
          ),
        ) ??
        [];

    return [...pois, ...sensoren];
  }

  /// Verarbeitet die Auswahl eines Mapbox-Vorschlags und schließt die Suche mit dem Ergebnis.
  Future<void> _pickMapboxSuggestions(String id) async {
    final mapboxSuggestions = ref.read(mapboxSearchSuggestions);
    final feature = await mapboxSuggestions.retrieveFeature(id);

    if (mounted) {
      final coordinates = feature.properties.coordinates;
      final latLng = LatLng(coordinates.latitude, coordinates.longitude);
      context.pop(LocationSearchResult(latLng, shouldMark: true));
    }
  }

  /// Verarbeitet die Auswahl eines POI-Vorschlags und schließt die Suche mit dem Ergebnis.
  void _pickPoiSuggestion(PoiSearchQueryResult result) {
    final latLng = LatLng(result.position[0], result.position[1]);

    final maybeCategory = result.category?.id;
    context.pop(
      LocationSearchResult(
        latLng,
        overrideFilter: maybeCategory != null ? [maybeCategory] : null,
      ),
    );
  }

  /// Schließt die Suche ohne Ergebnis.
  void _close() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final hasResults =
        _poiSuggestions.isNotEmpty || _mapboxSuggestions.isNotEmpty;
    final showEmptyState = !_loading && _searchText.isNotEmpty && !hasResults;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _LocationSearchHeader(
            onChanged: (newValue) {
              const duration = Duration(milliseconds: 400);

              _debounce.debounce(
                duration: duration,
                onDebounce: () {
                  setState(() {
                    _searchText = newValue;
                    _fetchSuggestions(newValue);
                  });
                },
              );
            },
            onClose: _close,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _LocationSearchBody(
              loading: _loading,
              showEmptyState: showEmptyState,
              poiSuggestions: _poiSuggestions,
              mapboxSuggestions: _mapboxSuggestions,
              onPoiSelected: _pickPoiSuggestion,
              onMapboxSelected: _pickMapboxSuggestions,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationSearchBody extends StatelessWidget {
  const _LocationSearchBody({
    required this.loading,
    required this.showEmptyState,
    required this.poiSuggestions,
    required this.mapboxSuggestions,
    required this.onPoiSelected,
    required this.onMapboxSelected,
  });

  final bool loading;
  final bool showEmptyState;
  final List<PoiSearchQueryResult> poiSuggestions;
  final List<MapboxSuggestion> mapboxSuggestions;
  final ValueChanged<PoiSearchQueryResult> onPoiSelected;
  final ValueChanged<String> onMapboxSelected;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (showEmptyState) {
      return const LocationSearchEmptyState();
    }

    return ListView(
      children: [
        PoiSearchResult(
          results: poiSuggestions,
          onResultSelected: onPoiSelected,
        ),
        ...mapboxSuggestions.map(
          (s) => LocationSearchItem(
            suggestion: s,
            onSelect: () => onMapboxSelected(s.mapboxId),
          ),
        ),
      ],
    );
  }
}

class _LocationSearchHeader extends StatelessWidget {
  const _LocationSearchHeader({required this.onChanged, required this.onClose});

  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              suffixIcon: Icon(Icons.search),
              isDense: true,
              filled: true,
              border: OutlineInputBorder(),
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        MapControlButton(onPressed: onClose, icon: Icons.close),
      ],
    );
  }
}
