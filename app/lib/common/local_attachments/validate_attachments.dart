import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

/// Requests reselection if the system has removed a selected temporary file.
String? validateAttachments(List<dynamic>? files) {
  if (kIsWeb || files == null) return null;
  for (final file in files.whereType<XFile>()) {
    if (file.path.isNotEmpty && !File(file.path).existsSync()) {
      return 'application.attachments.missing'.tr();
    }
  }
  return null;
}
