import 'package:app/common/app_config/app_config.dart';
import 'package:app/components/error/error_view.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Displays the Lagehelfer application hosted by the configured backend.
class LagehelferPage extends ConsumerStatefulWidget {
  /// Creates the embedded Lagehelfer page.
  const LagehelferPage({super.key});

  @override
  ConsumerState<LagehelferPage> createState() => _LagehelferPageState();
}

class _LagehelferPageState extends ConsumerState<LagehelferPage> {
  late final WebViewController _controller;
  var _isLoading = true;
  var _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (!mounted || error.isForMainFrame == false) return;
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      );
    _loadLagehelfer();
  }

  Future<void> _loadLagehelfer() {
    final config = ref.read(appConfigProvider);
    final uri = Uri.parse(
      '${config.backendUrl.replaceFirst(RegExp(r'/$'), '')}/lagehelfer',
    ).replace(queryParameters: {'kommuneId': config.kommuneId});
    return _controller.loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('application.news.actions.lagehelfer'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/aktuelles'),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_hasError)
            ErrorView(
              onRetry: _loadLagehelfer,
              text: 'application.error.error_loading'.tr(),
              buttonText: 'application.error.retry'.tr(),
            ),
        ],
      ),
    );
  }
}

/// Route for the embedded Lagehelfer page.
final lagehelferRoute = GoRoute(
  path: '/lagehelfer',
  pageBuilder: TransitionPageBuilders.sliding(
    builder: (_, __) => const LagehelferPage(),
  ),
);
