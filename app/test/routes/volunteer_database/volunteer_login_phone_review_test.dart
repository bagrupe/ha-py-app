import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_notifier.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

/// Verifies that reviewing an unchanged phone number does not request another SMS.
void main() {
  testWidgets('reuses the code on review and allows explicit resend', (
    tester,
  ) async {
    final requestedNumbers = <String>[];
    final client = GraphQLClient(
      link: Link.function((request, [forward]) {
        final input = request.variables['input'] as Map<String, dynamic>;
        requestedNumbers.add(input['telephoneNumber'] as String);
        return Stream.value(
          const Response(
            response: {},
            data: {
              '__typename': 'Mutation',
              'requestSmsCode': {
                '__typename': 'RequestSmsCodePayload',
                'requestSmsResult': 'SUCCESS',
              },
            },
          ),
        );
      }),
      cache: GraphQLCache(store: InMemoryStore()),
    );
    final container = ProviderContainer(
      overrides: [graphqlClientProvider.overrideWithValue(client)],
    )..listen(volunteerLoginProvider, (_, _) {});
    final notifier = container.read(volunteerLoginProvider.notifier)
      ..updatePhoneNumber('15123456789');
    await notifier.continueLogin();
    notifier.updateSmsCode('123456');
    final remainingSeconds = container
        .read(volunteerLoginProvider)
        .resendSecondsRemaining;

    for (final number in ['15123456789', '151 23456789']) {
      notifier
        ..reviewPhoneNumber()
        ..updatePhoneNumber(number);
      await notifier.continueLogin();
      final state = container.read(volunteerLoginProvider);
      expect(requestedNumbers, ['+4915123456789']);
      expect(state.currentStep, VolunteerLoginStep.sms);
      expect(state.smsCode, '123456');
      expect(state.resendSecondsRemaining, remainingSeconds);
      expect(state.errorMessageKey, isNull);
    }

    notifier
      ..reviewPhoneNumber()
      ..updatePhoneNumber('15123456780');
    await notifier.continueLogin();
    expect(requestedNumbers, ['+4915123456789', '+4915123456780']);
    expect(container.read(volunteerLoginProvider).smsCode, isEmpty);
    await notifier.resendCode();
    expect(requestedNumbers, hasLength(2));
    await tester.pump(const Duration(seconds: 59));
    await notifier.resendCode();
    expect(requestedNumbers, [
      '+4915123456789',
      '+4915123456780',
      '+4915123456780',
    ]);
    container.dispose();
  });
}
