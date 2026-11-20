import 'package:app/common/kommune.dart';
import 'package:app/components/images/image_carousel/image_carousel.dart';
import 'package:app/graphql/__generated__/blocks.graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_app.dart';

Widget carousel(List<CarouselItem> items) => ProviderScope(
  overrides: [
    kommuneProvider.overrideWithBuild((ref, notifier) => fakeKommune),
  ],
  child: MaterialApp(
    home: Scaffold(
      body: ImageCarousel(items: items, title: 'Artikel'),
    ),
  ),
);

CarouselItem item({String? caption}) =>
    CarouselItem(image: Fragment_VeranstaltungsmedienImage(), caption: caption);

Future<void> openCaption(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.info_outline));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows a caption button instead of inline caption text', (
    tester,
  ) async {
    await tester.pumpWidget(carousel([item(caption: 'Erstes Bild')]));

    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.text('Erstes Bild'), findsNothing);
  });

  testWidgets('opens the caption when the button is tapped', (tester) async {
    await tester.pumpWidget(carousel([item(caption: 'Erstes Bild')]));
    await openCaption(tester);

    expect(find.text('Erstes Bild'), findsOneWidget);
  });

  testWidgets('shows the photo credit separately from the caption text', (
    tester,
  ) async {
    await tester.pumpWidget(
      carousel([item(caption: 'Die Gruppe auf der Treppe.© Peter Jahn')]),
    );
    await openCaption(tester);

    expect(find.text('Die Gruppe auf der Treppe.'), findsOneWidget);
    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    expect(find.textContaining('©'), findsNothing);
  });

  testWidgets('shows a credit-only caption without caption text', (
    tester,
  ) async {
    await tester.pumpWidget(carousel([item(caption: '© Anke Hettwer')]));
    await openCaption(tester);

    expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    expect(find.textContaining('©'), findsNothing);
  });

  testWidgets('shows no caption button when there is no caption', (
    tester,
  ) async {
    await tester.pumpWidget(carousel([item(), item(caption: '   ')]));

    expect(find.byIcon(Icons.info_outline), findsNothing);
  });

  testWidgets('shows the caption of the image that is currently visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      carousel([item(caption: 'Erstes Bild'), item(caption: 'Zweites Bild')]),
    );

    await tester.drag(find.byType(PageView), const Offset(-600, 0));
    await tester.pumpAndSettle();
    await openCaption(tester);

    expect(find.text('Erstes Bild'), findsNothing);
    expect(find.text('Zweites Bild'), findsOneWidget);
  });
}
