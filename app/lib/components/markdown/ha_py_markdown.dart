import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:url_launcher/url_launcher.dart';

/// A customized Markdown widget for the app with specific styling and link handling.
class HaPyMarkdown extends StatelessWidget {
  /// Creates a [HaPyMarkdown] widget for displaying markdown content.
  const HaPyMarkdown({required this.data, super.key});

  /// The markdown string to display.
  final String data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Markdown(
      data: data,
      onTapLink: (String text, String? href, String title) async {
        if (href != null) {
          final uri = Uri.tryParse(href);
          if (uri != null && await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      bulletBuilder: (parameter) => const Icon(Icons.circle, size: 12),
      styleSheet: MarkdownStyleSheet(
        h1: textTheme.displayMedium,
        h2: textTheme.displaySmall,
        h3: textTheme.headlineMedium,
        h4: textTheme.headlineSmall,
        h5: textTheme.headlineSmall,
        h5Padding: EdgeInsets.zero,
        p: textTheme.bodySmall,
        strong: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        listBullet: textTheme.bodySmall,
      ),
    );
  }
}
