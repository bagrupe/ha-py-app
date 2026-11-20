part of 'profil_personal_data.dart';

/// Default profile fields with stable storage names and localized labels.
const List<DefaultField> defaultFields = [
  DefaultTextField(
    'Anrede',
    'application.profil.personal_data.fields.salutation',
    options: {
      'Herr': 'application.profil.personal_data.options.mr',
      'Frau': 'application.profil.personal_data.options.mrs',
      'Divers': 'application.profil.personal_data.options.diverse',
    },
  ),
  DefaultTextField(
    'Doktorgrad',
    'application.profil.personal_data.fields.academic_title',
  ),
  DefaultTextField(
    PersonalDataKeys.vorname,
    'application.profil.personal_data.fields.first_name',
    showInFirstSetup: true,
  ),
  DefaultTextField(
    PersonalDataKeys.nachname,
    'application.profil.personal_data.fields.last_name',
    showInFirstSetup: true,
  ),
  DefaultTextField(
    'Geschlecht',
    'application.profil.personal_data.fields.gender',
    options: {
      'Männlich': 'application.profil.personal_data.options.male',
      'Weiblich': 'application.profil.personal_data.options.female',
      'Divers': 'application.profil.personal_data.options.diverse',
    },
  ),
  DefaultDateField(
    'Geburtsdatum',
    'application.profil.personal_data.fields.birth_date',
  ),
  DefaultTextField(
    'Postleitzahl',
    'application.profil.personal_data.fields.postal_code',
  ),
  DefaultSelectField(
    PersonalDataKeys.gemeinde,
    'application.profil.personal_data.fields.municipality',
  ),
  DefaultTextField('Ort', 'application.profil.personal_data.fields.city'),
  DefaultTextField('Straße', 'application.profil.personal_data.fields.street'),
  DefaultTextField(
    'Hausnummer',
    'application.profil.personal_data.fields.house_number',
  ),
  DefaultTextField(
    'Adresszusatz',
    'application.profil.personal_data.fields.address_extra',
  ),
];

/// Removes storage prefixes while preserving backend-provided field names.
String removePrefixes(String key) =>
    key.replaceFirst('date_', '').replaceFirst('image_', '');
