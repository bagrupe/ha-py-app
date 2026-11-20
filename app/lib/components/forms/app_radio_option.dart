import 'package:flutter/material.dart';

/// Displays one compact, selectable option inside a [RadioGroup].
class AppRadioOption<T> extends StatelessWidget {
  /// Creates a radio option with an exact gap between control and [title].
  const AppRadioOption({
    required this.value,
    required this.title,
    this.spacing = 8,
    this.enabled = true,
    super.key,
  });

  /// Value represented by this option.
  final T value;

  /// Text displayed next to the radio control.
  final String title;

  /// Horizontal distance between the control bounds and the title.
  final double spacing;

  /// Whether the option accepts user interaction.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final registry = RadioGroup.maybeOf<T>(context);
    assert(registry != null, 'AppRadioOption requires a RadioGroup<$T>.');
    final isSelected = registry?.groupValue == value;

    return Semantics(
      button: true,
      checked: isSelected,
      enabled: enabled,
      inMutuallyExclusiveGroup: true,
      label: title,
      child: InkWell(
        onTap: enabled ? () => registry?.onChanged(value) : null,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing,
            children: [
              ExcludeSemantics(
                child: SizedBox.square(
                  dimension: 18,
                  child: Radio<T>(
                    value: value,
                    enabled: enabled,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
