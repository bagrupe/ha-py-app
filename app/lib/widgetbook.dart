import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/kommune.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/startup.dart';
import 'package:app/common/widgetbook/addons/widgetbook_base_layout_addon.dart';
import 'package:app/common/widgetbook/addons/widgetbook_customization_addon.dart';
import 'package:app/widgetbook.directories.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE');
  Intl.defaultLocale = 'de_DE';
  if (kDebugMode) {
    // Turns `Failed assertion: 'asynchronous gap'` into something useful.
    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is Trace) return stack.vmTrace;
      if (stack is Chain) return stack.toTrace().vmTrace;
      return stack;
    };
  }
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        appConfigRepositoryProvider.overrideWithValue(
          WidgetbookAppConfigRepository(prefs),
        ),
        sharedPreferencesProvider.overrideWithValue(prefs),
        initialStateProvider.overrideWithValue(InitialState(null, null)),
      ],
      child: const WidgetbookApp(),
    ),
  );
}

@App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        ViewportAddon([
          Viewports.none,
          IosViewports.iPhone12Mini,
          AndroidViewports.samsungGalaxyNote20,
        ]),
        TextScaleAddon(min: 1, initialScale: 1),
        WidgetbookCustomizationAddon(),
        WidgetbookBaseLayoutAddon(),
        InspectorAddon(enabled: true),
      ],
    );
  }
}

class WidgetbookAppConfigRepository extends AppConfigRepository {
  WidgetbookAppConfigRepository(super.prefs);

  @override
  AppConfig read() {
    const backendUrl = String.fromEnvironment(
      'BACKEND_URL',
      defaultValue: 'localhost:3000',
    );

    return const AppConfig(backendUrl: backendUrl, kommuneId: KommuneIds.hapy);
  }
}
