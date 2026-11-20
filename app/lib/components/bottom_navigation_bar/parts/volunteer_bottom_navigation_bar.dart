part of '../bottom_navigation_bar.dart';

class VolunteerBottomNavigationBar extends ConsumerWidget {
  const VolunteerBottomNavigationBar({
    required this.currentIndex,
    super.key,
    this.onTap,
  });

  final int currentIndex;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(ausfuehrungenCountProvider);

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
          label: 'application.bottom_navigation.volunteer_database'.tr(),
          icon: const Icon(Icons.people),
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
      ],
    );
  }
}
