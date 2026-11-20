// ignore_for_file: strict_raw_type

import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/heading/heading.dart';
import 'package:app/routes/antraege/common/antrag_meta.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'antrag_content_loading_placeholder.dart';

/// Layout-Komponente für die Darstellung eines Antrags mit AppBar und Inhalt.
/// Nutzt Riverpod zur Beobachtung des Antragsfortschritts und der Metadaten.
/// Ermöglicht das Steuern des Pop-Verhaltens der Seite.
class AntragLayout extends ConsumerWidget {
  /// Erstellt ein neues AntragLayout mit den angegebenen Parametern.
  const AntragLayout({
    required this.canPop,
    required this.children,
    super.key,
    this.onPopScope,
    this.contentReadyListenable,
  });

  /// Die untergeordneten Widgets, die im Layout angezeigt werden.
  final List<Widget> children;

  /// Callback, der beim Poppen der Seite mit Ergebnis aufgerufen wird.
  final PopInvokedWithResultCallback? onPopScope;

  /// Gibt an, ob das Poppen der Seite erlaubt ist.
  final bool canPop;

  final ValueListenable<bool>? contentReadyListenable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(antragProgressProvider);
    final meta = ref.watch(antragMetaProvider);
    if (progress == null) return const SizedBox.shrink();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Heading(progress.prozess.name), ...children],
    );

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPopScope,
      child: Scaffold(
        appBar: CommonAppBar(title: Text(meta.title)),
        body: SingleChildScrollView(
          child: contentReadyListenable == null
              ? content
              : ValueListenableBuilder<bool>(
                  valueListenable: contentReadyListenable!,
                  builder: (context, ready, _) => Stack(
                    children: [
                      Offstage(offstage: !ready, child: content),
                      if (!ready) const _AntragContentLoadingPlaceholder(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
