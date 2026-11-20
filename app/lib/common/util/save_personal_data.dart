// ignore_for_file: cascade_invocations, unawaited_futures

import 'dart:async';
import 'dart:typed_data';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/personal_data.dart';
import 'package:app/common/auth/profile_gemeinde_provider.dart';
import 'package:app/common/crypto/byte_array_converters.dart';
import 'package:app/common/crypto/crypto.dart';
import 'package:app/common/extensions/encrypted_value.dart';
import 'package:app/common/extensions/string.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/user.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Encrypts a value with a key and returns an encrypted PersonalData-Input object.
/// [name] is the key name, [value] the value to be encrypted, [key] the encryption key.
Future<Input_BuergerPersonalDataInput> encryptToPersonalData(
  String name,
  dynamic value,
  Uint8List key,
) async {
  final bytes = await convertToByteArray(value);
  final encrypted = await Crypto.encrypt(bytes, key);

  return Input_BuergerPersonalDataInput(key: name, value: encrypted.toInput());
}

/// Saves personal data from a form, encrypts them and sends them to the server.
/// [ref] is the Riverpod-Widget-Reference, [formKey] the key of the form.
Future<void> savePersonalData(
  WidgetRef ref,
  GlobalKey<FormBuilderState> formKey,
) async {
  final form = formKey.currentState!;
  form.saveAndValidate();

  final vorname = form.value[PersonalDataKeys.vorname] as String?;
  final nachname = form.value[PersonalDataKeys.nachname] as String?;

  final progressNotifier = ref.watch(antragProgressProvider.notifier);

  final sanitized = form.instantValue.map(
    (key, value) => MapEntry(
      key.replaceFirst('image_multi_', '').replaceFirst('image_single_', ''),
      value,
    ),
  );
  await progressNotifier.saveFieldValues(sanitized);
  ref.invalidate(profileGemeindeProvider);

  final key = ref.read(authProvider).personalDataKey;
  if (key == null || vorname == null || nachname == null) {
    return;
  }

  final personalData = await Future.wait([
    encryptToPersonalData(PersonalDataKeys.vorname, vorname, key),
    encryptToPersonalData(PersonalDataKeys.nachname, nachname, key),
  ]);

  final client = ref.read(graphqlClientProvider);
  await client.mutate_UpdatePersonalData(
    Options_Mutation_UpdatePersonalData(
      variables: Variables_Mutation_UpdatePersonalData(
        input: Input_PersonalDataUpdateInput(personalData: personalData),
      ),
    ),
  );

  ref.invalidate(asyncPersonalDataProvider);
}

/// Canonical keys for personal data fields used in the profile to ensure consistent naming.
const personalDataCanonicalKeys = {
  'anrede': 'Anrede',
  'doktorgrad': 'Doktorgrad',
  'vorname': 'Vorname',
  'nachname': 'Nachname',
  'geschlecht': 'Geschlecht',
  'geburtsdatum': 'Geburtsdatum',
  'postleitzahl': 'Postleitzahl',
  'plz': 'Postleitzahl',
  'gemeinde': 'Gemeinde',
  'ort': 'Ort',
  'strasse': 'Straße',
  'hausnummer': 'Hausnummer',
  'zusatz': 'Adresszusatz',
  'adresszusatz': 'Adresszusatz',
};

/// Saves personal data collected/changed by the application,
/// encrypts them and sends them to the server,
/// and updates the SharedPreferences.
Future<void> saveExtractedPersonalData(
  WidgetRef ref,
  Map<String, dynamic> data,
) async {
  final key = ref.read(authProvider).personalDataKey;

  if (key == null) return;

  final profile = ref.read(personalDataProvider) ?? {};
  final personalDataList = <Input_BuergerPersonalDataInput>[];

  final dataForPrefs = <String, dynamic>{};

  for (final entry in data.entries) {
    if (entry.value == null) continue;

    final normalizedKey = entry.key.normalize();
    if (!personalDataCanonicalKeys.containsKey(normalizedKey)) continue;

    var valueForBe = entry.value;

    final prettyKeyForPrefs = personalDataCanonicalKeys[normalizedKey]!;
    dataForPrefs[prettyKeyForPrefs] = entry.value;

    if (valueForBe is String && valueForBe.isGermanDate) {
      valueForBe = valueForBe.toIsoDate();
    }

    final existingEntry = profile.entries.firstWhereOrNull(
      (profileEntry) => profileEntry.key.normalize() == normalizedKey,
    );

    if (existingEntry != null) {
      if (existingEntry.value?.toString() != valueForBe?.toString()) {
        personalDataList.add(
          await encryptToPersonalData(existingEntry.key, valueForBe, key),
        );
      }
    } else {
      personalDataList.add(
        await encryptToPersonalData(prettyKeyForPrefs, valueForBe, key),
      );
    }
  }

  // save to local profile
  final progressNotifier = ref.read(antragProgressProvider.notifier);
  await progressNotifier.saveFieldValues(dataForPrefs);

  if (personalDataList.isEmpty) return;

  // Save to backend profile
  final client = ref.read(graphqlClientProvider);
  await client.mutate_UpdatePersonalData(
    Options_Mutation_UpdatePersonalData(
      variables: Variables_Mutation_UpdatePersonalData(
        input: Input_PersonalDataUpdateInput(personalData: personalDataList),
      ),
    ),
  );

  ref.invalidate(asyncPersonalDataProvider);
  ref.invalidate(graphqlClientProvider);
}
