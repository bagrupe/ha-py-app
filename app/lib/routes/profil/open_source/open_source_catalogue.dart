import 'package:app/routes/profil/open_source/open_source_package.dart';
import 'package:app/routes/profil/open_source/open_source_package_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Keeps the search form and list position alive during navigation and backgrounding.
class OpenSourceCatalogue extends StatefulWidget {
  /// Creates the searchable catalogue.
  const OpenSourceCatalogue({required this.packages, super.key});

  /// Alphabetically sorted bundled dependencies.
  final List<OpenSourcePackage> packages;

  @override
  State<OpenSourceCatalogue> createState() => _OpenSourceCatalogueState();
}

/// Owns the local search form value.
class _OpenSourceCatalogueState extends State<OpenSourceCatalogue> {
  /// The current package search query.
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final packages = widget.packages
        .where((package) => package.name.toLowerCase().contains(_query))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text(
                'application.open_source.intro'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'application.open_source.search'.tr(),
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) =>
                    setState(() => _query = value.trim().toLowerCase()),
              ),
              Semantics(
                liveRegion: true,
                child: Text(
                  'application.open_source.count'.tr(
                    args: ['${packages.length}'],
                  ),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: packages.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('application.open_source.empty'.tr()),
                  ),
                )
              : ListView.builder(
                  key: PageStorageKey('open-source-$_query'),
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemCount: packages.length,
                  itemBuilder: (context, index) =>
                      OpenSourcePackageTile(package: packages[index]),
                ),
        ),
      ],
    );
  }
}
