part of 'strong_session.dart';

/// Rejected by the backend or without refresh token, the session was removed.
final class StrongSessionEnded extends StrongSessionRefresh {
  const StrongSessionEnded();
}
