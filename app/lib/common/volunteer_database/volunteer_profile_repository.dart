// ignore_for_file: one_member_abstracts

import 'dart:math';

import 'package:app/common/volunteer_database/time_credit_model.dart';
import 'package:app/common/volunteer_database/volunteer_profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contract for fetching volunteer profile data.
abstract class VolunteerProfileRepository {
  /// Returns the profile for [userId].
  Future<VolunteerProfileModel> getUserProfile(String userId);
}

/// Backend API mock for volunteer profile requests.
class MockVolunteerProfileApiRepository implements VolunteerProfileRepository {
  @override
  Future<VolunteerProfileModel> getUserProfile(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final timeCredit = _variants[Random().nextInt(_variants.length)];
    return VolunteerProfileModel(
      id: userId,
      firstName: 'Magdalena',
      lastName: 'Schmidt',
      phoneNumber: '+49 151 23456789',
      timeCredit: timeCredit,
    );
  }
}

/// Provider for the volunteer profile repository.
///
/// Provides the profile API implementation used by the volunteer feature.
final volunteerProfileRepositoryProvider = Provider<VolunteerProfileRepository>(
  (ref) {
    return MockVolunteerProfileApiRepository();
  },
);

final _variants = [
  const TimeCreditModel(
    baseCredit: Duration(hours: 8),
    helpProvided: Duration.zero,
    helpReceived: Duration(hours: 4, minutes: 30),
    timeBlocked: Duration.zero,
  ),
  const TimeCreditModel(
    baseCredit: Duration(hours: 8),
    helpProvided: Duration.zero,
    helpReceived: Duration(hours: 8),
    timeBlocked: Duration.zero,
  ),
  const TimeCreditModel(
    baseCredit: Duration(hours: 8),
    helpProvided: Duration.zero,
    helpReceived: Duration(hours: 8, minutes: 30),
    timeBlocked: Duration.zero,
  ),
];
