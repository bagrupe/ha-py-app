import 'package:app/common/design_tokens.dart';
import 'package:app/common/util/scaler.dart';
import 'package:app/routes/volunteer_database/providers/help_type_provider.dart';
import 'package:app/routes/volunteer_database/widgets/login/volunteer_login_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Toggle row for choosing whether the user offers or seeks help.
class HelpToggleButtons extends ConsumerWidget {
  /// Creates the volunteer help type toggle and login action row.
  const HelpToggleButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (MediaQuery.textScalerOf(context).isA11yMode) {
      return const _HelpTypeSelectorColumn();
    }

    return const _HelpTypeSelectorRow();
  }
}

/// Segmented control button for a single help type option.
class _ToggleButton extends StatelessWidget {
  /// Creates a selectable help type button.
  const _ToggleButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.isLeft,
  });

  /// Translation-ready button label.
  final String title;

  /// Whether this button is currently selected.
  final bool isSelected;

  /// Callback that selects this help type.
  final VoidCallback onTap;

  /// Whether this button is the left side of the segmented control.
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.horizontal(
      left: isLeft ? const Radius.circular(8) : Radius.zero,
      right: isLeft ? Radius.zero : const Radius.circular(8),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? DesignTokens.gray500 : DesignTokens.white,
          borderRadius: borderRadius,
          border: Border.all(color: DesignTokens.gray500),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: isSelected ? DesignTokens.white : DesignTokens.gray500,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class HelpTypeSelector extends ConsumerWidget {
  const HelpTypeSelector({super.key});

  static const double _textScaleThreshold = 1.3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

    if (textScaleFactor > _textScaleThreshold) {
      return const _HelpTypeSelectorColumn();
    }

    return const _HelpTypeSelectorRow();
  }
}

class _HelpTypeSelectorRow extends ConsumerWidget {
  const _HelpTypeSelectorRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      children: [
        Expanded(child: _HelpTypeToggleButtons()),
        SizedBox(width: 16),
        VolunteerDatabaseLoginButton(),
      ],
    );
  }
}

class _HelpTypeSelectorColumn extends ConsumerWidget {
  const _HelpTypeSelectorColumn();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HelpTypeToggleButtons(),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: VolunteerDatabaseLoginButton(),
        ),
      ],
    );
  }
}

class _HelpTypeToggleButtons extends ConsumerWidget {
  const _HelpTypeToggleButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helpType = ref.watch(helpTypeProvider);

    return Row(
      children: [
        Expanded(
          child: _ToggleButton(
            title: 'application.volunteer_database.offer_help'.tr(),
            isSelected: helpType == HelpType.offerHelp,
            onTap: () {
              ref.read(helpTypeProvider.notifier).state = HelpType.offerHelp;
            },
            isLeft: true,
          ),
        ),
        Expanded(
          child: _ToggleButton(
            title: 'application.volunteer_database.seek_help'.tr(),
            isSelected: helpType == HelpType.seekHelp,
            onTap: () {
              ref.read(helpTypeProvider.notifier).state = HelpType.seekHelp;
            },
            isLeft: false,
          ),
        ),
      ],
    );
  }
}
