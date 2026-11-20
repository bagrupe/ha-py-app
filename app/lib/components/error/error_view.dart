import 'package:flutter/material.dart';

/// A generic error view for pages with a retry action.
class ErrorView extends StatelessWidget {
  /// Creates a [ErrorView] with a required [onRetry] callback.
  const ErrorView({
    required this.text,
    required this.buttonText,
    required this.onRetry,
    super.key,
  });

  /// Callback to execute when the retry button is pressed.
  final VoidCallback onRetry;
  final String text;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(text, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: onRetry, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}
