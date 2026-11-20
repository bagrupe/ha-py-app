import 'package:app/common/design_tokens.dart';
import 'package:app/common/kommune.dart';
import 'package:app/components/images/loading_image.dart';
import 'package:app/components/page_indicator.dart';
import 'package:app/graphql/__generated__/blocks.graphql.dart';
import 'package:app/routes/overlays/photoview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'carousel_content.dart';
part 'carousel_caption.dart';
part 'carousel_image.dart';
part 'carousel_indicator.dart';

/// Represents a single carousel item based on GraphQL fragment data.
class CarouselItem {
  const CarouselItem({required this.image, this.caption});

  final Fragment_VeranstaltungsmedienImage image;

  final String? caption;
}

/// A widget that displays a horizontal image carousel with optional pagination indicator.
///
/// If no items are provided, a placeholder image is shown.
/// Tapping on an image opens a fullscreen view.
class ImageCarousel extends StatefulWidget {
  /// Creates an image carousel.
  const ImageCarousel({required this.items, required this.title, super.key});

  /// List of images to display inside the carousel.
  final List<CarouselItem> items;

  /// Title passed to the fullscreen view.
  final String title;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

/// State class handling the page controller lifecycle.
class _ImageCarouselState extends State<ImageCarousel> {
  /// Controller used to manage and listen to page changes.
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Column(
        children: [
          Stack(
            children: [
              _CarouselContent(
                pageController: _pageController,
                items: widget.items,
                title: widget.title,
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: _CarouselCaptionButton(
                  controller: _pageController,
                  items: widget.items,
                ),
              ),
            ],
          ),
          if (widget.items.length > 1)
            _CarouselIndicator(
              controller: _pageController,
              count: widget.items.length,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
