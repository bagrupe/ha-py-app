import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/router.dart';
import 'package:app/routes/overlays/location_search/location_search.dart';
import 'package:app/routes/overlays/photoview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Definiert die Route für Overlay-Komponenten der App.
/// Enthält Unterrouten für die Standortsuche und die Vollbild-Fotodarstellung.
final overlaysRoute = GoRoute(
  path: '/overlays',
  builder: (_, __) => const Text('You should not be here.'),
  routes: [
    /// Route für die Standortsuche als Dialog.
    GoRoute(
      path: 'location-search',
      pageBuilder: TransitionPageBuilders.dialogTransition(
        builder: (_, __) => const LocationSearch(),
      ),
      parentNavigatorKey: rootNavigatorKey,
    ),

    /// Route für die Vollbild-Fotodarstellung als Dialog.
    GoRoute(
      path: 'photo-fullscreen',
      pageBuilder: TransitionPageBuilders.dialogTransition(
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra! as FullscreenPhotoViewExtras;
          return Material(
            color: Colors.transparent,
            child: FullscreenPhotoView(
              url: extra.url,
              fallbackUrl: extra.fallbackUrl,
              titel: extra.title,
            ),
          );
        },
      ),
      parentNavigatorKey: rootNavigatorKey,
    ),
  ],
);
