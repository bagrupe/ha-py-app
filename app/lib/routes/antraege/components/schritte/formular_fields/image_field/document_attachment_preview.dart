part of 'document_field.dart';

/// Displays an attachment thumbnail with an accessible removal action.
class _DocumentAttachmentPreview extends StatelessWidget {
  /// Creates a preview for a selected document.
  const _DocumentAttachmentPreview({
    required this.file,
    required this.onRemove,
  });

  /// Attachment represented by the preview.
  final XFile file;

  /// Removes the attachment from the surrounding form.
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isPdf = lookupMimeType(file.path) == 'application/pdf';
    return Stack(
      children: [
        if (!kIsWeb && file.path.isNotEmpty)
          if (isPdf)
            const PDFDisplay()
          else
            Image.file(
              File(file.path),
              cacheWidth: 400,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
        else
          FutureBuilder<Uint8List>(
            future: file.readAsBytes(),
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (snapshot.hasError) {
                return Text('application.attachments.missing'.tr());
              }
              if (data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return lookupMimeType('', headerBytes: data) == 'application/pdf'
                  ? const PDFDisplay()
                  : Image.memory(
                      data,
                      cacheWidth: 400,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    );
            },
          ),
        PositionedDirectional(
          top: 0,
          end: 0,
          child: IconButton(
            tooltip: 'application.attachments.remove'.tr(),
            onPressed: onRemove,
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.withValues(alpha: .7),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.close, size: 18),
          ),
        ),
      ],
    );
  }
}
