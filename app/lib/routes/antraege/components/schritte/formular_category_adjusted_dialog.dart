part of 'formular_schritt.dart';

/// Explains why a previously selected category is no longer available.
class _FormularCategoryAdjustedDialog extends StatelessWidget {
  /// Creates the category-change notice.
  const _FormularCategoryAdjustedDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      'application.antraege.formular_schritt.category_adjusted_title'.tr(),
      style: Theme.of(context).textTheme.headlineSmall,
    ),
    content: Text(
      'application.antraege.formular_schritt.category_adjusted'.tr(),
    ),
    actions: [
      FilledButton(
        style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
        onPressed: () => Navigator.of(context).pop(),
        child: Text(
          'application.antraege.formular_schritt.category_adjusted_confirm'
              .tr(),
        ),
      ),
    ],
  );
}
