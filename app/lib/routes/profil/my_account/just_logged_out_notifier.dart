part of 'my_account_provider.dart';

class JustLoggedOutNotifier extends Notifier<bool> {
  @override
  bool build() {
    ref.listen(hasStrongSessionProvider, (previous, next) {
      if (next.value ?? false) {
        state = false;
      }
    });
    return false;
  }

  void set(bool value) => state = value;
}
