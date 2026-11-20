import 'package:app/components/rounded_meta_icon.dart';
import 'package:flutter/material.dart';

/// Additional attributes of a volunteer entry.
class VolunteerRequestDetailsMetadata extends StatelessWidget {
  /// Creates the metadata list.
  const VolunteerRequestDetailsMetadata({this.metaData, super.key});

  /// Accessible additional entry attributes.
  final List<String>? metaData;

  @override
  Widget build(BuildContext context) {
    if (metaData?.isEmpty ?? true) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      children: metaData!
          .map(
            (tag) => Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const RoundedMetaIcon(padding: EdgeInsets.only(right: 4)),
                  Expanded(child: Text(tag, style: theme.textTheme.bodyLarge)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
