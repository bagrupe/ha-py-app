import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart' hide Path;

/// Typ der Marker auf der Karte.
enum MarkerType {
  mangelOpen,
  mangelCompleted,
  ideeOpen,
  ideeCompleted,
  poi,
  sensor,
}

/// Datenmodell für einen Marker auf der Karte.
class MarkerData {
  /// Erstellt eine neue Instanz von MarkerData mit den angegebenen Werten.
  const MarkerData({
    required this.id,
    required this.type,
    required this.point,
    required this.marker,
    required this.routePrefix,
  });

  /// Eindeutige ID des Markers.
  final String id;

  /// Typ des Markers.
  final MarkerType type;

  /// Geographische Position des Markers.
  final LatLng point;

  /// Widget, das den Marker visuell darstellt.
  final Widget marker;

  /// Präfix für die zugehörige Navigationsroute.
  final String routePrefix;
}

/// Widget zur Darstellung eines Markers auf der Karte mit unterschiedlicher Farbgebung und optionalem Icon.
class MapMarker extends StatelessWidget {
  /// Erstellt einen neuen MapMarker mit Typ und optionalem Icon.
  const MapMarker({required this.type, super.key, this.iconUrl});

  /// Typ des Markers, bestimmt Farbe und Stil.
  final MarkerType type;

  /// Optionale URL für ein SVG-Icon, das im Marker angezeigt wird.
  final String? iconUrl;

  IconData? get _reportFallbackIcon => switch (type) {
    MarkerType.mangelOpen ||
    MarkerType.mangelCompleted => Icons.campaign_outlined,
    MarkerType.ideeOpen || MarkerType.ideeCompleted => Icons.lightbulb_outline,
    MarkerType.poi || MarkerType.sensor => null,
  };

  static const double _triangleSize = 14;
  static const double _circleSize = 40;
  static const markerWidth = _circleSize;
  static const markerHeight = _circleSize + _triangleSize;

  @override
  Widget build(BuildContext context) {
    late Color bgColor;
    late Color strokeColor;

    switch (type) {
      case MarkerType.mangelCompleted:
      case MarkerType.ideeCompleted:
        bgColor = DesignTokens.green100;
        strokeColor = DesignTokens.green500;
      case MarkerType.mangelOpen:
      case MarkerType.ideeOpen:
        bgColor = DesignTokens.orange100;
        strokeColor = DesignTokens.orange500;
      case MarkerType.poi:
      case MarkerType.sensor:
        bgColor = DesignTokens.white;
        strokeColor = DesignTokens.gray100;
    }

    final reportFallbackIcon = _reportFallbackIcon;
    final fallbackIcon = Icon(
      reportFallbackIcon ?? Icons.campaign_outlined,
      color: strokeColor,
    );
    final hasIcon = reportFallbackIcon == null
        ? iconUrl != null
        : iconUrl?.isNotEmpty ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: _circleSize,
          width: _circleSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: hasIcon
                  ? SvgPicture.network(
                      iconUrl!,
                      width: 26,
                      height: 26,
                      errorBuilder: reportFallbackIcon == null
                          ? null
                          : (context, error, stackTrace) => fallbackIcon,
                    )
                  : fallbackIcon,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -2),
          child: SizedBox(
            width: _triangleSize,
            height: _triangleSize,
            child: CustomPaint(painter: TrianglePainter(strokeColor: bgColor)),
          ),
        ),
      ],
    );
  }
}

/// CustomPainter zur Darstellung eines Dreiecks als Marker-Spitze.
class TrianglePainter extends CustomPainter {
  /// Erstellt einen neuen TrianglePainter mit optionalen Parametern.
  const TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.fill,
  });

  /// Farbe des Dreiecks.
  final Color strokeColor;

  /// Stil der Maloperation (Füllen oder Kontur).
  final PaintingStyle paintingStyle;

  /// Breite der Kontur, falls verwendet.
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  /// Erzeugt den Pfad für ein gleichschenkliges Dreieck mit gegebener Breite und Höhe.
  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x / 2, y)
      ..lineTo(x, 0)
      ..lineTo(x, 0);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
