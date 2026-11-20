import 'package:app/components/html_rich_text.dart';
import 'package:app/components/images/loading_image.dart';
import 'package:app/graphql/__generated__/blocks.graphql.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that decides which specific content block widget to render.
class ContentBlockRenderer extends StatelessWidget {
  /// Creates a renderer for a given content [block].
  const ContentBlockRenderer({required this.block, super.key});

  /// The block data from the backend.
  final dynamic block;

  @override
  Widget build(BuildContext context) {
    final currentBlock = block;

    if (currentBlock is Fragment_RichTextBlock) {
      return _RichTextBlock(block: currentBlock);
    }

    if (currentBlock is Fragment_ImageBlockVeranstaltungsmedien ||
        currentBlock is Fragment_ImageBlockMedien) {
      return _ImageBlock(block: currentBlock);
    }

    if (kDebugMode) {
      return _UnknownBlockDebug(type: currentBlock.runtimeType.toString());
    }

    return const SizedBox.shrink();
  }
}

/// Private widget for rendering RichText content.
class _RichTextBlock extends StatelessWidget {
  const _RichTextBlock({required this.block});

  final Fragment_RichTextBlock block;

  @override
  Widget build(BuildContext context) {
    final html = block.contentHtml;
    if (html == null || html.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: HtmlRichText(html: html),
    );
  }
}

/// Private widget for rendering Image blocks with a fixed AspectRatio
/// to prevent layout exceptions.
class _ImageBlock extends StatelessWidget {
  const _ImageBlock({required this.block});

  final dynamic block;

  @override
  Widget build(BuildContext context) {
    String? url;
    final tempBlock = block;
    if (tempBlock is Fragment_ImageBlockVeranstaltungsmedien) {
      url = tempBlock.image?.url;
    } else if (tempBlock is Fragment_ImageBlockMedien) {
      url = tempBlock.image?.url;
    }
    if (url == null) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: LoadingImage(imageUrl: url, fit: BoxFit.contain),
    );
  }
}

/// debug widget to visualize unhandled block types.
class _UnknownBlockDebug extends StatelessWidget {
  const _UnknownBlockDebug({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      color: Colors.orange.withValues(alpha: 0.1),
      child: Text(
        '<Unknown block: $type>',
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
