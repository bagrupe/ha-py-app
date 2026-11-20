import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/auth.dart';
import 'package:app/common/startup.dart';
import 'package:app/graphql/graphql_cache.dart';
import 'package:app/graphql/links/auth_link.dart';
import 'package:app/graphql/sentry_reportable_exception.dart';
import 'package:app/graphql/timeout_http_client.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

final authTokenProvider = StateProvider<String?>(
  (ref) => ref.read(initialStateProvider).authToken,
);

final fileAuthHeadersProvider = Provider<Map<String, String>?>((ref) {
  final token = ref.watch(authTokenProvider);
  return token == null ? null : {'Authorization': 'Bearer $token'};
});

/// The token fetched at startup only serves the first build, later builds resolve the current one.
bool _hasBuiltGraphqlClient = false;

final graphqlClientProvider = Provider((ref) {
  final backendUrl = ref.watch(appConfigProvider).backendUrl;

  final url = '$backendUrl/graphql';
  final dedupeLink = DedupeLink();
  final errorLink = ErrorLink(
    onException: (request, _, ex) {
      Sentry.captureException(sentryReportableException(request, ex));
      return null;
    },
  );

  final initialToken = _hasBuiltGraphqlClient
      ? null
      : ref.read(initialStateProvider).authToken;
  _hasBuiltGraphqlClient = true;
  final container = ref.container;
  final authLink = HttpAuthLink(
    url,
    initialToken,
    (token) {
      if (ref.mounted) ref.read(authTokenProvider.notifier).state = token;
    },
    () => container.read(strongSessionExpiredProvider.notifier).set(true),
    () => endRejectedDeviceLogin(container),
  );
  final httpLink = HttpLink(
    url,
    httpClient: SentryHttpClient(client: TimeoutHttpClient(http.Client())),
  );

  final usedLink = Link.from([dedupeLink, errorLink, authLink, httpLink]);

  return GraphQLClient(
    link: usedLink,
    cache: cache,
    defaultPolicies: DefaultPolicies(
      query: Policies(fetch: FetchPolicy.cacheAndNetwork),
    ),
  );
});

/// Used by `graphql_flutter` widgets.
class GraphQLProvider extends ConsumerWidget {
  const GraphQLProvider({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(graphqlClientProvider);
    final notifier = ValueNotifier(client);
    return graphql_flutter.GraphQLProvider(client: notifier, child: child);
  }
}
