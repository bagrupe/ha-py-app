part of 'antrag_progress.dart';

/// Handles navigation for the application controller.
mixin _AntragProgressNavigation on _AntragProgressController {
  /// Switches to next step or to verification if last step reached.
  void naechsterSchritt() {
    if (_state.index == _state.schritteCount - 1) {
      ueberpruefen();
    } else {
      state = _state.copyWith(index: _state.index + 1);
    }
  }

  /// Switches to previous step or to confirmation if in amending mode.
  bool vorigerSchritt() {
    if (_state.clientStatus == AntragClientStatus.amending) {
      state = _state.copyWith(
        clientStatus: AntragClientStatus.confirming,
        index: _state.schritteCount - 1,
      );
      return true;
    } else if (_state.index > 0) {
      state = _state.copyWith(
        clientStatus: AntragClientStatus.editing,
        index: _state.index - 1,
      );
      return true;
    }
    return false;
  }

  /// Sets status to editing and optional step index.
  void bearbeiten({int? index}) {
    state = _state.copyWith(
      clientStatus: AntragClientStatus.editing,
      index: index ?? _state.index,
    );
  }

  /// Sets status to confirming.
  void ueberpruefen() {
    state = _state.copyWith(clientStatus: AntragClientStatus.confirming);
  }

  /// Sets status to amending and optionally jumps to a step with errors.
  void korrigieren({int? index}) {
    if (index != null) {
      state = _state.copyWith(
        clientStatus: AntragClientStatus.amending,
        index: index,
      );
      return;
    }

    for (final (i, schritt) in _state.schritte.indexed) {
      if (schritt.slots.any((slot) => _state.slotErrors[slot.name] != null)) {
        korrigieren(index: i);
        return;
      }
    }
  }

  /// Ends current process and resets state.
  void endProzess() {
    _ausfuehrungKey = null;
    ref.read(antragMetaProvider.notifier).endProzess();
    ref.read(searchCategorySelectionProvider.notifier).clear();
    state = null;
  }

  /// Sets a value for a slot field.
  void setSlot(String name, String value) {
    final newSlots = EditableSlots.unmodifiable({..._state.slots, name: value});
    state = _state.copyWith(slots: newSlots);
  }

  /// Completes a step and updates slots and errors.
  void completeStep(EditableSlots slots, EditableSlots slotErrors) {
    state = _state.copyWith(
      slots: {..._state.slots, ...slots},
      slotErrors: {..._state.slotErrors, ...slotErrors},
      index: _state.clientStatus == AntragClientStatus.amending
          ? _state.schritteCount - 1
          : _state.index,
    );
    naechsterSchritt();
  }
}
