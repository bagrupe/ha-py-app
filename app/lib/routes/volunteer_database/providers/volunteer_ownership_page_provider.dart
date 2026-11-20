import 'package:app/common/volunteer_database/my_volunteer_requests_page_data.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shares ownership page requests and retries a failed page once in isolation.
final volunteerOwnershipPageProvider = FutureProvider.autoDispose
    .family<MyVolunteerRequestsPageData, int>((ref, skip) async {
      ref.watch(volunteerAuthProvider);
      final repository = ref.watch(volunteerRepositoryProvider);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (!ref.mounted) throw StateError('Ownership lookup disposed');
      try {
        return await repository.getMyRequestsPage(skip: skip, take: 50);
      } catch (_) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (!ref.mounted) rethrow;
        return repository.getMyRequestsPage(skip: skip, take: 50);
      }
    }, retry: (_, _) => null);
