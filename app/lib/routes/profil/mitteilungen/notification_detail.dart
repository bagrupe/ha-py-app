import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/theme.dart';
import 'package:app/routes/profil/mitteilungen/components/notification_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Displays a single notification in overview or detail mode.
class NotificationDetail extends ConsumerWidget {
  /// Creates a notification display for [notification].
  const NotificationDetail({
    required this.notification,
    super.key,
    this.overview = false,
  });

  /// Notification to display.
  final MitteilungData notification;

  /// Whether the notification is displayed as an overview item.
  final bool overview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final formatter = DateFormat('dd.MM.yyyy | HH:mm');

    final statusDescription = overview
        ? notification.historie.statusAenderung
        : notification.historie.statusAenderungBeschreibung ??
              notification.historie.statusAenderung;
    final message = notification.historie.nachricht?.trim();
    final hasMessage = message != null && message.isNotEmpty;
    final overviewDescription = hasMessage ? message : statusDescription;

    return Container(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: overview
            ? () => context.push(
                '/profil/notifications/${notification.id}/${notification.historie.id}',
              )
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    notification.prozessName,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: theme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (overview && overviewDescription != null)
                    Text(
                      overviewDescription,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (!overview && statusDescription != null)
                    Text(
                      statusDescription,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (!overview && hasMessage) ...[
                    const SizedBox(height: 12),
                    NotificationMessage(text: message),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    formatter.format(notification.historie.createdAt.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            if (overview) const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
