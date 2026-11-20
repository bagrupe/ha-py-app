import 'package:app/common/design_tokens.dart';
import 'package:app/graphql/__generated__/fragments.graphql.dart';
import 'package:app/routes/ideas/common/idea.dart';
import 'package:app/routes/ideas/components/idea_detail_field.dart';
import 'package:app/routes/melder/components/report_history_item.dart';
import 'package:app/routes/melder/components/report_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays the details of a submitted idea.
class IdeaDetailContent extends StatelessWidget {
  /// Creates detail content for a submitted idea.
  const IdeaDetailContent({
    required this.idea,
    required this.status,
    required this.history,
    required this.backendUrl,
    super.key,
    this.isFollowing = false,
    this.onToggleFollow,
    this.followEnabled = true,
  });

  /// Idea shown by this detail content.
  final Idea idea;

  /// Localized execution status.
  final String status;

  /// Execution history displayed below the idea information.
  final List<Fragment_HistorieEintrag> history;

  /// Backend URL used to load uploaded images.
  final String backendUrl;

  /// Whether the current user already follows this idea.
  final bool isFollowing;

  /// Called when the follow button is tapped. Omit to hide the button, e.g.
  /// for the idea's own reporter, who cannot follow their own idea.
  final VoidCallback? onToggleFollow;

  final bool followEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final imageUrl = idea.image?.imageUrl(backendUrl, 1080);

    return Semantics(
      label: 'application.melder.detail_semantics'.tr(
        namedArgs: {'title': idea.title, 'status': status},
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 7,
              child: ExcludeSemantics(
                child: ReportImage(
                  image: idea.image,
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(idea.title, style: textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    status,
                    style: textTheme.bodyLarge?.copyWith(
                      color: DesignTokens.gray500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    idea.description ??
                        'application.melder.ideas.no_description'.tr(),
                    style: textTheme.bodySmall,
                  ),
                  if (idea.address != null || idea.detailValues.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'application.melder.detail_information_title'.tr(),
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    if (idea.address != null)
                      IdeaDetailField(
                        label: 'application.melder.ideas.fields.location'.tr(),
                        value: idea.address!,
                      ),
                    ...idea.detailValues.map(
                      (detailValue) => IdeaDetailField(
                        label: detailValue.label,
                        value: detailValue.value,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: DesignTokens.gray100),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'application.melder.history_title'.tr(),
                style: textTheme.headlineSmall,
              ),
            ),
            ...history.map(
              (historyItem) => ReportHistoryItem(history: historyItem),
            ),
            if (onToggleFollow != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(
                  onPressed: followEnabled ? onToggleFollow : null,
                  child: Text(
                    isFollowing
                        ? 'application.melder.ideas.unfollow'.tr()
                        : 'application.melder.ideas.follow'.tr(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
