/// Traffic-light classification of a volunteer's time-credit balance.
enum TimeCreditState {
  /// Balance is healthy (above one hour).
  positive,

  /// Balance is low: between zero and one hour (inclusive).
  warning,

  /// Balance is overdrawn.
  negative,
}

/// Immutable domain model for volunteer time currency.
///
/// Balance is derived, never stored:
/// `baseCredit + helpProvided - helpReceived - timeBlocked`.
class TimeCreditModel {
  /// Creates a time-credit snapshot from the given duration components.
  const TimeCreditModel({
    required this.baseCredit,
    required this.helpProvided,
    required this.helpReceived,
    required this.timeBlocked,
  });

  /// Starter credit granted to the volunteer by the backend.
  final Duration baseCredit;

  /// Upper bound of the warning band (inclusive); above this is [TimeCreditState.positive].
  static const Duration warningThreshold = Duration(hours: 1);

  /// Time earned by providing help to others.
  final Duration helpProvided;

  /// Time spent by receiving help from others.
  final Duration helpReceived;

  /// Time reserved for in-progress or pending help requests.
  final Duration timeBlocked;

  /// Net available time credit.
  Duration get currentBalance =>
      baseCredit + helpProvided - helpReceived - timeBlocked;

  /// [TimeCreditState] derived from [currentBalance].
  ///
  /// - [TimeCreditState.negative] when overdrawn (`< 0`)
  /// - [TimeCreditState.warning] when `0 ≤ balance ≤ 1h`
  /// - [TimeCreditState.positive] when `balance > 1h`
  TimeCreditState get state {
    final balance = currentBalance;
    if (balance.isNegative) {
      return TimeCreditState.negative;
    }
    if (balance <= warningThreshold) {
      return TimeCreditState.warning;
    }
    return TimeCreditState.positive;
  }
}
