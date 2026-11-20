import 'package:app/common/kommune.dart';
import 'package:app/graphql/__generated__/gemeindeinformationen.graphql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ein Auswahlfeld für Gemeinden, das die Gemeinden einer Kommune lädt und anzeigt.
class GemeindeSelectField extends ConsumerStatefulWidget {
  /// Erstellt ein GemeindeSelectField mit Label, Name und optionalem Hilfetext.
  const GemeindeSelectField({
    required this.label,
    required this.name,
    super.key,
    this.hintText,
  });

  /// Der Name des Formularfelds.
  final String name;

  /// Das Label, das über dem Auswahlfeld angezeigt wird.
  final String label;

  /// Optionaler Hilfetext, der im Auswahlfeld angezeigt wird.
  final String? hintText;

  @override
  ConsumerState<GemeindeSelectField> createState() =>
      _GemeindeSelectFieldState();
}

/// Zustand des GemeindeSelectField, der die Daten lädt und das Dropdown rendert.
class _GemeindeSelectFieldState extends ConsumerState<GemeindeSelectField> {
  @override
  Widget build(BuildContext context) {
    final kommune = ref.watch(kommuneProvider).value;
    if (kommune == null) return const SizedBox.shrink();

    return Query_Gemeindeinformationen_Widget(
      options: Options_Query_Gemeindeinformationen(
        variables: Variables_Query_Gemeindeinformationen(
          kommuneId: kommune.bereichAId,
        ),
      ),
      builder: (result, {fetchMore, refetch}) {
        final textTheme = Theme.of(context).textTheme;
        if (result.isLoading) {
          return const CircularProgressIndicator();
        }
        final gemeindeList = result.parsedData?.kommune.untereinheiten;

        return gemeindeList == null
            ? const SizedBox.shrink()
            : FormBuilderDropdown(
                name: widget.name,
                items: gemeindeList.map((gemeinde) {
                  return DropdownMenuItem(
                    value: gemeinde.id,
                    child: Text(gemeinde.name),
                  );
                }).toList(),
                decoration: InputDecoration(
                  label: Text(widget.label),
                  hintText: widget.hintText ?? widget.label,
                  hintStyle: textTheme.bodySmall,
                ),
              );
      },
    );
  }
}
