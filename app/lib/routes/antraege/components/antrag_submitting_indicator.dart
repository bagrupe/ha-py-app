import 'dart:async';

import 'package:app/common/design_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Shown while an Antrag submission is in flight (e.g. large image uploads
/// that can take up to a minute due to the GraphQL request timeout).
/// Combines a pulsing icon with rotating status messages so the wait
/// doesn't read as the app having frozen.
class AntragSubmittingIndicator extends StatefulWidget {
  const AntragSubmittingIndicator({super.key});

  @override
  State<AntragSubmittingIndicator> createState() =>
      _AntragSubmittingIndicatorState();
}

class _AntragSubmittingIndicatorState extends State<AntragSubmittingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Ein einziges, statisches Semantik-Label für den ganzen Indikator statt
    // der wechselnden Zwischentexte – sonst unterbricht sich ein Screenreader
    // alle drei Sekunden selbst (s. Review-Kommentar).
    return Semantics(
      label: 'application.antraege.submitting.semantics.progress'.tr(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1.05).animate(
                CurvedAnimation(
                  parent: _pulseController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: 30,
                    color: theme.primaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'application.antraege.submitting.title'.tr(),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'application.antraege.submitting.subtitle'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: DesignTokens.gray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const ExcludeSemantics(child: _RotatingSubmitMessage()),
          ],
        ),
      ),
    );
  }
}

/// Rotiert alle drei Sekunden durch Status-Zwischentexte. In ein eigenes
/// Widget ausgelagert, damit nur dieser kleine Teilbaum bei jedem Wechsel neu
/// gebaut wird, statt des gesamten [AntragSubmittingIndicator] (inkl. der
/// unabhängig laufenden Puls-Animation).
class _RotatingSubmitMessage extends StatefulWidget {
  const _RotatingSubmitMessage();

  @override
  State<_RotatingSubmitMessage> createState() => _RotatingSubmitMessageState();
}

class _RotatingSubmitMessageState extends State<_RotatingSubmitMessage> {
  static const _messageKeys = [
    'application.antraege.submitting.message_encrypting',
    'application.antraege.submitting.message_transferring',
    'application.antraege.submitting.message_processing',
    'application.antraege.submitting.message_finishing',
  ];

  late final Timer _messageTimer;
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() => _messageIndex = (_messageIndex + 1) % _messageKeys.length);
    });
  }

  @override
  void dispose() {
    _messageTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Text(
        _messageKeys[_messageIndex].tr(),
        key: ValueKey(_messageIndex),
        style: theme.textTheme.bodySmall?.copyWith(
          color: DesignTokens.gray500,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
