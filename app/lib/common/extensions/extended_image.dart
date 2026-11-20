import 'package:extended_image/extended_image.dart';

/// Extension for adding [copyWith] to [ExtendedImage].
extension ExtendedImageCopyWith on ExtendedImage {
  /// Creates a copy of this image with some properties overridden.
  ExtendedImage copyWith({
    LoadStateChanged? loadStateChanged,
    bool? enableSlideOutPage,
    ExtendedImageMode? mode,
    void Function(ExtendedImageGestureState)? onDoubleTap,
    InitGestureConfigHandler? initGestureConfigHandler,
  }) {
    if (image is ExtendedNetworkImageProvider) {
      final provider = image as ExtendedNetworkImageProvider;

      return ExtendedImage.network(
        provider.url,
        cache: provider.cache,
        headers: provider.headers,
        cacheKey: provider.cacheKey,
        loadStateChanged: loadStateChanged,
        enableSlideOutPage: enableSlideOutPage ?? this.enableSlideOutPage,
        mode: mode ?? this.mode,
        onDoubleTap: onDoubleTap,
        initGestureConfigHandler: initGestureConfigHandler,
      );
    }

    if (image is ExtendedAssetImageProvider) {
      final provider = image as ExtendedAssetImageProvider;

      return ExtendedImage.asset(
        provider.assetName,
        bundle: provider.bundle,
        enableLoadState: true,
        loadStateChanged: loadStateChanged,
        enableSlideOutPage: enableSlideOutPage ?? this.enableSlideOutPage,
        mode: mode ?? this.mode,
        onDoubleTap: onDoubleTap,
        initGestureConfigHandler: initGestureConfigHandler,
      );
    }

    return this;
  }
}
