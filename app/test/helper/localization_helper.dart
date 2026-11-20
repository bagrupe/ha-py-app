import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// A utility class to initialize localization for unit tests.
class TestLocalizationHelper {
  /// Loads translation files and initializes date formatting for the test environment.
  ///
  /// [localeCode] defaults to 'de'. Ensure the corresponding JSON file exists
  /// at 'assets/translations/[localeCode].json'.
  static Future<void> init({String localeCode = 'de'}) async {
    await initializeDateFormatting(localeCode);

    final file = File('assets/translations/$localeCode.json');
    final jsonString = await file.readAsString();
    final data = json.decode(jsonString) as Map<String, dynamic>;

    Localization.load(Locale(localeCode), translations: Translations(data));

    Intl.defaultLocale = localeCode;
  }
}
