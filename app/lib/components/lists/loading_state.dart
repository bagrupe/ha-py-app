import 'package:flutter/material.dart';

/// Central widget for representing a loading process at the end of a list or initially.
class ListLoadingState extends StatelessWidget {
  const ListLoadingState({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 32),
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
