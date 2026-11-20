import 'dart:convert';

import 'package:app/routes/profil/open_source/open_source_package.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loads bundled licenses once and keeps them available without a connection.
final openSourcePackagesProvider = FutureProvider<List<OpenSourcePackage>>((
  ref,
) async {
  final source = await rootBundle.loadString('assets/licenses/packages.json');
  final entries = jsonDecode(source) as List<dynamic>;
  final sdkLicense =
      entries.cast<Map<String, dynamic>>().firstWhere(
            (entry) => entry['name'] == 'flutter',
          )['license']
          as String;
  for (final entry in entries.cast<Map<String, dynamic>>()) {
    if (entry['isSdk'] == true && entry['license'] == null) {
      entry['license'] = sdkLicense;
    }
  }
  return entries
      .map((entry) => OpenSourcePackage.fromJson(entry as Map<String, dynamic>))
      .toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
});
