import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/volunteer_database/models/volunteer_interest_overview_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a request model for one party and backend status.
VolunteerInterestOverviewModel createInterest({
  required Enum_EhrenamtsbankAnfrageStatus status,
  required Enum_EhrenamtsbankAnfrageTyp type,
}) {
  return VolunteerInterestOverviewModel(
    id: 'interest-id',
    entryId: 'entry-id',
    entryTitle: 'Einkaufshilfe',
    entryDescription: 'Einkauf gesucht',
    plannedDurationMinutes: null,
    personName: 'Lea M.',
    status: status,
    type: type,
    createdAt: DateTime.utc(2026, 9),
  );
}

void main() {
  for (final type in [
    Enum_EhrenamtsbankAnfrageTyp.EMPFANGENE_ANFRAGE,
    Enum_EhrenamtsbankAnfrageTyp.EIGENE_ANFRAGE,
  ]) {
    test('allows $type to confirm an accepted agreement', () {
      final interest = createInterest(
        status: Enum_EhrenamtsbankAnfrageStatus.AKZEPTIERT,
        type: type,
      );

      expect(interest.canConfirmAgreement, isTrue);
    });

    test('keeps WhatsApp available for $type after confirmation', () {
      final interest = createInterest(
        status: Enum_EhrenamtsbankAnfrageStatus.VEREINBART,
        type: type,
      );

      expect(interest.canContact, isTrue);
      expect(interest.canConfirmAgreement, isFalse);
    });
  }
}
