import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  /// shares content
  static Future<void> shareContent({
    required String? text,
    required GlobalKey buttonKey,
    String? title,
  }) async {
    final box = buttonKey.currentContext?.findRenderObject() as RenderBox?;

    final sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        title: title,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}
