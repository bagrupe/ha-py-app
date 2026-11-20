import 'package:app/common/design_tokens.dart';
import 'package:app/components/filter_button/filter_pill.dart';
import 'package:app/routes/volunteer_database/providers/selected_category_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_categories_provider.dart';
import 'package:app/routes/volunteer_database/widgets/categories_error_state.dart';
import 'package:app/routes/volunteer_database/widgets/categories_loading_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesFilter extends ConsumerWidget {
  const CategoriesFilter({super.key});

  static const String _allCategoriesValue = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = ref.watch(volunteerCategoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'application.volunteer_database.browse_categories'.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: DesignTokens.gray500,
          ),
        ),
        const SizedBox(height: 4),
        categories.when(
          loading: () => const CategoriesLoadingState(),
          error: (error, stackTrace) => const CategoriesErrorState(),
          data: (items) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterPill(
                isSelected: selectedCategory == null,
                label: 'application.volunteer_database.category_all'.tr(),
                value: _allCategoriesValue,
                onSelectedChange: (value) {
                  ref.read(selectedCategoryProvider.notifier).state = null;
                },
              ),
              ...items.map(
                (category) => FilterPill(
                  isSelected: category.id == selectedCategory,
                  label: category.name,
                  value: category.id,
                  onSelectedChange: (value) {
                    ref.read(selectedCategoryProvider.notifier).state = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
