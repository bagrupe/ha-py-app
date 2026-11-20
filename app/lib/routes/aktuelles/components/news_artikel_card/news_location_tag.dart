import 'package:app/common/design_tokens.dart';
import 'package:app/common/util/scaler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A widget that displays a location tag with a source name.
class NewsLocationTag extends StatelessWidget {
  /// Creates a [NewsLocationTag] with the given [source].
  const NewsLocationTag({required this.source, super.key});

  /// The source text to be displayed in the tag.
  final String source;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isA11yMode = MediaQuery.textScalerOf(context).isA11yMode;
    return Semantics(
      container: true,
      label: tr(
        'application.news_location_tag.semantics.location_source',
        namedArgs: {'source': source},
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: DesignTokens.gray100,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              if (isA11yMode)
                const SizedBox.shrink()
              else
                ExcludeSemantics(
                  child: Container(
                    height: 6,
                    width: 6,
                    decoration: const BoxDecoration(
                      color: DesignTokens.gray900,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              Padding(
                padding: isA11yMode
                    ? const EdgeInsets.all(8)
                    : EdgeInsetsGeometry.zero,
                child: Text(source, style: textTheme.titleLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
