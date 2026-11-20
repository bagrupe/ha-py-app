import 'package:app/routes/volunteer_database/models/volunteer_request_form_state.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_municipalities_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the persisted volunteer request creation form.
class VolunteerRequestFormNotifier extends Notifier<VolunteerRequestFormState> {
  @override
  VolunteerRequestFormState build() {
    final initialMunicipalityId = ref
        .read(volunteerMunicipalitiesProvider)
        .value
        ?.firstOrNull
        ?.id;
    ref.listen(volunteerMunicipalitiesProvider, (previous, next) {
      next.whenData((municipalities) {
        if (state.municipalityId == null && municipalities.isNotEmpty) {
          state = state.copyWith(municipalityId: municipalities.first.id);
        }
      });
    });
    return VolunteerRequestFormState(municipalityId: initialMunicipalityId);
  }

  /// Updates the request title.
  void setTitle(String value) => state = state.copyWith(title: value);

  /// Updates the request description.
  void setDescription(String value) =>
      state = state.copyWith(description: value);

  /// Selects a request category.
  void setCategory(String value) => state = state.copyWith(categoryId: value);

  /// Selects a municipality.
  void setMunicipality(String value) =>
      state = state.copyWith(municipalityId: value);

  /// Updates the private street and house number.
  void setAddress(String value) => state = state.copyWith(address: value);

  /// Updates whether scheduling via WhatsApp has been accepted.
  void setWhatsAppArrangementAccepted(bool value) =>
      state = state.copyWith(hasAcceptedWhatsAppArrangement: value);

  /// Changes the estimated duration by [minutes].
  void changeDuration(int minutes) {
    final next = (state.estimatedDurationMinutes + minutes).clamp(30, 720);
    state = state.copyWith(estimatedDurationMinutes: next);
  }

  /// Updates whether barrier-free access is available.
  void setBarrierFreeAccess(bool value) =>
      state = state.copyWith(hasBarrierFreeAccess: value);

  /// Updates whether remote help is possible.
  void setRemotePossible(bool value) =>
      state = state.copyWith(isRemotePossible: value);

  /// Updates whether the household is free of pets.
  void setPetFreeHousehold(bool value) =>
      state = state.copyWith(hasPetFreeHousehold: value);

  /// Stores the local preview path of the selected photo.
  void setPhotoPath(String? value) => state = value == null
      ? state.copyWith(clearPhotoPath: true)
      : state.copyWith(photoPath: value);

  /// Advances to the next step when the current step is valid.
  void nextStep() {
    if (state.canContinue && state.step < 3) {
      state = state.copyWith(step: state.step + 1);
    }
  }

  /// Returns to the previous workflow step.
  void previousStep() {
    if (state.step > 0) state = state.copyWith(step: state.step - 1);
  }

  /// Resets the complete workflow.
  void reset() => state = const VolunteerRequestFormState();
}

/// Persisted state of the volunteer request creation workflow.
final volunteerRequestFormProvider =
    NotifierProvider<VolunteerRequestFormNotifier, VolunteerRequestFormState>(
      VolunteerRequestFormNotifier.new,
    );
