// ignore_for_file: inference_failure_on_function_return_type

import 'package:app/common/app_config/app_config.dart';
import 'package:app/components/heading/subheading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ein Bottom Sheet, das den Nutzer darauf hinweist, dass nicht alle Daten korrekt ausgefüllt sind.
/// Bietet Optionen zum Fortfahren mit unvollständigen Daten oder zur Korrektur der Daten.
class DatenUnvollstaendigSheet extends ConsumerStatefulWidget {
  /// Erstellt ein neues DatenUnvollstaendigSheet mit den erforderlichen Callbacks.
  const DatenUnvollstaendigSheet({
    required this.onSkip,
    required this.onAmend,
    super.key,
  });

  /// Callback, der ausgeführt wird, wenn der Nutzer mit den aktuellen Daten fortfahren möchte.
  final Function() onSkip;

  /// Callback, der ausgeführt wird, wenn der Nutzer die Daten korrigieren möchte.
  final Function() onAmend;

  @override
  ConsumerState<DatenUnvollstaendigSheet> createState() =>
      _DatenUnvollstaendigSheetState();
}

class _DatenUnvollstaendigSheetState
    extends ConsumerState<DatenUnvollstaendigSheet> {
  // Wir benutzen einen eigenen State hier, damit sich die View beim Ändern der Checkbox nicht neu
  // rendert und der Navigation Stack nicht kaputt geht. Der Wert wird so erst beim Navigieren gespeichert.
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    final appConfigNotifier = ref.watch(appConfigProvider.notifier);

    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.warning, size: 40),
          ),
          const SizedBox(height: 16),
          SubHeading('application.antraege.unvollstaendig_sheet.title'.tr()),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'application.antraege.unvollstaendig_sheet.description'.tr(),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Checkbox(
                  value: _dontShowAgain,
                  onChanged: (bool? value) {
                    setState(() {
                      _dontShowAgain = value ?? false;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'application.antraege.unvollstaendig_sheet.dont_show_again'
                        .tr(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                FilledButton(
                  onPressed: () {
                    appConfigNotifier.setProzessPromptOnSkip(!_dontShowAgain);
                    widget.onSkip();
                  },
                  child: Text(
                    'application.antraege.unvollstaendig_sheet.continue_button'
                        .tr(),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    appConfigNotifier.setProzessPromptOnSkip(!_dontShowAgain);
                    widget.onAmend();
                  },
                  child: Text(
                    'application.antraege.unvollstaendig_sheet.correct_button'
                        .tr(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
