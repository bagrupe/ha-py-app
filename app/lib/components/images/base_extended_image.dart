part of 'animated_extended_image.dart';

/// Internal base widget for image loading and gestures.
class _BaseExtendedImage extends ConsumerStatefulWidget {
  /// Creates a network image source.
  const _BaseExtendedImage.network({
    required this.url,
    required this.enableSlideOutPage,
    required this.inPageView,
  }) : isNetwork = true;

  /// Creates a local asset image source.
  const _BaseExtendedImage.asset({
    required this.enableSlideOutPage,
    required this.inPageView,
  }) : url = null,
       isNetwork = false;

  /// The image URL.
  final String? url;

  /// Whether this is a network image.
  final bool isNetwork;

  /// Whether to enable sliding out.
  final bool enableSlideOutPage;

  /// Whether we are in a page view.
  final bool inPageView;

  @override
  ConsumerState<_BaseExtendedImage> createState() => _BaseExtendedImageState();
}

class _BaseExtendedImageState extends ConsumerState<_BaseExtendedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  Animation<double>? _animation;
  VoidCallback? _animationListener;

  final List<double> _scales = [1, 2];

  late ImageSourceType _sourceType;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _sourceType = widget.isNetwork
        ? ImageSourceType.primary
        : ImageSourceType.fallbackAsset;
  }

  @override
  void dispose() {
    _animationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fallbackUrl = ref
        .watch(kommuneProvider)
        .value
        ?.design
        ?.fallbackImage
        ?.url;

    final image = _buildImage(fallbackUrl);

    return image.copyWith(
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          return const _LoadingIndicator();
        }

        if (state.extendedImageLoadState == LoadState.failed) {
          _handleFailure(fallbackUrl);
        }

        return null;
      },
      enableSlideOutPage: widget.enableSlideOutPage,
      mode: ExtendedImageMode.gesture,
      onDoubleTap: _handleDoubleTap,
      initGestureConfigHandler: _gestureConfig,
    );
  }

  ExtendedImage _buildImage(String? fallbackUrl) {
    switch (_sourceType) {
      case ImageSourceType.primary:
        return ExtendedImage.network(widget.url!);

      case ImageSourceType.fallbackNetwork:
        if (fallbackUrl != null) {
          return ExtendedImage.network(fallbackUrl);
        }
        return ExtendedImage.asset('assets/images/fallback_image.png');

      case ImageSourceType.fallbackAsset:
        return ExtendedImage.asset('assets/images/fallback_image.png');
    }
  }

  void _handleFailure(String? fallbackUrl) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_sourceType == ImageSourceType.primary && fallbackUrl != null) {
        setState(() {
          _sourceType = ImageSourceType.fallbackNetwork;
        });
        return;
      }

      if (_sourceType != ImageSourceType.fallbackAsset) {
        setState(() {
          _sourceType = ImageSourceType.fallbackAsset;
        });
      }
    });
  }

  void _handleDoubleTap(ExtendedImageGestureState state) {
    final position = state.pointerDownPosition;
    final begin = state.gestureDetails!.totalScale;

    final end = begin == _scales[0] ? _scales[1] : _scales[0];

    _animation?.removeListener(_animationListener ?? () {});
    _animationController
      ..stop()
      ..reset();

    _animation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(_animationController);

    _animationListener = () {
      state.handleDoubleTap(
        scale: _animation!.value,
        doubleTapPosition: position,
      );
    };

    _animation!.addListener(_animationListener!);

    _animationController.forward();
  }

  GestureConfig _gestureConfig(ExtendedImageState state) {
    return GestureConfig(
      minScale: 0.9,
      animationMinScale: 0.7,
      maxScale: 4,
      animationMaxScale: 4.5,
      inPageView: widget.inPageView,
      reverseMousePointerScrollDirection: true,
    );
  }
}
