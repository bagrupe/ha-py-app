import 'dart:io';

import 'package:app/common/keys.dart';
import 'package:app/common/location_service.dart';
import 'package:app/routes/maengel/components/maengel_liste_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:patrol/patrol.dart';
import 'common/start.dart';

void main() {
  patrolTest('Mängelmelder', ($) async {
    LocationService.mockLocation = Position(
      latitude: 52.3741275,
      longitude: 9.7433711,
      accuracy: 0,
      altitude: 1,
      heading: 0,
      speed: 0,
      isMocked: true,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
      speedAccuracy: 0,
      timestamp: DateTime.now(),
    );

    await launchApp($);

    await $('Weiter').scrollTo(step: 300).tap();

    await $('Weiter').tap();
    await $('Weiter').tap();
    await $('Weiter').tap();

    // Location
    if (await $.platformAutomator.mobile.isPermissionDialogVisible(
      timeout: const Duration(milliseconds: 2000),
    )) {
      try {
        await $.platformAutomator.mobile.selectFineLocation();
      } catch (e) {
        /* https://github.com/leancodepl/patrol/issues/2171 */
      }

      await $.platformAutomator.mobile.grantPermissionWhenInUse();
    }

    await $.pumpAndSettle();

    await $('Überspringen').tap();

    // Notifications
    if (await $.platformAutomator.mobile.isPermissionDialogVisible()) {
      await $.platformAutomator.mobile.grantPermissionWhenInUse();
    }

    await $.pump(const Duration(milliseconds: 200));
    await $.pumpAndSettle();
    expect($('Aktuelles'), findsAtLeastNWidgets(1));

    await $('Karte').tap();

    await $(K.mangelmelder).tap();
    await $(K.addMangel).scrollTo().tap();

    await $(Icons.place_outlined).tap();

    await $(#titel).enterText('Testtitel');
    await $(#kategorie).tap();
    await $('Vandalismus').tap();
    await $(#beschreibung).scrollTo().enterText('Testbeschreibung');

    await $(K.nextStep).scrollTo().tap();

    await $(Icons.file_upload_outlined).tap();

    if (Platform.isAndroid) {
      await $(Icons.camera_alt_outlined).tap();
      if (await $.platformAutomator.mobile.isPermissionDialogVisible()) {
        await $.platformAutomator.mobile.grantPermissionWhenInUse();
      }

      await tapFirstVisibleNativeElement(
        tester: $,
        selectors: [
          Selector(resourceId: 'com.sec.android.app.camera:id/center_button'),
          Selector(resourceId: 'com.android.camera2:id/shutter_button'),
        ],
      );
      await tapFirstVisibleNativeElement(
        tester: $,
        selectors: [
          Selector(textContains: 'OK'),
          Selector(resourceId: 'com.android.camera2:id/done_button'),
        ],
      );
    } else if (Platform.isIOS) {
      await $(Icons.photo_library_outlined).tap();

      if (await $.platformAutomator.mobile.isPermissionDialogVisible(
        timeout: const Duration(seconds: 2),
      )) {
        await $.platformAutomator.mobile.tap(
          Selector(text: 'Allow Full Access'),
        );
      }

      // We use native2 and NativeSelector here because Selector appears to not honour all properties
      // and taps the Photos / Album switch button for some reason
      await $.platformAutomator.mobile.tap(
        const IOSSelector(
          elementType: IOSElementType.image,
          labelStartsWith: 'Photo',
        ),
      );

      await $.platformAutomator.mobile.tap(Selector(text: 'Add'));

      // Trigger closing animation of the bottom sheet because it doesn't happen on its own
      await $.pumpAndSettle();
    }
    await $.pump(const Duration(milliseconds: 200));
    await $(K.nextStep).tap();

    await $(K.confirmSummary).scrollTo().tap();
    await $(K.backToList).tap();

    await $(K.mangelmelder).tap();
    await $.pumpAndSettle(duration: const Duration(seconds: 1));
    expect($(MaengelListeItem), findsAtLeastNWidgets(1));
  });
}

Future<CompoundSelector> tapFirstVisibleNativeElement({
  required PatrolIntegrationTester tester,
  required List<CompoundSelector> selectors,
  Duration timeout = const Duration(seconds: 10),
  Duration attemptTimeout = const Duration(milliseconds: 500),
}) async {
  final stopwatch = Stopwatch()..start();

  while (stopwatch.elapsed < timeout) {
    for (final selector in selectors) {
      try {
        await tester.platform.mobile.tap(selector, timeout: attemptTimeout);

        return selector;
      } on Exception {
        continue;
      }
    }
  }

  throw TestFailure(
    'None of the provided native selectors became visible within $timeout.',
  );
}
