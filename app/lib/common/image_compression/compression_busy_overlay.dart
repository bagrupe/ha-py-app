part of 'compressing_image_field.dart';

class _CompressionBusyOverlay extends StatelessWidget {
  const _CompressionBusyOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
