import 'package:app/common/ausfuehrungen_provider.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/pill_tab_bar.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/routes/antraege/antrag_detail.dart';
import 'package:app/routes/antraege/antrag_select.dart';
import 'package:app/routes/antraege/antrag_subgroup_select.dart';
import 'package:app/routes/antraege/common/antrag_schritte.dart';
import 'package:app/routes/antraege/laufende_antraege.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Haupt-Widget zur Darstellung der Antragsübersicht mit Tab-Navigation.
/// Zeigt Tabs für neue Anträge und laufende Anträge an.
class Antraege extends ConsumerStatefulWidget {
  const Antraege({super.key});

  @override
  ConsumerState<Antraege> createState() => _AntraegeState();
}

/// State-Klasse für das Antraege-Widget mit TabController für die Tab-Navigation.
class _AntraegeState extends ConsumerState<Antraege>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counts = ref.watch(ausfuehrungenCountProvider);
    return Scaffold(
      appBar: const CommonAppBar(title: Text('Service')),
      body: Column(
        children: [
          const SizedBox(height: 22),
          PillTabBar(
            controller: _tabController,
            tabs: [
              PillTabInfo(label: 'Neuer Antrag'),
              PillTabInfo(label: 'Laufend', badgeCount: counts.laufend),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [AntragSelect(), LaufendeAntraege()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Definition der Routen für den Bereich "Anträge" mit zugehörigen Unterrouten.
final antraegeRoute = GoRoute(
  path: '/antraege',
  pageBuilder: TransitionPageBuilders.noTransition(
    builder: (_, __) => const Antraege(),
  ),
  routes: [
    GoRoute(
      path: 'detail/:id',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, state) =>
            AntragDetailPage(id: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: 'schritt',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, __) => const AntragSchritte(),
      ),
    ),
    GoRoute(
      path: 'antrag-subgroup-select',
      pageBuilder: TransitionPageBuilders.sliding(
        builder: (_, state) {
          final obj = state.extra! as AntragSubGroupSelectProps;
          return AntragSubgroupSelect(prozesse: obj.$2, gruppenName: obj.$1);
        },
      ),
    ),
  ],
);
