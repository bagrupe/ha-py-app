import 'package:app/components/buttons/primary_button.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:app/routes/volunteer_database/providers/my_volunteer_requests_provider.dart';
import 'package:app/routes/volunteer_database/views/volunteer_request_create_page.dart';
import 'package:app/routes/volunteer_database/widgets/my_volunteer_requests_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Page containing all entries belonging to the authenticated user.
class MyVolunteerRequestsPage extends ConsumerStatefulWidget {
  /// Creates the user's volunteer request page.
  const MyVolunteerRequestsPage({super.key});

  /// Absolute route path for the user's volunteer requests.
  static const path = '/ehrenamtsdatenbank/marketplace/my-requests';

  @override
  ConsumerState<MyVolunteerRequestsPage> createState() =>
      _MyVolunteerRequestsPageState();
}

/// Refreshes cached entry and interest data each time the page is opened.
class _MyVolunteerRequestsPageState
    extends ConsumerState<MyVolunteerRequestsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
        ..invalidate(myVolunteerRequestsProvider)
        ..invalidate(volunteerInterestsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.volunteer_database.my_requests.title'.tr()),
      ),
      body: Semantics(
        label: 'application.volunteer_database.my_requests.page_semantics'.tr(),
        explicitChildNodes: true,
        child: const SafeArea(child: MyVolunteerRequestsList()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.sizeOf(context).width - 32,
        child: PrimaryButton(
          label: 'application.volunteer_database.my_requests.create'.tr(),
          trailingIconData: Icons.add,
          onPressed: () => context.push(VolunteerRequestCreatePage.path),
        ),
      ),
    );
  }
}
