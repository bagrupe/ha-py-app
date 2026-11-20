import 'package:app/routes/aktuelles/common/text_sizer.dart';

/// Legacy manual functions kept temporarily for testing purposes.
/// These should be removed at a later point when migration is fully complete.
extension TextSizerLegacy on TextSizeState {
  /// Gibt eine neue Instanz mit optional geändertem Textgrößenfaktor zurück.
  TextSizeState legacyCopyWith({double? textSizeModifier}) =>
      TextSizeState(textSizeModifier ?? this.textSizeModifier);
}
