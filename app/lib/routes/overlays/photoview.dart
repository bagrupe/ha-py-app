import 'package:app/components/images/animated_extended_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// Enthält die notwendigen Daten für die Vollbild-Fotoansicht.
class FullscreenPhotoViewExtras {
  /// Erstellt eine Instanz mit der URL und dem Titel des Fotos.
  FullscreenPhotoViewExtras({
    required this.url,
    required this.title,
    required this.fallbackUrl,
  });

  /// Die URL des anzuzeigenden Fotos.
  final String? url;

  /// Der Titel, der in der Ansicht angezeigt wird.
  final String title;

  /// Die Fallback-URL des anzuzeigenden Fotos.
  final String? fallbackUrl;
}

/// Zeigt ein Foto im Vollbildmodus mit Gestenunterstützung an.
class FullscreenPhotoView extends StatelessWidget {
  /// Erstellt eine Vollbild-Fotoansicht mit URL und Titel.
  const FullscreenPhotoView({
    required this.url,
    required this.fallbackUrl,
    required this.titel,
    super.key,
  });

  /// Die URL des anzuzeigenden Fotos.
  final String? url;

  /// Die Fallback-URL des anzuzeigenden Fotos.
  final String? fallbackUrl;

  /// Der Titel, der in der AppBar angezeigt wird.
  final String titel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titel)),
      backgroundColor: Colors.transparent,
      body: ExtendedImageSlidePage(
        slidePageBackgroundHandler: (_, __) => Colors.transparent,
        child: ExtendedImageGesturePageView(
          children: [
            AnimatedExtendedImage(
              fallbackUrl: fallbackUrl,
              enableSlideOutPage: true,
              inPageView: true,
              url: url,
            ),
          ],
        ),
      ),
    );
  }
}
