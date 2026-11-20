import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Shimmer placeholder matching the full owned-request card layout.
class MyVolunteerRequestCardSkeleton extends StatelessWidget {
  /// Creates a non-interactive card loading placeholder.
  const MyVolunteerRequestCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'application.volunteer_database.my_requests.loading'.tr(),
      child: ExcludeSemantics(
        child: Skeletonizer.zone(
          effect: const ShimmerEffect(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AspectRatio(aspectRatio: 2.15, child: Bone.square()),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      Bone.text(
                        words: 6,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Row(
                        spacing: 12,
                        children: [
                          Bone.circle(size: 40),
                          Expanded(child: Bone.multiText()),
                        ],
                      ),
                      const Bone.text(words: 4),
                      const Bone.multiText(lines: 3),
                      const Center(child: Bone(width: 112, height: 24)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
