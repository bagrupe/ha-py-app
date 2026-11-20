import 'package:app/common/image_compression/compressing_image_field.dart';
import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:app/common/local_attachments/validate_attachments.dart';
import 'package:app/components/image_picker/image_picker_options_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Selects and previews a signature image.
/// Uses FormBuilderImagePicker with a framed image preview.
class UnterschriftImageField extends StatelessWidget {
  /// Creates a signature image field with the supplied name.
  const UnterschriftImageField({
    required this.name,
    super.key,
    this.optional = false,
  });

  /// Field identifier within the form.
  final String name;

  /// Whether the field can be left empty.
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CompressingImageField(
          name: name,
          profile: ImageCompressionProfile.unterschrift,
          builder: (context, onChanged) => FormBuilderImagePicker(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: name,
            onChanged: onChanged,
            transformImageWidget: (context, displayImage) =>
                Card(child: SizedBox.expand(child: displayImage)),
            icon: Icons.file_upload_outlined,
            iconColor: Colors.grey.shade400,
            showDecoration: false,
            maxImages: 1,
            previewWidth: double.infinity,
            backgroundColor: Colors.grey.shade200,
            optionsBuilder: defaultOptionsBuilder,
            maxWidth: ImageCompressionProfile.unterschrift.pickerMaxEdge,
            maxHeight: ImageCompressionProfile.unterschrift.pickerMaxEdge,
            validator: FormBuilderValidators.compose([
              validateAttachments,
              if (!optional)
                FormBuilderValidators.required(
                  errorText: 'application.image_picker.required'.tr(),
                ),
            ]),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
