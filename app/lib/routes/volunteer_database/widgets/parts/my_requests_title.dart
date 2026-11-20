import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyRequestsTitle extends StatelessWidget {
  const MyRequestsTitle({required this.requestCount, super.key});

  final int requestCount;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      'application.volunteer_database.marketplace.my_requests'.tr(),
    );
    if (requestCount == 0) {
      return textWidget;
    }

    final countWidget = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Text(requestCount.toString()),
    );

    return Row(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: textWidget),
        countWidget,
      ],
    );
  }
}
