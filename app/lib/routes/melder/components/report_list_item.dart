import 'package:app/routes/melder/common/report_upload_image.dart';
import 'package:app/routes/melder/components/report_image.dart';
import 'package:flutter/material.dart';

/// Shared list item layout for reporting workflows.
class ReportListItem extends StatelessWidget {
  const ReportListItem({
    required this.title,
    required this.detailTexts,
    required this.onTap,
    super.key,
    this.image,
    this.imageUrl,
    this.semanticsLabel,
  });

  /// Primary text displayed in the item.
  final String title;

  /// Detail lines displayed below the title.
  final List<String> detailTexts;

  /// Optional image URL displayed in the leading image area.
  final String? imageUrl;

  /// Optional image data displayed in the leading image area.
  final ReportUploadImage? image;

  /// Callback executed when the item is tapped.
  final VoidCallback onTap;

  /// Optional accessibility label for the whole item.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: semanticsLabel ?? title,
      child: IntrinsicHeight(
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: InkWell(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 100,
                    child: ExcludeSemantics(
                      child: ReportImage(
                        image: image,
                        fit: BoxFit.cover,
                        imageUrl: imageUrl,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        ...detailTexts.map(
                          (detailText) =>
                              Text(detailText, style: textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
