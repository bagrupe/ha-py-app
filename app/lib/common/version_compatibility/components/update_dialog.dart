import 'package:app/common/version_compatibility/store_url_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A dialog widget that informs the user that their current application version
/// is incompatible with the server and requires an update.
///
/// This dialog forces the user to update by providing a link to the respective
/// App Store or Play Store.
class UpdateDialog extends StatelessWidget {
  const UpdateDialog({
    required this.appVersion,
    required this.minimumCompatibleAppVersion,
    super.key,
  });

  /// The current version of the app installed on the user's device.
  final String appVersion;

  /// The minimum version required by the server to continue using the app.
  final String minimumCompatibleAppVersion;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.system_update_rounded,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'application.version_compatibility.title'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              'application.version_compatibility.message'.tr(
                namedArgs: {
                  'current_version': appVersion,
                  'required_version': minimumCompatibleAppVersion,
                },
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: StoreUrlProvider.launchStore,
                child: Text('application.version_compatibility.update'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
