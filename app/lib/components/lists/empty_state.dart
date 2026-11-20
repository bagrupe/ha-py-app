import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Central widget to display when a list contains no entries.
class ListEmptyState extends StatelessWidget {
  const ListEmptyState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/empty_state.svg', height: 150),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
