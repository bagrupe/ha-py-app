import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_interest_submission_exception.dart';
import 'package:app/common/volunteer_database/volunteer_profile_provider.dart';
import 'package:app/components/buttons/app_filled_button.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_interest_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_ownership_provider.dart';
import 'package:app/routes/volunteer_database/widgets/logged_out_modal.dart';
import 'package:app/routes/volunteer_database/widgets/volunteer_interest_load_error.dart';
import 'package:app/routes/volunteer_database/widgets/volunteer_interest_requested_info.dart';
import 'package:app/routes/volunteer_database/widgets/volunteer_interest_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the interest form for a volunteer request.
class VolunteerInterestButton extends ConsumerWidget {
  /// Creates an interest button for [entryId] owned by [ownerId].
  const VolunteerInterestButton({
    required this.entryId,
    required this.ownerId,
    super.key,
  });

  /// Backend identifier of the volunteer request.
  final String entryId;

  /// Backend identifier of the user who owns the volunteer entry.
  final String ownerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const basePath = 'application.volunteer_database.details.interest';
    final userId = ref.watch(volunteerAuthProvider);

    final ownership = ref.watch(volunteerRequestOwnershipProvider(entryId));
    if (ownership.isLoading ||
        ownership.hasError ||
        (ownership.value ?? false)) {
      return const SizedBox.shrink();
    }

    final profile = ref.watch(volunteerProfileProvider);
    final submission = ref.watch(volunteerInterestProvider(entryId));
    final isRequested = submission.value?.isRequested ?? false;

    if (submission.hasError &&
        submission.error is! VolunteerInterestSubmissionException) {
      return VolunteerInterestLoadError(
        error: submission.error!,
        onRetry: () => ref.invalidate(volunteerInterestProvider(entryId)),
      );
    }

    if (isRequested) {
      return const VolunteerInterestRequestedInfo();
    }

    return AppFilledButton(
      label: '$basePath.button'.tr(),
      semanticLabel: '$basePath.semantics.open'.tr(),
      isLoading: submission.isLoading,
      onPressed: userId == null
          ? () => showLoggedOutModal(context)
          : profile.isLoading
          ? null
          : profile.value == null
          ? () => showLoggedOutModal(context)
          : () => _openSheet(context, ref),
    );
  }

  Future<void> _openSheet(BuildContext context, WidgetRef ref) async {
    ref
        .read(volunteerInterestProvider(entryId).notifier)
        .clearSubmissionError();
    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => VolunteerInterestSheet(entryId: entryId),
    );
    if (submitted != true || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'application.volunteer_database.details.interest.confirmation'.tr(),
        ),
      ),
    );
  }
}
