import 'package:app/graphql/__generated__/bundid.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

part 'request_sms_code_bundid_login_required.dart';
part 'request_sms_code_delivery_failed.dart';
part 'request_sms_code_failure.dart';
part 'request_sms_code_invalid_phone.dart';
part 'request_sms_code_outcome.dart';
part 'request_sms_code_rate_limited.dart';
part 'request_sms_code_same_as_current_number.dart';
part 'request_sms_code_success.dart';
part 'validate_sms_code_expired.dart';
part 'validate_sms_code_failure.dart';
part 'validate_sms_code_invalid_code.dart';
part 'validate_sms_code_locked.dart';
part 'validate_sms_code_no_code_requested.dart';
part 'validate_sms_code_outcome.dart';
part 'validate_sms_code_rate_limited.dart';
part 'validate_sms_code_requires_bundid_reverification.dart';
part 'validate_sms_code_success.dart';

const minGermanMobileNumberDigits = 9;

Future<RequestSmsCodeOutcome> requestSmsCode(
  GraphQLClient client,
  String telephoneNumber,
) async {
  final QueryResult<Mutation_RequestSmsCode> response;
  try {
    response = await client.mutate_RequestSmsCode(
      Options_Mutation_RequestSmsCode(
        fetchPolicy: FetchPolicy.noCache,
        variables: Variables_Mutation_RequestSmsCode(
          input: Input_RequestSmsCodeInput(telephoneNumber: telephoneNumber),
        ),
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('requestSmsCode failed: ${error.runtimeType}\n$stackTrace');
    return RequestSmsCodeFailure();
  }

  if (response.hasException) {
    final rateLimit = _rateLimitError(response.exception!);
    return rateLimit == null
        ? RequestSmsCodeFailure()
        : RequestSmsCodeRateLimited(retryAfter: _retryAfter(rateLimit));
  }

  final result = response.parsedData?.requestSmsCode.requestSmsResult;
  return switch (result) {
    Enum_RequestSmsResult.SUCCESS => RequestSmsCodeSuccess(),
    Enum_RequestSmsResult.SAME_AS_CURRENT_PHONE_NUMBER =>
      RequestSmsCodeSameAsCurrentNumber(),
    Enum_RequestSmsResult.INVALID_FORMAT ||
    Enum_RequestSmsResult.INVALID_PHONE => RequestSmsCodeInvalidPhone(),
    Enum_RequestSmsResult.SMS_DELIVERY_FAILED => RequestSmsCodeDeliveryFailed(),
    Enum_RequestSmsResult.BUND_ID_LOGIN_REQUIRED =>
      RequestSmsCodeBundIdLoginRequired(),
    _ => RequestSmsCodeFailure(),
  };
}

GraphQLError? _rateLimitError(OperationException exception) {
  final linkException = exception.linkException;
  final serverErrors = linkException is ServerException
      ? linkException.parsedResponse?.errors ?? const <GraphQLError>[]
      : const <GraphQLError>[];
  return <GraphQLError>[
    ...exception.graphqlErrors,
    ...serverErrors,
  ].where((error) => error.extensions?['code'] == 'RATE_LIMIT').firstOrNull;
}

Duration? _retryAfter(GraphQLError error) {
  final seconds = error.extensions?['retryAfterSeconds'];
  return seconds is int ? Duration(seconds: seconds) : null;
}

Future<ValidateSmsCodeOutcome> validateSmsCode(
  GraphQLClient client, {
  required String telephoneNumber,
  required String code,
}) async {
  final QueryResult<Mutation_ValidateSmsCode> response;
  try {
    response = await client.mutate_ValidateSmsCode(
      Options_Mutation_ValidateSmsCode(
        fetchPolicy: FetchPolicy.noCache,
        variables: Variables_Mutation_ValidateSmsCode(
          input: Input_ValidateSmsCodeInput(
            telephoneNumber: telephoneNumber,
            validationCode: code,
          ),
        ),
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('validateSmsCode failed: ${error.runtimeType}\n$stackTrace');
    return ValidateSmsCodeFailure();
  }

  if (response.hasException) {
    final rateLimit = _rateLimitError(response.exception!);
    return rateLimit == null
        ? ValidateSmsCodeFailure()
        : ValidateSmsCodeRateLimited(retryAfter: _retryAfter(rateLimit));
  }

  final result = response.parsedData?.validateSmsCode;
  return switch (result?.result) {
    Enum_ValidateCodeResult.SUCCESS when result?.token != null =>
      ValidateSmsCodeSuccess(
        result!.token!,
        isNewRegistration: result.isNewRegistration,
        refreshToken: result.refreshToken,
      ),
    Enum_ValidateCodeResult.EXISTING_ACCOUNT_REQUIRES_BUND_ID_REVERIFICATION =>
      ValidateSmsCodeRequiresBundIdReverification(),
    Enum_ValidateCodeResult.CODE_EXPIRED => ValidateSmsCodeExpired(),
    Enum_ValidateCodeResult.NO_VERIFICATION_CODE_REQUESTED =>
      ValidateSmsCodeNoCodeRequested(),
    Enum_ValidateCodeResult.INVALID_CODE => ValidateSmsCodeInvalidCode(
      remainingAttempts: result?.remainingAttempts,
    ),
    Enum_ValidateCodeResult.CODE_LOCKED => ValidateSmsCodeLocked(
      retryAfter: result?.retryAfterSeconds == null
          ? null
          : Duration(seconds: result!.retryAfterSeconds!),
    ),
    _ => ValidateSmsCodeFailure(),
  };
}
