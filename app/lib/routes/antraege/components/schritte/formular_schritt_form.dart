part of 'formular_schritt.dart';

/// Renders the fields and loading state of a form step.
class _FormularSchrittForm extends ConsumerWidget {
  /// Connects the view to its existing stateful step controller.
  const _FormularSchrittForm({required this.step});

  /// Controller preserving field and cascade selections between builds.
  final FormularSchritt step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(antragProgressProvider)!;
    final evaluatingVisitor = ref.watch(evaluatingVisitorProvider);
    final persistedSearchSelections = ref.read(searchCategorySelectionProvider);
    final searchSelectionNotifier = ref.read(
      searchCategorySelectionProvider.notifier,
    );
    step._prozessVersionId = progress.prozessVersion.id;
    step._searchSelectionNotifier = searchSelectionNotifier;
    final initialValue = step._buildInitialValue(progress.slots, ref);
    for (final rootField
        in step.schritt.felder.whereType<FormularTextFeldData>().where(
          (field) =>
              field.durchsuchbar &&
              field.stringOptions.isNotEmpty &&
              !step._cascadeChildSlots.contains(field.slotName),
        )) {
      final persistedPath =
          persistedSearchSelections[step._selectionKey(
            progress.prozessVersion.id,
            rootField.slotName,
          )];
      if (persistedPath != null) initialValue.addAll(persistedPath);
    }
    step._letzteFormWerte ??= Map<String, dynamic>.from(initialValue);

    return FormBuilder(
      key: step._formKey,
      initialValue: initialValue,
      onChanged: () => step._onFormChanged(evaluatingVisitor),
      child: StreamBuilder<dynamic>(
        stream: step._stream.stream,
        initialData: initialValue,
        builder: (context, snapshot) {
          if (snapshot.data == null) return const SizedBox.shrink();
          final values = snapshot.data as Map<String, dynamic>;
          return FutureBuilder<Iterable<Widget?>>(
            future: step.renderFieldsAsync(
              evaluatingVisitor,
              values,
              persistedSearchSelections: persistedSearchSelections,
              prozessVersionId: progress.prozessVersion.id,
              searchSelectionNotifier: searchSelectionNotifier,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                step._markContentReady();
                return Text(
                  'application.antraege.formular_schritt.load_error'.tr(),
                );
              }
              if (snapshot.data == null) return const SizedBox.shrink();
              if (snapshot.connectionState == ConnectionState.done) {
                step._markContentReady();
              }
              final aktuelleFormWerte =
                  step._formKey.currentState?.instantValue ??
                  const <String, dynamic>{};
              final felder = [...?snapshot.data?.nonNulls].where((widget) {
                final key = widget.key;
                final slotName = key is ValueKey<String> ? key.value : null;
                return slotName == null ||
                    !step._hasEmptyCascadeAncestor(slotName, aktuelleFormWerte);
              }).toList();
              if (felder.isEmpty) {
                return Text(
                  'application.antraege.formular_schritt.step_skipped'.tr(),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const MissingAttachmentsNotice(),
                  ...felder.joinWithElement(const SizedBox(height: 16)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
