import 'package:app/common/ausfuehrungen_provider.dart';
import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/components/bottom_navigation_bar/app_bottom_navigation_bar/app_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'parts/volunteer_bottom_navigation_bar.dart';

class MainBottomNavigationBar extends ConsumerWidget {
  const MainBottomNavigationBar({
    required this.currentIndex,
    super.key,
    this.onTap,
  });

  final int currentIndex;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(ausfuehrungenCountProvider);
    final notificationCount = ref.watch(mitteilungenCountNotifierProvider);

    return AppBottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        AppBottomNavigationBarItem(
          label: 'application.bottom_navigation.news'.tr(),
          icon: const Icon(Icons.home_outlined),
        ),
        AppBottomNavigationBarItem(
          label: 'application.bottom_navigation.map'.tr(),
          icon: const Icon(Icons.map_outlined),
        ),
        AppBottomNavigationBarItem(
          label: 'application.bottom_navigation.service'.tr(),
          icon: const Icon(Icons.add_circle),
          badgeCount: counts.laufend,
        ),
        AppBottomNavigationBarItem(
          label: 'application.bottom_navigation.events'.tr(),
          icon: const Icon(Icons.calendar_month_outlined),
        ),
        AppBottomNavigationBarItem(
          label: 'application.bottom_navigation.profile'.tr(),
          icon: const Icon(Icons.account_circle_outlined),
          badgeCount: notificationCount,
        ),
      ],
    );
  }
}
