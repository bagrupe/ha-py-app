part of 'strong_session.dart';

/// The backend did not answer usably, the session is kept for a later attempt.
final class StrongSessionUnreachable extends StrongSessionRefresh {
  const StrongSessionUnreachable(this.token);

  final String token;
}
