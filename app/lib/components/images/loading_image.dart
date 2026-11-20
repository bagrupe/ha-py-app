import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/kommune.dart';
import 'package:app/components/images/loading_indicator_image.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that loads an image from a URL and shows a fallback if it fails.
class LoadingImage extends ConsumerWidget {
  /// Creates a widget for loading network images.
  const LoadingImage({
    required this.imageUrl,
    this.fallbackUrl,
    this.fallbackAsset = 'assets/images/fallback_image.png',
    this.progressIndicatorBuilder,
    this.fit,
    this.height,
    this.alignment = Alignment.center,
    super.key,
  });

  /// The URL of the image to load.
  final String? imageUrl;

  /// Optional secondary URL tried if [imageUrl] fails (e.g. a thumbnail), before
  /// falling back to the CMS/asset placeholder. Useful locally when the full
  /// original is missing but the thumbnail exists.
  final String? fallbackUrl;

  /// The asset path of the local fallback image.
  final String fallbackAsset;

  /// The object fit of the image.
  final BoxFit? fit;

  /// The alignment of the image within its bounds.
  final Alignment alignment;

  /// An optional progress indicator builder.
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  /// The height to enforce for the image.
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallbackImageUrl = ref
        .watch(kommuneProvider)
        .value
        ?.design
        ?.fallbackImage
        ?.url;

    if (fallbackImageUrl == null && imageUrl == null) {
      return Image(
        image: AssetImage(fallbackAsset),
        alignment: alignment,
        fit: fit,
        height: height,
      );
    }

    // Report/idea photos are served from our own backend and may require
    // the current user's bearer token to view (e.g. own not-yet-approved
    // uploads) - attach it only for that endpoint, never for CMS media.
    final backendUrl = ref.watch(appConfigProvider).backendUrl;
    final url = imageUrl;
    final isBackendFile =
        url != null &&
        (url.startsWith('$backendUrl/api/file/') ||
            url.startsWith('$backendUrl/api/objects/'));
    final httpHeaders = isBackendFile
        ? ref.watch(fileAuthHeadersProvider)
        : null;

    return CachedNetworkImage(
      alignment: alignment,
      imageUrl: imageUrl ?? fallbackImageUrl ?? '',
      httpHeaders: httpHeaders,
      fit: fit,
      height: height,
      progressIndicatorBuilder:
          progressIndicatorBuilder ??
          (context, url, downloadProgress) => LoadingIndicatorImage(
            borderRadius: height == null
                ? null
                : const BorderRadius.all(Radius.circular(15)),
            height: height,
          ),
      errorWidget: (context, url, error) {
        final hasFallback =
            fallbackUrl != null &&
            fallbackUrl!.isNotEmpty &&
            fallbackUrl != imageUrl;
        return CachedNetworkImage(
          // 1) try the provided fallback (e.g. thumbnail), else the CMS fallback
          alignment: alignment,
          imageUrl: hasFallback ? fallbackUrl! : (fallbackImageUrl ?? ''),
          fit: fit,
          height: height,
          progressIndicatorBuilder:
              progressIndicatorBuilder ??
              (context, url, downloadProgress) => Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
              ),
          errorWidget: (context, url, error) {
            if (hasFallback) {
              // fallback (thumbnail) also failed -> CMS fallback, then asset
              return CachedNetworkImage(
                alignment: alignment,
                imageUrl: fallbackImageUrl ?? '',
                fit: fit,
                height: height,
                errorWidget: (context, url, error) => Image(
                  image: AssetImage(fallbackAsset),
                  alignment: alignment,
                  fit: fit,
                  height: height,
                ),
              );
            }
            return Image(
              //load local fallback in case of cms fallback error
              image: AssetImage(fallbackAsset),
              alignment: alignment,
              fit: fit,
              height: height,
            );
          },
        );
      },
    );
  }
}
