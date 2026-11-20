import 'package:app/routes/maengel/common/mangel.dart';
import 'package:app/routes/maengel/components/maengel_liste_item.dart';
import 'package:flutter/material.dart';

/// List entry that fades and collapses with the given [animation].
class MaengelAnimatedItem extends StatelessWidget {
  const MaengelAnimatedItem({
    required this.mangel,
    required this.animation,
    super.key,
  });

  /// Mangel shown in this entry.
  final Mangel mangel;

  /// Drives the fade and the collapse of the entry.
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: MaengelListeItem(mangel: mangel),
      ),
    );
  }
}
