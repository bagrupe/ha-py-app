// ignore_for_file: avoid_field_initializers_in_const_classes

part of 'document_field.dart';

class _DocumentUploadOption extends StatelessWidget {
  const _DocumentUploadOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;

  final IconData icon;

  final VoidCallback onTap;

  final size = 56.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              SizedBox(
                height: size,
                width: size,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.primaryColorLight,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                  ),
                  child: Icon(icon, size: 24, color: Colors.black),
                ),
              ),
              const SizedBox(width: 12),
              Text(title, style: theme.textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }
}
