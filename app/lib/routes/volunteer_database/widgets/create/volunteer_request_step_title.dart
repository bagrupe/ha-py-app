import 'package:app/components/forms/app_dropdown_form_field.dart';
import 'package:app/components/forms/app_text_field.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_form_state.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_categories_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_form_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Title and category fields of the request workflow.
class VolunteerRequestStepTitle extends ConsumerWidget {
  /// Creates the first workflow step.
  const VolunteerRequestStepTitle({
    required this.state,
    required this.notifier,
    super.key,
  });

  /// Current request form state.
  final VolunteerRequestFormState state;

  /// Request form notifier.
  final VolunteerRequestFormNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(volunteerCategoriesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        AppTextField(
          label: 'application.volunteer_database.create_request.fields.title'
              .tr(),
          initialValue: state.title,
          textInputAction: TextInputAction.next,
          onChanged: notifier.setTitle,
          helperText:
              'application.volunteer_database.create_request.hints.title'.tr(),
        ),
        categories.when(
          data: (items) => AppDropdownFormField<String>(
            initialValue: state.categoryId,
            items: [
              for (final category in items)
                DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                ),
            ],
            onChanged: (value) {
              if (value != null) notifier.setCategory(value);
            },
            name: 'volunteer_request_category',
            label:
                'application.volunteer_database.create_request.fields.category'
                    .tr(),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => TextButton(
            onPressed: () => ref.invalidate(volunteerCategoriesProvider),
            child: Text('application.error.retry'.tr()),
          ),
        ),
      ],
    );
  }
}
