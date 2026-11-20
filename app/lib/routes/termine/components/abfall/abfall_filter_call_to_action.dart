import 'package:app/common/design_tokens.dart';
import 'package:flutter/material.dart';

/// Widget, das einen Call-to-Action für den Abfallfilter anzeigt.
/// Zeigt einen Hinweistext mit Icon und reagiert auf Tap-Ereignisse.
class AbfallFilterCTA extends StatelessWidget {
  /// Erstellt eine Instanz des AbfallFilterCTA mit einem optionalen Tap-Handler.
  const AbfallFilterCTA({required this.onTap, super.key});

  /// Callback, der beim Tippen auf das Widget ausgeführt wird.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: DesignTokens.gray100,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outlined,
                        color: DesignTokens.orange500,
                        size: 12,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Hinweis',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: DesignTokens.orange500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Individuelle Abfuhrtermine für Ihre Straße, bequem in der App!',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: DesignTokens.gray500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
