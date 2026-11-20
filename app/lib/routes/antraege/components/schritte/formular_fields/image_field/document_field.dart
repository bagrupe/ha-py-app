import 'dart:async';
import 'dart:io';

import 'package:app/common/image_compression/image_compression.dart';
import 'package:app/common/image_compression/image_compression_overlay.dart';
import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:app/common/local_attachments/validate_attachments.dart';
import 'package:app/components/heading/subheading.dart';
import 'package:app/components/pdf_display.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/upload_field.dart';
import 'package:cross_file/cross_file.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:mime/mime.dart';

part 'document_upload_option.dart';
part 'document_attachment_preview.dart';

/// Selects and previews image or PDF attachments.
/// Supports camera scanning and PDF uploads.
class DocumentField extends ConsumerWidget {
  /// Creates a document field with the supplied definition and requirement.
  const DocumentField({required this.feld, super.key, this.required = false});

  /// Form field definition.
  final FormularImageFeldData feld;

  /// Whether at least one attachment is required.
  final bool required;

  /// Scans documents with the camera and adds processed images to the field.
  /// [field] receives the successfully processed images.
  Future<void> scanImages(FormFieldState<List<XFile>> field) async {
    final imagesPath = await CunningDocumentScanner.getPictures();

    if (imagesPath != null && imagesPath.isNotEmpty) {
      if (!field.context.mounted) return;
      final context = field.context;
      unawaited(
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              const PopScope(canPop: false, child: ImageCompressionOverlay()),
        ),
      );

      final List<XFile> xfiles;
      try {
        xfiles = await trackImageCompression(
          compressImages(
            imagesPath.map(XFile.new).toList(),
            ImageCompressionProfile.dokument,
          ),
        );
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('application.attachments.processing_error'.tr()),
            ),
          );
        }
        return;
      } finally {
        if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      }

      if (!context.mounted) return;

      field.didChange(
        (field.value == null ? xfiles : [...field.value!, ...xfiles])
            .cast<XFile>(),
      );
    }
  }

  /// Selects PDF documents and adds them to the form field.
  /// [field] receives the selected PDF files.
  Future<void> uploadPDFDocuments(FormFieldState<List<XFile>> field) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null && result.paths.isNotEmpty) {
      final xfiles = result.paths.map((path) => XFile(path!)).toList();

      field.didChange(
        (field.value == null ? xfiles : [...field.value!, ...xfiles])
            .cast<XFile>(),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FormBuilderField<List<XFile>>(
      builder: (field) {
        final hasValues = field.value != null && field.value!.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (field.hasError)
              Text(
                field.errorText ??
                    'application.antraege.document_field.error'.tr(),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (feld.angezeigterName != null) ...{
              SubHeading(feld.angezeigterName!, paddingLeft: 0),
              const SizedBox(height: 12),
              if (feld.anweisung != null) ...{
                Text(feld.anweisung!),
                const SizedBox(height: 12),
              },
            },
            if (hasValues) ...[
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 130),
                child: GridView.extent(
                  shrinkWrap: true,
                  primary: false,
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: [
                    for (final entry in field.value!.asMap().entries)
                      _DocumentAttachmentPreview(
                        file: entry.value,
                        onRemove: () => field.didChange(
                          field.value!.toList()..removeAt(entry.key),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            _DocumentUploadOption(
              title: 'application.antraege.document_field.scan_action'.tr(),
              icon: Icons.photo_camera_outlined,
              onTap: () => scanImages(field),
            ),
            const SizedBox(height: 12),
            _DocumentUploadOption(
              title: 'application.antraege.document_field.pdf_upload_action'
                  .tr(),
              icon: Icons.file_upload_outlined,
              onTap: () => uploadPDFDocuments(field),
            ),
          ],
        );
      },
      name: feld.slotName,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (valueCandidate) {
        if (required && (valueCandidate == null || valueCandidate.isEmpty)) {
          return 'application.antraege.document_field.required'.tr();
        }
        return validateAttachments(valueCandidate);
      },
    );
  }
}
