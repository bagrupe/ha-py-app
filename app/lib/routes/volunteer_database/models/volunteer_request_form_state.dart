/// Immutable state of the volunteer request creation workflow.
class VolunteerRequestFormState {
  /// Creates request form state.
  const VolunteerRequestFormState({
    this.step = 0,
    this.title = '',
    this.description = '',
    this.categoryId,
    this.municipalityId,
    this.address = '',
    this.hasAcceptedWhatsAppArrangement = false,
    this.estimatedDurationMinutes = 60,
    this.hasBarrierFreeAccess = false,
    this.isRemotePossible = false,
    this.hasPetFreeHousehold = false,
    this.photoPath,
  });

  /// Zero-based active workflow step.
  final int step;

  /// Request title.
  final String title;

  /// Request description.
  final String description;

  /// Selected category identifier.
  final String? categoryId;

  /// Selected municipality identifier.
  final String? municipalityId;

  /// Private street and house number entered for the request.
  final String address;

  /// Whether scheduling via WhatsApp has been explicitly accepted.
  final bool hasAcceptedWhatsAppArrangement;

  /// Estimated effort in minutes.
  final int estimatedDurationMinutes;

  /// Whether the location can be accessed without barriers.
  final bool hasBarrierFreeAccess;

  /// Whether help can be provided remotely.
  final bool isRemotePossible;

  /// Whether the household is free of pets.
  final bool hasPetFreeHousehold;

  /// Optional local photo path used for the preview.
  final String? photoPath;

  /// Whether the active step contains all required values.
  bool get canContinue => switch (step) {
    0 => title.trim().isNotEmpty && categoryId != null,
    1 => description.trim().isNotEmpty && estimatedDurationMinutes > 0,
    2 || 3 =>
      municipalityId != null &&
          address.trim().isNotEmpty &&
          hasAcceptedWhatsAppArrangement,
    _ => false,
  };

  /// Creates a changed copy of this state.
  VolunteerRequestFormState copyWith({
    int? step,
    String? title,
    String? description,
    String? categoryId,
    String? municipalityId,
    String? address,
    bool? hasAcceptedWhatsAppArrangement,
    int? estimatedDurationMinutes,
    bool? hasBarrierFreeAccess,
    bool? isRemotePossible,
    bool? hasPetFreeHousehold,
    String? photoPath,
    bool clearPhotoPath = false,
  }) {
    return VolunteerRequestFormState(
      step: step ?? this.step,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      municipalityId: municipalityId ?? this.municipalityId,
      address: address ?? this.address,
      hasAcceptedWhatsAppArrangement:
          hasAcceptedWhatsAppArrangement ?? this.hasAcceptedWhatsAppArrangement,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      hasBarrierFreeAccess: hasBarrierFreeAccess ?? this.hasBarrierFreeAccess,
      isRemotePossible: isRemotePossible ?? this.isRemotePossible,
      hasPetFreeHousehold: hasPetFreeHousehold ?? this.hasPetFreeHousehold,
      photoPath: clearPhotoPath ? null : photoPath ?? this.photoPath,
    );
  }
}
