// ignore_for_file: inference_failure_on_function_invocation

import 'package:app/common/util/open_app_settings_modal.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Definiert einen Callback-Typ, der eine asynchrone Funktion ohne Rückgabewert beschreibt.
typedef FutureVoidCallback = Future<void> Function();

/// Ein Widget, das Optionen zur Auswahl der Bildquelle anbietet.
/// Es ermöglicht das Öffnen der Kamera oder der Galerie über bereitgestellte Callback-Funktionen.
class ImagePickerOptionsBuilder extends StatelessWidget {
  /// Erstellt eine Instanz von [ImagePickerOptionsBuilder] mit den erforderlichen Callbacks.
  const ImagePickerOptionsBuilder({
    required this.openCameraPicker,
    required this.openGalleryPicker,
    super.key,
  });

  /// Callback zum Öffnen des Kamera-Pickers.
  final FutureVoidCallback openCameraPicker;

  /// Callback zum Öffnen des Galerie-Pickers.
  final FutureVoidCallback openGalleryPicker;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 24),
      const Text('Bildquelle auswählen', style: TextStyle(fontSize: 18)),
      const SizedBox(height: 24),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => _openCameraPicker(context),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            child: const Column(
              children: [Icon(Icons.camera_alt_outlined), Text('Kamera')],
            ),
          ),
          ElevatedButton(
            onPressed: openGalleryPicker,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            child: const Column(
              children: [Icon(Icons.photo_library_outlined), Text('Galerie')],
            ),
          ),
        ],
      ),
    ],
  );

  /// Prüft die Kameraberechtigung und öffnet den Kamera-Picker oder zeigt bei dauerhafter Verweigerung eine Erklärung an.
  ///
  /// [context] wird für die Anzeige von UI-Elementen benötigt.
  Future<void> _openCameraPicker(BuildContext context) async {
    final status = await Permission.camera.status;
    if (!context.mounted) {
      return;
    }
    if (status.isPermanentlyDenied) {
      _handlePermissionPermanentlyDenied(context);
    }
    return openCameraPicker();
  }

  /// Zeigt ein Modal an, das den Nutzer informiert, wie er die Kameraberechtigung in den Einstellungen freigeben kann.
  ///
  /// [context] wird für die Anzeige des Modals benötigt.
  void _handlePermissionPermanentlyDenied(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const OpenAppSettingsModal(
          title: 'Kamera freigeben',
          description:
              'Um Fotos zu machen oder Bilder hochzuladen, benötigt die App Zugriff auf die Kamera.\n\n'
              'Gehen Sie dazu in die Einstellungen Ihres Geräts und gewähren Sie der App die Berechtigung, auf die Kamera zuzugreifen.',
        );
      },
    );
  }
}

/// Liefert eine Standard-Instanz von [ImagePickerOptionsBuilder] mit den übergebenen Callbacks.
///
/// [openCameraPicker] und [openGalleryPicker] sind die Funktionen zum Öffnen der jeweiligen Bildquellen.
Widget defaultOptionsBuilder(
  FutureVoidCallback openCameraPicker,
  FutureVoidCallback openGalleryPicker,
) => ImagePickerOptionsBuilder(
  openCameraPicker: openCameraPicker,
  openGalleryPicker: openGalleryPicker,
);
