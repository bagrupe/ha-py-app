part of 'formular_schritt.dart';

/// Provides relevance for a form step.
extension FormularSchrittRelevance on FormularSchritt {
  /// Runs relevance cleanup and refreshes the rendered form.
  /// Serializes updates so overlapping changes cannot race with cleanup.
  Future<void> _updateRelevance(
    EvaluatingVisitorService evaluatingVisitor,
  ) async {
    if (_relevanzLaeuft) {
      _relevanzErneutNoetig = true;
      return;
    }

    _relevanzLaeuft = true;
    final automatischGeloeschteKategorieSlots = <String>{};
    final durchKategorieAenderungAusgeloest =
        _relevanzAusgeloestDurchKategorieAenderung;
    _relevanzAusgeloestDurchKategorieAenderung = false;
    _syncSearchSelectionsToForm();
    final aktiveKategorieSlots = await _activeSelectedCascadeSlots(
      evaluatingVisitor,
      _formKey.currentState!.instantValue,
    );

    try {
      var durchlaeufe = 0;
      const maxDurchlaeufe = 5;
      do {
        _relevanzErneutNoetig = false;
        _inCleanup = true;
        try {
          automatischGeloeschteKategorieSlots.addAll(
            await cleanupIrrelevantFields(evaluatingVisitor),
          );
        } finally {
          _inCleanup = false;
        }
        _discardInvalidSearchSelections();
        _stream.add(_formKey.currentState!.instantValue);
        durchlaeufe++;
      } while (_relevanzErneutNoetig && durchlaeufe < maxDurchlaeufe);
    } finally {
      _relevanzLaeuft = false;
    }

    _letzteFormWerte = Map<String, dynamic>.from(
      _formKey.currentState!.instantValue,
    );

    final aktiveKategorieWurdeAngepasst = automatischGeloeschteKategorieSlots
        .any(aktiveKategorieSlots.contains);
    if (aktiveKategorieWurdeAngepasst && !durchKategorieAenderungAusgeloest) {
      _showCategoryAdjustedSnackbar();
    }
  }

  Future<Set<String>> _activeSelectedCascadeSlots(
    EvaluatingVisitorService evaluatingVisitor,
    Map<String, dynamic> formValues,
  ) async {
    final kandidaten = schritt.felder.whereType<FormularTextFeldData>().where(
      (feld) =>
          _searchableCascadeSlots.contains(feld.slotName) &&
          formValues[feld.slotName] != null,
    );
    final bewertungen = await kandidaten.map((feld) async {
      final relevant = await evaluatingVisitor.evaluateBool(
        feld.istRelevant,
        formValues,
      );
      return (slotName: feld.slotName, relevant: relevant);
    }).wait;
    return {
      for (final bewertung in bewertungen)
        if (bewertung.relevant) bewertung.slotName,
    };
  }

  /// Clears irrelevant fields and reports reset category slots.
  /// Preserves valid selections elsewhere in the category cascade.
  /// [evaluatingVisitor] evaluates the current relevance expressions.
  Future<Set<String>> cleanupIrrelevantFields(
    EvaluatingVisitorService evaluatingVisitor,
  ) async {
    final form = _formKey.currentState!;
    final geloeschteKategorieSlots = <String>{};

    final felderMitRelevant = await schritt.felder
        .where(
          (feld) =>
              form.instantValue.containsKey(feld.slotName) &&
              form.instantValue[feld.slotName] != null,
        )
        .map(
          (feld) async => (
            slotName: feld.slotName,
            istRelevant: await evaluatingVisitor.evaluateBool(
              feld.istRelevant,
              form.instantValue,
            ),
          ),
        )
        .wait;

    final irrelevanteFelder = felderMitRelevant.where((f) => !f.istRelevant);

    for (final feld in irrelevanteFelder) {
      if (_searchableCascadeSlots.contains(feld.slotName)) {
        geloeschteKategorieSlots.add(feld.slotName);
      }
      FormularSchritt._clearFormValue(form, feld.slotName);
    }

    final aktuelleWerte = Map<String, dynamic>.from(form.instantValue);
    final optionsPruefungen = await schritt.felder
        .whereType<FormularTextFeldData>()
        .where(
          (feld) =>
              aktuelleWerte[feld.slotName] != null &&
              feld.stringOptions.isNotEmpty,
        )
        .map((feld) async {
          final aktuellerWert = aktuelleWerte[feld.slotName];
          final ausgewaehlteOption = feld.stringOptions
              .where((option) => option.key == aktuellerWert)
              .firstOrNull;
          final istRelevant = ausgewaehlteOption?.istRelevant;
          final istVerfuegbar =
              ausgewaehlteOption != null &&
              (istRelevant == null ||
                  await evaluatingVisitor.evaluateBool(
                    istRelevant,
                    aktuelleWerte,
                  ));
          return (feld: feld, istVerfuegbar: istVerfuegbar);
        })
        .wait;

    for (final pruefung in optionsPruefungen) {
      if (pruefung.istVerfuegbar) continue;
      if (_searchableCascadeSlots.contains(pruefung.feld.slotName)) {
        geloeschteKategorieSlots.add(pruefung.feld.slotName);
      }
      FormularSchritt._clearFormValue(form, pruefung.feld.slotName);
    }
    return geloeschteKategorieSlots;
  }
}
