import 'package:app/common/design_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

/// Ein Suchleisten-Widget mit Debounce-Funktionalität zur verzögerten Ausführung von Suchanfragen.
/// [value] ist der aktuelle Suchbegriff, [onChanged] wird bei Änderungen aufgerufen, [debounce] definiert die Verzögerung in Millisekunden.
class Searchbar extends StatefulWidget {
  const Searchbar({
    required this.onChanged,
    super.key,
    this.value = '',
    this.debounce = 300,
    this.hintText,
    this.fillColor = DesignTokens.gray100,
    this.borderColor = DesignTokens.gray300,
    this.foregroundColor = DesignTokens.gray900,
  });
  final String value;
  final ValueChanged<String> onChanged;
  final int debounce;
  final String? hintText;
  final Color fillColor;
  final Color borderColor;
  final Color foregroundColor;

  @override
  State<Searchbar> createState() => _SearchbarState();
}

/// Zustandsklasse für die Suchleiste, verwaltet den Textcontroller und den Debouncer.
class _SearchbarState extends State<Searchbar> {
  final Debouncer _debounce = Debouncer();
  final _textController = TextEditingController();

  /// Behandelt Änderungen im Suchfeld und führt die Debounce-Logik aus.
  /// [search] ist der aktuelle Suchbegriff.
  void _onChanged(String search) {
    setState(() {});
    final duration = Duration(milliseconds: widget.debounce);

    _debounce.debounce(
      duration: duration,
      onDebounce: () {
        setState(() {
          widget.onChanged(search);
        });
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textController.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      onChanged: _onChanged,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        filled: true,
        fillColor: widget.fillColor,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        hintText: widget.hintText ?? 'application.common.searchbar_hint'.tr(),
        hintStyle: TextStyle(color: widget.foregroundColor),
        suffixIcon: _textController.text.isEmpty
            ? const Icon(Icons.search)
            : ClipOval(
                child: Material(
                  color: Colors.transparent,
                  clipBehavior: Clip.hardEdge,
                  child: IconButton(
                    onPressed: () {
                      _textController.clear();
                      _onChanged('');
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
        suffixIconColor: widget.foregroundColor,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
