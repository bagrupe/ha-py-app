import 'package:app/common/auth/personal_data.dart';
import 'package:app/common/local_attachments/local_attachment_store.dart';
import 'package:app/common/local_attachments/missing_attachments_notice.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/util/save_personal_data.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/forms/app_dropdown_form_field.dart';
import 'package:app/components/gemeinde_select_field/gemeinde_select_field.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/components/image_picker/multi_image_picker.dart';
import 'package:app/components/image_picker/single_image_picker.dart';
import 'package:app/routes/profil/components/app_version_footer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'default_date_field.dart';
part 'default_field.dart';
part 'default_select_field.dart';
part 'default_text_field.dart';
part 'profile_additional_field.dart';
part 'profile_default_field.dart';
part 'profile_default_fields.dart';
part 'profile_initial_values.dart';

/// Records introductory setup completion independently of login state.
const profilFirstSetupCompletedKey = 'profil_first_setup_completed';

/// Displays and edits locally saved personal data.
/// Supports an introductory mode for initial profile setup.
class ProfilPersonalDataPage extends ConsumerStatefulWidget {
  const ProfilPersonalDataPage({super.key, this.firstSetup = false});

  /// Whether only the introductory profile fields are shown.
  final bool firstSetup;

  @override
  ConsumerState<ProfilPersonalDataPage> createState() =>
      _ProfilPersonalDataPageState();
}

/// Preserves the profile form state and initializes its saved values.
class _ProfilPersonalDataPageState
    extends ConsumerState<ProfilPersonalDataPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final personalData = ref.watch(personalDataProvider) ?? {};

    final prefs = ref.read(sharedPreferencesProvider);
    final initialValues = _profileInitialValues(prefs, personalData);

    final defaultFieldsToShow = widget.firstSetup
        ? defaultFields.where((field) => field.showInFirstSetup)
        : defaultFields;

    final additionalFields = widget.firstSetup
        ? null
        : prefs
              .getKeys()
              .where((key) {
                return key.startsWith('field_') &&
                    !defaultFields.any(
                      (field) => field.key == removePrefixes(key),
                    );
              })
              .map((key) {
                final value = prefs.getString(key);
                final name = key.replaceFirst('field_', '');

                return PersonalData(name, value);
              });

    return Scaffold(
      appBar: CommonAppBar(
        logo: widget.firstSetup,
        title: Text('application.profil.title'.tr()),
      ),
      body: SingleChildScrollView(
        key: const PageStorageKey('profile_personal_data'),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(
                widget.firstSetup
                    ? 'application.profil.personal_data.welcome'.tr()
                    : 'application.profil.menu.personal_data'.tr(),
                horizontalPadding: false,
              ),
              if (widget.firstSetup) ...[
                Text(
                  'application.profil.menu.personal_data'.tr(),
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('application.profil.personal_data.intro'.tr()),
              ],
              const SizedBox(height: 24),
              const MissingAttachmentsNotice(),
              FormBuilder(
                key: _formKey,
                initialValue: initialValues,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (index, field)
                        in defaultFieldsToShow.indexed) ...[
                      if (index > 0) const SizedBox(height: 16),
                      _ProfileDefaultField(field: field),
                    ],
                    if (additionalFields != null &&
                        additionalFields.isNotEmpty) ...[
                      for (final field in additionalFields) ...[
                        const SizedBox(height: 16),
                        _ProfileAdditionalField(field: field),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () async {
                  await savePersonalData(ref, _formKey);
                  if (widget.firstSetup) {
                    await ref
                        .read(sharedPreferencesProvider)
                        .setBool(profilFirstSetupCompletedKey, true);
                  }
                  if (context.mounted && context.canPop()) context.pop();
                },
                child: Text('application.profil.personal_data.save'.tr()),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AppVersionFooter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
