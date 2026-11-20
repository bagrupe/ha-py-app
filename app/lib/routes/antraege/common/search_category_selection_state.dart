import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SearchCategoryPath = Map<String, String>;

String searchCategorySelectionKey({
  required String prozessVersionId,
  required String schrittId,
  required String rootSlot,
}) => '$prozessVersionId::$schrittId::$rootSlot';

class SearchCategorySelectionNotifier
    extends Notifier<Map<String, SearchCategoryPath>> {
  @override
  Map<String, SearchCategoryPath> build() => const {};

  void setSelection(String key, SearchCategoryPath path) {
    state = {...state, key: Map.unmodifiable(path)};
  }

  void clearSelection(String key) {
    if (!state.containsKey(key)) return;
    state = Map.of(state)..remove(key);
  }

  void clear() => state = const {};
}

final searchCategorySelectionProvider =
    NotifierProvider<
      SearchCategorySelectionNotifier,
      Map<String, SearchCategoryPath>
    >(SearchCategorySelectionNotifier.new);
