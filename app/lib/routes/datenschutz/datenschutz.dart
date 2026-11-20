import 'dart:async';

import 'package:app/common/kommune.dart';
import 'package:app/components/error/error_view.dart';
import 'package:app/components/markdown/markdown_view.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/routes/datenschutz/components/datenschutz_continue_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Key for storing whether the privacy policy has been acknowledged.
const String dsgvoGelesenKey = 'dsgvo_acknowledged';

/// Page for displaying the privacy policy (Datenschutzerklärung) of the app.
class DatenschutzerklaerungPage extends ConsumerStatefulWidget {
  /// Creates a [DatenschutzerklaerungPage].
  const DatenschutzerklaerungPage({super.key});

  @override
  ConsumerState<DatenschutzerklaerungPage> createState() =>
      _DatenschutzerklaerungPageState();
}

class _DatenschutzerklaerungPageState
    extends ConsumerState<DatenschutzerklaerungPage> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _hasError = false;
  bool _useMarkdownFallback = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _hasError = false;
              _useMarkdownFallback = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            if (!mounted || error.isForMainFrame == false) return;
            setState(() {
              _isLoading = false;
              _hasError = true;
              _useMarkdownFallback = true;
            });
          },
        ),
      );

    _loadInitialUrl();
  }

  Future<void> _loadInitialUrl() async {
    try {
      final kommune = await ref.read(kommuneProvider.future);
      if (!mounted) return;
      final rawUrl = kommune.rechtsTexte.privacy;

      if (rawUrl != null && rawUrl.isNotEmpty) {
        var url = rawUrl.trim();

        if (!url.startsWith('http')) {
          url = 'https://$url';
        }

        final uri = Uri.tryParse(url);

        if (uri != null && uri.hasScheme) {
          await _controller.loadRequest(uri);
          return;
        }
      }
    } catch (_) {}

    _activateFallback();
  }

  void _activateFallback() {
    if (!mounted) return;
    setState(() {
      _useMarkdownFallback = true;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      kommuneProvider.select((value) => value.value?.rechtsTexte.privacy),
      (previous, next) {
        if (previous != next) unawaited(_loadInitialUrl());
      },
    );
    final canPop = context.canPop();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('application.legal.datenschutz_title'.tr()),
          automaticallyImplyLeading: false,
          actions: [
            if (canPop)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (!_useMarkdownFallback)
                    WebViewWidget(controller: _controller),

                  if (_useMarkdownFallback)
                    const MarkdownView(
                      assetPath: 'assets/legal/datenschutz.md',
                    ),

                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),

                  if (_hasError && !_useMarkdownFallback)
                    ErrorView(
                      onRetry: _loadInitialUrl,
                      text: 'application.error.error_loading'.tr(),
                      buttonText: 'application.error.retry'.tr(),
                    ),
                ],
              ),
            ),
            if (!canPop) const DatenschutzContinueButton(),
          ],
        ),
      ),
    );
  }
}

/// Returns the route for the privacy policy page.
GoRoute datenschutzRoute() => GoRoute(
  path: '/datenschutz',
  pageBuilder: TransitionPageBuilders.sliding(
    builder: (_, __) => const DatenschutzerklaerungPage(),
  ),
);
