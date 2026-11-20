import 'package:app/common/auth/personal_data.dart';
import 'package:app/common/extensions/string.dart';
import 'package:app/common/keys.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/util/save_personal_data.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/routes/antraege/common/antrag_meta.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/antrag_submitting_indicator.dart';
import 'package:app/routes/antraege/components/data_save_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Removes known prefixes from a key.
String _removePrefixes(String key) {
  return key.replaceFirst('date_', '').replaceFirst('image_', '');
}

/// Page for displaying the status when sending an application.
/// Shows loading state, success message or error message and provides navigation back to the overview.
class AntragSendenPage extends ConsumerStatefulWidget {
  /// Creates a new instance of the page for sending an application.
  /// [backToListButton] can be a custom button for returning to the overview.
  const AntragSendenPage({super.key, this.backToListButton});

  /// Optional button to be displayed instead of the default return-to-overview button.
  final Widget? backToListButton;

  @override
  ConsumerState<AntragSendenPage> createState() => _AntragSendenPageState();
}

class _AntragSendenPageState extends ConsumerState<AntragSendenPage> {
  bool _promptShown = false;

  bool _hasSavingDifferences(Map<String, dynamic> formValues) {
    if (formValues.isEmpty) return false;

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
        return MapEntry(name, value);
      }),
    };

    final normalizedInitial = initialValues.map(
      (key, value) => MapEntry(key.normalize(), value),
    );

    for (final key in formValues.keys) {
      final normalizedKey = key.normalize();
      if (!personalDataCanonicalKeys.containsKey(normalizedKey)) continue;

      if (normalizedInitial[normalizedKey]?.toString() !=
          formValues[key]?.toString()) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final antragProgress = ref.watch(antragProgressProvider);
    final antragMeta = ref.watch(antragMetaProvider);
    final notifier = ref.watch(antragProgressProvider.notifier);

    // check if there is data to save on 'submitted'
    ref.listen<AntragProgress?>(antragProgressProvider, (prev, current) {
      if (current?.clientStatus == AntragClientStatus.submitted &&
          !_promptShown) {
        _promptShown = true;
        final formValues = notifier.extractFormValues();

        if (_hasSavingDifferences(formValues)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (bottomSheetContext) {
                return DataSaveSheet(
                  onAccept: () async {
                    Navigator.of(bottomSheetContext).pop();
                    await saveExtractedPersonalData(ref, formValues);
                  },
                  onDecline: () {
                    Navigator.of(bottomSheetContext).pop();
                  },
                );
              },
            );
          });
        }
      }
    });

    if (antragProgress == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: CommonAppBar(title: Text(antragMeta.title)),
      body: Center(
        child: Builder(
          builder: (context) {
            if (antragProgress.clientStatus == AntragClientStatus.submitting) {
              return const AntragSubmittingIndicator();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (antragProgress.clientStatus == AntragClientStatus.submitted)
                  Heading(antragMeta.completedText),
                if (antragProgress.clientStatus ==
                    AntragClientStatus.errorSubmitting)
                  const Heading('Es ist ein Fehler aufgetreten'),
                if (antragProgress.clientStatus ==
                    AntragClientStatus.errorKeyUnavailable) ...[
                  Heading('application.antraege.key_unavailable.title'.tr()),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      'application.antraege.key_unavailable.description'.tr(),
                    ),
                  ),
                ],
                if (antragProgress.clientStatus ==
                    AntragClientStatus.errorKeyMismatch) ...[
                  Heading('application.antraege.key_mismatch.title'.tr()),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      'application.antraege.key_mismatch.description'.tr(),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (antragProgress.clientStatus ==
                    AntragClientStatus.errorSubmitting) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton(
                      onPressed: notifier.submit,
                      child: const Text('Erneut versuchen'),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      widget.backToListButton ??
                      OutlinedButton(
                        key: K.backToList,
                        onPressed: () {
                          // Don't reorder; ending the prozess clears the meta
                          final returnRoute = antragMeta.returnRoute;
                          notifier.endProzess();
                          context.go(returnRoute);
                        },
                        child: const Text('Zurück zur Übersicht'),
                      ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
