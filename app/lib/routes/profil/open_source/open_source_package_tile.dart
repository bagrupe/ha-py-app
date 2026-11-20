import 'package:app/routes/profil/open_source/open_source_detail_page.dart';
import 'package:app/routes/profil/open_source/open_source_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// An accessible package row opening its full license notice.
class OpenSourcePackageTile extends StatelessWidget {
  /// Creates a package row.
  const OpenSourcePackageTile({required this.package, super.key});

  /// The resolved package metadata.
  final OpenSourcePackage package;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(
        Icons.inventory_2_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(package.name),
      subtitle: Text(
        package.version.isEmpty
            ? 'application.open_source.sdk'.tr()
            : 'application.open_source.version'.tr(args: [package.version]),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => OpenSourceDetailPage(package: package),
        ),
      ),
    ),
  );
}
