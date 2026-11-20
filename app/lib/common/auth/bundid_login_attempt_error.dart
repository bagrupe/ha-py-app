part of 'bundid_auth.dart';

class BundIdLoginAttemptError extends BundIdLoginAttempt {
  const BundIdLoginAttemptError(this.result);

  final BundIdLoginResult result;
}
