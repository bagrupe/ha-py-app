part of 'app_image_picker.dart';

/// Displays the empty image-picker upload target.
class _AppImagePickerAddButton extends StatelessWidget {
  /// Creates the empty image-picker upload target.
  const _AppImagePickerAddButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: 'application.image_picker.add'.tr(),
      child: CustomPaint(
        painter: _AppImagePickerBorderPainter(
          color: theme.colorScheme.outlineVariant,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            minHeight: 112,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.file_upload_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  'application.image_picker.add'.tr(),
                  style: theme.textTheme.bodyXSmall.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
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
