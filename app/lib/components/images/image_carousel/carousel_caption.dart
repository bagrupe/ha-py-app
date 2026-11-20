part of 'image_carousel.dart';

final _creditPattern = RegExp(
  r'^(.*?)\s*©\s*(?:Fotos?\s*:?\s*)?(.+)$',
  dotAll: true,
);

({String text, String? credit}) _splitCredit(String caption) {
  final match = _creditPattern.firstMatch(caption);
  if (match == null) return (text: caption, credit: null);
  return (text: match.group(1)!.trim(), credit: match.group(2)!.trim());
}

class _CarouselCaptionButton extends StatelessWidget {
  const _CarouselCaptionButton({required this.controller, required this.items});

  final PageController controller;
  final List<CarouselItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final page = controller.hasClients
            ? controller.page ?? controller.initialPage.toDouble()
            : controller.initialPage.toDouble();
        final index = page.round().clamp(0, items.length - 1);
        final caption = items[index].caption?.trim();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: caption == null || caption.isEmpty
              ? const SizedBox.shrink()
              : Tooltip(
                  key: ValueKey(index),
                  message: 'application.news.show_caption'.tr(),
                  child: Material(
                    color: Colors.white,
                    elevation: 4,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        showDragHandle: true,
                        builder: (context) => _CaptionSheet(caption: caption),
                      ),
                      child: const SizedBox.square(
                        dimension: 40,
                        child: Icon(
                          Icons.info_outline,
                          size: 24,
                          color: DesignTokens.gray900,
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _CaptionSheet extends StatelessWidget {
  const _CaptionSheet({required this.caption});

  final String caption;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final (:text, :credit) = _splitCredit(caption);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (text.isNotEmpty)
                Text(
                  text,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              if (credit != null) ...[
                if (text.isNotEmpty) const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'application.news.photo_credit'.tr(
                          namedArgs: {'name': credit},
                        ),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
