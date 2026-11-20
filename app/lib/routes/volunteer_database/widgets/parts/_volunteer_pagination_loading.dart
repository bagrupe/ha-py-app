part of '../suggested_requests_list.dart';

/// Loading state displayed while another volunteer page is fetched.
class _VolunteerPaginationLoading extends StatelessWidget {
  /// Creates the volunteer pagination loading state.
  const _VolunteerPaginationLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Semantics(
        liveRegion: true,
        child: Column(
          spacing: 8,
          children: [
            const CircularProgressIndicator(),
            Text('application.volunteer_database.loading_more'.tr()),
          ],
        ),
      ),
    );
  }
}
