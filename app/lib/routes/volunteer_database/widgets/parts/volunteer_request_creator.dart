import 'package:app/common/design_tokens.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_request_creator_avatar.dart';
import 'package:flutter/material.dart';

class VolunteerRequestCreator extends StatelessWidget {
  const VolunteerRequestCreator({
    required this.userAvatar,
    required this.userName,
    required this.isVerified,
    this.image,
    this.subtitle,
    super.key,
  });

  final String userAvatar;
  final ViewImage? image;
  final String userName;
  final bool isVerified;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        VolunteerRequestCreatorAvatar(initials: userAvatar, image: image),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      userName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (isVerified)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 18,
                            color: DesignTokens.blue200,
                          ),
                          Icon(
                            Icons.verified_outlined,
                            size: 18,
                            color: DesignTokens.blue500,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              ?subtitle,
            ],
          ),
        ),
      ],
    );
  }
}
