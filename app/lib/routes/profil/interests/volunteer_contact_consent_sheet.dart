import 'package:app/components/buttons/app_filled_button.dart';
import 'package:app/routes/profil/interests/volunteer_contact_privacy_hint.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Requests explicit mobile-number sharing consent for a volunteer match.
class VolunteerContactConsentSheet extends StatefulWidget {
  /// Creates the contact consent sheet.
  const VolunteerContactConsentSheet({super.key});

  @override
  State<VolunteerContactConsentSheet> createState() =>
      _VolunteerContactConsentSheetState();
}

class _VolunteerContactConsentSheetState
    extends State<VolunteerContactConsentSheet> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    const basePath = 'application.profile.volunteer_interests.actions.consent';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Semantics(
          container: true,
          label: '$basePath.title'.tr(),
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$basePath.title'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: '$basePath.close'.tr(),
                    excludeSemantics: true,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              const VolunteerContactPrivacyHint(),
              Transform.translate(
                offset: const Offset(-10, 0),
                child: Semantics(
                  checked: _accepted,
                  label: '$basePath.checkbox'.tr(),
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: () => setState(() => _accepted = !_accepted),
                    child: Row(
                      spacing: 8,
                      children: [
                        Checkbox(
                          value: _accepted,
                          onChanged: (value) =>
                              setState(() => _accepted = value ?? false),
                        ),
                        Expanded(child: Text('$basePath.checkbox'.tr())),
                      ],
                    ),
                  ),
                ),
              ),
              AppFilledButton(
                label: '$basePath.confirm'.tr(),
                trailingIcon: Icons.arrow_forward,
                onPressed: _accepted
                    ? () => Navigator.pop(context, true)
                    : null,
              ),
              SizedBox(
                height: MediaQuery.textScalerOf(
                  context,
                ).scale(48).clamp(48.0, 500.0),
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('$basePath.cancel'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
