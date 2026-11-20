import 'package:app/components/markdown/ha_py_markdown.dart';
import 'package:flutter/material.dart';

/// A generic view for displaying markdown content with CircularProgressIndicator as loading indication (e.g., privacy policy, error notice).
class MarkdownView extends StatelessWidget {
  /// Creates a [MarkdownView] that loads markdown from the given [assetPath].
  const MarkdownView({required this.assetPath, super.key});

  /// The path to the markdown asset to load.
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString(assetPath),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return HaPyMarkdown(data: snapshot.data!);
      },
    );
  }
}
