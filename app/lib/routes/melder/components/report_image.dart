import 'package:app/components/images/loading_image.dart';
import 'package:app/routes/melder/common/report_upload_image.dart';
import 'package:flutter/material.dart';

/// Displays an uploaded report image from bytes or a backend image URL.
class ReportImage extends StatelessWidget {
  /// Creates a report image widget.
  const ReportImage({
    required this.fit,
    super.key,
    this.image,
    this.imageUrl,
    this.height,
    this.alignment = Alignment.center,
  });

  /// Optional normalized image data.
  final ReportUploadImage? image;

  /// Optional backend image URL.
  final String? imageUrl;

  /// Image fit used for byte and URL backed images.
  final BoxFit fit;

  /// Optional image height.
  final double? height;

  /// Image alignment.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final bytes = image?.bytes;
    if (bytes != null) {
      return Image.memory(
        bytes,
        fit: fit,
        height: height,
        alignment: alignment,
        gaplessPlayback: true,
      );
    }
    return LoadingImage(
      imageUrl: imageUrl,
      fit: fit,
      height: height,
      alignment: alignment,
    );
  }
}
