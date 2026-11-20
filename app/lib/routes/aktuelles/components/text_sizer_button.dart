import 'package:app/common/design_tokens.dart';
import 'package:app/routes/aktuelles/common/text_sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

/// Ein Button, der die Textgröße in der App erhöht.
/// Nutzt einen Riverpod-Notifier, um die Textgröße zu steuern.
class TextSizerButton extends ConsumerWidget {
  const TextSizerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizerNotifier = ref.watch(textSizerProvider.notifier);

    return IconButton(
      padding: const EdgeInsets.all(8),
      splashRadius: 28,
      onPressed: sizerNotifier.bumpTextSize,
      iconSize: 28,
      icon: const Icon(
        Symbols.match_case,
        color: DesignTokens.gray900,
        weight: 900,
      ),
    );
  }
}
