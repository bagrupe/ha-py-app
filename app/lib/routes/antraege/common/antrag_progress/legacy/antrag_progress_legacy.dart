import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';

/// Legacy manual functions kept temporarily for testing purposes.
/// These should be removed at a later point when migration is fully complete.
extension AntragProgressLegacy on AntragProgress {
  /// Erzeugt eine Kopie mit optionalen neuen Werten.
  AntragProgress legacyCopyWith({
    Kommune? kommune,
    Prozess? prozess,
    ProzessVersion? prozessVersion,
    int? index,
    EditableSlots? slots,
    EditableSlots? slotErrors,
    AntragClientStatus? clientStatus,
    String? sharedKeyEncryptedForBuerger,
  }) {
    return AntragProgress(
      sharedKeyEncryptedForBuerger:
          sharedKeyEncryptedForBuerger ?? this.sharedKeyEncryptedForBuerger,
      kommune: kommune ?? this.kommune,
      prozess: prozess ?? this.prozess,
      prozessVersion: prozessVersion ?? this.prozessVersion,
      index: index ?? this.index,
      slots: slots ?? this.slots,
      slotErrors: slotErrors ?? this.slotErrors,
      clientStatus: clientStatus ?? this.clientStatus,
      schritte: schritte,
      ausfuehrungId: ausfuehrungId,
    );
  }
}
