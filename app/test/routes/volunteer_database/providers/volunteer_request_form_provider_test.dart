import 'package:app/routes/volunteer_database/models/volunteer_municipality_model.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_municipalities_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_form_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies the volunteer request workflow state transitions.
void main() {
  test(
    'selects the first loaded municipality outside the widget build',
    () async {
      final container = ProviderContainer(
        overrides: [
          volunteerMunicipalitiesProvider.overrideWith(
            (ref) async => const [
              VolunteerMunicipalityModel(id: 'municipality-id', name: 'Hameln'),
            ],
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(volunteerRequestFormProvider);
      await container.read(volunteerMunicipalitiesProvider.future);
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(volunteerRequestFormProvider).municipalityId,
        'municipality-id',
      );
    },
  );

  test('does not advance when required values are missing', () {
    final container = _createContainer();
    addTearDown(container.dispose);

    container.read(volunteerRequestFormProvider.notifier).nextStep();

    expect(container.read(volunteerRequestFormProvider).step, 0);
  });

  test('advances after all required values are present', () {
    final container = _createContainer();
    addTearDown(container.dispose);

    container.read(volunteerRequestFormProvider.notifier)
      ..setTitle('Wer gießt meine Pflanzen?')
      ..setCategory('category-id')
      ..nextStep()
      ..setDescription('Ich benötige während meines Urlaubs Unterstützung.')
      ..nextStep()
      ..setMunicipality('municipality-id')
      ..setAddress('Musterstraße 12')
      ..setWhatsAppArrangementAccepted(true)
      ..nextStep();

    expect(container.read(volunteerRequestFormProvider).step, 3);
    expect(container.read(volunteerRequestFormProvider).canContinue, isTrue);
  });

  test('enforces the minimum duration', () {
    final container = _createContainer();
    addTearDown(container.dispose);

    container.read(volunteerRequestFormProvider.notifier).changeDuration(-1000);

    expect(
      container.read(volunteerRequestFormProvider).estimatedDurationMinutes,
      30,
    );
  });

  test('enforces the maximum duration', () {
    final container = _createContainer();
    addTearDown(container.dispose);

    container.read(volunteerRequestFormProvider.notifier).changeDuration(2000);

    expect(
      container.read(volunteerRequestFormProvider).estimatedDurationMinutes,
      720,
    );
  });

  test('preserves the selected photo path in the workflow state', () {
    final container = _createContainer();
    addTearDown(container.dispose);

    container
        .read(volunteerRequestFormProvider.notifier)
        .setPhotoPath('/tmp/request-photo.jpg');

    expect(
      container.read(volunteerRequestFormProvider).photoPath,
      '/tmp/request-photo.jpg',
    );
  });

  test('preserves the private address in the workflow state', () {
    final container = _createContainer();
    addTearDown(container.dispose);

    container
        .read(volunteerRequestFormProvider.notifier)
        .setAddress('Musterstraße 12');

    expect(
      container.read(volunteerRequestFormProvider).address,
      'Musterstraße 12',
    );
  });

  test('requires address and WhatsApp arrangement for the location step', () {
    final container = _createContainer();
    addTearDown(container.dispose);
    final notifier = container.read(volunteerRequestFormProvider.notifier)
      ..setTitle('Wer gießt meine Pflanzen?')
      ..setCategory('category-id')
      ..nextStep()
      ..setDescription('Ich benötige Unterstützung.')
      ..nextStep()
      ..setMunicipality('municipality-id');

    expect(container.read(volunteerRequestFormProvider).canContinue, isFalse);

    notifier.setAddress('Musterstraße 12');
    expect(container.read(volunteerRequestFormProvider).canContinue, isFalse);

    notifier.setWhatsAppArrangementAccepted(true);
    expect(container.read(volunteerRequestFormProvider).canContinue, isTrue);
  });
}

/// Creates an isolated form provider container without network dependencies.
ProviderContainer _createContainer() {
  return ProviderContainer(
    overrides: [
      volunteerMunicipalitiesProvider.overrideWith((ref) async => []),
    ],
  );
}
