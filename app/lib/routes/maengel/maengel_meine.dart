import 'package:app/components/lists/empty_state.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/components/lists/loading_state.dart';
import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:app/routes/maengel/common/mangel.dart';
import 'package:app/routes/maengel/components/maengel_animated_section.dart';
import 'package:app/routes/melder/common/report_workflow_configs.dart';
import 'package:app/routes/melder/components/report_create_button.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seite zur Anzeige der vom Nutzer gemeldeten und gefolgten Mängel.
class MaengelMeinePage extends ConsumerWidget {
  const MaengelMeinePage({super.key});

  /// Baut das Widget mit den Mängeln des aktuellen Nutzers.
  /// Zeigt gemeldete und gefolgte Mängel sortiert nach Kategorie an oder eine Nachricht, wenn keine Einträge vorhanden sind.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabActive = TickerMode.valuesOf(context).enabled;

    return Query_MeineMaengel_Widget(
      options: Options_Query_MeineMaengel(
        pollInterval: tabActive ? const Duration(seconds: 15) : null,
      ),
      builder: (result, {refetch, fetchMore}) {
        if (result.hasException) {
          return ListErrorState(
            message: maengelMelderConfig.errorMessageKey.tr(),
            onRetry: refetch,
          );
        }

        if (result.isLoading && result.parsedData == null) {
          return const ListLoadingState();
        }

        final data = result.parsedData?.my;
        if (data == null || data is! Query_MeineMaengel_my__Buerger) {
          return ListEmptyState(
            message: 'application.melder.user_data_error'.tr(),
          );
        }

        final maengel = data.maengel.sortedBy(
          (m) => Mangel.fromMaengelAusfuehrung(m).kategorie,
        );
        final gefolgte = data.gefolgteAusfuehrungen.sortedBy(
          (m) => Mangel.fromMaengelAusfuehrung(m).kategorie,
        );

        if (maengel.isEmpty && gefolgte.isEmpty) {
          return Stack(
            children: [
              ListEmptyState(message: maengelMelderConfig.emptyMessageKey.tr()),
              const Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ReportCreateButton(config: maengelMelderConfig),
              ),
            ],
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async => refetch?.call(),
                child: CustomScrollView(
                  slivers: [
                    MaengelAnimatedSection(
                      title: 'application.melder.maengel.reported_title'.tr(),
                      maengel: maengel
                          .map(Mangel.fromMaengelAusfuehrung)
                          .toList(),
                    ),
                    MaengelAnimatedSection(
                      title: 'application.melder.maengel.followed_title'.tr(),
                      maengel: gefolgte
                          .map(Mangel.fromMaengelAusfuehrung)
                          .toList(),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),
              ),
              const Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: ReportCreateButton(config: maengelMelderConfig),
              ),
            ],
          ),
        );
      },
    );
  }
}
