import 'package:app/common/abfall/abfall_notifications.dart';
import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/strong_session.dart';
import 'package:app/common/image_compression/image_compression.dart';
import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:app/common/local_attachments/local_attachment_store.dart';
import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/common/notifications/notifications.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/graphql_cache.dart';
import 'package:app/graphql/links/auth_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds values resolved during startup before the app is rendered.
class InitialState {
  InitialState(this.initialRoute, this.authToken);

  InitialState._empty() : initialRoute = null, authToken = null;
  final String? initialRoute;
  final String? authToken;
}

/// Prepares authentication, attachment migration and caches during the splash screen.
Future<(InitialState, SharedPreferences)> startUp() async {
  if (!kIsWeb) WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebasePush();
  final initialLocation = await getInitialRouteFromNotification();

  final prefs = await SharedPreferences.getInstance();
  await LocalAttachmentStore(prefs).migrate(
    processImage: (file) =>
        compressImage(file, ImageCompressionProfile.dokument),
  );
  await initializeGraphQLCache(prefs);

  final setupSteps = <Future<dynamic>>[
    migrateFromSecureStorageToSharedPrefs().then((_) => getInitialAuthToken()),
    getMatomoSettings().then((settings) async {
      if (settings.url == null || settings.siteId == null) {
        return;
      }
      await MatomoTracker.instance.initialize(
        siteId: settings.siteId!,
        url: settings.url!,
      );
    }),
  ];

  final setupResults = await Future.wait(setupSteps);

  final (_, authToken) = setupResults[0] as AuthTokenResult;

  return (InitialState(initialLocation, authToken), prefs);
}

typedef AuthTokenResult = (SharedPreferences, String?);

Future<AuthTokenResult> getInitialAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  final graphqlUrl = '${AppConfigRepository.getBackendUrl(prefs)}/graphql';

  if (prefs.getString(secureWeakLoginIdPrefsKey) == null) {
    await discardStrongSession(
      const FlutterSecureStorage(),
      backendUrl: () => AppConfigRepository.getBackendUrl(prefs),
    );
  }

  String? token;
  try {
    token = await HttpAuthLink.resolveToken(
      graphqlUrl,
    ).timeout(const Duration(seconds: 5));
  } catch (error, stackTrace) {
    debugPrint('Auth token fetch failed: $error\n$stackTrace');
  }

  return (prefs, token);
}

/// Fetches Matomo analytics settings with a fail-fast timeout.
///
/// Uses 5s to tolerate slow (2G/Edge) connections while still unblocking
/// the splash screen if analytics config is unreachable. On timeout or
/// network failure, logs locally and returns nulls so startup continues.
Future<({String? url, String? siteId})> getMatomoSettings() async {
  try {
    return await _fetchMatomoSettings().timeout(const Duration(seconds: 5));
  } catch (error, stackTrace) {
    debugPrint('Matomo settings fetch failed: $error\n$stackTrace');
    return (url: null, siteId: null);
  }
}

Future<({String? url, String? siteId})> _fetchMatomoSettings() async {
  final prefs = await SharedPreferences.getInstance();
  final graphqlUrl = '${AppConfigRepository.getBackendUrl(prefs)}/graphql';
  final kommuneId = AppConfigRepository.getKommuneId(prefs);
  final httpLink = HttpLink(graphqlUrl);
  final client = GraphQLClient(link: httpLink, cache: cache);
  final kommune = await client.query_Kommune(
    Options_Query_Kommune(
      fetchPolicy: FetchPolicy.noCache,
      variables: Variables_Query_Kommune(kommuneId: kommuneId),
    ),
  );

  final analytics = kommune.parsedData?.kommune.analytics;
  return (url: analytics?.url, siteId: analytics?.siteId);
}

final initialStateProvider = Provider((ref) => InitialState._empty());

/// Starts background authentication and notification setup after the app mounts.
final setupProvider = Provider((ref) async {
  ref.watch(authProvider);
  if (!kIsWeb) {
    ref
      ..watch(notificationsProvider)
      ..watch(abfallNotificationsProvider);

    final notifications = ref.read(notificationsProvider);
    await notifications.init();
    if (!ref.mounted) return;

    final abfallNotifications = ref.read(abfallNotificationsProvider);
    await abfallNotifications.schedule();
  }
});
