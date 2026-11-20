import 'package:app/app/app_connectivity_listener.dart';
import 'package:app/app/showcase_wrapper.dart';
import 'package:app/common/theme.dart';
import 'package:app/common/version_compatibility/app_version_compatibility_lifecycle.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/localization/l10n.dart';

/// Main widget of the app, configures router, theme and localization.
/// Provides GraphQL-Provider and Showcase-Widget.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);

    return GraphQLProvider(
      child: ShowcaseWrapper(
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, child) => AppConnectivityListener(
            child: AppVersionCompatibilityLifecycleHost(
              child: child ?? const SizedBox.shrink(),
            ),
          ),
          theme: ref.watch(themeProvider),
          localizationsDelegates: [
            ...context.localizationDelegates,
            FormBuilderLocalizations.delegate,
          ],
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        ),
      ),
    );
  }
}
