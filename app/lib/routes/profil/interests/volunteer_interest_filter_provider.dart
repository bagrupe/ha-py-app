import 'package:app/routes/profil/interests/volunteer_interest_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the active filter for the volunteer interest overview.
class VolunteerInterestFilterNotifier
    extends Notifier<VolunteerInterestFilter> {
  @override
  VolunteerInterestFilter build() => VolunteerInterestFilter.all;

  /// Selects the active [filter].
  void select(VolunteerInterestFilter filter) {
    state = filter;
  }
}

/// Active volunteer interest list filter.
final volunteerInterestFilterProvider =
    NotifierProvider<VolunteerInterestFilterNotifier, VolunteerInterestFilter>(
      VolunteerInterestFilterNotifier.new,
    );
