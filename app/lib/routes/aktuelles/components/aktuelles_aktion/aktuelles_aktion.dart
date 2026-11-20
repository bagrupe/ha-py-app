import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Clickable action item with an icon, label and navigation target.
class AktuellesAktion extends StatelessWidget {
  /// Creates an action item with the required label, icon and link.
  const AktuellesAktion({
    required this.text,
    required this.icon,
    required this.link,
    super.key,
    this.onClick,
  });

  /// Label displayed in the action item.
  final String text;

  /// Icon displayed next to the label.
  final IconData icon;

  /// Target route used when the action is tapped.
  final String link;

  /// Optional callback executed before navigation.
  final VoidCallback? onClick;

  static const double borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: text,
      child: IntrinsicHeight(
        child: Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: DesignTokens.gray100,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    ExcludeSemantics(
                      child: Icon(icon, color: theme.primaryColor),
                    ),
                    const SizedBox(width: 16),
                    Text(text, style: theme.colorTextTheme.headlineSmall),
                    const Spacer(),
                    const ExcludeSemantics(
                      child: Icon(
                        Icons.arrow_forward,
                        color: DesignTokens.gray900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: () {
                  onClick?.call();
                  context.go(link);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
