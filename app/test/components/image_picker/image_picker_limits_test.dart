import 'package:app/components/forms/app_image_picker/app_image_picker.dart';
import 'package:app/components/image_picker/multi_image_picker.dart';
import 'package:app/components/image_picker/single_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

void main() {
  Future<FormBuilderImagePicker> pumpPicker(
    WidgetTester tester,
    Widget picker,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FormBuilder(child: picker)),
      ),
    );
    return tester.widget<FormBuilderImagePicker>(
      find.byType(FormBuilderImagePicker),
    );
  }

  group('native picker resizing', () {
    for (final entry in {
      'AppImagePicker': const AppImagePicker(name: 'a'),
      'SingleImagePicker': const SingleImagePicker(name: 'a'),
      'MultiImagePicker': const MultiImagePicker(name: 'a'),
    }.entries) {
      for (final platform in TargetPlatform.values) {
        testWidgets(
          '${entry.key} leaves resizing to the compression on $platform',
          (tester) async {
            final picker = await pumpPicker(tester, entry.value);

            expect(picker.maxWidth, isNull);
            expect(picker.maxHeight, isNull);
            expect(picker.imageQuality, isNull);
          },
          variant: TargetPlatformVariant.only(platform),
        );
      }
    }
  });
}
