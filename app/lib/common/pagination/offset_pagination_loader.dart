import 'dart:async';

import 'package:flutter/material.dart';

/// Loads another offset page when the enclosing scrollable nears its end.
class OffsetPaginationLoader extends StatefulWidget {
  /// Creates an automatic offset pagination loader.
  const OffsetPaginationLoader({
    required this.isLoading,
    required this.hasNextPage,
    required this.onLoadMore,
    this.loading,
    this.error,
    this.preloadExtent = 300,
    super.key,
  });

  /// Whether another page is currently loading.
  final bool isLoading;

  /// Whether another backend page is available.
  final bool hasNextPage;

  /// Callback invoked when the next page should be loaded.
  final Future<void> Function() onLoadMore;

  /// Widget displayed while another page is loading.
  final Widget? loading;

  /// Widget displayed after a next-page error.
  final Widget? error;

  /// Remaining scroll extent at which preloading begins.
  final double preloadExtent;

  @override
  State<OffsetPaginationLoader> createState() => OffsetPaginationLoaderState();
}

/// State that observes the nearest enclosing scroll position.
class OffsetPaginationLoaderState extends State<OffsetPaginationLoader> {
  ScrollPosition? _scrollPosition;
  bool _isRequestInFlight = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachToScrollPosition(Scrollable.maybeOf(context)?.position);
    _scheduleScrollCheck();
  }

  @override
  void didUpdateWidget(covariant OffsetPaginationLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleScrollCheck();
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_handleScroll);
    super.dispose();
  }

  /// Attaches the loader to [position] when the enclosing scrollable changes.
  void _attachToScrollPosition(ScrollPosition? position) {
    if (identical(_scrollPosition, position)) return;
    _scrollPosition?.removeListener(_handleScroll);
    _scrollPosition = position;
    _scrollPosition?.addListener(_handleScroll);
  }

  /// Schedules a pagination check after the current layout pass.
  void _scheduleScrollCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _handleScroll();
    });
  }

  /// Loads the next page when the viewport approaches the content boundary.
  void _handleScroll() {
    final position = _scrollPosition;
    if (position == null ||
        !position.hasContentDimensions ||
        widget.isLoading ||
        _isRequestInFlight ||
        !widget.hasNextPage ||
        widget.error != null) {
      return;
    }

    if (position.extentAfter <= widget.preloadExtent) {
      unawaited(_loadMore());
    }
  }

  /// Loads one page while preventing overlapping callback invocations.
  Future<void> _loadMore() async {
    if (_isRequestInFlight) return;
    _isRequestInFlight = true;
    try {
      await widget.onLoadMore();
    } finally {
      _isRequestInFlight = false;
      if (mounted) _scheduleScrollCheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error case final error?) return error;
    final loading = widget.loading;
    if (widget.isLoading && loading != null) return loading;
    return const SizedBox.shrink();
  }
}
