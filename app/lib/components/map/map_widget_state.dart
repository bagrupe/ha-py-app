part of 'map.dart';

/// Manages map initialization, valid camera persistence and lifecycle updates.
class _KommunalAppMapState extends ConsumerState<KommunalAppMap> {
  /// Controller used throughout this widget lifetime.
  late final KommunalAppMapController _controller;

  /// Refreshes location permissions after returning from the background.
  final LocationLifecycleObserver lifecycleObserver =
      LocationLifecycleObserver();

  /// Initializes tile caching once, independently of municipality data.
  final _cacheStoreFuture = _getCacheStore();

  /// Debounces persistence across rebuilds.
  Timer? _positionTimer;

  /// Retains the camera when a temporary empty layout removes the map.
  MapCamera? _lastCamera;

  /// Prevents late defaults or location lookups from overriding interaction.
  bool _hasPositionOverride = false;

  /// Tracks map attachment across asynchronous work.
  int _mapGeneration = 0;

  /// Whether a laid out map is attached to the controller.
  bool _mapReady = false;

  /// Whether current constraints can support a map.
  bool _hasUsableLayout = false;

  /// Applies municipality updates deferred while the map has no layout.
  bool _needsDefaultUpdate = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? KommunalAppMapController();

    final saved = ref.read(lastPositionProvider);
    if (saved != null &&
        MapValues.isValidCenter(saved.center) &&
        MapValues.isValidZoom(saved.zoom)) {
      _lastCamera = saved;
      _hasPositionOverride = true;
    }
    LocationService.updateGranted(force: true);

    WidgetsBinding.instance.addObserver(lifecycleObserver);
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    _mapGeneration++;
    WidgetsBinding.instance.removeObserver(lifecycleObserver);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant KommunalAppMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.center != null ||
        _hasPositionOverride ||
        listEquals(oldWidget.defaultPosition, widget.defaultPosition)) {
      return;
    }
    _needsDefaultUpdate = true;
    if (!_mapReady) {
      _lastCamera = null;
      return;
    }
    final generation = _mapGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _mapGeneration || _hasPositionOverride) {
        return;
      }
      _needsDefaultUpdate = false;
      _controller.map.move(MapValues.centerFrom(widget.defaultPosition), 16);
    });
  }

  /// Defers location restoration until the interactive map has been laid out.
  void _onMapReady() {
    if (!mounted || !_hasUsableLayout) return;
    _mapReady = true;
    final generation = ++_mapGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted ||
          generation != _mapGeneration ||
          widget.center != null ||
          _hasPositionOverride) {
        return;
      }
      if (_needsDefaultUpdate) {
        _needsDefaultUpdate = false;
        _controller.map.move(MapValues.centerFrom(widget.defaultPosition), 16);
        return;
      }
      final position = await LocationService.getLastKnownPosition();
      if (!mounted ||
          generation != _mapGeneration ||
          widget.center != null ||
          _hasPositionOverride ||
          position == null) {
        return;
      }
      final center = LatLng(position.latitude, position.longitude);
      if (MapValues.isValidCenter(center)) _controller.map.move(center, 16);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [mapControllerProvider.overrideWithValue(_controller)],
      child: FutureBuilder<Object?>(
        future: _cacheStoreFuture,
        builder: (context, snapshot) {
          if (!kIsWeb && snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'application.map.loading'.tr(),
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              if (!constraints.maxWidth.isFinite ||
                  !constraints.maxHeight.isFinite ||
                  constraints.maxWidth <= 0 ||
                  constraints.maxHeight <= 0) {
                _hasUsableLayout = false;
                _mapReady = false;
                _mapGeneration++;
                return const SizedBox.shrink();
              }
              _hasUsableLayout = true;
              return FlutterMap(
                mapController: _controller.map,
                options: MapOptions(
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    cursorKeyboardRotationOptions:
                        CursorKeyboardRotationOptions.disabled(),
                  ),
                  minZoom: MapValues.minZoom,
                  maxZoom: MapValues.maxZoom,
                  initialCenter:
                      widget.center != null &&
                          MapValues.isValidCenter(widget.center!)
                      ? widget.center!
                      : _lastCamera?.center ??
                            MapValues.centerFrom(widget.defaultPosition),
                  initialZoom: _lastCamera?.zoom ?? 16,
                  onPositionChanged: (position, hasGesture) {
                    if (!MapValues.isValidCenter(position.center) ||
                        !MapValues.isValidZoom(position.zoom)) {
                      return;
                    }
                    _lastCamera = position;
                    if (hasGesture) _hasPositionOverride = true;
                    _positionTimer?.cancel();
                    _positionTimer = Timer(
                      const Duration(milliseconds: 250),
                      () {
                        if (!mounted || widget.center != null) return;
                        ref
                            .read(lastPositionProvider.notifier)
                            .setLastPosition(position);
                      },
                    );
                  },
                  onMapReady: _onMapReady,
                ),
                children: [
                  TileLayer(
                    maxNativeZoom: MapValues.maxNativeZoom,
                    urlTemplate:
                        'https://tile.openstreetmap.de/{z}/{x}/{y}.png',
                    userAgentPackageName:
                        'Ha-Py App (https://www.smart-city-dialog.de/wissensspeicher/massnahmen/ha-py-immer-dabei)',
                    tileProvider: kIsWeb || !snapshot.hasData
                        ? NetworkTileProvider(
                            cachingProvider: const DisabledMapCachingProvider(),
                          )
                        : CachedTileProvider(
                            store: snapshot.data! as FileCacheStore,
                          ),
                  ),
                  if (widget.layers != null) ...widget.layers!,
                  StreamBuilder<LatLng?>(
                    stream: _controller.markedPosition,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const SizedBox.shrink();
                      }

                      return MarkerLayer(
                        rotate: true,
                        markers: [
                          Marker(
                            width: 32,
                            height: 32,
                            alignment: Alignment.topCenter,
                            point: snapshot.data!,
                            child: const Icon(Icons.place, size: 32),
                          ),
                        ],
                      );
                    },
                  ),
                  StreamBuilder<bool>(
                    stream: LocationService.grantedStream,
                    initialData: LocationService.lastEmit,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data!) {
                        return const SizedBox.shrink();
                      }

                      return FutureBuilder(
                        future: LocationService.getPositionStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox.shrink();

                          return CurrentLocationLayer(
                            style: const LocationMarkerStyle(
                              showAccuracyCircle: false,
                            ),
                            positionStream:
                                const LocationMarkerDataStreamFactory()
                                    .fromGeolocatorPositionStream(
                                      stream: snapshot.data,
                                    ),
                          );
                        },
                      );
                    },
                  ),
                  MapControlsLayer(withShowcase: widget.withShowcase),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
