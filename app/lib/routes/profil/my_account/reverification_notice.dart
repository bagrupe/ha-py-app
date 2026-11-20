part of 'my_account.dart';

class _ReverificationNotice extends StatelessWidget {
  const _ReverificationNotice({
    required this.isLoading,
    required this.onReverify,
  });

  final bool isLoading;
  final VoidCallback onReverify;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          'application.volunteer_database.bundid_onboarding_page.errors.requires_bundid_reverification'
              .tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: isLoading ? null : onReverify,
            child: isLoading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: DesignTokens.white,
                    ),
                  )
                : Text(
                    'application.volunteer_database.bundid_onboarding_page.bundid_reverify'
                        .tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: DesignTokens.white),
                  ),
          ),
        ),
      ],
    );
  }
}
