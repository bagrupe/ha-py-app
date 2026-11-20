import 'package:app/routes/profil/components/package_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that shows the app version number
class AppVersionFooter extends ConsumerWidget {
  const AppVersionFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);
    final theme = Theme.of(context);

    return packageInfo.when(
      data: (info) => Column(
        children: [
          Text(
            'App-Version',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.disabledColor,
            ),
          ),
          Text(
            'v${info.version} (${info.buildNumber})',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.disabledColor,
            ),
          ),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
