part of 'strong_session.dart';

/// Refreshed, or a newer session was already stored.
final class StrongSessionRefreshed extends StrongSessionRefresh {
  const StrongSessionRefreshed(this.token);

  final String token;
}
