import 'package:app/common/design_tokens.dart';
import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/common/theme.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/routes/profil/mitteilungen/components/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget zur Darstellung der Einstellungen für Mitteilungen im Profilbereich.
class Mitteilungseinstellungen extends ConsumerWidget {
  const Mitteilungseinstellungen({super.key});

  /// Baut das Widget mit den verschiedenen Einstellungsmöglichkeiten für Mitteilungen.
  /// Nutzt [WidgetRef], um auf den aktuellen Theme-Zustand zuzugreifen.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return Scaffold(
      appBar: const CommonAppBar(title: Text('Profil')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Heading('Mitteilungseinstellungen'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: DesignTokens.gray100,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          'Benachrichtigungen',
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(color: theme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isFirebasePushAvailable) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: DesignTokens.gray100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            'News',
                            style: Theme.of(context).textTheme.headlineSmall!
                                .copyWith(color: theme.primaryColor),
                          ),
                        ),
                        const NewsBenachrichtungen(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
