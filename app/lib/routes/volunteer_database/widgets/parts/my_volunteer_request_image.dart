part of '../my_volunteer_request_card.dart';

/// Entry image with its lifecycle status and metadata overlays.
class _MyVolunteerRequestImage extends ConsumerWidget {
  /// Creates the image section for [request].
  const _MyVolunteerRequestImage({required this.request});

  /// Entry supplying the image and badge content.
  final VolunteerRequestModel request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCompletionProposal =
        request.status == VolunteerRequestStatus.assigned &&
        (ref
                .watch(volunteerInterestsProvider)
                .value
                ?.any(
                  (interest) =>
                      interest.entryId == request.id &&
                      interest.isAgreed &&
                      interest.completionProposal != null,
                ) ??
            false);
    return AspectRatio(
      aspectRatio: 2.15,
      child: Stack(
        fit: StackFit.expand,
        children: [
          LoadingImage(imageUrl: request.image?.url, fit: BoxFit.cover),
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: MyRequestStatusBadge(
                status: request.status,
                hasCompletionProposal: hasCompletionProposal,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                VolunteerRequestInterestBadge(requestId: request.id),
                if (request.time.isNotEmpty)
                  VolunteerBadge(icon: Icons.arrow_outward, text: request.time),
                if (request.commune.isNotEmpty)
                  VolunteerBadge(text: request.commune),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
