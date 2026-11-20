import 'package:flutter_riverpod/legacy.dart';

/// Provider for the currently selected category in the Ehrenamtsdatenbank.
/// Defaults to "all" so the marketplace and preview show unfiltered results.
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
