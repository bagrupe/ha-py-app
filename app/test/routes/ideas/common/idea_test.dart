import 'package:app/graphql/__generated__/idee.graphql.dart';
import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/ideas/common/idea.dart';
import 'package:flutter_test/flutter_test.dart';

Fragment_IdeeAusfuehrung _ausfuehrung({
  required String id,
  Fragment_PlainSlotValue? adresse,
  Fragment_PlainSlotValue? title,
  Fragment_PlainSlotValue? beschreibung,
  Fragment_IdeeAusfuehrung_bilder? bilder,
  String prozessName = 'Ideenmelder',
}) {
  return Fragment_IdeeAusfuehrung(
    id: id,
    userId: 'user-1',
    adresse: adresse,
    title: title,
    beschreibung: beschreibung,
    bilder: bilder,
    status: Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_KOMMUNE,
    prozessVersion: Fragment_IdeeAusfuehrung_prozessVersion(
      prozess: Fragment_IdeeAusfuehrung_prozessVersion_prozess(
        name: prozessName,
      ),
    ),
  );
}

void main() {
  group('Idea.fromIdeeSummary', () {
    test('parses address and coordinates when the slot is present', () {
      final ausfuehrung = _ausfuehrung(
        id: 'idee-1',
        adresse: Fragment_PlainSlotValue(
          id: 'slot-1',
          slotName: 'adresse',
          value: {
            'addressString': 'Musterstraße 1, Hameln',
            'coordinates': [9.35, 52.1],
          },
        ),
        title: Fragment_PlainSlotValue(
          id: 'slot-2',
          slotName: 'titel',
          value: 'Mehr Bänke am Ufer',
        ),
        beschreibung: Fragment_PlainSlotValue(
          id: 'slot-3',
          slotName: 'beschreibung',
          value: 'Es fehlen Sitzgelegenheiten.',
        ),
      );

      final idea = Idea.fromIdeeSummary(ausfuehrung);

      expect(idea.id, 'idee-1');
      expect(idea.address, 'Musterstraße 1, Hameln');
      expect(idea.coordinates?.latitude, 52.1);
      expect(idea.coordinates?.longitude, 9.35);
      expect(idea.title, 'Mehr Bänke am Ufer');
      expect(idea.description, 'Es fehlen Sitzgelegenheiten.');
    });

    test('falls back to the process name and (0, 0) coordinates instead of '
        'throwing when title/address slots are missing', () {
      final ausfuehrung = _ausfuehrung(id: 'idee-2');

      final idea = Idea.fromIdeeSummary(ausfuehrung);

      expect(idea.address, isNull);
      expect(idea.coordinates?.latitude, 0);
      expect(idea.coordinates?.longitude, 0);
      expect(idea.title, 'Ideenmelder');
      expect(idea.description, isNull);
    });

    test('falls back gracefully when the address slot has no value', () {
      final ausfuehrung = _ausfuehrung(
        id: 'idee-3',
        adresse: Fragment_PlainSlotValue(
          id: 'slot-1',
          slotName: 'adresse',
          value: null,
        ),
      );

      final idea = Idea.fromIdeeSummary(ausfuehrung);

      expect(idea.address, isNull);
      expect(idea.coordinates?.latitude, 0);
      expect(idea.coordinates?.longitude, 0);
    });

    test('ignores an address slot that holds plain text', () {
      final ausfuehrung = _ausfuehrung(
        id: 'idee-5',
        adresse: Fragment_PlainSlotValue(
          id: 'slot-1',
          slotName: 'adresse',
          value: 'Brünnerstraße 16',
        ),
      );

      final idea = Idea.fromIdeeSummary(ausfuehrung);

      expect(idea.address, isNull);
      expect(idea.coordinates?.latitude, 0);
      expect(idea.coordinates?.longitude, 0);
    });

    test('builds the image from the bilder slot id', () {
      final ausfuehrung = _ausfuehrung(
        id: 'idee-4',
        bilder: Fragment_IdeeAusfuehrung_bilder(
          id: 'file-1',
          slotName: 'bilder',
          slotValueCount: 1,
        ),
      );

      final idea = Idea.fromIdeeSummary(ausfuehrung);

      expect(idea.image?.fileId, 'file-1');
    });
  });
}
