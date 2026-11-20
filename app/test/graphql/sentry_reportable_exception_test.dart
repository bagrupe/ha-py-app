import 'package:app/graphql/sentry_reportable_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;

void main() {
  const secret = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQ';

  Request request(String document) =>
      Request(operation: Operation(document: parseString(document)));

  LinkException unreadableResponse() => HttpLinkParserException(
    originalException: const FormatException(
      'Unexpected end of input',
      '{"data":{"keyEscrow":"$secret',
    ),
    originalStackTrace: null,
    response: http.Response('{"data":{"keyEscrow":"$secret', 200),
  );

  test('the original exception carries the response text', () {
    expect(unreadableResponse().toString(), contains(secret));
  });

  test('an unreadable key escrow response is reported without its text', () {
    final reported = sentryReportableException(
      request('query KeyEscrow { keyEscrow }'),
      unreadableResponse(),
    );

    expect(reported.toString(), isNot(contains(secret)));
    expect(reported.toString(), contains('HttpLinkParserException'));
  });

  test('storing the key is reported without its text', () {
    final reported = sentryReportableException(
      request(
        r'mutation StoreKeyEscrow($input: StoreKeyEscrowInput!) '
        r'{ storeKeyEscrow(input: $input) { boolean } }',
      ),
      unreadableResponse(),
    );

    expect(reported.toString(), isNot(contains(secret)));
  });

  test('an unreadable SMS validation is reported without its tokens', () {
    final reported = sentryReportableException(
      request(
        r'mutation ValidateSmsCode($input: ValidateSmsCodeInput!) '
        r'{ validateSmsCode(input: $input) { token refreshToken } }',
      ),
      unreadableResponse(),
    );

    expect(reported.toString(), isNot(contains(secret)));
  });

  test('other operations are reported unchanged', () {
    final exception = unreadableResponse();

    expect(
      sentryReportableException(request('query My { my { id } }'), exception),
      same(exception),
    );
  });
}
