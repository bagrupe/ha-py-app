import 'package:app/common/auth/personal_data.dart';
import 'package:app/common/extensions/string.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/util/save_personal_data.dart';
import 'package:app/graphql/__generated__/schritte.graphql.dart';
import 'package:app/routes/antraege/common/antrag_meta.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/data_transfer_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// Type alias for a process from the GraphQL query of the municipality's first steps.
typedef AntragAuswahlProzess =
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__Prozess;

/// Type alias for a ServicePortalLink from the GraphQL query of the municipality's first steps.
typedef AntragAuswahlServicePortalLink =
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items__ServicePortalLink;

/// Type alias for an entry that is either a process or a service from the GraphQL query.
typedef ProzessOrLeistung =
    Query_ErsteSchritte_kommune_prozesseUndLeistungen_items;

/// Removes known prefixes from a key.
String _removePrefixes(String key) {
  return key.replaceFirst('date_', '').replaceFirst('image_', '');
}

/// Starts an application based on the passed process or ServicePortalLink.
/// [p] is the selected process or link, [ref] the WidgetRef for the state, [context] the BuildContext for navigation.
void startAntrag(ProzessOrLeistung p, WidgetRef ref, BuildContext context) {
  switch (p) {
    case AntragAuswahlProzess(:final currentVersion)
        when currentVersion != null:
      final prefs = ref.read(sharedPreferencesProvider);
      final personalData = ref.read(personalDataProvider) ?? {};

      final allEntries = prefs.getKeys().map(
        (key) => MapEntry<String, dynamic>(key, prefs.get(key)),
      );

      final filteredEntries = allEntries.where(
        (entry) => entry.key.startsWith('field_'),
      );
      final savedValues = Map.fromEntries(filteredEntries);

      final initialValues = {
        ...personalData,
        ...savedValues.map((key, value) {
          final name = _removePrefixes(key.replaceFirst('field_', ''));
          return MapEntry(name.normalize(), value);
        }),
      };

      void proceed([EditableSlots slots = const {}]) {
        ref
            .read(antragProgressProvider.notifier)
            .startProzess(
              kommune: p.kommune,
              prozess: p,
              prozessVersion: currentVersion,
              initialSlots: slots,
            );

        ref
            .read(antragMetaProvider.notifier)
            .setMeta(
              const AntragMeta(
                'Anträge',
                'Erfolgreich beantragt!',
                'Antrag stellen',
                '/antraege',
              ),
            );

        context.replace('/antraege/schritt');
      }

      final needsPersonalData = currentVersion.ersteSchritte
          .expand((s) => s.slots)
          .any(
            (slot) =>
                personalDataCanonicalKeys.containsKey(slot.name.normalize()),
          );

      if (initialValues.isNotEmpty && needsPersonalData) {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (bottomSheetContext) {
            return DataTransferSheet(
              onAccept: () {
                Navigator.of(bottomSheetContext).pop();
                proceed(initialValues);
              },
              onDecline: () {
                Navigator.of(bottomSheetContext).pop();
                proceed();
              },
            );
          },
        );
      } else {
        proceed(needsPersonalData ? {} : initialValues);
      }

    case AntragAuswahlServicePortalLink(:final url):
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
