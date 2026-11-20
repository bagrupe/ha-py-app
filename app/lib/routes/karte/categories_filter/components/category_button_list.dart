// ignore_for_file: inference_failure_on_function_return_type

import 'package:app/common/extensions/iterable.dart';
import 'package:app/graphql/__generated__/poi-categories.graphql.dart';
import 'package:app/routes/karte/categories_filter/components/category_button.dart';
import 'package:flutter/material.dart';

class CategoryButtonList extends StatelessWidget {
  const CategoryButtonList({
    required this.poiCategories,
    required this.selectedOptions,
    required this.onChange,
    this.fallbackIcons = const {},
    super.key,
  });

  /// Categories displayed by the button list.
  final List<Query_PoiCategoryForKommune_poiCategories_docs?> poiCategories;

  /// IDs of the currently selected categories.
  final List<String> selectedOptions;

  /// Called when the selection of a category changes.
  final Function(String categoryId) onChange;

  /// Local icons used when a category has no backend icon.
  final Map<String, IconData> fallbackIcons;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        // crossAxisAlignment: CrossAxisAlignment.start,
        runSpacing: 10,
        textDirection: TextDirection.ltr,
        children: [
          ...poiCategories.nonNulls
              .map<Widget>(
                (poiCategory) => CategoryButton(
                  poiCategory: poiCategory,
                  active: selectedOptions.contains(poiCategory.id),
                  fallbackIcon: fallbackIcons[poiCategory.id],
                  onChange: () {
                    onChange(poiCategory.id);
                  },
                ),
              )
              .joinWithElement(const SizedBox(width: 20)),
        ],
      ),
    );
  }
}
