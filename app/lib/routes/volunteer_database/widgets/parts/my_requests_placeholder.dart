part of '../my_volunteer_requests_list.dart';

/// Keeps empty, loading and error states scrollable for pull-to-refresh.
class _MyRequestsPlaceholder extends StatelessWidget {
  /// Creates a centered placeholder within the available viewport.
  const _MyRequestsPlaceholder({required this.child});

  /// Content displayed in the viewport.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(hasScrollBody: false, child: Center(child: child)),
      ],
    );
  }
}
