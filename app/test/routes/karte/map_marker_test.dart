import 'dart:async';
import 'dart:io';

import 'package:app/routes/karte/map_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

class _PendingHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) =>
      Completer<HttpClientRequest>().future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PendingHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _PendingHttpClient();
}

Widget _host(MapMarker marker) => MaterialApp(
  home: Scaffold(body: Center(child: marker)),
);

void main() {
  group('without an icon url', () {
    for (final type in [MarkerType.ideeOpen, MarkerType.ideeCompleted]) {
      testWidgets('$type falls back to a lightbulb', (tester) async {
        await tester.pumpWidget(_host(MapMarker(type: type)));

        expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
        expect(find.byIcon(Icons.campaign_outlined), findsNothing);
      });
    }

    for (final type in [MarkerType.mangelOpen, MarkerType.mangelCompleted]) {
      testWidgets('$type falls back to a megaphone', (tester) async {
        await tester.pumpWidget(_host(MapMarker(type: type)));

        expect(find.byIcon(Icons.campaign_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lightbulb_outline), findsNothing);
      });
    }

    for (final type in [MarkerType.poi, MarkerType.sensor]) {
      testWidgets('$type keeps the megaphone', (tester) async {
        await tester.pumpWidget(_host(MapMarker(type: type)));

        expect(find.byIcon(Icons.campaign_outlined), findsOneWidget);
      });
    }
  });

  group('with an empty icon url', () {
    testWidgets('an idea marker shows the lightbulb without loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const MapMarker(type: MarkerType.ideeOpen, iconUrl: '')),
      );

      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });

    testWidgets('a defect marker shows the megaphone without loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const MapMarker(type: MarkerType.mangelOpen, iconUrl: '')),
      );

      expect(find.byIcon(Icons.campaign_outlined), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });
  });

  group('when the icon cannot be loaded', () {
    const iconUrl = 'http://localhost:1/icon.svg';

    Future<Widget?> errorFallback(WidgetTester tester, MarkerType type) {
      return HttpOverrides.runWithHttpOverrides(() async {
        await tester.pumpWidget(_host(MapMarker(type: type, iconUrl: iconUrl)));
        final svgFinder = find.byType(SvgPicture);
        final fallback = tester
            .widget<SvgPicture>(svgFinder)
            .errorBuilder
            ?.call(
              tester.element(svgFinder),
              StateError('x'),
              StackTrace.empty,
            );
        await tester.pumpWidget(const SizedBox.shrink());
        return fallback;
      }, _PendingHttpOverrides());
    }

    IconData? iconOf(Widget? widget) => widget is Icon ? widget.icon : null;

    testWidgets('an idea marker shows the lightbulb', (tester) async {
      for (final type in [MarkerType.ideeOpen, MarkerType.ideeCompleted]) {
        expect(
          iconOf(await errorFallback(tester, type)),
          Icons.lightbulb_outline,
        );
      }
    });

    testWidgets('a defect marker shows the megaphone', (tester) async {
      for (final type in [MarkerType.mangelOpen, MarkerType.mangelCompleted]) {
        expect(
          iconOf(await errorFallback(tester, type)),
          Icons.campaign_outlined,
        );
      }
    });

    testWidgets('a POI or sensor marker has no error fallback', (tester) async {
      for (final type in [MarkerType.poi, MarkerType.sensor]) {
        expect(await errorFallback(tester, type), isNull);
      }
    });
  });
}
