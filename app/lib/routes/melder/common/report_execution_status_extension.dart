import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:easy_localization/easy_localization.dart';

/// Localized labels for reporting execution statuses.
extension ReportExecutionStatusExtension on Enum_AusfuehrungStatus {
  /// Returns the localized label for this execution status.
  String get localizedLabel {
    return switch (this) {
      Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_BUERGER =>
        'application.melder.status.editing'.tr(),
      Enum_AusfuehrungStatus.BEARBEITUNG_DURCH_KOMMUNE =>
        'application.melder.status.submitted'.tr(),
      Enum_AusfuehrungStatus.ABGESCHLOSSEN =>
        'application.melder.status.completed'.tr(),
      Enum_AusfuehrungStatus.$unknown =>
        'application.melder.status.unknown'.tr(),
    };
  }
}
