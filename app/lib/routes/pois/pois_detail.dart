import 'package:app/common/design_tokens.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/detail_page/detail_page.dart';
import 'package:app/components/detail_page/parts/content_block_renderer.dart';
import 'package:app/components/heading/subheading.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/graphql/__generated__/pois.graphql.dart';
import 'package:app/routes/pois/components/poi_additional_information_detail.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart' show ErrorPolicy, FetchPolicy;

/// Seite zur Anzeige der Detailinformationen eines Points of Interest (POI).
class PoisDetailPage extends StatelessWidget {
  /// Erstellt eine Detailseite für einen POI mit der angegebenen ID.
  const PoisDetailPage({required this.id, super.key});

  /// Die ID des anzuzeigenden POI.
  final String id;

  @override
  Widget build(BuildContext context) {
    return Query_Poi_Widget(
      options: Options_Query_Poi(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        errorPolicy: ErrorPolicy.all,
        variables: Variables_Query_Poi(id: id),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException && result.parsedData == null) {
          return Scaffold(
            appBar: const CommonAppBar(title: Text('Point of Interest')),
            body: ListErrorState(
              message: 'application.error.offline_no_cache'.tr(),
              onRetry: refetch,
            ),
          );
        }

        final poi = result.parsedData?.poi;
        final titel = poi?.title ?? 'Lade...';

        String? imageUrl;

        if (poi?.image != null) {
          imageUrl = poi!.image!.$external != null && poi.image!.$external!
              ? poi.image!.url
              : poi.image!.internal?.url;
        }

        return Scaffold(
          appBar: CommonAppBar(title: Text(titel)),
          body: Builder(
            builder: (context) {
              if (poi == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return DetailPage(
                imageUrl: imageUrl,
                preTitle: 'Point of Interest',
                title: poi.title,
                subtitle: poi.positionString,
                content: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...(poi.contents ?? []).map(
                        (e) => ContentBlockRenderer(block: e),
                      ),
                      ..._weitereInformationen(poi.additionalInformation ?? []),
                    ],
                  ),
                ),
                coordinates: poi.position,
              );
            },
          ),
        );
      },
    );
  }

  /// Erzeugt eine Liste von Widgets für zusätzliche Informationen eines POI.
  ///
  /// [additionalInformation] enthält die zusätzlichen Informationsdaten.
  static List<Widget> _weitereInformationen(
    List<Query_Poi_poi_additionalInformation> additionalInformation,
  ) {
    final List<Widget> widgets = additionalInformation
        .map(
          (information) =>
              PoiAdditionalInformationDisplay(information: information),
        )
        .toList();

    final section = widgets.isNotEmpty
        ? [
            const SizedBox(height: 20),
            const SubHeading('Weitere Informationen', background: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ColoredBox(
                color: DesignTokens.gray100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widgets,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ]
        : <Widget>[];

    return section;
  }
}
