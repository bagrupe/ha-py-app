import 'package:app/common/design_tokens.dart';
import 'package:app/routes/volunteer_database/providers/help_type_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBarWidget extends ConsumerWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final helpType = ref.watch(helpTypeProvider);

    return TextField(
      decoration: InputDecoration(
        hintText: helpType == HelpType.offerHelp
            ? 'application.volunteer_database.search_hint_offer'.tr()
            : 'application.volunteer_database.search_hint_seek'.tr(),
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: DesignTokens.gray500,
        ),
        suffixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary,
        ),
        filled: true,
        fillColor: DesignTokens.gray100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DesignTokens.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DesignTokens.gray300),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
