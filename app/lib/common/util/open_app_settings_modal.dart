import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

/// Ein modales Widget, das den Nutzer auffordert, die App-Einstellungen zu öffnen.
/// Zeigt einen Titel, eine Beschreibung und einen Button, der die Systemeinstellungen öffnet.
class OpenAppSettingsModal extends StatelessWidget {
  /// Erstellt eine Instanz von OpenAppSettingsModal mit Titel und Beschreibung.
  const OpenAppSettingsModal({
    required this.title,
    required this.description,
    super.key,
  });

  /// Der Titel des Modals.
  final String title;

  /// Die Beschreibung, die den Zweck des Modals erklärt.
  final String description;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: DesignTokens.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                  color: DesignTokens.gray900,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: DesignTokens.gray900,
                    ),
                  ),
                  const SizedBox(height: 29),
                  FilledButton(
                    onPressed: () {
                      openAppSettings();
                      Navigator.pop(context);
                    },
                    child: const Text('Zu den App Einstellungen'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 34),
          ],
        ),
      ),
    );
  }
}
