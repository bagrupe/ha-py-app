import 'package:app/components/filter_button/app_filter_chip.dart';
import 'package:app/routes/profil/interests/volunteer_interest_filter.dart';
import 'package:app/routes/profil/interests/volunteer_interest_filter_provider.dart';
import 'package:app/routes/volunteer_database/models/volunteer_interest_overview_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays accessible filters for sent and received interest requests.
class VolunteerInterestFilterBar extends ConsumerWidget {
  /// Creates the filter bar with counts from [interests].
  const VolunteerInterestFilterBar({required this.interests, super.key});

  /// Complete interest list used for filter counts.
  final List<VolunteerInterestOverviewModel> interests;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const basePath = 'application.profile.volunteer_interests.filters';
    final selected = ref.watch(volunteerInterestFilterProvider);
    return Semantics(
      container: true,
      label: '$basePath.semantics'.tr(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8,
          children: VolunteerInterestFilter.values
              .map((filter) {
                final label = '$basePath.${filter.name}'.tr();
                return AppFilterChip(
                  selected: selected == filter,
                  label: label,
                  semanticLabel: label,
                  onSelected: () => ref
                      .read(volunteerInterestFilterProvider.notifier)
                      .select(filter),
                );
              })
              .toList(growable: false),
        ),
      ),
    );
  }
}
