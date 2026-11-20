part of 'cascade_search_field.dart';

class _CascadeSearchResult extends StatelessWidget {
  const _CascadeSearchResult({required this.entry, required this.onTap});

  final CascadeEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ResultCard(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (entry.parentLabels.isNotEmpty)
                Text(
                  entry.parentLabels.join(' › '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              Text(entry.label, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
