import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A skeletonized loading indicator used for images.
class LoadingIndicatorImage extends StatelessWidget {
  /// Creates a new loading indicator.
  const LoadingIndicatorImage({this.height, this.borderRadius, super.key});

  /// The height of the loading indicator.
  final double? height;

  /// The border radius of the loading indicator.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      effect: const ShimmerEffect(),
      enableSwitchAnimation: true,
      child: Bone.square(
        size: height ?? double.infinity,
        borderRadius: borderRadius,
      ),
    );
  }
}
