import 'package:app/common/volunteer_database/my_volunteer_requests_page_data.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/providers/help_type_provider.dart';
import 'package:app/routes/volunteer_database/providers/my_volunteer_requests_provider.dart';
import 'package:app/routes/volunteer_database/providers/my_volunteer_requests_state.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_ownership_page_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_ownership_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Session stub reproducing the mock identity used by the login flow.
class _MockSession extends VolunteerAuthNotifier {
  @override
  String? build() => 'mock-volunteer-user';
}

/// Backend-scoped entries with an owner different from the session mock ID.
class _OwnedEntries extends MyVolunteerRequestsNotifier {
  @override
  Future<MyVolunteerRequestsState> build() async =>
      const MyVolunteerRequestsState(
        items: [
          VolunteerRequestModel(
            id: 'own-entry',
            ownerId: 'real-backend-owner',
            title: '',
            time: '',
            commune: '',
            userAvatar: '',
            userName: '',
            isVerified: false,
            description: '',
            categoryKey: '',
            helpType: HelpType.offerHelp,
            image: null,
            status: VolunteerRequestStatus.active,
          ),
        ],
        totalCount: 1,
        hasNextPage: false,
      );
}

/// First ownership page with one further page reported by the backend.
class _PaginatedEntries extends _OwnedEntries {
  @override
  Future<MyVolunteerRequestsState> build() async =>
      (await super.build()).copyWith(totalCount: 2, hasNextPage: true);
}

void main() {
  test('stops at the reported total even if hasNextPage stays true', () async {
    var calls = 0;
    final container = ProviderContainer(
      overrides: [
        volunteerAuthProvider.overrideWith(_MockSession.new),
        myVolunteerRequestsProvider.overrideWith(_PaginatedEntries.new),
        volunteerOwnershipPageProvider(1).overrideWith((ref) async {
          calls++;
          final entries = await _OwnedEntries().build();
          return MyVolunteerRequestsPageData(
            items: entries.items,
            hasNextPage: true,
            totalCount: 2,
          );
        }),
      ],
    );
    addTearDown(container.dispose);
    expect(
      await container.read(volunteerRequestOwnershipProvider('missing').future),
      isFalse,
    );
    expect(calls, 1);
  });

  test(
    'propagates a page failure instead of reporting foreign ownership',
    () async {
      final failure = StateError('Page unavailable');
      final container = ProviderContainer(
        overrides: [
          volunteerAuthProvider.overrideWith(_MockSession.new),
          myVolunteerRequestsProvider.overrideWith(_PaginatedEntries.new),
          volunteerOwnershipPageProvider(
            1,
          ).overrideWith((ref) async => throw failure),
        ],
      );
      addTearDown(container.dispose);
      await expectLater(
        container.read(volunteerRequestOwnershipProvider('missing').future),
        throwsA(same(failure)),
      );
    },
  );

  test('recognizes own backend entry despite mock session identity', () async {
    final container = ProviderContainer(
      overrides: [
        volunteerAuthProvider.overrideWith(_MockSession.new),
        myVolunteerRequestsProvider.overrideWith(_OwnedEntries.new),
      ],
    );
    addTearDown(container.dispose);
    expect(
      await container.read(
        volunteerRequestOwnershipProvider('own-entry').future,
      ),
      isTrue,
    );
    expect(
      await container.read(
        volunteerRequestOwnershipProvider('foreign-entry').future,
      ),
      isFalse,
    );
  });
}
