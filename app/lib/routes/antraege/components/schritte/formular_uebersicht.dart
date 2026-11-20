import 'dart:typed_data';

import 'package:app/common/design_tokens.dart';
import 'package:app/common/expressions/evaluating_visitor_service.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/checkbox_list_field/checkbox_list_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/upload_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/location_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/uebersicht_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_schritt.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Widget zur Darstellung der Übersicht eines Formularschritts mit seinen Feldern und deren Werten.
class FormularSchrittUebersicht extends ConsumerWidget {
  /// Erstellt eine Übersicht für den übergebenen Formularschritt mit den zugehörigen Slots und Fehlern.
  const FormularSchrittUebersicht({
    required this.schritt,
    required this.slots,
    required this.slotErrors,
    super.key,
  });

  /// Die Daten des Formularschritts.
  final FormularSchrittData schritt;

  /// Die aktuellen Werte der Slots.
  final EditableSlots slots;

  /// Die aktuellen Fehler der Slots.
  final EditableSlots slotErrors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: DesignTokens.gray100,
      child: FutureBuilder(
        future: renderFieldsAsync(schritt.felder, ref),
        builder: (context, snapshot) {
          if (snapshot.data == null) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [...?snapshot.data?.nonNulls],
          );
        },
      ),
    );
  }

  /// Erzeugt asynchron eine Liste von Widgets zur Übersicht der Formularfelder.
  /// Berücksichtigt die Relevanz der Felder und zeigt passende Übersichts-Widgets mit Werten und Fehlern an.
  Future<Iterable<Widget?>> renderFieldsAsync(
    List<Fragment_FormularFeld> formularFelder,
    WidgetRef ref,
  ) async {
    final evaluatingVisitor = ref.watch(evaluatingVisitorProvider);
    return Future.wait(
      schritt.felder.map<Future<Widget?>>((f) async {
        if (!await evaluatingVisitor.evaluateBool(f.istRelevant, slots)) {
          return null;
        }

        final slot = slots[f.slotName];
        final error = slotErrors[f.slotName] as String?;

        if (f.$__typename == 'AnzeigeTextBlockFeld') {
          return null;
        }

        if (slot == null) {
          return SimpleFieldUebersicht(
            title: f.angezeigterName ?? f.slotName,
            error: error,
            value: '---',
          );
        }

        if (f.$__typename == 'UploadFormularFeld') {
          final tempSlot = slot as List<dynamic>;
          // UploadFormularFeld kann ein leeres Array als Wert enthalten, wenn der Nutzer Bilder löscht.
          if (tempSlot.isEmpty) {
            return SimpleFieldUebersicht(
              title: f.angezeigterName ?? f.slotName,
              error: error,
              value: '---',
            );
          }

          return UploadFieldUebersicht(
            feld: f as FormularImageFeldData,
            error: error,
            slot: slot,
          );
        }

        if (f.$__typename == 'SignatureFormularFeld') {
          return Image(image: MemoryImage(slot as Uint8List), height: 210);
        }

        if (f.$__typename == 'LocationFormularFeld') {
          return SimpleFieldUebersicht(
            title: f.angezeigterName ?? f.slotName,
            error: error,
            value: slot is FormLocation && slot.addressString != null
                ? slot.addressString!
                : '---',
          );
        }

        if (f.$__typename == 'CheckboxListFormularFeld') {
          return CheckboxListFieldUebersicht(
            feld: f as FormularCheckboxFeldData,
            slot: slot,
            error: error,
          );
        }

        if (f.$__typename == 'DateFormularFeld') {
          final formatter = DateFormat('dd.MM.yyyy');

          return SimpleFieldUebersicht(
            title: f.angezeigterName ?? f.slotName,
            error: error,
            value: slot is DateTime ? formatter.format(slot) : '---',
          );
        }

        if (f.$__typename == 'TimeFormularFeld') {
          final formatter = DateFormat('hh:mm');
          return SimpleFieldUebersicht(
            title: f.angezeigterName ?? f.slotName,
            error: error,
            value: slot is DateTime ? '${formatter.format(slot)} Uhr' : '---',
          );
        }

        if (f.$__typename == 'StringFormularFeld') {
          if (f is Fragment_FormularFeld__StringFormularFeld &&
              f.stringOptions.isNotEmpty) {
            final stringOptions = f.stringOptions;
            final value = stringOptions
                .firstWhereOrNull((element) => element.key == slot)
                ?.value;

            return SimpleFieldUebersicht(
              title: f.angezeigterName ?? f.slotName,
              error: error,
              value: value ?? '---',
            );
          }
        }

        return SimpleFieldUebersicht(
          title: f.angezeigterName ?? f.slotName,
          error: error,
          value: slot is String && slot.isNotEmpty ? slot : '---',
        );
      }),
    );
  }
}
