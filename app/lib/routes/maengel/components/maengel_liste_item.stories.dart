import 'dart:typed_data';

import 'package:app/routes/maengel/common/mangel.dart';
import 'package:app/routes/maengel/components/maengel_liste_item.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'MängelListeItem', type: MaengelListeItem)
Widget maengelListeItem(BuildContext context) => FutureBuilder<Uint8List>(
  future: get(
    Uri.parse(
      'https://publicinterestnetwork.org/wp-content/uploads/2018/02/MN-dump.jpg',
    ),
  ).then((res) => res.bodyBytes),
  builder: (context, snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const SizedBox.shrink();
    }

    return MaengelListeItem(
      mangel: Mangel(
        id: 'test',
        adresse: context.knobs.stringOrNull(
          label: 'Adresse',
          initialValue: 'Teststraße 1, 12345 Testhausen',
        ),
        coordinates: const LatLng(52.0001, 10.0001),
        title: '',
        kategorie: context.knobs.object.dropdown(
          label: 'Kategorie',
          options: ['Vandalismus', 'Straßenschäden', 'Müllentsorgung'],
          initialOption: 'Müllentsorgung',
        ),
        beschreibung: '',
        bilder: [XFile.fromData(snapshot.data!)],
      ),
    );
  },
);
