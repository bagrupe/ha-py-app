part of 'image_carousel.dart';

/// Displays a single image inside the carousel and handles navigation
/// to the fullscreen photo view.
class _CarouselImage extends ConsumerWidget {
  /// Creates a single carousel image widget.
  const _CarouselImage({
    required this.imageUrl,
    required this.title,
    this.fallbackUrl,
  });

  /// URL of the image to display.
  final String? imageUrl;

  /// Optional fallback URL (e.g. the original `sourceUrl` from the internet),
  /// used if [imageUrl] (the CMS-served file) cannot be loaded.
  final String? fallbackUrl;

  /// Title passed to the fullscreen view.
  final String title;

  /// Navigates to the fullscreen photo view.
  /// [fallbackImageUrl] is the Kommune-wide placeholder used as a last resort,
  /// if neither [imageUrl] nor [fallbackUrl] (the item's own source) are usable.
  void _openFullscreen(BuildContext context, String? fallbackImageUrl) {
    context.push(
      '/overlays/photo-fullscreen',
      extra: FullscreenPhotoViewExtras(
        url: imageUrl,
        title: title,
        fallbackUrl: fallbackUrl ?? fallbackImageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallbackImageUrl = ref
        .watch(kommuneProvider)
        .value
        ?.design
        ?.fallbackImage
        ?.url;
    return InkWell(
      onTap: () => _openFullscreen(context, fallbackImageUrl),
      child: LoadingImage(
        imageUrl: imageUrl,
        fallbackUrl: fallbackUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
