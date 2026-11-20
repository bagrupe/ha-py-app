// ignore_for_file: use_named_constants, inference_failure_on_instance_creation

import 'dart:async';
import 'dart:io';

import 'package:app/common/location_service.dart';
import 'package:app/components/map/last_position_provider.dart';
import 'package:app/components/map/map_controller.dart';
import 'package:app/components/map/map_controls_layer.dart';
import 'package:app/components/map/map_values.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

part 'map_widget_state.dart';

/// Displays the interactive map with optional controls and custom layers.
class KommunalAppMap extends ConsumerStatefulWidget {
  /// Creates a map with validated defaults and optional explicit positioning.
  const KommunalAppMap({
    required this.defaultPosition,
    required this.withShowcase,
    super.key,
    this.controller,
    this.center,
    this.layers,
  });

  /// Optional externally owned map controller.
  final KommunalAppMapController? controller;

  /// Explicit initial center, taking precedence over saved positions.
  final LatLng? center;

  /// Additional map layers.
  final List<Widget>? layers;

  /// Municipality latitude and longitude, validated before projection.
  final List<double> defaultPosition;

  /// Whether to show the map introduction.
  final bool withShowcase;

  @override
  ConsumerState<KommunalAppMap> createState() => _KommunalAppMapState();
}

/// Creates a tile cache in the platform temporary directory.
Future<Object?> _getCacheStore() async {
  if (kIsWeb) return null;
  final dir = await getTemporaryDirectory();
  return FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
}
