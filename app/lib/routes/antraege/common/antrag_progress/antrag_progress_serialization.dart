part of 'antrag_progress.dart';

/// Handles serialization for the application controller.
mixin _AntragProgressSerialization on _AntragProgressController {
  /// Converts the current state into a list of inputs for execution.
  @override
  Future<List<Input_AusfuehrungBearbeitungInput>> convertStateToInputs(
    Uint8List key,
  ) async {
    final slots = _state.schritte
        .expand((s) => s.slots)
        .whereNot((s) => s.optional && _state.slots[s.name] == null);
    final encryptionRequiredMap = {
      for (final slot in slots) slot.name: slot.encrypted,
    };

    final evaluatingVisitor = ref.read(evaluatingVisitorProvider);
    final slotValues = <Input_SlotValuesInput>[];
    for (final e in _state.slots.entries) {
      final preparedValue = await _prepareAttachmentValue(e.value);
      final isEncrypted = encryptionRequiredMap[e.key] ?? true;

      final value = isEncrypted
          ? Input_SlotValuesValueInput.encryptedValue(
              await toEncryptedSlotValue(preparedValue, key),
            )
          : Input_SlotValuesValueInput.plainValue(
              await toPlainSlotValue(preparedValue),
            );

      slotValues.add(Input_SlotValuesInput(name: e.key, value: value));
    }
    return Future.wait(
      _state.schritte.map((s) async {
        var nextVerbindungId = '';
        for (final verbindung in s.verbindungen) {
          if (await evaluatingVisitor.evaluateBool(
            verbindung.istRelevant,
            _state.slots,
          )) {
            nextVerbindungId = verbindung.id;
            break;
          }
        }
        return Input_AusfuehrungBearbeitungInput(
          schrittId: s.id,
          slotValues: slotValues
              .where((sv) => s.slots.any((slot) => slot.name == sv.name))
              .toList(),
          nextVerbindungId: nextVerbindungId,
        );
      }),
    );
  }
}
