part of 'antrag_progress.dart';

/// Defines the shared state and operations used by the controller's parts.
abstract class _AntragProgressController extends Notifier<AntragProgress?> {
  /// Holds the execution key across submission retries.
  Uint8List? _ausfuehrungKey;

  /// Returns the current state or throws an error if null.
  AntragProgress get _state {
    final maybeState = state;
    if (maybeState == null) {
      throw StateError('AntragProgress state is null');
    }
    return maybeState;
  }

  /// Loads the next step of an existing execution.
  Future<AntragProgress?> continueAusfuehrung({
    required String id,
    bool keepAusfuehrungKey = false,
  });

  /// Serializes and encrypts the current form state for transmission.
  Future<List<Input_AusfuehrungBearbeitungInput>> convertStateToInputs(
    Uint8List key,
  );

  /// Sends the current application or continues an existing execution.
  Future<void> submit();

  /// Sends values for the current step of an existing execution.
  Future<void> ausfuehrungContinue();

  /// Creates an execution using a stable encryption key across retries.
  Future<void> ausfuehrungCreate();
}
