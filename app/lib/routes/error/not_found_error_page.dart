import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

/// A fallback page displayed when a link fails to resolve or load.
class NotFoundErrorPage extends StatelessWidget {
  /// Creates a new [NotFoundErrorPage].
  const NotFoundErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.not_found_error.title'.tr()),
        logo: true,
      ),
      body: Semantics(
        label: 'application.not_found_error.title'.tr(),
        hint: 'application.not_found_error.description'.tr(),
        header: true,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/empty_state.svg'),
                  const SizedBox(height: 64),
                  Text(
                    'application.not_found_error.title'.tr(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'application.not_found_error.description'.tr(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        context.go('/aktuelles');
                      },
                      child: Text(
                        'application.not_found_error.back_button'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Returns the route for the not_found Error page.
GoRoute notFoundErrorRoute() => GoRoute(
  path: '/not_found/error',
  pageBuilder: TransitionPageBuilders.noTransition(
    builder: (_, __) => const NotFoundErrorPage(),
  ),
);
