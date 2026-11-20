import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Ein Drawer-Widget, das das Hauptmenü der App darstellt.
class MainMenuDrawer extends StatelessWidget {
  /// Erstellt einen neuen MainMenuDrawer.
  const MainMenuDrawer({super.key});

  /// Baut das Widget und zeigt eine Liste von Menüeinträgen an.
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.terminal),
              title: const Text('Dev Console'),
              onTap: () {
                context.push('/dev');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
