import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/profile_gemeinde_provider.dart';
import 'package:app/graphql/__generated__/gemeindeinformationen.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

const _hamelnCenterLat = 52.1037;
const _hamelnCenterLng = 9.3571;
const _hamelnRadiusMeters = 6000.0;
const _hamelnGemeindeName = 'Hameln';
const _ideahubLocationSettings = LocationSettings(
  accuracy: LocationAccuracy.low,
  distanceFilter: 100,
);

/// Checks whether a position is physically inside the Hameln city boundaries.
bool _isInsideHamelnGeofence(Position? position) {
  if (position == null) return false;
  final distanceMeters = Geolocator.distanceBetween(
    position.latitude,
    position.longitude,
    _hamelnCenterLat,
    _hamelnCenterLng,
  );

  return distanceMeters <= _hamelnRadiusMeters;
}

/// Provides the current position and all subsequent position changes.
/// Does not request permissions and emits `null` when none are granted.
final ideahubPositionProvider = StreamProvider<Position?>((_) async* {
  final permission = await Geolocator.checkPermission();
  final hasPermission =
      permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;

  if (!hasPermission) {
    yield null;
    return;
  }

  yield await Geolocator.getCurrentPosition(
    locationSettings: _ideahubLocationSettings,
  );
  yield* Geolocator.getPositionStream(
    locationSettings: _ideahubLocationSettings,
  );
});

/// Checks whether the selected profile municipality is Hameln.
Future<bool> _isSelectedProfileGemeindeHameln(Ref ref) async {
  final selectedGemeinde = ref.watch(profileGemeindeProvider);

  if (selectedGemeinde == null) {
    return false;
  }

  if (selectedGemeinde == _hamelnGemeindeName) {
    return true;
  }

  final appConfig = ref.watch(appConfigProvider);
  final graphqlClient = ref.watch(graphqlClientProvider);
  final result = await graphqlClient.query_Gemeindeinformationen(
    Options_Query_Gemeindeinformationen(
      variables: Variables_Query_Gemeindeinformationen(
        kommuneId: appConfig.kommuneId,
      ),
    ),
  );
  final gemeinden = result.parsedData?.kommune.untereinheiten;

  return gemeinden?.any(
        (gemeinde) =>
            gemeinde.id == selectedGemeinde &&
            gemeinde.name == _hamelnGemeindeName,
      ) ??
      false;
}

/// Whether the selected profile municipality is Hameln.
final _selectedProfileGemeindeIsHamelnProvider = FutureProvider<bool>(
  _isSelectedProfileGemeindeHameln,
);

/// Whether the Ideahub button should be shown on the map.
/// Visible when the profile commune is Hameln
/// or when the user is physically within the Hameln city boundaries.
final ideahubVisibilityProvider = Provider<AsyncValue<bool>>((ref) {
  final isSelectedProfileGemeindeHameln = ref.watch(
    _selectedProfileGemeindeIsHamelnProvider,
  );

  return isSelectedProfileGemeindeHameln.when(
    data: (isSelected) {
      if (isSelected) return const AsyncData(true);
      return ref
          .watch(ideahubPositionProvider)
          .whenData(_isInsideHamelnGeofence);
    },
    error: AsyncError.new,
    loading: AsyncLoading.new,
  );
});
