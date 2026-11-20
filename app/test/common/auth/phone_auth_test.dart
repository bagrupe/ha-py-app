import 'dart:convert';

import 'package:app/common/auth/phone_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeLink extends Link {
  _FakeLink(this.response);

  final Response response;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) =>
      Stream.value(response);
}

GraphQLClient _clientReturning(Response response) =>
    GraphQLClient(cache: GraphQLCache(), link: _FakeLink(response));

Response _validateResult(
  String result, {
  int? remainingAttempts,
  int? retryAfterSeconds,
  String? token,
  String? refreshToken,
}) => Response(
  data: {
    '__typename': 'Mutation',
    'validateSmsCode': {
      '__typename': 'ValidateSmsCodePayload',
      'result': result,
      'token': token,
      'refreshToken': refreshToken,
      'isNewRegistration': false,
      'remainingAttempts': remainingAttempts,
      'retryAfterSeconds': retryAfterSeconds,
    },
  },
  response: const {},
);

Response _rateLimited({int? retryAfterSeconds}) => Response(
  errors: [
    GraphQLError(
      message: 'Rate Limit exceeded',
      extensions: {
        'code': 'RATE_LIMIT',
        'retryAfterSeconds': ?retryAfterSeconds,
      },
    ),
  ],
  response: const {},
);

Future<ValidateSmsCodeOutcome> _validate(Response response) => validateSmsCode(
  _clientReturning(response),
  telephoneNumber: '+4915112345678',
  code: '123456',
);

void main() {
  group('nothing of the login stays in the persistent cache', () {
    test('after a validated code', () async {
      final store = InMemoryStore();
      final client = GraphQLClient(
        cache: GraphQLCache(store: store),
        link: _FakeLink(
          _validateResult(
            'SUCCESS',
            token: 'secret-token',
            refreshToken: 'secret-refresh',
          ),
        ),
      );

      await validateSmsCode(
        client,
        telephoneNumber: '+4915112345678',
        code: '123456',
      );

      final cached = jsonEncode(store.toMap());
      expect(cached, isNot(contains('secret-refresh')));
      expect(cached, isNot(contains('secret-token')));
      expect(cached, isNot(contains('15112345678')));
    });

    test('after a requested code', () async {
      final store = InMemoryStore();
      final client = GraphQLClient(
        cache: GraphQLCache(store: store),
        link: _FakeLink(
          const Response(
            data: {
              '__typename': 'Mutation',
              'requestSmsCode': {
                '__typename': 'RequestSmsCodePayload',
                'requestSmsResult': 'SUCCESS',
              },
            },
            response: {},
          ),
        ),
      );

      await requestSmsCode(client, '+4915112345678');

      expect(jsonEncode(store.toMap()), isNot(contains('15112345678')));
    });
  });

  group('validateSmsCode', () {
    test('a success carries the token and its refresh token', () async {
      final outcome = await _validate(
        _validateResult('SUCCESS', token: 'token', refreshToken: 'refresh'),
      );

      expect(outcome, isA<ValidateSmsCodeSuccess>());
      final success = outcome as ValidateSmsCodeSuccess;
      expect(success.token, 'token');
      expect(success.refreshToken, 'refresh');
    });

    test('a success without refresh token still signs in', () async {
      final outcome = await _validate(
        _validateResult('SUCCESS', token: 'token'),
      );

      expect((outcome as ValidateSmsCodeSuccess).refreshToken, isNull);
    });

    test('wrong code carries the remaining attempts', () async {
      final outcome = await _validate(
        _validateResult('INVALID_CODE', remainingAttempts: 3),
      );

      expect(outcome, isA<ValidateSmsCodeInvalidCode>());
      expect((outcome as ValidateSmsCodeInvalidCode).remainingAttempts, 3);
    });

    test('wrong code without a count from an older backend', () async {
      final outcome = await _validate(_validateResult('INVALID_CODE'));

      expect((outcome as ValidateSmsCodeInvalidCode).remainingAttempts, isNull);
    });

    test('locked account carries the lock time', () async {
      final outcome = await _validate(
        _validateResult('CODE_LOCKED', retryAfterSeconds: 900),
      );

      expect(outcome, isA<ValidateSmsCodeLocked>());
      expect(
        (outcome as ValidateSmsCodeLocked).retryAfter,
        const Duration(minutes: 15),
      );
    });

    test('rate limit carries the wait time', () async {
      final outcome = await _validate(_rateLimited(retryAfterSeconds: 120));

      expect(outcome, isA<ValidateSmsCodeRateLimited>());
      expect(
        (outcome as ValidateSmsCodeRateLimited).retryAfter,
        const Duration(minutes: 2),
      );
    });

    test('rate limit without a wait time from an older backend', () async {
      final outcome = await _validate(_rateLimited());

      expect((outcome as ValidateSmsCodeRateLimited).retryAfter, isNull);
    });

    test('any other error stays a generic failure', () async {
      final outcome = await _validate(
        const Response(
          errors: [GraphQLError(message: 'boom')],
          response: {},
        ),
      );

      expect(outcome, isA<ValidateSmsCodeFailure>());
    });

    test('an unknown result stays a generic failure', () async {
      final outcome = await _validate(_validateResult('SOMETHING_NEW'));

      expect(outcome, isA<ValidateSmsCodeFailure>());
    });
  });

  group('requestSmsCode', () {
    test('an account linked to BundID is sent to the BundID login', () async {
      final outcome = await requestSmsCode(
        _clientReturning(
          const Response(
            data: {
              '__typename': 'Mutation',
              'requestSmsCode': {
                '__typename': 'RequestSmsCodePayload',
                'requestSmsResult': 'BUND_ID_LOGIN_REQUIRED',
              },
            },
            response: {},
          ),
        ),
        '+4915112345678',
      );

      expect(outcome, isA<RequestSmsCodeBundIdLoginRequired>());
    });

    test('rate limit carries the wait time', () async {
      final outcome = await requestSmsCode(
        _clientReturning(_rateLimited(retryAfterSeconds: 45)),
        '+4915112345678',
      );

      expect(outcome, isA<RequestSmsCodeRateLimited>());
      expect(
        (outcome as RequestSmsCodeRateLimited).retryAfter,
        const Duration(seconds: 45),
      );
    });
  });
}
