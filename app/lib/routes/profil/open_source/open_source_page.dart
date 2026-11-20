import 'package:app/routes/profil/open_source/open_source_catalogue.dart';
import 'package:app/routes/profil/open_source/open_source_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A searchable offline catalogue of bundled open-source attributions.
class OpenSourcePage extends ConsumerWidget {
  /// Creates the catalogue page.
  const OpenSourcePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: Text('application.open_source.title'.tr())),
    body: ref
        .watch(openSourcePackagesProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  Text('application.open_source.error'.tr()),
                  FilledButton(
                    onPressed: () => ref.invalidate(openSourcePackagesProvider),
                    child: Text('application.open_source.retry'.tr()),
                  ),
                ],
              ),
            ),
          ),
          data: (packages) => OpenSourceCatalogue(packages: packages),
        ),
  );
}
