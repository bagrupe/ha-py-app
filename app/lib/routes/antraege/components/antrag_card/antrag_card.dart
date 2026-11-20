import 'package:app/common/theme.dart';
import 'package:app/routes/antraege/common/antrag_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat('dd.MM.yyyy');

/// Widget zur Darstellung einer Karte mit Informationen zu einem Antrag.
/// Zeigt Titel, Status, Datum der letzten Änderung und optional eine Fehleranzahl an.
/// Unterstützt eine optionale Tap-Interaktion.
class AntragCard extends ConsumerWidget {
  /// Erzeugt eine neue Instanz von AntragCard.
  /// [title] ist der Titel des Antrags, [id] die eindeutige Kennung.
  /// [state] beschreibt den aktuellen Status des Antrags.
  /// [lastChange] ist das Datum der letzten Statusänderung.
  /// [errorCount] gibt die Anzahl der Fehler an, wenn der Status Fehler ist.
  /// [onTap] ist der Callback für Tap-Interaktionen.
  const AntragCard({
    required this.title,
    required this.id,
    required this.state,
    super.key,
    this.lastChange,
    this.errorCount,
    this.onTap,
  }) : assert(
         state != AntragState.error || errorCount != null,
         'If the Antrag is in an error state, errorCount must not be null!',
       );
  final String title;
  final String id;

  final AntragState state;
  final DateTime? lastChange;
  final int? errorCount;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final textTheme = Theme.of(context).textTheme;

    final row = Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 30, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(state.toDatedLabel(lastChange)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              AntragCardStatusIcon(
                state: state,
                count: state == AntragState.buerger ? 1 : null,
              ),
            ],
          ),
          if (state == AntragState.buerger) ...[
            const SizedBox(height: 16),
            Text(
              'Bitte übermitteln Sie ...',
              style: TextStyle(color: theme.primaryColor),
            ),
          ],
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: onTap != null ? InkWell(onTap: onTap, child: row) : row,
    );
  }
}

/// Widget zur Darstellung eines Status-Icons für einen Antrag.
/// Zeigt je nach Status ein Icon oder eine Zahl in einem farbigen Kreis an.
class AntragCardStatusIcon extends ConsumerWidget {
  /// Erzeugt eine neue Instanz von AntragCardStatusIcon.
  /// [state] bestimmt das anzuzeigende Icon und die Farben.
  /// [count] zeigt eine Zahl anstelle des Icons, falls gesetzt.
  const AntragCardStatusIcon({required this.state, super.key, this.count});
  final AntragState state;
  final int? count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeProvider);
    final (IconData iconData, Color fgColor, Color bgColor) = state
        .toRenderDetails(theme);

    return Container(
      height: 34,
      width: 34,
      decoration: ShapeDecoration(color: bgColor, shape: const CircleBorder()),
      child: count == null
          ? Icon(iconData, color: fgColor)
          : Center(
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: fgColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
