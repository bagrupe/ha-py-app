import 'package:app/routes/aktuelles/components/original_article_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a link to the original article', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OriginalArticleButton(
            url:
                'https://example.test/portal/meldungen/artikel-900000539-33910.html',
          ),
        ),
      ),
    );

    expect(find.text('application.news.original_article'), findsOneWidget);
    expect(find.byIcon(Icons.open_in_new), findsOneWidget);
  });
}
