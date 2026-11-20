import 'dart:async';

import 'package:app/components/heading/heading.dart';
import 'package:app/routes/maengel/common/mangel.dart';
import 'package:app/routes/maengel/components/maengel_animated_item.dart';
import 'package:flutter/material.dart';

/// Duration of the insert and remove animation of a list entry.
const maengelSectionAnimationDuration = Duration(milliseconds: 300);

/// Sliver section with a heading whose entries animate in and out.
class MaengelAnimatedSection extends StatefulWidget {
  const MaengelAnimatedSection({
    required this.title,
    required this.maengel,
    super.key,
  });

  /// Heading of the section, hidden while the section is empty.
  final String title;

  /// Current Mängel; differences to the previous list are animated.
  final List<Mangel> maengel;

  @override
  State<MaengelAnimatedSection> createState() => _MaengelAnimatedSectionState();
}

class _MaengelAnimatedSectionState extends State<MaengelAnimatedSection> {
  final _listKey = GlobalKey<SliverAnimatedListState>();
  late List<Mangel> _items = List.of(widget.maengel);

  /// Entries still animating out; they keep the heading visible.
  var _removing = 0;

  @override
  void didUpdateWidget(MaengelAnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newItems = widget.maengel;
    final newIds = newItems.map((m) => m.id).toSet();
    final list = _listKey.currentState;

    for (var i = _items.length - 1; i >= 0; i--) {
      if (newIds.contains(_items[i].id)) continue;

      final removed = _items.removeAt(i);
      list?.removeItem(
        i,
        (_, animation) =>
            MaengelAnimatedItem(mangel: removed, animation: animation),
      );
      _removing++;
      unawaited(
        Future<void>.delayed(maengelSectionAnimationDuration, () {
          if (mounted) setState(() => _removing--);
        }),
      );
    }

    final currentIds = _items.map((m) => m.id).toSet();
    for (var i = 0; i < newItems.length; i++) {
      if (currentIds.contains(newItems[i].id)) continue;

      _items.insert(i, newItems[i]);
      list?.insertItem(i);
    }

    _items = List.of(newItems);
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        if (_items.isNotEmpty || _removing > 0)
          SliverToBoxAdapter(
            child: Heading(widget.title, horizontalPadding: false),
          ),
        SliverAnimatedList(
          key: _listKey,
          initialItemCount: _items.length,
          itemBuilder: (_, index, animation) =>
              MaengelAnimatedItem(mangel: _items[index], animation: animation),
        ),
      ],
    );
  }
}
