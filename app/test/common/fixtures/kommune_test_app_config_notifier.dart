import 'package:app/common/app_config/app_config.dart';

/// Supplies configuration without shared preferences or startup dependencies.
class KommuneTestAppConfigNotifier extends AppConfigNotifier {
  @override
  AppConfig build() =>
      const AppConfig(backendUrl: 'http://localhost', kommuneId: 'kommune-1');
}
