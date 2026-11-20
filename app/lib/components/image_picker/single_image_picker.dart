import 'dart:io';

import 'package:app/common/image_compression/compressing_image_field.dart';
import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:app/common/local_attachments/validate_attachments.dart';
import 'package:app/components/image_picker/image_picker_options_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Selects a single image within a form.
/// Uses FormBuilderImagePicker to display and manage selected images.
/// [name] identifies the form field and [initialValue] supplies a saved image.
/// [required] determines whether an image must be selected.
class SingleImagePicker extends StatelessWidget {
  const SingleImagePicker({
    required this.name,
    super.key,
    this.initialValue,
    this.required = false,
    this.profile = ImageCompressionProfile.foto,
  });
  final String name;
  final XFile? initialValue;
  final bool required;
  final ImageCompressionProfile profile;

  @override
  Widget build(BuildContext context) => CompressingImageField(
    name: name,
    profile: profile,
    builder: (context, onChanged) => FormBuilderImagePicker(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: name,
      onChanged: onChanged,
      maxImages: 1,
      placeholderWidget: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(
              Icons.file_upload_outlined,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
      previewBuilder: (context, images, addButton) => Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 130),
            child: addButton ?? images[0],
          ),
        ),
      ),
      optionsBuilder: defaultOptionsBuilder,
      validator: FormBuilderValidators.compose([
        validateAttachments,
        if (required)
          FormBuilderValidators.required(
            errorText: 'application.attachments.required'.tr(),
          ),
        (valueCandidate) {
          if (kIsWeb) return null;
          const maxBytes = 30 * 1024 * 1024;
          final files = (valueCandidate ?? []) as List?;
          if (files == null || files.isEmpty) return null;

          final file = files.first;
          try {
            final path = file is XFile ? file.path : null;
            if (path != null && path.isNotEmpty) {
              final size = File(path).lengthSync();
              if (size > maxBytes) {
                return 'application.attachments.max_file_size'.tr(
                  namedArgs: {'size': '30'},
                );
              }
            }
          } catch (_) {}
          return null;
        },
      ]),
      initialValue: initialValue != null ? [initialValue] : null,
    ),
  );
}
