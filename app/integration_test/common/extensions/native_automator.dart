import 'package:patrol/patrol.dart';

extension KommunalAppNativeAutomator on PlatformAutomator {
  Future<void> tapOneOf(
    List<Selector> selectors, {
    String? appId,
    Duration? timeout,
  }) async {
    for (final selector in selectors) {
      try {
        await tap(selector, appId: appId, timeout: timeout);
        return;
      } catch (e) {
        if (e is! PatrolActionException) rethrow;
      } finally {}
    }

    throw PatrolActionException(
      "Failed to find any of the provided selectors:\n${selectors.map((s) => s.toString()).join(",\n")}",
    );
  }
}
