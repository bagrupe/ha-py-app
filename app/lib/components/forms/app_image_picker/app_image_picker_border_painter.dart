part of 'app_image_picker.dart';

/// Paints the dashed rounded border used by the application image picker.
class _AppImagePickerBorderPainter extends CustomPainter {
  /// Creates a dashed border painter using [color].
  const _AppImagePickerBorderPainter({required this.color});

  /// Border color.
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(8)),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 6), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(_AppImagePickerBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
