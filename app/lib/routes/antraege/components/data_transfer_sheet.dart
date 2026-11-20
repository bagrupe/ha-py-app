import 'package:app/components/heading/subheading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A modal bottom sheet prompt asking the user if they'd like to transfer
/// their existing profile data into the application form.
class DataTransferSheet extends ConsumerWidget {
  /// Creates a [DataTransferSheet] with the required callbacks.
  const DataTransferSheet({
    required this.onAccept,
    required this.onDecline,
    super.key,
  });

  /// Callback fired when the user agrees to transfer data.
  final VoidCallback onAccept;

  /// Callback fired when the user declines transferring data.
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.info_outline, size: 40),
          ),
          const SizedBox(height: 16),
          SubHeading('application.data_transfer.title'.tr()),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('application.data_transfer.description'.tr()),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: onAccept,
                  child: Text('application.data_transfer.accept'.tr()),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onDecline,
                  child: Text('application.data_transfer.decline'.tr()),
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
