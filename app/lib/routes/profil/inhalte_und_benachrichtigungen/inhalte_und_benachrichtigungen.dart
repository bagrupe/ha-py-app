import 'package:app/common/theme.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/routes/profil/inhalte_und_benachrichtigungen/components/abfall.dart';
import 'package:app/routes/profil/inhalte_und_benachrichtigungen/components/news_und_veranstaltungen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InhalteUndBenachrichtigungenPage extends ConsumerWidget {
  const InhalteUndBenachrichtigungenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return Scaffold(
      appBar: const CommonAppBar(title: Text('Profil')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Heading(
                'Inhalte & Benachrichtigungen',
                horizontalPadding: false,
              ),
              const Text(
                'Wählen Sie aus für welche Gemeinden Sie News und Veranstaltungen sehen und legen Sie Benachrichtigungseinstellungen für verschiedene Bereiche fest.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Text(
                'News & Veranstaltungen',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const NewsUndVeranstaltungenPage(),
              const SizedBox(height: 16),
              Text(
                'Müllabfuhr',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const AbfallBenachrichtigungen(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
