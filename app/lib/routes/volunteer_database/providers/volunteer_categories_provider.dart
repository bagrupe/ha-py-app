import 'package:app/common/volunteer_database/volunteer_category_repository.dart';
import 'package:app/routes/volunteer_database/models/volunteer_category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loads the visible root categories for the volunteer marketplace.
class VolunteerCategoriesNotifier
    extends AsyncNotifier<List<VolunteerCategoryModel>> {
  @override
  Future<List<VolunteerCategoryModel>> build() {
    return ref.read(volunteerCategoryRepositoryProvider).getCategories();
  }
}

/// Visible volunteer marketplace root categories.
final volunteerCategoriesProvider =
    AsyncNotifierProvider<
      VolunteerCategoriesNotifier,
      List<VolunteerCategoryModel>
    >(VolunteerCategoriesNotifier.new);
