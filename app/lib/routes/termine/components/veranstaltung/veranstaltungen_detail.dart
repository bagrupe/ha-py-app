import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/util/open_external_web_link.dart';
import 'package:app/components/adresse_view.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/detail_page/detail_page.dart';
import 'package:app/components/detail_page/parts/content_block_renderer.dart';
import 'package:app/components/heading/subheading.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/graphql/__generated__/termine.graphql.dart';
import 'package:app/routes/termine/veranstaltungs_termin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart' show FetchPolicy;

part 'event_link_button.dart';

/// Displays the current backend details of an event occurrence.
class VeranstaltungDetailPage extends ConsumerWidget {
  /// Creates a detail page for the given backend event identifier.
  const VeranstaltungDetailPage({required this.id, super.key});

  /// The backend identifier of the displayed event.
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termin = GoRouterState.of(context).extra as VeranstaltungsTermin?;

    return Query_Veranstaltung_Widget(
      options: Options_Query_Veranstaltung(
        variables: Variables_Query_Veranstaltung(id: id),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {fetchMore, refetch}) {
        final veranstaltung = result.parsedData?.veranstaltungskalender;
        final titel = veranstaltung?.titel ?? 'application.events.title'.tr();

        if (veranstaltung == null) {
          return Scaffold(
            appBar: CommonAppBar(title: Text(titel)),
            body: result.isLoading
                ? Semantics(
                    label: 'application.events.loading'.tr(),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : ListErrorState(
                    message: result.hasException
                        ? 'application.error.offline_no_cache'.tr()
                        : 'application.events.unavailable'.tr(),
                    onRetry: () async {
                      await refetch?.call();
                    },
                  ),
          );
        }

        final inhalte = veranstaltung.inhalte ?? [];
        final weitereTermine =
            veranstaltung.timeAndLocation?.dates
                ?.where(
                  (d) =>
                      d.start != null &&
                      d.start!.isAfter(termin?.start ?? DateTime.now()),
                )
                .take(5)
                .map((d) => d.start!)
                .toList() ??
            [];

        final backendUrl = ref.read(appConfigProvider).backendUrl;
        final termineRoute = GoRouterState.of(context).uri.toString();
        final formattedStart = termin?.start.toIso8601String();
        final shareLink =
            '$backendUrl/deeplinks$termineRoute${formattedStart == null ? '' : '/$formattedStart'}';

        return Scaffold(
          appBar: CommonAppBar(title: Text(titel)),
          body: DetailPage(
            imageUrl: termin?.imageUrl,
            preTitle: termin?.formattedDateTimeString,
            title: veranstaltung.titel,
            subtitle: veranstaltung.subtitle,
            showTextSizer: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (inhalte.isEmpty &&
                    (veranstaltung.teaser?.isNotEmpty ?? false))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Text(veranstaltung.teaser!),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: inhalte
                        .map((e) => ContentBlockRenderer(block: e))
                        .toList(),
                  ),
                ),
                if (veranstaltung.timeAndLocation?.locationName != null) ...[
                  SubHeading(
                    'application.events.location'.tr(),
                    background: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Text(
                      veranstaltung.timeAndLocation?.locationName ?? '',
                    ),
                  ),
                ],
                if (veranstaltung.veranstalterAdresse != null) ...[
                  SubHeading(
                    'application.events.organizer'.tr(),
                    background: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: AdresseView.fromFragment(
                      veranstaltung.veranstalterAdresse!,
                    ),
                  ),
                ],
                if (veranstaltung.buchungsUrl != null ||
                    veranstaltung.ticketUrl != null ||
                    veranstaltung.anbieterUrl != null) ...[
                  SubHeading(
                    'application.events.provider'.tr(),
                    background: true,
                  ),
                  const SizedBox(height: 12),
                  if (veranstaltung.buchungsUrl != null)
                    _EventLinkButton(
                      'application.events.booking'.tr(),
                      veranstaltung.buchungsUrl!,
                    ),
                  if (veranstaltung.buchungsUrl != null &&
                      veranstaltung.ticketUrl != null)
                    const SizedBox(height: 12),
                  if (veranstaltung.ticketUrl != null)
                    _EventLinkButton(
                      'application.events.tickets'.tr(),
                      veranstaltung.ticketUrl!,
                    ),
                  if ((veranstaltung.buchungsUrl != null ||
                          veranstaltung.ticketUrl != null) &&
                      veranstaltung.anbieterUrl != null)
                    const SizedBox(height: 12),
                  if (veranstaltung.anbieterUrl != null)
                    _EventLinkButton(
                      'application.events.provider_link'.tr(),
                      veranstaltung.anbieterUrl!,
                    ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
            shareLink: shareLink,
            weitereTermine: weitereTermine,
            coordinates: veranstaltung.timeAndLocation?.coordinates,
          ),
        );
      },
    );
  }
}
