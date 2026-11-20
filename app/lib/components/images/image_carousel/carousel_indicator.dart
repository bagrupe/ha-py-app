part of 'image_carousel.dart';

/// Displays a page indicator for the carousel when multiple images exist.
class _CarouselIndicator extends StatelessWidget {
  /// Creates a carousel indicator widget.
  const _CarouselIndicator({required this.controller, required this.count});

  /// Controller linked to the PageView.
  final PageController controller;

  /// Total number of pages.
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: PageIndicator(pageController: controller, pageCount: count),
      ),
    );
  }
}
