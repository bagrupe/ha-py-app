import 'dart:async';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/gemeinde_prefs.dart';
import 'package:app/common/loading/loading.dart';
import 'package:app/common/location_service.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/util/save_personal_data.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/main_menu_drawer.dart';
import 'package:app/components/transition_page/transition_page_builders.dart';
import 'package:app/routes/onboarding/components/onboarding_screen.dart';
import 'package:app/routes/onboarding/components/onboarding_setup_error_dialog.dart';
import 'package:app/routes/onboarding/onboarding_auth_retry.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

const String onboardingIntroCompletedKey = 'onboarding_intro_completed';

/// Maximum time the onboarding setup waits for authentication.
const Duration onboardingSetupTimeout = Duration(seconds: 15);

/// Seite für die Einführung im Onboarding-Prozess mit mehreren Bildschirmen.
class OnboardingIntroPage extends ConsumerStatefulWidget {
  const OnboardingIntroPage({super.key});

  @override
  ConsumerState<OnboardingIntroPage> createState() =>
      _OnboardingIntroPageState();
}

const double horizontalPadding = 20;

/// Zustandsklasse für die OnboardingIntroPage, verwaltet Seitenwechsel und Formular.
class _OnboardingIntroPageState extends ConsumerState<OnboardingIntroPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  /// Whether the onboarding completion flow is currently running.
  bool _isCompleting = false;

  List<OnboardingScreen>? _onboardingScreens;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Öffnet die End-Drawer des Scaffold.
  void _openEndDrawer() => _scaffoldKey.currentState?.openEndDrawer();

  /// Erzeugt die Liste der Onboarding-Bildschirme basierend auf Berechtigungen.
  Future<List<OnboardingScreen>> _getOnboardingScreens() async {
    final locationPermission = await Geolocator.checkPermission();
    final screens = [
      const OnboardingScreen(
        text:
            'Bleiben Sie immer auf dem neusten Stand mit der praktischen Terminübersicht!',
        imagePath: 'assets/images/onboarding/onboarding_1.png',
      ),
      OnboardingScreen(
        text:
            'Mit der Karte finden Sie sich schnell zurecht, oder entdecken neue Orte in der Region.',
        imagePath: 'assets/images/onboarding/onboarding_2.png',
        oneStepBack: _goToPrevPage,
      ),
    ];

    if (locationPermission != LocationPermission.whileInUse &&
        locationPermission != LocationPermission.always &&
        locationPermission != LocationPermission.deniedForever) {
      screens.add(
        OnboardingScreen(
          text:
              'Die App benötigt Zugriff auf Ihren Standort um Ihre Position auf der Karte bestimmen zu können.',
          imagePath: 'assets/images/onboarding/onboarding_3.png',
          oneStepBack: _goToPrevPage,
          skip: true,
          oneStepForward: () async {
            await LocationService.requestPermission(context: context);
            await _goToNextPage();
          },
          locationPermission: true,
        ),
      );
    }

    screens.add(
      OnboardingScreen(
        title: 'Schön Sie kennenzulernen!',
        text:
            'Bitte geben Sie zunächst Ihren Namen ein. Sie können diese Angaben später vervollständigen oder bearbeiten.',
        imagePath: 'assets/images/onboarding/onboarding_4.png',
        oneStepBack: _goToPrevPage,
        skip: true,
        oneStepForward: _completeOnboarding,
        personalData: true,
        formKey: _formKey,
      ),
    );

    return screens;
  }

  @override
  void initState() {
    super.initState();

    _getOnboardingScreens().then(
      (screens) => setState(() => _onboardingScreens = screens),
    );
  }

  /// Navigiert zur vorherigen Seite, falls möglich.
  void _goToPrevPage() {
    if (_pageIndex != 0) {
      setState(() {
        _pageIndex = _pageIndex - 1;
      });
      _pageController.animateToPage(
        _pageIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }
  }

  /// Navigiert zur nächsten Seite.
  Future<void> _goToNextPage() async {
    setState(() {
      _pageIndex = _pageIndex + 1;
    });
    await _pageController.animateToPage(
      _pageIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  /// Schließt das Onboarding ab, speichert Daten und navigiert weiter.
  Future<void> _completeOnboarding() async {
    if (_isCompleting) return;
    _isCompleting = true;

    final loading = ref.read(globalLoadingControllerProvider.notifier);
    unawaited(
      loading.show(context, 'application.onboarding.setup.loading'.tr()),
    );

    try {
      await _waitForAuthentication();

      await savePersonalData(ref, _formKey);
      final gemeindeFilter = ref.read(gemeindeFilterProvider.notifier);
      final nextGemeinde = _formKey.currentState?.value['Gemeinde'];
      if (nextGemeinde is String) {
        gemeindeFilter.updateGemeindeFilter([nextGemeinde]);
      }
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setBool(onboardingIntroCompletedKey, true);

      await loading.hide();

      if (mounted) {
        context.go('/aktuelles');
      }
    } on Object catch (error, stackTrace) {
      debugPrint('Onboarding setup failed: $error\n$stackTrace');
      await _showSetupError(loading);
    } finally {
      _isCompleting = false;
    }
  }

  /// Waits until authentication is ready or the setup timeout is reached.
  Future<void> _waitForAuthentication() async {
    final authCompleter = Completer<void>();
    final providerSubscription = ref.listenManual(authProvider, (
      previous,
      next,
    ) {
      if (next.personalDataKey != null && !authCompleter.isCompleted) {
        authCompleter.complete();
      }
    }, fireImmediately: true);

    try {
      await authCompleter.future.timeout(onboardingSetupTimeout);
    } finally {
      providerSubscription.close();
    }
  }

  /// Hides the loading state and offers another setup attempt.
  Future<void> _showSetupError(GlobalLoadingController loading) async {
    await loading.hide();

    if (mounted) {
      unawaited(
        OnboardingSetupErrorDialog.show(
          context,
          onRetry: _retryOnboardingSetup,
        ),
      );
    }
  }

  /// Restarts setup and authentication after a failed attempt.
  void _retryOnboardingSetup() {
    if (shouldRestartOnboardingAuthentication(ref.read(asyncAuthProvider))) {
      ref.invalidate(asyncAuthProvider);
    }
    unawaited(_completeOnboarding());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screens = _onboardingScreens;

    return Scaffold(
      endDrawer: kDebugMode ? const MainMenuDrawer() : null,
      appBar: kDebugMode
          ? CommonAppBar(
              title: const Text('Onboarding'),
              customOnPressed: _openEndDrawer,
            )
          : null,
      body: screens == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: PageView(
                        onPageChanged: (index) {
                          setState(() {
                            _pageIndex = index;
                          });
                        },
                        controller: _pageController,
                        children: screens,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: DotsIndicator(
                            dotsCount: screens.length,
                            position: _pageIndex.toDouble(),
                            decorator: DotsDecorator(
                              size: const Size(10, 10),
                              activeSize: const Size(10, 10),
                              activeColor: theme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed:
                              screens[_pageIndex].oneStepForward ??
                              _goToNextPage,
                          child: const Text('Weiter'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Definiert die Route zur Onboarding-Einführungsseite.
final onboardingIntroRoute = GoRoute(
  path: '/onboarding-intro',
  pageBuilder: TransitionPageBuilders.sliding(
    builder: (_, __) => const OnboardingIntroPage(),
  ),
);
