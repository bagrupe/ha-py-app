import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/sensor_type_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SensorTrendPills extends StatelessWidget {
  const SensorTrendPills({
    required this.trend,
    required this.fieldIcon,
    required this.unit,
    super.key,
  });

  final SensorTrend trend;
  final IconData fieldIcon;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _Pill(icon: fieldIcon, label: trend.direction.label),
        _Pill(
          icon: trend.direction.icon,
          label: _deltaLabel(trend.delta, unit),
        ),
      ],
    );
  }
}

String _deltaLabel(double delta, String unit) {
  final sign = delta > 0
      ? '+'
      : delta < 0
      ? '-'
      : '±';
  return '$sign${NumberFormat('#0.#').format(delta.abs())} $unit';
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: DesignTokens.gray100,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurface),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
