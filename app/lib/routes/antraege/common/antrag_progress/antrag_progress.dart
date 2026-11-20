import 'dart:convert';
import 'dart:typed_data';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/ausfuehrungen_provider.dart';
import 'package:app/common/auth/auth.dart';
import 'package:app/common/crypto/byte_array_converters.dart';
import 'package:app/common/crypto/crypto.dart';
import 'package:app/common/expressions/evaluating_visitor_service.dart';
import 'package:app/common/extensions/encrypted_value.dart';
import 'package:app/common/extensions/graphql_client.dart';
import 'package:app/common/extensions/string.dart';
import 'package:app/common/image_compression/image_compression.dart';
import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:app/common/local_attachments/local_attachment_store.dart';
import 'package:app/common/local_attachments/missing_attachments_provider.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/schritte.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/antraege/antrag_schritt.dart' as antrag_schritt;
import 'package:app/routes/antraege/common/antrag_graphql_client.dart';
import 'package:app/routes/antraege/common/antrag_meta.dart';
import 'package:app/routes/antraege/common/search_category_selection_state.dart';
import 'package:app/routes/antraege/components/schritte/abstract_schritt.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/checkbox_list_field/checkbox_list_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_schritt.dart';
import 'package:collection/collection.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';
import 'package:pointycastle/export.dart' show PrivateKey;

part 'antrag_client_status.dart';
part 'antrag_progress_controller.dart';
part 'antrag_progress_execution.dart';
part 'antrag_progress_navigation.dart';
part 'antrag_progress_notifier.dart';
part 'antrag_progress_persistence.dart';
part 'antrag_progress_serialization.dart';
part 'antrag_progress_submission.dart';
part 'antrag_slot_values.dart';
part 'antrag_progress.freezed.dart';

typedef Prozess = Fragment_ProzessOwnData;
typedef ProzessVersion = Fragment_ProzessVersionOwnData;

/// Type for editable form fields held in memory for easy editing.
typedef EditableSlots = Map<String, dynamic>;
typedef Kommune = Fragment_KommuneCrypto;

@immutable
/// Represents the progress of an application including status, current step and entered data.
@freezed
abstract class AntragProgress with _$AntragProgress {
  const factory AntragProgress({
    required Prozess prozess,
    required ProzessVersion prozessVersion,
    required Kommune kommune,
    required List<Fragment_Schritt> schritte,
    @Default(0) int index,
    @Default(<String, dynamic>{}) EditableSlots slots,
    @Default(<String, dynamic>{}) EditableSlots slotErrors,
    @Default(AntragClientStatus.editing) AntragClientStatus clientStatus,
    String? ausfuehrungId,
    String? sharedKeyEncryptedForBuerger,
  }) = _AntragProgress;

  const AntragProgress._();

  Fragment_Schritt__BezahlenSchritt? get bezahlenSchritt =>
      schritte.firstWhereOrNull((s) => s is Fragment_Schritt__BezahlenSchritt)
          as Fragment_Schritt__BezahlenSchritt?;

  /// Number of steps in the process.
  int get schritteCount => schritte.length;

  /// Checks if a payment step is present.
  bool get hasBezahlenSchritt => bezahlenSchritt != null;

  /// Returns the current step.
  SchrittData get schritt => schritte[index];

  /// Checks if errors are present in the slots.
  bool get hasErrors {
    return slotErrors.values.any((value) => value != null);
  }
}

final antragProgressProvider =
    NotifierProvider<AntragProgressNotifier, AntragProgress?>(
      AntragProgressNotifier.new,
    );
