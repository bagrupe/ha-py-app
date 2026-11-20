import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OriginalArticleButton extends StatelessWidget {
  const OriginalArticleButton({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () =>
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      icon: const Icon(Icons.open_in_new),
      label: Text('application.news.original_article'.tr()),
    );
  }
}
