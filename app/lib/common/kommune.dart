import 'package:app/common/kommune_notifier.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enthält Konstanten für die IDs bekannter Kommunen.
abstract final class KommuneIds {
  /// Fallback map center in the district of Hameln-Pyrmont.
  static const hapyMapPosition = <double>[52.1039, 9.36];

  static const hapy = '5a1aefef-809f-403d-a14c-27051353c7d4';
}

/// Ordnet Kommunennamen die zugehörigen IDs zu.
final Map<String, String> kommuneIdByKommuneName = {
  'Landkreis Hameln-Pyrmont': KommuneIds.hapy,
};

/// Provides offline municipality data and revalidates it in the background.
final kommuneProvider =
    AsyncNotifierProvider<KommuneNotifier, Fragment_Kommune>(
      KommuneNotifier.new,
    );
