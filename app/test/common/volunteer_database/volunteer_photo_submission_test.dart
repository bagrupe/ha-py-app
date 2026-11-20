import 'dart:io';
import 'dart:typed_data';

import 'package:app/common/object_storage/object_storage_client.dart';
import 'package:app/common/volunteer_database/graphql_volunteer_repository.dart';
import 'package:app/common/volunteer_database/volunteer_photo_policy.dart';
import 'package:app/common/volunteer_database/volunteer_repository.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_submission.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_submission_error.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_submission_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Verifies upload ordering, validation and recovery without a running backend.
void main() {
  test(
    'uploads first, links the image and only then submits for review',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'volunteer-photo',
      );
      addTearDown(() => directory.delete(recursive: true));
      final photo = await File(
        '${directory.path}/photo.jpg',
      ).writeAsBytes([0xff, 0xd8, 0xff, 0xe0]);
      final events = <String>[];
      var failUpload = true;
      final storage = ObjectStorageClient(
        backendUrl: 'https://backend.test',
        authHeaders: () => {'Authorization': 'Bearer token'},
        httpClient: MockClient((request) async {
          events.add('upload');
          expect(request.url.path, '/api/objects/ehrenamtsbank');
          expect(request.headers['Authorization'], 'Bearer token');
          expect(request.headers['content-type'], 'image/jpeg');
          expect(request.bodyBytes, await photo.readAsBytes());
          if (failUpload) throw const SocketException('offline');
          return http.Response('{"key":"ehrenamtsbank/photo"}', 201);
        }),
      );
      final repository = GraphqlVolunteerRepository(
        GraphQLClient(
          cache: GraphQLCache(store: InMemoryStore()),
          link: Link.function((request, [forward]) {
            final create = printNode(
              request.operation.document,
            ).contains('CreateVolunteerRequest');
            events.add(create ? 'create' : 'review');
            final input = request.variables['input'] as Map<String, dynamic>;
            if (create) {
              expect(input['imageKey'], 'ehrenamtsbank/photo');
            } else {
              expect(input['status'], 'PENDING_REVIEW');
            }
            return Stream.value(
              Response(
                response: const {},
                data: {
                  '__typename': 'Mutation',
                  create
                      ? 'createEhrenamtsbankEintrag'
                      : 'updateEhrenamtsbankEintragStatus': {
                    '__typename': create
                        ? 'CreateEhrenamtsbankEintragPayload'
                        : 'UpdateEhrenamtsbankEintragStatusPayload',
                    'errors': const <Object>[],
                    'ehrenamtsbankEintrag': {
                      '__typename': 'EhrenamtsbankEintrag',
                      'id': 'entry-id',
                      'status': create ? 'DRAFT' : 'PENDING_REVIEW',
                    },
                  },
                },
              ),
            );
          }),
        ),
        objectStorage: storage,
      );
      final submission = _submission(photo.path);
      final container = ProviderContainer(
        overrides: [volunteerRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final notifier = container.read(
        volunteerRequestSubmissionProvider.notifier,
      );
      await notifier.submit(submission);
      expect(
        container.read(volunteerRequestSubmissionProvider).error,
        isA<SocketException>(),
      );
      expect(events, ['upload']);
      failUpload = false;
      final pending = notifier.submit(submission);
      expect(
        container.read(volunteerRequestSubmissionProvider).isLoading,
        isTrue,
      );
      await notifier.submit(submission);
      await pending;
      expect(
        container.read(volunteerRequestSubmissionProvider).hasError,
        isFalse,
      );
      expect(events, ['upload', 'upload', 'create', 'review']);
    },
  );

  test('rejects oversized and unsupported photos before upload', () async {
    final directory = await Directory.systemTemp.createTemp('volunteer-photo');
    addTearDown(() => directory.delete(recursive: true));
    final oversized = File('${directory.path}/large.jpg');
    final handle = await oversized.open(mode: FileMode.write);
    await handle.truncate(VolunteerPhotoPolicy.maxBytes + 1);
    await handle.close();
    await expectLater(
      VolunteerPhotoPolicy.validate(oversized),
      throwsA(isA<ObjectTooLarge>()),
    );
    final unsupported = await File(
      '${directory.path}/photo.gif',
    ).writeAsBytes([1]);
    await expectLater(
      VolunteerPhotoPolicy.validate(unsupported),
      throwsA(isA<ObjectContentTypeNotAllowed>()),
    );
  });

  test(
    'handles non-JSON server validation errors with actionable messages',
    () async {
      for (final status in [401, 403, 413, 415, 503]) {
        final storage = ObjectStorageClient(
          backendUrl: 'https://backend.test',
          authHeaders: () => null,
          httpClient: MockClient(
            (request) async => http.Response('proxy error', status),
          ),
        );
        try {
          await storage.uploadBytes(
            'ehrenamtsbank',
            Uint8List(0),
            contentType: 'image/png',
          );
          fail('Expected an upload error');
        } on ObjectUploadException catch (error) {
          expect(
            VolunteerRequestSubmissionError.translationKey(error),
            contains('.upload_errors.'),
          );
        }
      }
    },
  );
}

/// Creates complete submission data with an optional local image.
VolunteerRequestSubmission _submission(String? photoPath) =>
    VolunteerRequestSubmission(
      title: 'Test',
      description: 'Test description',
      categoryId: 'category-id',
      municipalityId: 'municipality-id',
      urgency: Enum_EhrenamtsbankDringlichkeit.MITTEL,
      estimatedDurationMinutes: 30,
      photoPath: photoPath,
    );
