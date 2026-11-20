part of 'pilot_project_section.dart';

/// Retains the code and validation feedback while activation is saved.
class _PilotProjectSectionState extends ConsumerState<PilotProjectSection> {
  /// Translation namespace shared by the section's labels and feedback.
  static const _prefix = 'application.profil.my_account.pilot_project';

  /// Current input, retained after failed redemption attempts.
  String _code = '';

  /// Translation key describing the most recent failure.
  String? _error;

  /// Whether activation is currently being persisted.
  bool _isRedeeming = false;

  /// Validates the code and announces successful persistent activation.
  Future<void> _redeem() async {
    if (_isRedeeming || _code.trim().isEmpty) return;
    setState(() {
      _isRedeeming = true;
      _error = null;
    });
    try {
      final accepted = await ref
          .read(pilotProjectUnlockedProvider.notifier)
          .redeem(_code);
      if (!mounted) return;
      if (accepted) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$_prefix.success'.tr())));
      } else {
        setState(() => _error = '$_prefix.invalid');
      }
    } on Exception {
      if (mounted) setState(() => _error = '$_prefix.save_error');
    } finally {
      if (mounted) setState(() => _isRedeeming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = ref.watch(pilotProjectUnlockedProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Semantics(
          header: true,
          child: Text(
            '$_prefix.title'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Text(
          '$_prefix.description_title'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text('$_prefix.description'.tr()),
        if (unlocked)
          Semantics(liveRegion: true, child: Text('$_prefix.unlocked'.tr()))
        else ...[
          AppTextField(
            label: '$_prefix.code'.tr(),
            enabled: !_isRedeeming,
            errorText: _error?.tr(),
            onChanged: (value) => setState(() {
              _code = value;
              _error = null;
            }),
          ),
          FilledButton(
            onPressed: _code.trim().isEmpty || _isRedeeming ? null : _redeem,
            child: _isRedeeming
                ? Semantics(
                    label: '$_prefix.loading'.tr(),
                    child: const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Text('$_prefix.redeem'.tr()),
          ),
        ],
      ],
    );
  }
}
