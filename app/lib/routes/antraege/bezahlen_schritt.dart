// ignore_for_file: unawaited_futures, avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'dart:async';

import 'package:app/components/heading/subheading.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/graphql/__generated__/schritte.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/antraege/common/antrag_graphql_client.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/antrag_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Seite zur Abwicklung des Bezahlvorgangs innerhalb eines Antrags.
/// Verwaltet die Initiierung der Zahlung und überwacht den Status der Zahlung.
class AntragBezahlenPage extends ConsumerStatefulWidget {
  const AntragBezahlenPage({super.key});

  @override
  ConsumerState<AntragBezahlenPage> createState() => _AntragBezahlenPageState();
}

/// State-Klasse für die Zahlungsseite, die den Zahlungsprozess steuert und den UI-Status verwaltet.
class _AntragBezahlenPageState extends ConsumerState<AntragBezahlenPage>
    with WidgetsBindingObserver {
  bool _initiatedPayment = false;

  /// Startet den Bezahlvorgang für den übergebenen Bezahlen-Schritt.
  /// Ruft die Zahlungs-URL vom Backend ab und öffnet diese im externen Browser.
  Future<void> _initiatePayment(
    Fragment_Schritt__BezahlenSchritt schritt,
  ) async {
    setState(() => _initiatedPayment = true);

    final antrag = ref.read(antragProgressProvider)!;
    final client = withAntragRequestTimeout(ref.read(graphqlClientProvider));

    final response = await client.mutate_BezahlenSchrittUrl(
      Options_Mutation_BezahlenSchrittUrl(
        variables: Variables_Mutation_BezahlenSchrittUrl(
          ausfuehrungId: antrag.ausfuehrungId!,
          bezahlenSchrittId: schritt.id,
        ),
      ),
    );

    final zahlungsUrl = response.parsedData!.bezahlenSchrittUrl.string!;

    launchUrl(Uri.parse(zahlungsUrl), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final antragProgress = ref.watch(antragProgressProvider);
    final bezahlenSchritt = antragProgress!.bezahlenSchritt;
    final currentSchritt = antragProgress.schritt;

    if (bezahlenSchritt == null && !_initiatedPayment) {
      return const SizedBox.shrink();
    }

    return AntragLayout(
      canPop: false,
      onPopScope: (didPop, _) {
        if (didPop) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final shouldPop = !ref
              .read(antragProgressProvider.notifier)
              .vorigerSchritt();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        });
      },
      children: [
        if (currentSchritt.titel != null) SubHeading(currentSchritt.titel!),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: _initiatedPayment
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.start,
            children: [
              if (currentSchritt.anweisung != null) ...{
                Text(currentSchritt.anweisung!),
                const SizedBox(height: 36),
              },
              if (_initiatedPayment)
                const Column(
                  children: [
                    SizedBox(height: 30),
                    CircularProgressIndicator(),
                    SizedBox(height: 30),
                    Text('Warte auf den Abschluss der Zahlung'),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weiter klicken zum Bezahlen. Die Gebühr beträgt ${bezahlenSchritt!.betrag.toStringAsFixed(2).replaceAll('.', ',')}€.',
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => _initiatePayment(bezahlenSchritt),
                      child: const Text('Bezahlen'),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final schritt = ref.read(antragProgressProvider)?.schritt;
    final isWaitingForPayment =
        schritt is Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt;

    setState(() => _initiatedPayment = isWaitingForPayment);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  /// Prüft wiederholt den Status der Zahlung und aktualisiert den Fortschritt.
  /// Bricht nach 25 Versuchen ab, um Endlosschleifen zu vermeiden.
  Future<void> _updatePaymentStatus([retries = 0]) async {
    if (retries == 25) return;

    final antragProgress = ref.read(antragProgressProvider)!;
    final antragProgressNotifier = ref.read(antragProgressProvider.notifier);

    final continuedProgress = await antragProgressNotifier.continueAusfuehrung(
      id: antragProgress.ausfuehrungId!,
    );

    if (continuedProgress!.clientStatus == AntragClientStatus.paying) {
      Timer(
        const Duration(seconds: 1),
        () => _updatePaymentStatus(retries + 1),
      );
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _updatePaymentStatus();
    }
  }
}
