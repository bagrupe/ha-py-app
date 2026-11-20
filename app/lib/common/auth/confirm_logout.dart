import 'dart:async';

import 'package:app/common/auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _backupCheckTimeout = Duration(seconds: 20);

Future<bool> confirmLogout(BuildContext context, WidgetRef ref) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  final notifier = ref.read(asyncAuthProvider.notifier);
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    ),
  );

  var isBackedUp = false;
  try {
    isBackedUp = await notifier.ensureKeyBackup().timeout(_backupCheckTimeout);
  } on Object catch (error) {
    debugPrint(
      'confirmLogout: checking the backup failed: ${error.runtimeType}',
    );
  }
  navigator.pop();

  if (isBackedUp) return true;
  if (!context.mounted) return false;

  return _ask(context, 'application.profil.logout_backup');
}

Future<bool> confirmLogoutEverywhere(
  BuildContext context,
  WidgetRef ref,
) async {
  final confirmed = await _ask(context, 'application.profil.logout_everywhere');
  if (!confirmed || !context.mounted) return false;
  return confirmLogout(context, ref);
}

Future<void> showDeviceLoginKept(BuildContext context) async {
  const texts = 'application.profil.device_login_kept';
  final textTheme = Theme.of(context).textTheme;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      scrollable: true,
      title: Text('$texts.title'.tr(), style: textTheme.headlineMedium),
      content: Text('$texts.description'.tr()),
      actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      actions: [
        FilledButton(
          style: _buttonStyle(textTheme),
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text('$texts.confirm'.tr(), textAlign: TextAlign.center),
        ),
      ],
    ),
  );
}

ButtonStyle _buttonStyle(TextTheme textTheme) => ButtonStyle(
  alignment: Alignment.center,
  minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
  textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
);

Future<bool> _ask(BuildContext context, String texts) async {
  final textTheme = Theme.of(context).textTheme;
  final buttonStyle = _buttonStyle(textTheme);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      scrollable: true,
      title: Text('$texts.title'.tr(), style: textTheme.headlineMedium),
      content: Text('$texts.description'.tr()),
      actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              style: buttonStyle,
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('$texts.cancel'.tr(), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: buttonStyle,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('$texts.confirm'.tr(), textAlign: TextAlign.center),
            ),
          ],
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
