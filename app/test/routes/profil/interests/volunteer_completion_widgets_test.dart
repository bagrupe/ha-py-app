import 'package:app/routes/profil/interests/volunteer_completion_date_field.dart';
import 'package:app/routes/profil/interests/volunteer_completion_form.dart';
import 'package:app/routes/profil/interests/volunteer_completion_proposal_view.dart';
import 'package:app/routes/profil/interests/volunteer_completion_success_view.dart';
import 'package:app/routes/volunteer_database/models/volunteer_completion_proposal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper/localization_helper.dart';

/// Renders a scrollable completion widget for tests.
Future<void> pumpCompletionWidget(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
}

/// Verifies completion proposal, form and success states.
void main() {
  setUpAll(TestLocalizationHelper.init);

  final proposal = VolunteerCompletionProposalModel(
    minutes: 135,
    performedOn: DateTime(2026, 8, 31),
    proposedById: 'other-user-id',
    note: 'Alles erledigt.',
  );

  testWidgets('shows confirm and adjust actions for a counterparty proposal', (
    tester,
  ) async {
    var confirmCount = 0;
    var adjustCount = 0;
    await pumpCompletionWidget(
      tester,
      VolunteerCompletionProposalView(
        proposal: proposal,
        isOwnProposal: false,
        isLoading: false,
        onConfirm: () => confirmCount += 1,
        onAdjust: () => adjustCount += 1,
      ),
    );

    expect(find.text('2:15 Std.'), findsOneWidget);
    expect(find.text('Alles erledigt.'), findsOneWidget);
    expect(find.text('Bestätigen und abschließen'), findsOneWidget);
    expect(find.text('Anpassen'), findsOneWidget);

    await tester.tap(find.text('Bestätigen und abschließen'));
    await tester.tap(find.text('Anpassen'));

    expect(confirmCount, 1);
    expect(adjustCount, 1);
  });

  testWidgets('shows a waiting state for the proposing party', (tester) async {
    await pumpCompletionWidget(
      tester,
      VolunteerCompletionProposalView(
        proposal: proposal,
        isOwnProposal: true,
        isLoading: false,
        onConfirm: () {},
        onAdjust: () {},
      ),
    );

    expect(find.textContaining('Gegenpartei'), findsOneWidget);
    expect(find.text('Bestätigen und abschließen'), findsNothing);
    expect(find.text('Anpassen'), findsNothing);
  });

  testWidgets('starts from planned duration and submits a stepped adjustment', (
    tester,
  ) async {
    int? submittedMinutes;
    DateTime? submittedDate;
    String? submittedNote;
    await pumpCompletionWidget(
      tester,
      VolunteerCompletionForm(
        interestId: 'interest-id',
        initialMinutes: 120,
        initialDate: DateTime(2026, 8, 31),
        submitLabel: 'Einsatz abschließen und Zeit buchen',
        isLoading: false,
        onSubmit:
            ({required minutes, required performedOn, required note}) async {
              submittedMinutes = minutes;
              submittedDate = performedOn;
              submittedNote = note;
            },
      ),
    );

    expect(find.text('2:00 Std.', findRichText: true), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.enterText(find.byType(TextFormField), ' Alles erledigt. ');
    await tester.pump();
    await tester.tap(find.text('Einsatz abschließen und Zeit buchen'));

    expect(submittedMinutes, 135);
    expect(submittedDate, DateTime(2026, 8, 31));
    expect(submittedNote, 'Alles erledigt.');
  });

  testWidgets('announces the booked duration after mutual confirmation', (
    tester,
  ) async {
    await pumpCompletionWidget(
      tester,
      const VolunteerCompletionSuccessView(minutes: 135, isDebit: false),
    );

    expect(
      find.text(
        'Vorgang abgeschlossen: 2:15 Stunden wurden Deinem Zeitkonto gutgeschrieben.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('announces the deducted duration after mutual confirmation', (
    tester,
  ) async {
    await pumpCompletionWidget(
      tester,
      const VolunteerCompletionSuccessView(minutes: 135, isDebit: true),
    );

    expect(
      find.text(
        'Vorgang abgeschlossen: 2:15 Stunden wurden von Deinem Zeitkonto abgezogen.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('styles and formats the completion date field', (tester) async {
    await pumpCompletionWidget(
      tester,
      VolunteerCompletionDateField(value: DateTime(2000), onChanged: (_) {}),
    );

    final context = tester.element(find.byType(VolunteerCompletionDateField));
    final theme = Theme.of(context);
    final dateText = tester.widget<Text>(find.text('01.01.2000'));
    final calendarIcon = tester.widget<Icon>(
      find.byIcon(Icons.calendar_month_outlined),
    );
    final decorator = tester.widget<InputDecorator>(
      find.byType(InputDecorator),
    );
    final border = decorator.decoration.enabledBorder! as OutlineInputBorder;

    expect(dateText.style, theme.textTheme.bodySmall);
    expect(calendarIcon.color, theme.colorScheme.primary);
    expect(border.borderSide.color, theme.colorScheme.outline);
  });
}
