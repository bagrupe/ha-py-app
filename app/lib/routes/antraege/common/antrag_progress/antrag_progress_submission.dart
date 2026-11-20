part of 'antrag_progress.dart';

/// Handles submission for the application controller.
mixin _AntragProgressSubmission on _AntragProgressController {
  /// Confirms the application and initiates the payment process or submission if necessary.
  Future<void> bestaetigen() async {
    final hasBezahlenSchritt = _state.bezahlenSchritt != null;

    if (hasBezahlenSchritt) {
      state = _state.copyWith(clientStatus: AntragClientStatus.paying);
    } else {
      await submit();
    }
  }

  /// Submits the application, depending on the current status.
  @override
  Future<void> submit() async {
    if (_state.clientStatus == AntragClientStatus.submitting) return;
    state = _state.copyWith(clientStatus: AntragClientStatus.submitting);

    try {
      await awaitPendingImageCompressions();
      if (_state.ausfuehrungId != null) {
        await ausfuehrungContinue();
      } else {
        await ausfuehrungCreate();
      }
    } catch (_) {
      state = _state.copyWith(clientStatus: AntragClientStatus.errorSubmitting);
    }

    ref.invalidate(ausfuehrungProvider);
  }

  /// Sets the status to submitted.
  void setSubmitted() {
    state = _state.copyWith(clientStatus: AntragClientStatus.submitted);
  }
}
