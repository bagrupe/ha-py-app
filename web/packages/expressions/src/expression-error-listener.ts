import {
  type ATNSimulator,
  BaseErrorListener,
  type RecognitionException,
  type Recognizer,
} from 'antlr4ng';

/**
 * Fehler-Listener für Ausdrücke, der bei Syntaxfehlern eine Ausnahme wirft.
 */
export class ExpressionErrorListener extends BaseErrorListener {
  /**
   * Wird bei einem Syntaxfehler aufgerufen und wirft die Fehlermeldung als Ausnahme.
   * @param _recognizer Der Parser, der den Fehler erkannt hat.
   * @param _offendingSymbol Das fehlerhafte Symbol.
   * @param _line Die Zeilennummer des Fehlers.
   * @param _column Die Spaltennummer des Fehlers.
   * @param msg Die Fehlermeldung.
   * @param _e Die Ausnahme, falls vorhanden.
   */
  syntaxError<T extends ATNSimulator>(
    _recognizer: Recognizer<T> | null,
    _offendingSymbol: unknown,
    _line: number,
    _column: number,
    msg: string,
    _e: RecognitionException | null,
  ): void {
    throw _e ? `${msg}: ${_e.message}` : msg;
  }
}
