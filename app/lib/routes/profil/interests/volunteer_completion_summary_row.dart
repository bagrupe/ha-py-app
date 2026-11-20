import 'package:flutter/material.dart';

/// Displays one labeled value in a completion proposal summary.
class VolunteerCompletionSummaryRow extends StatelessWidget {
  /// Creates a proposal summary row.
  const VolunteerCompletionSummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  /// Leading icon describing the value.
  final IconData icon;

  /// Localized value label.
  final String label;

  /// Localized or formatted value.
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        Expanded(
          child: Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}
