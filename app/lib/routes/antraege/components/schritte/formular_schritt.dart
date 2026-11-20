import 'dart:async';

import 'package:app/common/expressions/evaluating_visitor_service.dart';
import 'package:app/common/extensions/iterable.dart';
import 'package:app/common/extensions/string.dart';
import 'package:app/common/local_attachments/missing_attachments_notice.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/common/search_category_selection_state.dart';
import 'package:app/routes/antraege/components/schritte/abstract_schritt.dart';
import 'package:app/routes/antraege/components/schritte/cascade_entry.dart';
import 'package:app/routes/antraege/components/schritte/cascade_search_index.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/checkbox_list_field/checkbox_list_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/date_field/date_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/upload_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/location_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/signature_field/signature_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/cascade_search_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/cascade_search_selection.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/text_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/time_field/time_field.dart';
import 'package:app/routes/antraege/components/schritte/nur_anzeige_fields/text_block_field.dart';
import 'package:app/routes/antraege/components/schritte/user_stored_inhalte.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'formular_cascade_structure.dart';
part 'formular_category_adjusted_dialog.dart';
part 'formular_field_rendering.dart';
part 'formular_initial_values.dart';
part 'formular_relevance.dart';
part 'formular_schritt_form.dart';
part 'formular_search_editing.dart';
part 'formular_search_index.dart';
part 'formular_search_selection.dart';

typedef FormularSchrittData = Fragment_Schritt__FormularSchritt;
typedef FormularSchrittFeld = Fragment_FormularFeld;

/// Preserves form values and manages relevance within an application step.
class FormularSchritt extends AbstractSchritt<FormularSchrittData> {
  FormularSchritt(super.schritt);

  final _formKey = GlobalKey<FormBuilderState>();
  final _stream = StreamController<Map<String, dynamic>>.broadcast();
  final ValueNotifier<bool> _contentReady = ValueNotifier(false);
  Timer? _relevanzDebounce;

  late bool _relevanzLaeuft = false;
  bool _relevanzErneutNoetig = false;
  bool _inCleanup = false;
  bool _relevanzAusgeloestDurchKategorieAenderung = false;
  Map<String, dynamic>? _letzteFormWerte;

  static final RegExp _slotReferenzPattern = RegExp(r"slot\('([^']+)'\)");
  late final Set<String> _relevanzTriggerSlots =
      _computeRelevanceTriggerSlots();
  String? _letzteTriggerWerte;
  final Map<String, Future<CascadeSearchIndex>> _searchIndices = {};
  final Map<String, CascadeEntry> _searchSelections = {};
  String? _prozessVersionId;
  SearchCategorySelectionNotifier? _searchSelectionNotifier;
  late final Map<String, String> _cascadeParentByChild =
      _computeCascadeParentsByChild();
  late final Map<String, String> _cascadeRootsByChild = {
    for (final child in _cascadeParentByChild.keys) child: _rootFor(child),
  };
  late final Set<String> _cascadeChildSlots = _cascadeRootsByChild.keys.toSet();
  late final Set<String> _searchableCascadeSlots =
      _computeSearchableCascadeSlots();
  late final Set<String> _cascadeParentSlots = _computeCascadeParentSlots();

  @override
  void dispose() {
    _relevanzDebounce?.cancel();
    _stream.close();
    _contentReady.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      _FormularSchrittForm(step: this);

  @override
  ValueListenable<bool> get contentReadyListenable => _contentReady;

  /// Debounces relevance updates after a user changes a form value.
  void _onFormChanged(EvaluatingVisitorService evaluatingVisitor) {
    if (_inCleanup) return;

    final formWerte = _valuesWithSearchSelections(
      _formKey.currentState!.instantValue,
    );
    final vorherigeWerte = _letzteFormWerte ?? const <String, dynamic>{};
    _relevanzAusgeloestDurchKategorieAenderung = _searchableCascadeSlots.any(
      (slot) => vorherigeWerte[slot] != formWerte[slot],
    );
    _letzteFormWerte = Map<String, dynamic>.from(formWerte);

    final aktuelleWerte = _triggerValuesKey(formWerte);
    if (aktuelleWerte == _letzteTriggerWerte) return;
    _letzteTriggerWerte = aktuelleWerte;

    _relevanzDebounce?.cancel();
    _relevanzDebounce = Timer(
      const Duration(milliseconds: 400),
      () => _updateRelevance(evaluatingVisitor),
    );
  }

  void _markContentReady() {
    if (_contentReady.value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_contentReady.value) _contentReady.value = true;
    });
  }

  void _showCategoryAdjustedSnackbar() {
    final context = _formKey.currentContext;
    if (context == null) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _FormularCategoryAdjustedDialog(),
    );
  }

  static void _clearFormValue(FormBuilderState form, String slotName) {
    form.initialValue[slotName] = null;
    final registeredField = form.fields[slotName];
    if (registeredField != null) {
      registeredField.didChange(null);
    } else {
      form.setInternalFieldValue(slotName, null);
    }
  }

  @override
  /// Validates the current form.
  bool isComplete() {
    return _formKey.currentState!.validate();
  }

  @override
  /// Returns current slot values and their validation errors.
  (Map<String, dynamic>, Map<String, String?>) getSlots() {
    final state = _formKey.currentState!;
    final slotNames = schritt.felder.map((feld) => feld.slotName);
    state.validate();
    final slots = Map<String, dynamic>.from(state.instantValue);
    for (final selection in _searchSelections.values) {
      for (final step in selection.steps) {
        slots[step.field.slotName] = step.option.key;
      }
    }

    final expandedErrors = {
      for (final slotName in slotNames) slotName: state.errors[slotName],
    };

    return (slots, expandedErrors);
  }
}
