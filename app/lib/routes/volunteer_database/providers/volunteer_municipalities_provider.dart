import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/volunteer_database/volunteer_municipality_repository.dart';
import 'package:app/routes/volunteer_database/models/volunteer_municipality_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loads municipalities for the configured municipality association.
final volunteerMunicipalitiesProvider =
    FutureProvider<List<VolunteerMunicipalityModel>>((ref) {
      final municipalityAssociationId = ref.watch(appConfigProvider).kommuneId;
      return ref
          .watch(volunteerMunicipalityRepositoryProvider)
          .getMunicipalities(municipalityAssociationId);
    });
