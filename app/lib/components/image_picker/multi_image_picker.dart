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

/// Selects multiple images within a form.
/// Uses FormBuilderImagePicker to display and manage selected images.
class MultiImagePicker extends StatelessWidget {
  /// Creates a multiple-image form picker.
  /// [name] identifies the field and [initialValues] supplies saved images.
  /// [required] determines whether a selection is mandatory.
  const MultiImagePicker({
    required this.name,
    super.key,
    this.initialValues,
    this.required = false,
    this.profile = ImageCompressionProfile.foto,
  });

  /// Maximum combined attachment size in mebibytes.
  static const _maxTotalSizeMiB = 30;

  /// Maximum combined attachment size in bytes.
  static const _maxTotalSizeBytes = _maxTotalSizeMiB * 1024 * 1024;

  /// Form field identifier.
  final String name;

  /// Initially selected images.
  final List<XFile>? initialValues;

  /// Whether selecting an image is required.
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
      transformImageWidget: (context, displayImage) =>
          SizedBox.expand(child: displayImage),
      previewBuilder: (context, images, addButton) => ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 130),
        child: GridView.extent(
          shrinkWrap: true,
          primary: false,
          maxCrossAxisExtent: 150,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [...images, if (addButton != null) addButton],
        ),
      ),
      icon: Icons.file_upload_outlined,
      iconColor: Colors.grey.shade400,
      backgroundColor: Colors.grey.shade200,
      optionsBuilder: defaultOptionsBuilder,
      validator: FormBuilderValidators.compose([
        validateAttachments,
        FormBuilderValidators.required(
          errorText: 'application.attachments.required'.tr(),
        ),
        (valueCandidate) {
          if (kIsWeb) return null;
          final files = (valueCandidate ?? []) as List?;
          if (files == null) return null;

          var total = 0;
          for (final file in files) {
            try {
              final path = file is XFile ? file.path : null;
              if (path != null && path.isNotEmpty) {
                total += File(path).lengthSync();
              }
            } catch (_) {}
          }
          if (total > _maxTotalSizeBytes) {
            return 'application.attachments.max_total_size'.tr(
              namedArgs: {'size': '$_maxTotalSizeMiB'},
            );
          }
          return null;
        },
      ]),
      initialValue: initialValues,
    ),
  );
}
