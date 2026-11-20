import 'package:app/common/image_compression/compressing_image_field.dart';
import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:app/common/local_attachments/validate_attachments.dart';
import 'package:app/components/image_picker/image_picker_options_builder.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Selects a passport photo with a preview and framing guide.
/// Uses FormBuilderImagePicker with a placeholder illustration.
class PassfotoImageField extends ConsumerWidget {
  /// Creates a passport-photo field using the supplied definition.
  const PassfotoImageField({
    required this.feld,
    super.key,
    this.optional = false,
  });

  /// Upload field definition.
  final Fragment_FormularFeld__UploadFormularFeld feld;

  /// Whether the field can be left empty.
  final bool optional;

  /// Computes the preview height from the available screen height.
  static double getPreviewImageHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.4;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewHeight = getPreviewImageHeight(context);

    return Stack(
      children: [
        CompressingImageField(
          name: feld.slotName,
          profile: ImageCompressionProfile.passfoto,
          builder: (context, onChanged) => FormBuilderImagePicker(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: feld.slotName,
            onChanged: onChanged,
            transformImageWidget: (context, displayImage) =>
                Card(child: SizedBox.expand(child: displayImage)),
            placeholderWidget: Stack(
              alignment: Alignment.center,
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.5),
                    BlendMode.dstATop,
                  ),
                  child: const Image(
                    image: AssetImage('assets/images/musterfrau.png'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                const Icon(Icons.image_outlined, size: 48, color: Colors.white),
              ],
            ),
            showDecoration: false,
            maxImages: 1,
            previewWidth: double.infinity,
            previewHeight: previewHeight,
            backgroundColor: Colors.grey.shade200,
            optionsBuilder: defaultOptionsBuilder,
            maxWidth: ImageCompressionProfile.passfoto.pickerMaxEdge,
            maxHeight: ImageCompressionProfile.passfoto.pickerMaxEdge,
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
          child: Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(), top: BorderSide()),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(), top: BorderSide()),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(), bottom: BorderSide()),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(), bottom: BorderSide()),
            ),
          ),
        ),
      ],
    );
  }
}
