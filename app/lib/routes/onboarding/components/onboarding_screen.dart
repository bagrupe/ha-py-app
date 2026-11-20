import 'package:app/common/location_service.dart';
import 'package:app/routes/onboarding/components/personal_data_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

const double horizontalPadding = 20;

/// Bildschirm für den Onboarding-Prozess mit Text, Bild und optionalen Interaktionen.
class OnboardingScreen extends StatefulWidget {
  /// Erstellt einen Onboarding-Bildschirm mit den angegebenen Parametern.
  const OnboardingScreen({
    required this.text,
    required this.imagePath,
    super.key,
    this.title,
    this.customWidget,
    this.skip = false,
    this.oneStepBack,
    this.locationPermission = false,
    this.oneStepForward,
    this.personalData = false,
    this.formKey,
  });

  /// Optionaler Titel des Bildschirms.
  final String? title;

  /// Anzuzeigender Textinhalt.
  final String text;

  /// Pfad zum anzuzeigenden Bild.
  final String imagePath;

  /// Optionales benutzerdefiniertes Widget.
  final Widget? customWidget;

  /// Gibt an, ob eine Überspringen-Option angezeigt wird.
  final bool skip;

  /// Callback für einen Schritt zurück.
  final VoidCallback? oneStepBack;

  /// Callback für einen Schritt vorwärts.
  final VoidCallback? oneStepForward;

  /// Gibt an, ob Standortberechtigungen abgefragt werden sollen.
  final bool locationPermission;

  /// Gibt an, ob das Formular für persönliche Daten angezeigt wird.
  final bool personalData;

  /// Schlüssel für das Formular zur Validierung und Steuerung.
  final GlobalKey<FormBuilderState>? formKey;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

/// Zustandsklasse für den OnboardingScreen, verwaltet Lifecycle-Observer.
class _OnboardingScreenState extends State<OnboardingScreen>
    with WidgetsBindingObserver {
  final LocationLifecycleObserver _lifecycleObserver =
      LocationLifecycleObserver();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          SizedBox(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.oneStepBack != null)
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => widget.oneStepBack!.call(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: colorScheme.primary,
                        ),
                      ),
                    if (widget.skip)
                      InkWell(
                        onTap: () => widget.oneStepForward!.call(),
                        child: Text('Überspringen', style: textTheme.bodySmall),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(width: 160, image: AssetImage(widget.imagePath)),
                    if (widget.title != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          widget.title!,
                          style: textTheme.headlineMedium,
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      widget.text,
                      style: textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    if (widget.locationPermission)
                      StreamBuilder<bool>(
                        stream: LocationService.grantedStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            LocationService.updateGranted(force: true);
                            return const SizedBox.shrink();
                          }

                          if (snapshot.data!) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text('Berechtigungen wurden erteilt.'),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: InkWell(
                              onTap: () {
                                LocationService.requestPermission(
                                  context: context,
                                );
                              },
                              child: Text(
                                'Standortzugriff Erlauben',
                                style: textTheme.bodySmall?.apply(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                    if (widget.personalData) PersonalDataForm(widget.formKey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
