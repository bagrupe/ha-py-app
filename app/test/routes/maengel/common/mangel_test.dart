import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/maengel/common/mangel.dart';
import 'package:flutter_test/flutter_test.dart';

Fragment_PlainSlotValue _slot(String name, Object? value) =>
    Fragment_PlainSlotValue(id: 'slot-$name', slotName: name, value: value);

void main() {
  group('Mangel.fromMaengelAusfuehrung', () {
    test('reads all public slots', () {
      final mangel = Mangel.fromMaengelAusfuehrung(
        Fragment_MangelAusfuehrung(
          id: 'mangel-1',
          userId: 'user-1',
          adresse: _slot('adresse', {
            'addressString': 'Musterstraße 1, Hameln',
            'coordinates': [9.35, 52.1],
          }),
          title: _slot('titel', 'Schlagloch'),
          kategorie: _slot('kategorie', 'Straßenschäden'),
          beschreibung: _slot('beschreibung', 'Tiefes Loch'),
          status: Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_KOMMUNE,
        ),
      );

      expect(mangel.title, 'Schlagloch');
      expect(mangel.adresse, 'Musterstraße 1, Hameln');
      expect(mangel.coordinates?.latitude, 52.1);
    });

    test('tolerates every slot being null', () {
      final mangel = Mangel.fromMaengelAusfuehrung(
        Fragment_MangelAusfuehrung(
          id: 'mangel-1',
          userId: 'user-1',
          status: Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_KOMMUNE,
        ),
      );

      expect(mangel.title, 'Mangel');
      expect(mangel.kategorie, 'Mangel');
      expect(mangel.beschreibung, '');
      expect(mangel.adresse, isNull);
      expect(mangel.coordinates, isNull);
      expect(mangel.bilderSlotId, isNull);
    });
  });
}
