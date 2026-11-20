import 'package:app/common/design_tokens.dart';
import 'package:app/common/volunteer_database/volunteer_interest_submission_exception.dart';
import 'package:app/components/buttons/app_filled_button.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_interest_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modal form for submitting interest in a volunteer request.
class VolunteerInterestSheet extends ConsumerStatefulWidget {
  /// Creates an interest form for [entryId].
  const VolunteerInterestSheet({required this.entryId, super.key});

  /// Backend identifier of the volunteer request.
  final String entryId;

  @override
  ConsumerState<VolunteerInterestSheet> createState() =>
      _VolunteerInterestSheetState();
}

class _VolunteerInterestSheetState
    extends ConsumerState<VolunteerInterestSheet> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const basePath = 'application.volunteer_database.details.interest';
    final submission = ref.watch(volunteerInterestProvider(widget.entryId));
    final error = submission.error;
    final messageKey = error is VolunteerInterestSubmissionException
        ? error.messageKey
        : '$basePath.errors.generic';

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          12 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Semantics(
          container: true,
          label: '$basePath.semantics.sheet'.tr(),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
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
                    label: '$basePath.semantics.close'.tr(),
                    excludeSemantics: true,
                    child: IconButton(
                      onPressed: submission.isLoading
                          ? null
                          : () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              Text(
                '$basePath.description'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Semantics(
                textField: true,
                label: '$basePath.semantics.message'.tr(),
                child: TextField(
                  controller: _messageController,
                  enabled: !submission.isLoading,
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: '$basePath.message_label'.tr(),
                    alignLabelWithHint: true,
                    counterText: '',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: DesignTokens.green900,
                  ),
                  Expanded(
                    child: Text(
                      '$basePath.privacy_hint'.tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              if (submission.hasError)
                Semantics(
                  liveRegion: true,
                  child: Text(
                    messageKey.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              AppFilledButton(
                label: '$basePath.submit'.tr(),
                semanticLabel: '$basePath.semantics.submit'.tr(),
                trailingIcon: Icons.arrow_forward,
                isLoading: submission.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final succeeded = await ref
        .read(volunteerInterestProvider(widget.entryId).notifier)
        .submit(_messageController.text);
    if (succeeded && mounted) {
      ref.invalidate(volunteerInterestsProvider);
      Navigator.pop(context, true);
    }
  }
}
