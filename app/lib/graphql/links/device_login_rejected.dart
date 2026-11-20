part of 'auth_link.dart';

final class DeviceLoginRejected implements Exception {
  const DeviceLoginRejected();

  @override
  String toString() => 'Login failed!';
}
