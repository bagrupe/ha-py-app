part of 'image_carousel.dart';

/// Responsible for rendering either the carousel or a placeholder
/// when no images are available.
class _CarouselContent extends StatelessWidget {
  /// Creates the carousel content widget.
  const _CarouselContent({
    required this.pageController,
    required this.items,
    required this.title,
  });

  /// Page controller used by the PageView.
  final PageController pageController;

  /// List of carousel items.
  final List<CarouselItem> items;

  /// Title passed to fullscreen view.
  final String title;

  /// Indicates whether the carousel has items.
  bool get _isEmpty => items.isEmpty;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _isEmpty
            ? _CarouselImage(imageUrl: null, title: title)
            : PageView.builder(
                controller: pageController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _CarouselImage(
                    imageUrl: items[index].image.url,
                    fallbackUrl: items[index].image.sourceUrl,
                    title: title,
                  );
                },
              ),
      ),
    );
  }
}
