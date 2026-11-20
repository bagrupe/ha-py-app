import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays an accessible date picker for the performed help date.
class VolunteerCompletionDateField extends StatelessWidget {
  /// Creates a completion date field.
  const VolunteerCompletionDateField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Currently selected performance date.
  final DateTime value;

  /// Called after another date was selected.
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    const basePath =
        'application.profile.volunteer_interests.completion.fields';
    final theme = Theme.of(context);
    final outlineBorder = OutlineInputBorder(
      borderSide: BorderSide(color: theme.colorScheme.outline),
    );
    final formattedDate = DateFormat('dd.MM.yyyy').format(value);
    return Semantics(
      button: true,
      label: '$basePath.date_semantics'.tr(namedArgs: {'date': formattedDate}),
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: '$basePath.date'.tr(),
            labelStyle: theme.textTheme.bodySmall,
            border: outlineBorder,
            enabledBorder: outlineBorder,
            suffixIcon: Icon(
              Icons.calendar_month_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          child: Text(formattedDate, style: theme.textTheme.bodySmall),
        ),
      ),
    );
  }

  /// Opens the platform date picker and reports the selected date.
  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final normalizedValue = DateTime(value.year, value.month, value.day);
    final initialDate = normalizedValue.isAfter(today)
        ? today
        : normalizedValue;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(today.year - 100),
      lastDate: today,
    );
    if (selectedDate != null) onChanged(selectedDate);
  }
}
