part of 'sensor_gauge_chart.dart';

/// Paints the gauge arc with four equal-width color zones and the needle for
/// the current reading.
///
/// Per the Figma design, the four zones are always exactly 60° wide each
/// (not proportional to how far apart their numeric thresholds are — with
/// very unevenly spaced thresholds a proportional zone can shrink to a
/// sliver), and the arc sweeps 240° total, overshooting the horizontal by
/// 30° on each end rather than stopping at a flat 180° semicircle. The
/// needle's angle is interpolated within its own zone, from the reading's
/// position between that zone's threshold boundaries.
class _GaugePainter extends CustomPainter {
  const _GaugePainter({
    required this.value,
    required this.greenThreshold,
    required this.yellowThreshold,
    required this.orangeThreshold,
    required this.scaleMax,
    required this.zoneColors,
  });

  final double value;
  final double greenThreshold;
  final double yellowThreshold;
  final double orangeThreshold;
  final double scaleMax;
  final List<Color> zoneColors;

  static const _strokeWidth = 18.0;
  static const _startAngle = 5 * math.pi / 6;
  static const _zoneSweep = math.pi / 3;
  static const _needleLength = 80.0;
  static const _centerCapRadius = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius - _strokeWidth / 2,
    );
    for (var i = 0; i < 4; i++) {
      paint.color = zoneColors[i];
      canvas.drawArc(
        rect,
        _startAngle + i * _zoneSweep,
        _zoneSweep,
        false,
        paint,
      );
    }

    final boundaries = [
      0.0,
      greenThreshold,
      yellowThreshold,
      orangeThreshold,
      scaleMax,
    ];
    final clampedValue = value.clamp(0, scaleMax);
    var zoneIndex = 3;
    for (var i = 0; i < 4; i++) {
      if (clampedValue <= boundaries[i + 1]) {
        zoneIndex = i;
        break;
      }
    }
    final zoneLower = boundaries[zoneIndex];
    final zoneUpper = boundaries[zoneIndex + 1];
    final zoneProgress = zoneUpper > zoneLower
        ? (clampedValue - zoneLower) / (zoneUpper - zoneLower)
        : 0.0;
    final needleAngle = _startAngle + (zoneIndex + zoneProgress) * _zoneSweep;
    final needleEnd =
        center +
        Offset(math.cos(needleAngle), math.sin(needleAngle)) * _needleLength;

    final needlePaint = Paint()
      ..color = DesignTokens.gray900
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(center, needleEnd, needlePaint)
      ..drawCircle(
        center,
        _centerCapRadius,
        Paint()..color = DesignTokens.gray900,
      );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.greenThreshold != greenThreshold ||
      oldDelegate.yellowThreshold != yellowThreshold ||
      oldDelegate.orangeThreshold != orangeThreshold ||
      oldDelegate.scaleMax != scaleMax;
}
