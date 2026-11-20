import 'dart:io';

import 'package:app/common/extensions/text_theme.dart';
import 'package:app/common/image_compression/compressing_image_field.dart';
import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:app/common/local_attachments/validate_attachments.dart';
import 'package:app/components/image_picker/image_picker_options_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

part 'app_image_picker_add_button.dart';
part 'app_image_picker_border_painter.dart';

/// Displays a consistently styled single- or multi-image form picker.
class AppImagePicker extends StatelessWidget {
  /// Creates an application image picker.
  const AppImagePicker({
    required this.name,
    this.allowMultiple = false,
    this.maxImages = 10,
    this.initialValues,
    this.onChanged,
    this.required = false,
    super.key,
  });

  /// Form field identifier.
  final String name;

  /// Whether more than one image can be selected.
  final bool allowMultiple;

  /// Maximum number of images when multiple selection is enabled.
  final int maxImages;

  /// Images initially displayed by the picker.
  final List<XFile>? initialValues;

  /// Callback invoked when the selected images change.
  final ValueChanged<List<dynamic>?>? onChanged;

  /// Whether at least one image must be selected.
  final bool required;

  @override
  Widget build(BuildContext context) {
    return CompressingImageField(
      name: name,
      profile: ImageCompressionProfile.foto,
      builder: (context, compress) => FormBuilderImagePicker(
        name: name,
        initialValue: initialValues,
        onChanged: (value) {
          compress(value);
          onChanged?.call(value);
        },
        maxImages: allowMultiple ? maxImages : 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        previewAutoSizeWidth: false,
        placeholderWidget: const _AppImagePickerAddButton(),
        transformImageWidget: (context, image) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox.expand(child: image),
        ),
        previewBuilder: (context, images, addButton) {
          if (images.isEmpty) return addButton ?? const SizedBox.shrink();
          if (!allowMultiple) {
            return SizedBox(height: 180, child: images.first);
          }
          return GridView.extent(
            shrinkWrap: true,
            primary: false,
            maxCrossAxisExtent: 150,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [...images, if (addButton != null) addButton],
          );
        },
        optionsBuilder: defaultOptionsBuilder,
        validator: _validateImages,
      ),
    );
  }

  /// Validates required selection and the combined upload size.
  String? _validateImages(List<dynamic>? images) {
    final missing = validateAttachments(images);
    if (missing != null) return missing;
    if (required && (images == null || images.isEmpty)) {
      return 'application.image_picker.required'.tr();
    }
    if (kIsWeb || images == null) return null;

    const maxBytes = 5 * 1024 * 1024;
    var totalBytes = 0;
    for (final image in images.whereType<XFile>()) {
      try {
        if (image.path.isNotEmpty) totalBytes += File(image.path).lengthSync();
      } on FileSystemException {
        continue;
      }
    }
    return totalBytes > maxBytes
        ? 'application.image_picker.max_size'.tr()
        : null;
  }
}
