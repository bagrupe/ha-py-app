import 'package:app/routes/profil/open_source/open_source_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays a complete selectable license with accessible package metadata.
class OpenSourceDetailPage extends StatelessWidget {
  /// Creates a license detail page.
  const OpenSourceDetailPage({required this.package, super.key});

  /// The package whose license is displayed.
  final OpenSourcePackage package;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(package.name)),
    body: SingleChildScrollView(
      key: PageStorageKey(package.name),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            package.version.isEmpty
                ? 'application.open_source.sdk'.tr()
                : 'application.open_source.version'.tr(args: [package.version]),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Semantics(
            header: true,
            child: Text(
              'application.open_source.license'.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SelectableText(
            package.license.isEmpty
                ? 'application.open_source.missing'.tr()
                : package.license,
          ),
        ],
      ),
    ),
  );
}
