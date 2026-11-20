import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:app/routes/maengel/components/maengel_historie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

AusfuehrungHistorie createEntry({String? message}) {
  return Query_Mangel_kommune_mangelAusfuehrung_historie(
    id: 'historie-1',
    createdAt: DateTime.utc(2026, 10, 14, 10),
    statusAenderung: 'Defect fixed',
    nachricht: message,
  );
}

Future<void> pumpHistorie(WidgetTester tester, AusfuehrungHistorie entry) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: MangelHistorie(historie: [entry])),
    ),
  );
}

void main() {
  testWidgets('shows the message below the status', (tester) async {
    await pumpHistorie(tester, createEntry(message: 'Please call us back.'));

    expect(find.text('Defect fixed'), findsOneWidget);
    expect(find.text('Please call us back.'), findsOneWidget);
  });

  testWidgets('shows only the status without a message', (tester) async {
    await pumpHistorie(tester, createEntry());

    expect(find.text('Defect fixed'), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));
  });

  testWidgets('ignores a whitespace-only message', (tester) async {
    await pumpHistorie(tester, createEntry(message: '   '));

    expect(find.byType(Text), findsNWidgets(2));
  });
}
