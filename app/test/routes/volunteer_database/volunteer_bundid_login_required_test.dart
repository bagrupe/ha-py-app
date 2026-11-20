import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_notifier.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_step.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

ProviderContainer _container() {
  final client = GraphQLClient(
    link: Link.function(
      (request, [forward]) => Stream.value(
        const Response(
          response: {},
          data: {
            '__typename': 'Mutation',
            'requestSmsCode': {
              '__typename': 'RequestSmsCodePayload',
              'requestSmsResult': 'BUND_ID_LOGIN_REQUIRED',
            },
          },
        ),
      ),
    ),
    cache: GraphQLCache(store: InMemoryStore()),
  );
  final container = ProviderContainer(
    overrides: [graphqlClientProvider.overrideWithValue(client)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('the volunteer login asks for the BundID login', () async {
    final container = _container()..listen(volunteerLoginProvider, (_, _) {});
    final notifier = container.read(volunteerLoginProvider.notifier)
      ..updatePhoneNumber('15123456789');

    await notifier.continueLogin();

    final state = container.read(volunteerLoginProvider);
    expect(state.currentStep, VolunteerLoginStep.phone);
    expect(
      state.errorMessageKey,
      'application.volunteer_database.login_page.errors.bundid_login_required',
    );
    expect(state.phoneErrorMessageKey, isNull);
  });

  test('the volunteer registration asks for the BundID login', () async {
    final container = _container()
      ..listen(volunteerRegistrationProvider, (_, _) {});
    final notifier = container.read(volunteerRegistrationProvider.notifier)
      ..updatePhoneNumber('15123456789');

    await notifier.continueRegistration();

    expect(
      container.read(volunteerRegistrationProvider).errorMessageKey,
      'application.volunteer_database.register_page.errors.bundid_login_required',
    );
  });
}
