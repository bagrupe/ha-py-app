import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/iterable.dart';
import 'package:app/common/extensions/text_theme.dart';
import 'package:app/common/util/scaler.dart';
import 'package:app/common/util/share_helper.dart';
import 'package:app/components/buttons/icon_only_button.dart';
import 'package:app/components/heading/subheading.dart';
import 'package:app/components/images/image_carousel/image_carousel.dart';
import 'package:app/components/images/loading_image.dart';
import 'package:app/routes/aktuelles/common/text_sizer.dart';
import 'package:app/routes/aktuelles/components/text_sizer_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_launcher/maps_launcher.dart';

final GlobalKey _shareButtonKey = GlobalKey();

/// A detail page that displays various content such as images, titles, subtitles, dates, and sources.
/// Supports link sharing, image carousels, text scaling, and opening navigation based on coordinates.
class DetailPage extends ConsumerWidget {
  /// Creates a detail page with the specified content and optional parameters.
  const DetailPage({
    required this.title,
    required this.content,
    super.key,
    this.preTitle,
    this.imageUrl,
    this.carouselItems,
    this.tag,
    this.showTextSizer = false,
    this.dateText,
    this.subtitle,
    this.shareLink,
    this.sources,
    this.coordinates,
    this.weitereTermine = const [],
  });

  final String title;
  final Widget content;
  final String? preTitle;
  final String? imageUrl;
  final List<CarouselItem>? carouselItems;
  final Widget? tag;
  final bool showTextSizer;
  final String? dateText;
  final String? subtitle;
  final String? shareLink;
  final List<Widget>? sources;
  final List<double>? coordinates;
  final List<DateTime> weitereTermine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSizeModifier = ref.watch(textSizerProvider).textSizeModifier;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme.apply(fontSizeFactor: textSizeModifier);
    final colorTextTheme = theme.colorTextTheme.apply(
      fontSizeFactor: textSizeModifier,
    );
    final defaultTextStyle = DefaultTextStyle.of(
      context,
    ).style.apply(fontSizeFactor: textSizeModifier);
    final sources = this.sources ?? [];
    final isA11yMode = MediaQuery.textScalerOf(context).isA11yMode;

    return Theme(
      data: theme.copyWith(textTheme: textTheme),
      child: DefaultTextStyle(
        style: defaultTextStyle,
        child: ListView(
          children: [
            if (carouselItems != null && carouselItems!.isNotEmpty)
              Semantics(
                image: true,
                label: tr(
                  'application.detail_page.semantics.carousel_for',
                  namedArgs: {'title': title},
                ),
                child: ImageCarousel(items: carouselItems!, title: title),
              )
            else if (imageUrl != null)
              Semantics(
                image: true,
                label: tr(
                  'application.detail_page.semantics.title_image_for',
                  namedArgs: {'title': title},
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRect(
                    child: Transform.scale(
                      scale: 1.1,
                      child: LoadingImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (tag != null)
                          Flexible(child: tag!)
                        else if (preTitle != null)
                          Expanded(
                            child: Semantics(
                              label: tr(
                                'application.detail_page.semantics.category',
                                namedArgs: {'category': preTitle!},
                              ),
                              child: Text(
                                preTitle!,
                                style: colorTextTheme.bodySmall,
                              ),
                            ),
                          ),
                        if (showTextSizer || shareLink != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showTextSizer && !isA11yMode)
                                Semantics(
                                  button: true,
                                  label: tr(
                                    'application.detail_page.semantics.adjust_text_size',
                                  ),
                                  child: const TextSizerButton(),
                                ),
                              if (showTextSizer && shareLink != null)
                                const SizedBox(width: 8),
                              if (shareLink != null)
                                Semantics(
                                  button: true,
                                  label: tr(
                                    'application.detail_page.semantics.share_content',
                                  ),
                                  child: IconOnlyButton(
                                    key: _shareButtonKey,
                                    icon: Icons.share_outlined,
                                    onPressed: () {
                                      ShareHelper.shareContent(
                                        buttonKey: _shareButtonKey,
                                        text: shareLink,
                                        title: title,
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (dateText != null) ...[
                    Semantics(
                      label: tr(
                        'application.detail_page.semantics.date',
                        namedArgs: {'date': dateText!},
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(dateText!, style: colorTextTheme.bodySmall),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                  ],
                  Semantics(
                    header: true,
                    child: Text(title, style: textTheme.headlineMedium),
                  ),
                  const SizedBox(height: 16),
                  if (subtitle != null) ...[
                    Text(
                      subtitle!,
                      style: textTheme.bodyLarge?.copyWith(
                        color: DesignTokens.gray500,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
            content,
            if (weitereTermine.isNotEmpty) ...[
              SubHeading(
                tr('application.detail_page.further_dates_title'),
                background: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: ColoredBox(
                  color: DesignTokens.gray100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Semantics(
                      label: tr(
                        'application.detail_page.semantics.further_dates',
                        namedArgs: {
                          'dates': weitereTermine
                              .map(
                                (t) => DateFormat(
                                  "EEEE, dd.MM.yyyy, HH:mm 'Uhr'",
                                ).format(t.toLocal()),
                              )
                              .join('\n'),
                        },
                      ),
                      excludeSemantics: true,
                      child: Row(
                        children: ['EEE', 'dd.MM.yyyy', "HH:mm 'Uhr'"]
                            .map<Widget>(
                              (f) => Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: weitereTermine
                                    .map(
                                      (t) => Text(
                                        DateFormat(f).format(t.toLocal()),
                                        style: textTheme.bodyMedium,
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                            .joinWithElement(const SizedBox(width: 8)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            if (sources.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: sources.joinWithElement(const SizedBox(height: 16)),
                ),
              ),
            ],
            if (coordinates != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                  onPressed: () {
                    final lat = coordinates![0];
                    final lon = coordinates![1];
                    MapsLauncher.launchCoordinates(lat, lon);
                  },
                  child: Text(tr('application.detail_page.open_navigation')),
                ),
              ),
            ],
            // const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
