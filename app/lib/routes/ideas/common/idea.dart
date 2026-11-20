import 'package:app/graphql/__generated__/ausfuehrung.graphql.dart';
import 'package:app/graphql/__generated__/idee.graphql.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/ideas/common/idea_detail_value.dart';
import 'package:app/routes/melder/common/report_form_value_parser.dart';
import 'package:app/routes/melder/common/report_upload_image.dart';
import 'package:latlong2/latlong.dart';

/// Represents a submitted idea with normalized detail fields.
class Idea {
  /// Creates a normalized idea object.
  const Idea({
    required this.id,
    required this.title,
    required this.description,
    required this.detailValues,
    this.image,
    this.address,
    this.coordinates,
  });

  /// Creates an idea from a generic execution.
  factory Idea.fromExecution(
    Query_AusfuehrungHistorie_ausfuehrung ausfuehrung,
  ) {
    final title = ReportFormValueParser.stringValue(ausfuehrung.titel?.value);
    final description = ReportFormValueParser.stringValue(
      ausfuehrung.beschreibung?.value,
    );
    final fields = ReportFormValueParser.formFields(ausfuehrung.prozessVersion);
    final slotValues = ReportFormValueParser.plainSlotValues(
      ausfuehrung.slotValues,
    );
    final image = ReportFormValueParser.firstImage(fields, slotValues);

    return Idea(
      id: ausfuehrung.id,
      title: title ?? ausfuehrung.prozessVersion.prozess.name,
      description: description,
      detailValues: _detailValues(fields, slotValues),
      image: image,
    );
  }

  /// Creates an idea from the shared, Kommune-scoped [Fragment_IdeeAusfuehrung]
  /// data (any Bürger may view and follow another citizen's idea, as opposed
  /// to [fromExecution], which is fed by the ownership-restricted generic
  /// `ausfuehrung` query).
  ///
  /// Deliberately only reads the small, fixed set of slots this fragment
  /// exposes (title, description, address, image) - unlike [fromExecution],
  /// it must NOT render arbitrary process-defined form fields
  /// ([_detailValues]/[IdeaDetailValue]), since those can contain personal
  /// data the reporter entered for Sachbearbeiter eyes only, not for other
  /// citizens browsing the public map/list.
  factory Idea.fromIdeeSummary(Fragment_IdeeAusfuehrung ausfuehrung) {
    final title = ReportFormValueParser.stringValue(ausfuehrung.title?.value);
    final description = ReportFormValueParser.stringValue(
      ausfuehrung.beschreibung?.value,
    );
    final rawAdresse = ausfuehrung.adresse?.value;
    final adresseValue = rawAdresse is Map<String, dynamic> ? rawAdresse : null;
    final bilderId = ausfuehrung.bilder?.id;

    return Idea(
      id: ausfuehrung.id,
      title: title ?? ausfuehrung.prozessVersion.prozess.name,
      description: description,
      detailValues: const [],
      image: bilderId == null ? null : ReportUploadImage.fileId(bilderId),
      address: adresseValue?['addressString'] as String?,
      coordinates: adresseValue != null
          ? LatLng.fromJson(adresseValue)
          : const LatLng(0, 0),
    );
  }

  /// Unique id of the idea execution.
  final String id;

  /// Title displayed on the detail page.
  final String title;

  /// Idea description.
  final String? description;

  /// Displayable user-entered values with process-defined labels.
  final List<IdeaDetailValue> detailValues;

  /// Optional image shown for the idea.
  final ReportUploadImage? image;

  /// Formatted address, only populated for map/list summaries.
  final String? address;

  /// Coordinates, only populated for map/list summaries.
  final LatLng? coordinates;

  /// Returns displayable detail values in process field order.
  static List<IdeaDetailValue> _detailValues(
    List<Fragment_FormularFeld> fields,
    Map<String, Object?> slotValues,
  ) {
    final detailValues = <IdeaDetailValue>[];
    for (final field in fields) {
      if (_hiddenDetailSlotNames.contains(field.slotName)) {
        continue;
      }
      if (field is Fragment_FormularFeld__UploadFormularFeld) {
        continue;
      }
      final label = field.angezeigterName ?? field.slotName;
      final value = ReportFormValueParser.displayValue(
        slotValues[field.slotName],
      );
      if (value == null) {
        continue;
      }
      detailValues.add(IdeaDetailValue(label: label, value: value));
    }
    return detailValues;
  }

  /// Slot names that are displayed as primary content or media.
  static const _hiddenDetailSlotNames = {
    'titel',
    'title',
    'beschreibung',
    'description',
  };
}
