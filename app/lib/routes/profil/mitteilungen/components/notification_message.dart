import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays an accessible, highlighted message from process handling.
class NotificationMessage extends StatelessWidget {
  /// Creates a notification message for the provided [text].
  const NotificationMessage({required this.text, super.key});

  /// Message content.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'application.notifications.message_semantics'.tr(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
