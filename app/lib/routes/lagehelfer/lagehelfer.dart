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

  /// Brightness of the Flutter theme surrounding the web view.
  Brightness? _brightness;

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
          onPageFinished: (_) async {
            if (!mounted) return;
            await _applyBrightness();
            if (mounted) setState(() => _isLoading = false);
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    if (_brightness == brightness) return;
    _brightness = brightness;
    if (!_isLoading && !_hasError) _applyBrightness();
  }

  /// Switches the embedded page to the active app theme without reloading it.
  Future<void> _applyBrightness() async {
    final media = _brightness == Brightness.dark ? 'all' : 'not all';
    try {
      await _controller.runJavaScript(
        '''
        (() => {
          const darkTheme = document.getElementById("lagehelfer-dark-theme");
          if (darkTheme) {
            darkTheme.media = "$media";
            return;
          }

          const styles = document.querySelector(
            'link[rel="stylesheet"][href*="/lagehelfer/styles.css"]'
          );
          for (const rule of styles?.sheet?.cssRules ?? []) {
            if (rule instanceof CSSMediaRule &&
                rule.media.mediaText.includes("prefers-color-scheme")) {
              rule.media.mediaText = "$media";
              break;
            }
          }
        })();
        ''',
      );
    } on Exception {
      return;
    }
  }

  /// Opens the reporting start page for the configured municipality.
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
