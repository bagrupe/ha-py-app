import 'dart:async';

import 'package:app/common/dev_tools_enabled.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:app/components/main_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Scaffold-Widget, das die Hauptnavigation der App mit BottomNavigationBar und optionalem End-Drawer bereitstellt.
class RootScaffold extends ConsumerWidget {
  /// Erstellt ein RootScaffold mit dem übergebenen NavigationShell.
  const RootScaffold({required this.navigationShell, super.key});

  /// NavigationShell zur Steuerung der Navigation zwischen den Hauptbereichen.
  final StatefulNavigationShell navigationShell;

  /// Maps the shell branch index to the bottom tab bar index based on whether the volunteer database is enabled.
  ///
  /// The shell branches in router.dart are:
  /// * Branch 0: Aktuelles (News)
  /// * Branch 1: Karte (Map)
  /// * Branch 2: Ehrenamtsdatenbank (Volunteer Database)
  /// * Branch 3: Anträge (Service / Applications)
  /// * Branch 4: Termine (Events / Calendar)
  /// * Branch 5: Profil (Profile)
  ///
  /// Normal tab items (volunteerDbEnabled = false):
  /// * Tab 0: Aktuelles (Branch 0)
  /// * Tab 1: Karte (Branch 1)
  /// * Tab 2: Service (Branch 3)
  /// * Tab 3: Termine (Branch 4)
  /// * Tab 4: Profil (Branch 5)
  ///
  /// Volunteer tab items (volunteerDbEnabled = true):
  /// * Tab 0: Aktuelles (Branch 0)
  /// * Tab 1: Karte (Branch 1)
  /// * Tab 2: Ehrenamtsdatenbank (Branch 2)
  /// * Tab 3: Service (Branch 3)
  /// * Tab 4: Termine (Branch 4)
  int _mapBranchToTabBarIndex(int branchIndex, bool volunteerDbEnabled) {
    if (volunteerDbEnabled) {
      if (branchIndex > 4) return 0;
      return branchIndex;
    } else {
      return switch (branchIndex) {
        0 => 0,
        1 => 1,
        3 => 2,
        4 => 3,
        5 => 4,
        _ => 0,
      };
    }
  }

  /// Switches GoRouter to the shell branch corresponding to the selected bottom tab index.
  ///
  /// Maps tab selection back to the corresponding branch index:
  ///
  /// Normal mode (volunteerDbEnabled = false):
  /// * Tab 0 ➔ Branch 0 (Aktuelles)
  /// * Tab 1 ➔ Branch 1 (Karte)
  /// * Tab 2 ➔ Branch 3 (Anträge)
  /// * Tab 3 ➔ Branch 4 (Termine)
  /// * Tab 4 ➔ Branch 5 (Profil)
  ///
  /// Volunteer mode (volunteerDbEnabled = true):
  /// * Tab 0 ➔ Branch 0 (Aktuelles)
  /// * Tab 1 ➔ Branch 1 (Karte)
  /// * Tab 2 ➔ Branch 2 (Ehrenamtsdatenbank)
  /// * Tab 3 ➔ Branch 3 (Anträge)
  /// * Tab 4 ➔ Branch 4 (Termine)
  void _onTap(int tabIndex, bool volunteerDbEnabled, WidgetRef ref) {
    unawaited(ref.read(kommuneProvider.notifier).reload());
    if (volunteerDbEnabled) {
      navigationShell.goBranch(
        tabIndex,
        initialLocation: tabIndex == navigationShell.currentIndex,
      );
    } else {
      final branchIndex = switch (tabIndex) {
        0 => 0,
        1 => 1,
        2 => 3,
        3 => 4,
        4 => 5,
        _ => 0,
      };
      navigationShell.goBranch(
        branchIndex,
        initialLocation: branchIndex == navigationShell.currentIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volunteerDbEnabled = ref.watch(volunteerDatabaseEnabledProvider);
    return Scaffold(
      endDrawer: devToolsEnabled ? const MainMenuDrawer() : null,
      body: navigationShell,
      bottomNavigationBar: volunteerDbEnabled
          ? VolunteerBottomNavigationBar(
              currentIndex: _mapBranchToTabBarIndex(
                navigationShell.currentIndex,
                true,
              ),
              onTap: (index) => _onTap(index, true, ref),
            )
          : MainBottomNavigationBar(
              currentIndex: _mapBranchToTabBarIndex(
                navigationShell.currentIndex,
                false,
              ),
              onTap: (index) => _onTap(index, false, ref),
            ),
    );
  }

  /// Liefert den ScaffoldState des nächsthöheren Scaffold im Widget-Baum.
  static ScaffoldState? of(BuildContext context) {
    return context.findRootAncestorStateOfType<ScaffoldState>();
  }

  /// Öffnet den End-Drawer des nächsthöheren Scaffold im Widget-Baum.
  static void openEndDrawer(BuildContext context) {
    of(context)?.openEndDrawer();
  }
}
