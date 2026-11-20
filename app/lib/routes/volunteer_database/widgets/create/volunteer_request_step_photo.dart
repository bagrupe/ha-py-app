import 'package:app/components/forms/app_image_picker/app_image_picker.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_form_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

/// Optional photo selection for the volunteer request.
class VolunteerRequestStepPhoto extends ConsumerWidget {
  /// Creates the optional photo step.
  const VolunteerRequestStepPhoto({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoPath = ref.watch(
      volunteerRequestFormProvider.select((state) => state.photoPath),
    );
    final notifier = ref.read(volunteerRequestFormProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'application.volunteer_database.create_request.hints.photo'.tr(),
          ),
        ),
        Semantics(
          label:
              'application.volunteer_database.create_request.semantics.photo_picker'
                  .tr(),
          child: FormBuilder(
            child: AppImagePicker(
              name: 'volunteerRequestPhoto',
              initialValues: photoPath == null ? null : [XFile(photoPath)],
              onChanged: (images) {
                final image = images?.firstOrNull;
                notifier.setPhotoPath(image is XFile ? image.path : null);
              },
            ),
          ),
        ),
      ],
    );
  }
}
