import 'package:app/routes/termine/components/termin_card/termin_card.dart';
import 'package:app/routes/termine/veranstaltungs_termin.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'WithImage', type: TerminCard)
Widget terminCardWithImage(BuildContext context) {
  final now = DateTime.now();

  final veranstaltungstermin = VeranstaltungsTermin(
    veranstaltungsId: '123456',
    start: DateTime(now.year, now.month, now.day, 14),
    end: DateTime(now.year, now.month, now.day, 16),
    titel: 'Katzen erschrecken!',
    subtitel: 'Wir legen eine Gurke hinter eine Katze und gucken was passiert.',
    imageUrl: '',
    thumbnailImageUrl:
        'https://images.pexels.com/photos/774731/pexels-photo-774731.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    termineOnSameDay: [],
  );
  return TerminCard(termin: veranstaltungstermin);
}

@UseCase(name: 'MissingImage', type: TerminCard)
Widget terminCardMissingImage(BuildContext context) {
  final now = DateTime.now();

  final veranstaltungstermin = VeranstaltungsTermin(
    veranstaltungsId: '123456',
    start: DateTime(now.year, now.month, now.day, 14),
    end: DateTime(now.year, now.month, now.day, 16),
    titel: 'Katzen erschrecken!',
    subtitel: 'Wir legen eine Gurke hinter eine Katze und gucken was passiert.',
    termineOnSameDay: [],
    imageUrl: null,
    thumbnailImageUrl: null,
  );
  return TerminCard(termin: veranstaltungstermin);
}

@UseCase(name: 'MultipleTermine', type: TerminCard)
Widget terminCardMultipleTermine(BuildContext context) {
  final now = DateTime.now();

  final veranstaltungstermin = VeranstaltungsTermin(
    veranstaltungsId: '123456',
    start: DateTime(now.year, now.month, now.day, 14),
    end: DateTime(now.year, now.month, now.day, 16),
    titel: 'Katzen erschrecken!',
    subtitel: 'Wir legen eine Gurke hinter eine Katze und gucken was passiert.',
    termineOnSameDay: [
      DateTime(now.year, now.month, now.day, 18),
      DateTime(now.year, now.month, now.day, 22),
    ],
    imageUrl: '',
    thumbnailImageUrl:
        'https://images.pexels.com/photos/774731/pexels-photo-774731.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  );
  return TerminCard(termin: veranstaltungstermin);
}
