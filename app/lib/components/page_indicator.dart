// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.pageController,
    required this.pageCount,
    super.key,
  });
  final PageController pageController;
  final int pageCount;

  static const EdgeInsets _gap = EdgeInsets.only(right: 4);
  static const double _shrunkWidth = 8;
  static const double _expandedWith = 24;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, _) {
        final page = pageController.page ?? 0.0;
        final floor = page.floor();
        final delta = page - floor;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Iterable.generate(pageCount).map((index) {
            final isLast = index == pageCount - 1;
            var progress = 0;
            if (index == floor) {
              progress = 1 - delta.toInt();
            } else if (index == floor + 1) {
              progress = delta.toInt();
            }
            return Padding(
              padding: isLast ? EdgeInsets.zero : _gap,
              child: Container(
                height: _shrunkWidth,
                width: _shrunkWidth + progress * (_expandedWith - _shrunkWidth),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: color),
                  color: color.withAlpha(progress * 255),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
