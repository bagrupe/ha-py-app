import 'package:app/components/images/loading_image.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:flutter/material.dart';

/// Hero image for a volunteer entry.
class VolunteerRequestDetailsImage extends StatelessWidget {
  /// Creates the entry image.
  const VolunteerRequestDetailsImage({required this.request, super.key});

  /// Entry supplying the hero image.
  final VolunteerRequestModel request;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: request.image?.altText ?? request.title,
      child: AspectRatio(
        aspectRatio: 2.35,
        child: ExcludeSemantics(
          child: LoadingImage(imageUrl: request.image?.url, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
