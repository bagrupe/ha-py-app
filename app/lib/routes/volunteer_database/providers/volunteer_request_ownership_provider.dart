import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/routes/volunteer_database/providers/my_volunteer_requests_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_ownership_page_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resolves ownership from backend-scoped entries instead of the mock login ID.
final volunteerRequestOwnershipProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, entryId) async {
      if (ref.watch(volunteerAuthProvider) == null) return false;
      final entries = await ref.watch(myVolunteerRequestsProvider.future);
      if (entries.items.any((entry) => entry.id == entryId)) return true;
      var hasNextPage = entries.hasNextPage;
      var skip = entries.items.length;
      while (hasNextPage && skip < entries.totalCount && ref.mounted) {
        final page = await ref.watch(
          volunteerOwnershipPageProvider(skip).future,
        );
        if (page.items.any((entry) => entry.id == entryId)) return true;
        if (page.items.isEmpty) break;
        hasNextPage = page.hasNextPage;
        skip += page.items.length;
      }
      return false;
    }, retry: (_, _) => null);
