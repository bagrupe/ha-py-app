import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:flutter/material.dart';

/// Displays a creator image with initials as its loading and error fallback.
class VolunteerRequestCreatorAvatar extends StatelessWidget {
  /// Creates an avatar from [image] or the fallback [initials].
  const VolunteerRequestCreatorAvatar({
    required this.initials,
    this.image,
    super.key,
  });

  /// Initials displayed while no remote image is available.
  final String initials;

  /// Optional remote creator image.
  final ViewImage? image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalizedInitials = initials.trim();
    if (image == null) {
      if (normalizedInitials.isEmpty) {
        return const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/images/fallback_image.png'),
        );
      }
      return CircleAvatar(
        radius: 24,
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Text(
          normalizedInitials,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Semantics(
      image: true,
      label: image!.altText,
      excludeSemantics: true,
      child: CircleAvatar(
        radius: 24,
        foregroundImage: NetworkImage(image!.url),
        onForegroundImageError: (_, _) {},
        backgroundImage: const AssetImage('assets/images/fallback_image.png'),
      ),
    );
  }
}
