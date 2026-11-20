import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls whether a completion counterproposal is being edited.
class VolunteerCompletionEditingNotifier extends Notifier<bool> {
  /// Creates editing state for [interestId].
  VolunteerCompletionEditingNotifier(this.interestId);

  /// Backend identifier of the interest request.
  final String interestId;

  @override
  bool build() => false;

  /// Opens the counterproposal form.
  void begin() {
    state = true;
  }

  /// Closes the counterproposal form.
  void cancel() {
    state = false;
  }
}

/// Counterproposal editing state keyed by interest request identifier.
final volunteerCompletionEditingProvider =
    NotifierProvider.family<VolunteerCompletionEditingNotifier, bool, String>(
      VolunteerCompletionEditingNotifier.new,
    );
