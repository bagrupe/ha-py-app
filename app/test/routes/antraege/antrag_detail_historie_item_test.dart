import 'package:app/graphql/__generated__/ausfuehrung.graphql.dart';
import 'package:app/routes/antraege/components/antrag_detail_historie_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Query_AusfuehrungHistorie_ausfuehrung_historie createEntry({String? message}) {
  return Query_AusfuehrungHistorie_ausfuehrung_historie(
    id: 'historie-1',
    createdAt: DateTime.utc(2026, 10, 1, 10),
    statusAenderung: 'Approved',
    statusAenderungBeschreibung: 'Your application was approved.',
    nachricht: message,
  );
}

Future<void> pumpEntry(
  WidgetTester tester,
  Query_AusfuehrungHistorie_ausfuehrung_historie entry,
) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: AntragDetailHistorieItem(historiePoint: entry)),
    ),
  );
}

void main() {
  testWidgets('shows the message below the status description', (tester) async {
    await pumpEntry(tester, createEntry(message: 'Please submit documents.'));

    expect(find.text('Your application was approved.'), findsOneWidget);
    expect(find.text('Please submit documents.'), findsOneWidget);
  });

  testWidgets('shows only the status description without a message', (
    tester,
  ) async {
    await pumpEntry(tester, createEntry());

    expect(find.text('Your application was approved.'), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));
  });

  testWidgets('ignores a whitespace-only message', (tester) async {
    await pumpEntry(tester, createEntry(message: '   '));

    expect(find.byType(Text), findsNWidgets(2));
  });
}
