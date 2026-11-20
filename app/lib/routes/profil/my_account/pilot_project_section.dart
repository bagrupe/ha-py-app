import 'package:app/common/volunteer_database/pilot_project_unlock_notifier.dart';
import 'package:app/components/forms/app_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'pilot_project_section_state.dart';

/// Account-independent form for activating pilot project features on this device.
class PilotProjectSection extends ConsumerStatefulWidget {
  /// Creates the pilot project section.
  const PilotProjectSection({super.key});

  @override
  ConsumerState<PilotProjectSection> createState() =>
      _PilotProjectSectionState();
}
