part of 'my_account_provider.dart';

class StrongSessionExpiredNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}
