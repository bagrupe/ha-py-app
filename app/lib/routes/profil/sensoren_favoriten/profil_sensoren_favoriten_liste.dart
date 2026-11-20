import 'package:app/common/sensor_favoriten.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/graphql/__generated__/sensoren.graphql.dart';
import 'package:app/routes/profil/sensoren_favoriten/components/sensor_favorite_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget zur Anzeige der Liste der favorisierten Sensoren im Profilbereich.
/// Nutzt Riverpod zur Beobachtung der Favoriten und zeigt die entsprechenden Sensordaten an.
class ProfilSensorenFavoritenListe extends ConsumerWidget {
  /// Erstellt eine Instanz von [ProfilSensorenFavoritenListe].
  const ProfilSensorenFavoritenListe({super.key});

  /// Baut das Widget mit einer Liste der favorisierten Sensoren.
  /// Nutzt [WidgetRef], um die Favoriten zu beobachten und die Sensordaten abzufragen.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final favoriten = ref.watch(sensorFavoritenProvider);

    return Scaffold(
      appBar: const CommonAppBar(title: Text('Profil'), logo: true),
      body: SingleChildScrollView(
        child: Query_ListSensoren_Widget(
          options: Options_Query_ListSensoren(
            variables: Variables_Query_ListSensoren(
              sensorIds: favoriten.favoritenIds,
            ),
          ),
          builder: (result, {refetch, fetchMore}) {
            final sensoren = result.parsedData?.sensoren.docs ?? [];

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Heading('Meine Sensoren'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Hier finden Sie alle Sensoren, die Sie als Favorit markiert haben.',
                    style: textTheme.bodySmall,
                  ),
                ),
                if (result.isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (!result.isLoading && sensoren.isEmpty)
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 52),
                          SvgPicture.asset('assets/images/empty_state.svg'),
                          const SizedBox(height: 32),
                          Text(
                            'Sie haben noch keine Sensoren zu Ihren Favoriten hinzugefügt',
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (sensoren.isNotEmpty)
                  ListView(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    children: sensoren
                        .map(
                          (f) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SensorFavoriteCard(sensor: f),
                          ),
                        )
                        .toList(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
