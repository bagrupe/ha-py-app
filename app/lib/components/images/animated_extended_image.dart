import 'package:app/common/extensions/extended_image.dart';
import 'package:app/common/kommune.dart';
import 'package:app/components/images/image_source_type.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'animated_loading_indicator.dart';
part 'base_extended_image.dart';

/// An extended image that supports zooming and transitions between fallbacks.
class AnimatedExtendedImage extends StatelessWidget {
  /// Creates an animated extended image.
  const AnimatedExtendedImage({
    required this.url,
    required this.fallbackUrl,
    super.key,
    this.enableSlideOutPage = false,
    this.inPageView = false,
  });

  /// The primary image URL.
  final String? url;

  /// The fallback image URL.
  final String? fallbackUrl;

  /// Whether to enable sliding out of the page.
  final bool enableSlideOutPage;

  /// Whether the image is part of a [PageView].
  final bool inPageView;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      if (fallbackUrl == null) {
        return const _BaseExtendedImage.asset(
          enableSlideOutPage: false,
          inPageView: false,
        );
      }
      return _BaseExtendedImage.network(
        url: fallbackUrl,
        enableSlideOutPage: enableSlideOutPage,
        inPageView: inPageView,
      );
    }

    return _BaseExtendedImage.network(
      url: url,
      enableSlideOutPage: enableSlideOutPage,
      inPageView: inPageView,
    );
  }
}
