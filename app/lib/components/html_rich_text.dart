import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Displays CMS-generated HTML content with app-specific rich text styling.
class HtmlRichText extends StatelessWidget {
  /// Creates an HTML rich text widget.
  ///
  /// The [html] value is rendered as rich text and [textSizeModifier] can be
  /// used to scale the displayed text.
  const HtmlRichText({
    required this.html,
    super.key,
    this.textSizeModifier = 1,
  });

  /// The HTML string that should be rendered.
  final String html;

  /// The factor used to scale the font size of the rendered text.
  final double textSizeModifier;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final defaultTextStyle = DefaultTextStyle.of(context).style;
    final defaultColor = defaultTextStyle.color;

    return HtmlWidget(
      html,
      textStyle: defaultTextStyle.apply(fontSizeFactor: textSizeModifier),
      customStylesBuilder: (element) {
        final localName = element.localName;

        final headingStyle = switch (localName) {
          'h1' => textTheme.headlineMedium,
          'h2' => textTheme.headlineSmall,
          'h3' || 'h4' || 'h5' || 'h6' => textTheme.titleLarge,
          _ => null,
        };

        if (headingStyle != null) {
          return {
            'margin': '0 0 8px 0',
            'padding': '0',
            if (headingStyle.fontSize != null)
              'font-size': '${headingStyle.fontSize! * textSizeModifier}px',
            if (headingStyle.fontWeight != null)
              'font-weight': '${headingStyle.fontWeight!.value}',
            if (headingStyle.fontStyle != null)
              'font-style': headingStyle.fontStyle == FontStyle.italic
                  ? 'italic'
                  : 'normal',
            if (headingStyle.color != null)
              'color': _colorToCss(headingStyle.color!),
          };
        }

        return switch (localName) {
          'p' => {'margin': '0 0 8px 0', 'padding': '0'},
          'ul' || 'ol' => {'margin': '0 0 8px 0', 'padding-left': '0'},
          'li' => {'margin': '0', 'padding-left': '8px'},
          'a' => {
            'color': defaultColor == null
                ? 'inherit'
                : _colorToCss(defaultColor),
            'text-decoration': 'underline',
          },
          _ => null,
        };
      },
      onTapUrl: (url) {
        launchUrlString(url, mode: LaunchMode.externalApplication);
        return true;
      },
    );
  }

  String _colorToCss(Color color) {
    final red = (color.r * 255).round();
    final green = (color.g * 255).round();
    final blue = (color.b * 255).round();
    final alpha = color.a;

    if (alpha >= 1) {
      return 'rgb($red, $green, $blue)';
    }

    return 'rgba($red, $green, $blue, $alpha)';
  }
}
