import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Loading state for volunteer marketplace categories.
class CategoriesLoadingState extends StatelessWidget {
  /// Creates the category loading state.
  const CategoriesLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final loadingLabel = 'application.volunteer_database.categories_loading'
        .tr();

    return Semantics(
      liveRegion: true,
      label: loadingLabel,
      child: const ExcludeSemantics(
        child: Skeletonizer.zone(
          effect: ShimmerEffect(),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Bone(width: 64, height: 48, uniRadius: 8),
              Bone(width: 128, height: 48, uniRadius: 8),
              Bone(width: 96, height: 48, uniRadius: 8),
              Bone(width: 144, height: 48, uniRadius: 8),
              Bone(width: 112, height: 48, uniRadius: 8),
            ],
          ),
        ),
      ),
    );
  }
}
