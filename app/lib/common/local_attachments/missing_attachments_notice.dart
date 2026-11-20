import 'package:app/common/local_attachments/missing_attachments_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Explains why previously selected attachments need to be selected again.
class MissingAttachmentsNotice extends ConsumerWidget {
  /// Creates a notice for saved files removed from temporary storage.
  const MissingAttachmentsNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(missingAttachmentsProvider)) return const SizedBox.shrink();
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'application.attachments.missing'.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
