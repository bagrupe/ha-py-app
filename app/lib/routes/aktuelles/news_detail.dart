import 'package:app/common/kommune.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/detail_page/detail_page.dart';
import 'package:app/components/detail_page/parts/content_block_renderer.dart';
import 'package:app/components/images/image_carousel/image_carousel.dart';
import 'package:app/graphql/__generated__/news.graphql.dart';
import 'package:app/routes/aktuelles/components/news_artikel_card/news_artikel_card.dart';
import 'package:app/routes/aktuelles/components/news_artikel_card/news_location_tag.dart';
import 'package:app/routes/aktuelles/components/original_article_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seite zur Anzeige der Detailansicht eines News-Artikels anhand der ID.
class NewsDetailPage extends ConsumerWidget {
  /// Erstellt eine Instanz von NewsDetailPage mit der angegebenen Artikel-ID.
  const NewsDetailPage({required this.id, super.key});

  /// Die ID des anzuzeigenden News-Artikels.
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kommuneName = ref.watch(kommuneProvider).requireValue.name;

    return Query_NewsArtikel_Widget(
      options: Options_Query_NewsArtikel(
        variables: Variables_Query_NewsArtikel(id: id),
      ),
      builder: (result, {fetchMore, refetch}) {
        final artikel = result.parsedData?.newsArtikel;
        final titel = artikel?.titel ?? 'Lade...';
        return Scaffold(
          appBar: CommonAppBar(title: Text(titel)),
          body: Builder(
            builder: (context) {
              if (artikel == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final content =
                  artikel.inhalte ?? <Fragment_NewsArtikel_inhalte>[];
              final carouselItems = <CarouselItem>[];
              if (artikel.titelbilder != null) {
                for (final titleImage in artikel.titelbilder!) {
                  final image = titleImage.bild;
                  if (image != null) {
                    carouselItems.add(
                      CarouselItem(
                        image: image,
                        caption: titleImage.bildunterschrift,
                      ),
                    );
                  }
                }
              }

              return DetailPage(
                title: artikel.titel!,
                carouselItems: carouselItems,
                tag: NewsLocationTag(
                  source: artikel.untereinheit?.name ?? kommuneName,
                ),
                showTextSizer: true,
                dateText: dateFormat.format(artikel.datum!),
                subtitle: artikel.teaser,
                content: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...content.map((e) => ContentBlockRenderer(block: e)),
                      if (artikel.originalUrl case final originalUrl?) ...[
                        const SizedBox(height: 16),
                        OriginalArticleButton(url: originalUrl),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
