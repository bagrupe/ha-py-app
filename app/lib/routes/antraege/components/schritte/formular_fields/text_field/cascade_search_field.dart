import 'dart:async';

import 'package:app/components/searchbar/searchbar.dart';
import 'package:app/routes/antraege/components/schritte/cascade_entry.dart';
import 'package:app/routes/antraege/components/schritte/cascade_search_index.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/formular_field_style.dart';
import 'package:app/routes/overlays/location_search/components/result_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

part 'no_results_hint.dart';
part 'cascade_search_result.dart';

class CascadeSearchField extends StatefulWidget {
  const CascadeSearchField({
    required this.loadEntries,
    required this.onSelected,
    super.key,
  });

  final Future<List<CascadeEntry>> Function() loadEntries;
  final ValueChanged<CascadeEntry> onSelected;

  @override
  State<CascadeSearchField> createState() => _CascadeSearchFieldState();
}

class _CascadeSearchFieldState extends State<CascadeSearchField> {
  String _query = '';
  List<CascadeEntry> _results = const [];
  bool _loading = false;
  int _searchGeneration = 0;
  int _searchbarVersion = 0;

  @override
  void didUpdateWidget(CascadeSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_query.trim().isNotEmpty) unawaited(_search(_query));
  }

  Future<void> _search(String query) async {
    final generation = ++_searchGeneration;
    _query = query;
    if (query.trim().isEmpty) {
      setState(() => _results = const []);
      return;
    }

    setState(() => _loading = true);
    try {
      final entries = await widget.loadEntries();
      if (!mounted || query != _query || generation != _searchGeneration) {
        return;
      }
      setState(() => _results = CascadeSearchIndex.search(entries, query));
    } catch (_) {
      if (mounted && generation == _searchGeneration) {
        setState(() => _results = const []);
      }
    } finally {
      if (mounted && query == _query && generation == _searchGeneration) {
        setState(() => _loading = false);
      }
    }
  }

  void _select(CascadeEntry entry) {
    FocusScope.of(context).unfocus();
    setState(() {
      _query = '';
      _results = const [];
      _searchbarVersion++;
    });
    widget.onSelected(entry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noResults = _query.trim().isNotEmpty && !_loading && _results.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Searchbar(
          key: ValueKey(_searchbarVersion),
          debounce: 150,
          hintText: 'application.antraege.formular_schritt.search_hint'.tr(),
          fillColor: highlightedFieldBackground(theme),
          borderColor: theme.primaryColor,
          onChanged: _search,
        ),
        if (_loading && _results.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        if (noResults) const _NoResultsHint(),
        if (_results.isNotEmpty) const SizedBox(height: 4),
        for (final entry in _results)
          _CascadeSearchResult(entry: entry, onTap: () => _select(entry)),
      ],
    );
  }
}
