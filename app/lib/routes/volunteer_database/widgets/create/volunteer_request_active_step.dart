import 'package:app/routes/volunteer_database/providers/volunteer_request_form_provider.dart';
import 'package:app/routes/volunteer_database/widgets/create/volunteer_request_step_details.dart';
import 'package:app/routes/volunteer_database/widgets/create/volunteer_request_step_location.dart';
import 'package:app/routes/volunteer_database/widgets/create/volunteer_request_step_photo.dart';
import 'package:app/routes/volunteer_database/widgets/create/volunteer_request_step_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Builds only the currently active volunteer request workflow step.
class VolunteerRequestActiveStep extends ConsumerWidget {
  /// Creates the active workflow step.
  const VolunteerRequestActiveStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(volunteerRequestFormProvider);
    final notifier = ref.read(volunteerRequestFormProvider.notifier);
    return switch (state.step) {
      0 => VolunteerRequestStepTitle(state: state, notifier: notifier),
      1 => VolunteerRequestStepDetails(state: state, notifier: notifier),
      2 => VolunteerRequestStepLocation(state: state, notifier: notifier),
      3 => const VolunteerRequestStepPhoto(),
      _ => const SizedBox.shrink(),
    };
  }
}
