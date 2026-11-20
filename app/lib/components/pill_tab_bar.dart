import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

/// Ein Tab-Bar-Widget in Pillenform, das eine horizontale Liste von Tabs mit Animation und Scrollbarkeit anzeigt.
class PillTabBar extends StatefulWidget {
  const PillTabBar({required this.controller, required this.tabs, super.key});

  /// Der TabController, der die Steuerung der Tabs übernimmt.
  final TabController controller;

  /// Die Liste der Tabs, die angezeigt werden sollen.
  final List<PillTabInfo> tabs;

  @override
  State<PillTabBar> createState() => _PillTabBarState();
}

class _PillTabBarState extends State<PillTabBar> {
  late ScrollController _scrollController;
  List<GlobalKey> _pillKeys = [];
  int _currentIndex = 0;

  @override
  void initState() {
    widget.controller.animation?.addListener(handleTick);
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.animation?.removeListener(handleTick);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pillKeys = widget.tabs.map((_) => GlobalKey()).toList();
    return AnimatedBuilder(
      animation: widget.controller.animation!,
      builder: (context, _) {
        final value = widget.controller.animation!.value;
        final floor = value.floor();
        final delta = (value - floor).toInt();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 20),
                ...widget.tabs.indexed.expand((item) {
                  final (index, tab) = item;
                  var progress = 0;
                  if (index == floor) {
                    progress = 1 - delta;
                  } else if (index == floor + 1) {
                    progress = delta;
                  }
                  return [
                    Pill(
                      index: index,
                      label: tab.label,
                      badgeCount: tab.badgeCount,
                      active: progress.toDouble(),
                      onTap: handleTap,
                      key: _pillKeys[index],
                    ),
                    if (index < widget.tabs.length - 1)
                      const SizedBox(width: 10),
                  ];
                }),
                const SizedBox(width: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Reagiert auf Tab-Auswahl und wechselt zum entsprechenden Tab.
  void handleTap(int i) {
    widget.controller.animateTo(i);
  }

  /// Aktualisiert die Sichtbarkeit des aktiven Tabs beim Animationsfortschritt.
  void handleTick() {
    final index = widget.controller.animation!.value.round();

    if (index == _currentIndex) return;
    _currentIndex = index;

    // Ensure that the pill which corresponds to the currently active tab is
    // always visible.

    if (index == 0) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      return;
    }

    final targetContext = _pillKeys[index].currentContext;

    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }
}

/// Enthält die Informationen eines einzelnen Tabs in der PillTabBar.
class PillTabInfo {
  PillTabInfo({required this.label, this.badgeCount});

  /// Die Beschriftung des Tabs.
  final String label;

  /// Optional die Anzahl eines Badges, das am Tab angezeigt wird.
  final int? badgeCount;
}

/// Ein einzelnes Pillen-Tab-Widget mit Label, optionalem Badge und Aktivitätsanzeige.
class Pill extends StatelessWidget {
  const Pill({
    required this.index,
    required this.label,
    required this.onTap,
    super.key,
    this.badgeCount,
    this.active = 0.0,
  });

  /// Der Index des Tabs.
  final int index;

  /// Die Anzahl des Badges, falls vorhanden.
  final int? badgeCount;

  /// Der Aktivitätswert zwischen 0.0 und 1.0 für Farbinterpolation.
  final double active;

  /// Die Beschriftung des Tabs.
  final String label;

  /// Callback, der bei Tap auf das Tab mit dem Index aufgerufen wird.
  final void Function(int i) onTap;

  @override
  Widget build(BuildContext context) {
    final badgeCount = this.badgeCount ?? 0;
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Color.lerp(DesignTokens.gray100, DesignTokens.green200, active),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onTap(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Center(
            child: Row(
              children: [
                Text(label, style: const TextStyle(fontSize: 16)),
                if (badgeCount > 0) ...[
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 18),
                    child: Container(
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Color.lerp(
                          DesignTokens.green200,
                          DesignTokens.white,
                          active,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            badgeCount.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: DesignTokens.green500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
