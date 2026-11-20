import 'package:app/common/shared_preferences.dart';
import 'package:app/components/map/last_position_provider.dart';
import 'package:app/components/map/map.dart';
import 'package:app/components/map/map_controller.dart';
import 'package:app/components/map/map_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Exercises map initialization, late municipality data and temporary layouts.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => throw PlatformException(code: 'cache-unavailable'),
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/geolocator'),
          (call) async => call.method == 'checkPermission' ? 0 : null,
        );
  });

  for (final position in <List<double>>[
    [],
    [double.nan, double.infinity],
    [90, 200],
  ]) {
    testWidgets('renders a usable map for $position', (tester) async {
      final preferences = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      );
      final controller = KommunalAppMapController();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: KommunalAppMap(
                controller: controller,
                defaultPosition: position,
                withShowcase: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FlutterMap), findsOneWidget);
      expect(controller.map.camera.center, MapValues.centerFrom([]));
      controller.map.move(controller.map.camera.center, MapValues.maxZoom);
      await tester.pumpAndSettle();
      final tiles = tester.widget<TileLayer>(find.byType(TileLayer));
      expect(tiles.maxNativeZoom, 18);
      expect(controller.map.camera.zoom, MapValues.maxZoom);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      controller.dispose();
    });
  }

  for (final zoom in [12.0, 100.0]) {
    testWidgets('validates a saved zoom of $zoom', (tester) async {
      final preferences = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      );
      container
          .read(lastPositionProvider.notifier)
          .setLastPosition(
            MapCamera(
              crs: const Epsg3857(),
              center: const LatLng(51, 8),
              zoom: zoom,
              rotation: 0,
              nonRotatedSize: const Size(300, 300),
            ),
          );
      final controller = KommunalAppMapController();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: KommunalAppMap(
                controller: controller,
                defaultPosition: const [52, 9],
                withShowcase: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        controller.map.camera.center,
        zoom == 12 ? const LatLng(51, 8) : const LatLng(52, 9),
      );
      expect(controller.map.camera.zoom, zoom == 12 ? 12 : 16);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      controller.dispose();
    });
  }

  testWidgets(
    'updates defaults, respects interaction and survives empty layout',
    (tester) async {
      final preferences = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      );
      final controller = KommunalAppMapController();
      final position = ValueNotifier<List<double>>([]);
      final size = ValueNotifier<double>(300);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: ValueListenableBuilder<double>(
                valueListenable: size,
                builder: (context, extent, child) => Align(
                  child: SizedBox(
                    width: extent,
                    height: extent,
                    child: ValueListenableBuilder<List<double>>(
                      valueListenable: position,
                      builder: (context, value, child) => KommunalAppMap(
                        controller: controller,
                        defaultPosition: value,
                        withShowcase: false,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      size.value = 0;
      await tester.pumpAndSettle();
      position.value = [52, 9];
      await tester.pumpAndSettle();
      size.value = 300;
      await tester.pumpAndSettle();
      expect(controller.map.camera.center, const LatLng(52, 9));
      await tester.drag(find.byType(FlutterMap), const Offset(60, 30));
      await tester.pumpAndSettle();
      await tester.tapAt(tester.getCenter(find.byType(FlutterMap)));
      await tester.pump(const Duration(milliseconds: 60));
      await tester.tapAt(tester.getCenter(find.byType(FlutterMap)));
      await tester.pumpAndSettle();
      expect(controller.map.camera.zoom, greaterThan(16));
      final moved = controller.map.camera.center;
      position.value = [51, 8];
      await tester.pumpAndSettle();
      expect(controller.map.camera.center, moved);
      size.value = 0;
      await tester.pumpAndSettle();
      expect(find.byType(FlutterMap), findsNothing);
      size.value = 300;
      await tester.pumpAndSettle();
      expect(controller.map.camera.center, moved);
      expect(container.read(lastPositionProvider)?.center, moved);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      position.dispose();
      size.dispose();
      container.dispose();
      controller.dispose();
    },
  );
}
