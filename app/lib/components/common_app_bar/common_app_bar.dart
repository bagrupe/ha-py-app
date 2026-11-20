import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/routes/root.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';

/// Eine AppBar-Komponente, die optional einen Titel, ein Logo und ein Menü anzeigt.
/// Das Menü kann entweder eine Drawer-Öffnung oder eine benutzerdefinierte Aktion auslösen.
class CommonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.customOnPressed,
    this.logo = false,
    this.menu = true,
    this.extraActions = const [],
  });

  /// Der optionale Titel der AppBar.
  final Widget? title;

  /// Gibt an, ob das Logo angezeigt werden soll.
  final bool logo;

  /// Gibt an, ob das Menü angezeigt werden soll.
  final bool menu;

  /// Eine optionale benutzerdefinierte Funktion, die beim Drücken des Menüs ausgeführt wird.
  final VoidCallback? customOnPressed;

  /// Zusätzliche Aktionen (z.B. ein Abmelden-Button), die vor dem Standard-Icon (Konto/Menü)
  /// eingefügt werden.
  final List<Widget> extraActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootScaffoldState = RootScaffold.of(context);
    final notificationCount = ref.watch(mitteilungenCountNotifierProvider);
    final volunteerDbEnabled = ref.watch(volunteerDatabaseEnabledProvider);
    final hasRootScaffoldEndDrawer =
        rootScaffoldState != null && rootScaffoldState.hasEndDrawer;

    var currentPath = '';
    try {
      currentPath = GoRouterState.of(context).uri.path;
    } catch (_) {}
    final isProfilePage = currentPath.startsWith('/profil');

    return AppBar(
      title: title,
      centerTitle: true,
      leading: logo
          ? Consumer(
              builder: (context, ref, _) {
                final logoImageUrl = ref
                    .watch(kommuneProvider)
                    .value
                    ?.design
                    ?.logo
                    ?.url;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
                  child: logoImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: logoImageUrl,
                          fadeInDuration: const Duration(milliseconds: 200),
                          placeholder: (context, url) =>
                              Image.memory(kTransparentImage),
                          errorWidget: (context, url, error) =>
                              Image.memory(kTransparentImage),
                        )
                      : null,
                );
              },
            )
          : null,
      leadingWidth: logo ? 80 : null,
      actions: [
        ...extraActions,
        if (volunteerDbEnabled && !isProfilePage)
          IconButton(
            icon: notificationCount > 0
                ? Badge.count(
                    count: notificationCount,
                    child: const Icon(Icons.account_circle_outlined),
                  )
                : const Icon(Icons.account_circle_outlined),

            onPressed: () {
              context.go('/profil');
            },
          )
        else if (menu && (hasRootScaffoldEndDrawer || customOnPressed != null))
          IconButton(
            onPressed: hasRootScaffoldEndDrawer
                ? rootScaffoldState.openEndDrawer
                : () => customOnPressed!(),
            icon: const Icon(Icons.menu),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
