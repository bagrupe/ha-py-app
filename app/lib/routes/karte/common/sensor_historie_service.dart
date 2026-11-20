import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service zur Verwaltung der Sensordatenhistorie.
class SensorHistorieService {}

/// Provider zur Bereitstellung einer Instanz von [SensorHistorieService].
final sensorHistorieServiceProvider = Provider(
  (ref) => SensorHistorieService(),
);
