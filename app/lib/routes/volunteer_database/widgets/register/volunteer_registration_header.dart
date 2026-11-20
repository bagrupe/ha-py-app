import 'package:app/common/design_tokens.dart';
import 'package:app/common/util/scaler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Header for the volunteer registration flow.
class VolunteerRegistrationHeader extends StatelessWidget {
  /// Creates the volunteer registration header.
  const VolunteerRegistrationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isA11y = MediaQuery.textScalerOf(context).isA11yMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isA11y)
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_Headline(), _CloseButton()],
          )
        else
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _Headline()),
              _CloseButton(),
            ],
          ),
        const SizedBox(height: 16),
        Text(
          'application.volunteer_database.register_page.introduction'.tr(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: DesignTokens.gray500,
          ),
        ),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      header: true,
      child: Text(
        'application.volunteer_database.register_page.welcome'.tr(),
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: DesignTokens.gray900,
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: context.pop,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.zero,
        minimumSize: const Size(72, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerRight,
      ),
      child: Text('application.volunteer_database.register_page.close'.tr()),
    );
  }
}
