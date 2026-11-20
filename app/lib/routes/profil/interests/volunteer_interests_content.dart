import 'package:app/components/heading/heading.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/profil/interests/volunteer_interest_card.dart';
import 'package:app/routes/profil/interests/volunteer_interest_filter.dart';
import 'package:app/routes/profil/interests/volunteer_interest_filter_bar.dart';
import 'package:app/routes/profil/interests/volunteer_interest_filter_provider.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/volunteer_database/models/volunteer_interest_overview_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays filtered volunteer interest requests.
class VolunteerInterestsContent extends ConsumerWidget {
  /// Creates overview content for [items].
  const VolunteerInterestsContent({required this.items, super.key});

  /// Complete interest request list.
  final List<VolunteerInterestOverviewModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const basePath = 'application.profile.volunteer_interests';
    final filter = ref.watch(volunteerInterestFilterProvider);
    final filteredItems = items
        .where((item) {
          return switch (filter) {
            VolunteerInterestFilter.all => true,
            VolunteerInterestFilter.received =>
              item.type == Enum_EhrenamtsbankAnfrageTyp.EMPFANGENE_ANFRAGE,
            VolunteerInterestFilter.sent =>
              item.type == Enum_EhrenamtsbankAnfrageTyp.EIGENE_ANFRAGE,
          };
        })
        .toList(growable: false);

    return RefreshIndicator(
      onRefresh: ref.read(volunteerInterestsProvider.notifier).refresh,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Heading('$basePath.title'.tr()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: VolunteerInterestFilterBar(interests: items),
          ),
          if (filteredItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  '$basePath.empty'.tr(),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...filteredItems.map(
              (item) => VolunteerInterestCard(interest: item),
            ),
        ],
      ),
    );
  }
}
