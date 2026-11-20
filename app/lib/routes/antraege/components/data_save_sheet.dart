import 'package:app/components/heading/subheading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A modal bottom sheet prompt asking the user if they'd like to save
/// newly entered or modified application data back to their profile.
class DataSaveSheet extends ConsumerWidget {
  /// Creates a [DataSaveSheet] with the required callbacks.
  const DataSaveSheet({
    required this.onAccept,
    required this.onDecline,
    super.key,
  });

  /// Callback fired when the user agrees to save the data.
  final VoidCallback onAccept;

  /// Callback fired when the user declines saving the data.
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
            child: Icon(Icons.save_outlined, size: 40),
          ),
          const SizedBox(height: 16),
          SubHeading('application.data_save.title'.tr()),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('application.data_save.description'.tr()),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: onAccept,
                  child: Text('application.data_save.accept'.tr()),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onDecline,
                  child: Text('application.data_save.decline'.tr()),
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
