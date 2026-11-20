import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays a selectable option in the volunteer request workflow.
class VolunteerRequestOptionTile extends StatelessWidget {
  /// Creates a switch option backed by a translated [titleKey].
  const VolunteerRequestOptionTile({
    required this.titleKey,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Translation key used for the visible and accessible option title.
  final String titleKey;

  /// Whether the option is selected.
  final bool value;

  /// Callback invoked when the selected value changes.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-8, 0),
      child: SwitchListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeThumbColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.zero,
        title: Text(
          titleKey.tr(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        value: value,
        onChanged: onChanged,
        visualDensity: const VisualDensity(vertical: -4),
      ),
    );
  }
}
