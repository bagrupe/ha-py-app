part of 'formular_schritt.dart';

/// Provides field rendering for a form step.
extension FormularSchrittRendering on FormularSchritt {
  /// Resolves relevant form fields using the current slot values.
  /// [evaluatingVisitor] evaluates field and option relevance.
  /// [slots] contains the current form values.
  Future<Iterable<Widget?>> renderFieldsAsync(
    EvaluatingVisitorService evaluatingVisitor,
    Map<String, dynamic> slots, {
    Map<String, SearchCategoryPath> persistedSearchSelections = const {},
    String? prozessVersionId,
    SearchCategorySelectionNotifier? searchSelectionNotifier,
  }) async {
    if (prozessVersionId != null) {
      await _restoreSearchSelections(
        evaluatingVisitor,
        slots,
        persistedSearchSelections,
        prozessVersionId,
      );
    }
    final renderSlots = _valuesWithSearchSelections(slots);
    final optionRelevanceCache = <String, Future<bool>>{};
    return Future.wait(
      schritt.felder.map<Future<Widget?>>((f) async {
        if (!await evaluatingVisitor.evaluateBool(f.istRelevant, renderSlots)) {
          return null;
        }

        final isOptional = !f.pflichtfeld;

        if (f.$__typename == 'UploadFormularFeld') {
          return FormularUploadField(
            key: Key(f.slotName),
            feld: f as FormularImageFeldData,
            optional: isOptional,
          );
        }
        if (f.$__typename == 'AnzeigeTextBlockFeld') {
          return TextBlockField(feld: f as TextBlockFeldData);
        }

        if (f.$__typename == 'LocationFormularFeld') {
          return FormularLocationField(
            key: Key(f.slotName),
            feld: f,
            optional: isOptional,
          );
        }

        if (f.$__typename == 'CheckboxListFormularFeld') {
          return FormularCheckboxListField(
            key: Key(f.slotName),
            feld: f as FormularCheckboxFeldData,
            optional: isOptional,
          );
        }

        if (f.$__typename == 'DateFormularFeld') {
          return FormularDateField(
            key: Key(f.slotName),
            feld: f as FormularDateFieldData,
            optional: isOptional,
          );
        }

        if (f.$__typename == 'TimeFormularFeld') {
          return FormularTimeField(
            optional: isOptional,
            key: Key(f.slotName),
            feld: f as FormularTimeFieldData,
          );
        }

        if (f.$__typename == 'SignatureFormularFeld') {
          return FormularSignatureField(
            key: Key(f.slotName),
            feld: f as FormularSignatureFeldData,
            optional: isOptional,
          );
        }

        final textFeld = f as FormularTextFeldData;
        final cascadeRoot = _cascadeRootsByChild[textFeld.slotName];
        if (cascadeRoot != null &&
            _activeSearchSelection(cascadeRoot, renderSlots) != null) {
          return null;
        }

        final searchSelection =
            textFeld.durchsuchbar &&
                textFeld.stringOptions.isNotEmpty &&
                !_cascadeChildSlots.contains(textFeld.slotName)
            ? _activeSearchSelection(textFeld.slotName, renderSlots)
            : null;
        if (searchSelection != null) {
          return Column(
            key: Key(f.slotName),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CascadeSearchSelection(
                key: Key('${f.slotName}_search_selection'),
                entry: searchSelection,
                label: textFeld.angezeigterName,
                onEdit: () => _editSearchSelection(
                  textFeld.slotName,
                  prozessVersionId,
                  searchSelectionNotifier,
                ),
                onClear: () => _clearSearchSelection(
                  textFeld.slotName,
                  searchSelection,
                  prozessVersionId,
                  searchSelectionNotifier,
                ),
              ),
            ],
          );
        }

        final sichtbareOptionen = await _visibleOptionsAsync(
          textFeld,
          evaluatingVisitor,
          renderSlots,
          relevanceCache: optionRelevanceCache,
        );

        if (textFeld.stringOptions.isNotEmpty && sichtbareOptionen.isEmpty) {
          return null;
        }

        final textField = FormularTextField(
          optional: isOptional,
          key: Key(f.slotName),
          feld: textFeld,
          sichtbareOptionen: sichtbareOptionen,
          highlightDropdown: _searchableCascadeSlots.contains(
            textFeld.slotName,
          ),
          showsNextDropdown: _cascadeParentSlots.contains(textFeld.slotName),
          onDropdownCleared: _searchableCascadeSlots.contains(textFeld.slotName)
              ? () => _clearCascadeDescendants(
                  textFeld.slotName,
                  evaluatingVisitor,
                )
              : null,
        );
        if (!textFeld.durchsuchbar ||
            textFeld.stringOptions.isEmpty ||
            _cascadeChildSlots.contains(textFeld.slotName)) {
          return textField;
        }

        return Column(
          key: Key(f.slotName),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CascadeSearchField(
              key: Key('${f.slotName}_search'),
              loadEntries: () =>
                  _visibleSearchEntries(textFeld, evaluatingVisitor),
              onSelected: (entry) => _applySearchResult(
                entry,
                evaluatingVisitor,
                prozessVersionId,
                searchSelectionNotifier,
              ),
            ),
            const SizedBox(height: 16),
            textField,
          ],
        );
      }),
    );
  }
}
