import 'package:app/common/local_attachments/local_attachment_store.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Rechecks saved temporary files when the app returns to the foreground.
final missingAttachmentsProvider = Provider.autoDispose<bool>((ref) {
  final listener = AppLifecycleListener(onResume: ref.invalidateSelf);
  ref.onDispose(listener.dispose);
  return LocalAttachmentStore(
    ref.watch(sharedPreferencesProvider),
  ).hasMissingFiles;
});
