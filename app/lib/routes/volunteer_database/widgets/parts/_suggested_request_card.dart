part of '../suggested_requests_list.dart';

class _SuggestedRequestCard extends StatelessWidget {
  const _SuggestedRequestCard({required this.request});

  final VolunteerRequestModel request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      focusColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      onTap: () {
        context.push(
          VolunteerRequestDetailsPage.path.replaceFirst(':id', request.id),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImagePillStack(request: request),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                request.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: VolunteerRequestCreator(
                userAvatar: request.userAvatar,
                userName: request.userName,
                isVerified: request.isVerified,
                subtitle: Text(
                  request.description,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: DesignTokens.gray500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePillStack extends StatelessWidget {
  const _ImagePillStack({required this.request});

  final VolunteerRequestModel request;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: DesignTokens.gray100,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: LoadingImage(
              imageUrl: request.image?.url,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 12,
            left: 8,
            right: 8,
            child: Row(
              children: [
                VolunteerBadge(icon: Icons.arrow_outward, text: request.time),
                const SizedBox(width: 8),
                VolunteerBadge(text: request.commune),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
