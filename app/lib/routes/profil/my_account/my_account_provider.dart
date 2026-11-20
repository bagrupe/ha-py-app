import 'package:app/common/auth/auth.dart';
import 'package:app/common/secure_storage_provider.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/graphql/__generated__/bundid.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';

part 'just_logged_out_notifier.dart';
part 'my_account_profile.dart';
part 'strong_session_expired_notifier.dart';

final myAccountProfileProvider = FutureProvider<MyAccountProfile?>((ref) async {
  final client = ref.watch(graphqlClientProvider);
  final response = await client.query_MyProfile(
    Options_Query_MyProfile(fetchPolicy: FetchPolicy.networkOnly),
  );

  final my = response.parsedData?.my;
  if (my is! Query_MyProfile_my__Buerger) return null;

  return MyAccountProfile(
    vorname: my.vorname,
    nachname: my.nachname,
    email: my.emailAddress,
    street: my.street,
    postalCode: my.postalCode,
    city: my.city,
    country: my.country,
    phoneVerified: my.phoneVerified,
    phoneNumberMasked: my.phoneNumberMasked,
    hasBundId: my.hasBundId,
  );
});

/// Shows the logged-out view right away instead of waiting for [hasStrongSessionProvider] to reload.
final justLoggedOutProvider = NotifierProvider<JustLoggedOutNotifier, bool>(
  JustLoggedOutNotifier.new,
);

final strongSessionExpiredProvider =
    NotifierProvider<StrongSessionExpiredNotifier, bool>(
      StrongSessionExpiredNotifier.new,
    );

Future<bool> saveMyAccountProfile(
  WidgetRef ref, {
  String? vorname,
  String? nachname,
  String? email,
  String? street,
  String? postalCode,
  String? city,
  String? country,
}) async {
  final client = ref.read(graphqlClientProvider);
  final response = await client.mutate_UpdateMyProfile(
    Options_Mutation_UpdateMyProfile(
      variables: Variables_Mutation_UpdateMyProfile(
        input: Input_UpdateMyProfileInput(
          vorname: vorname,
          nachname: nachname,
          email: email,
          street: street,
          postalCode: postalCode,
          city: city,
          country: country,
        ),
      ),
    ),
  );

  if (response.hasException) return false;

  ref.invalidate(myAccountProfileProvider);
  return true;
}

/// Through the container, so the sign-out also completes when the page is closed meanwhile.
Future<void> signOutAccount(ProviderContainer app) async {
  app.read(justLoggedOutProvider.notifier).set(true);

  app.read(volunteerAuthProvider.notifier).signOut();

  await app.read(asyncAuthProvider.notifier).signOut();
  app
    ..invalidate(hasStrongSessionProvider)
    ..invalidate(myAccountProfileProvider);
}

/// Null on failure, any server result (also an unknown one) means the sessions are gone.
Future<Enum_LogoutAllDevicesResult?> logOutEverywhere(
  ProviderContainer app, {
  void Function()? beforeSignOut,
}) async {
  final isFirstDevice = await _isFirstDevice(app);
  final result = await logoutAllDevices(app.read(graphqlClientProvider));
  if (result == null) return null;
  beforeSignOut?.call();
  await signOutAccount(app);
  return result == Enum_LogoutAllDevicesResult.DEVICE_LOGIN_KEPT &&
          isFirstDevice
      ? Enum_LogoutAllDevicesResult.LOGGED_OUT
      : result;
}

Future<bool> _isFirstDevice(ProviderContainer app) async {
  final token = await app
      .read(secureStorageProvider)
      .read(key: secureStrongTokenKey);
  return token != null &&
      accountIdFromToken(token) ==
          app
              .read(sharedPreferencesProvider)
              .getString(secureWeakLoginIdPrefsKey);
}

Future<Enum_LogoutAllDevicesResult?> logoutAllDevices(
  GraphQLClient client,
) async {
  try {
    final result = await client.mutate_LogoutAllDevices();
    if (result.hasException) {
      debugPrint('logoutAllDevices failed: ${result.exception.runtimeType}');
      return null;
    }
    return result.parsedData?.logoutAllDevices.logoutAllDevicesResult;
  } catch (error) {
    debugPrint('logoutAllDevices failed: ${error.runtimeType}');
    return null;
  }
}
