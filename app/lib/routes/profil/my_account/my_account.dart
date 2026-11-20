import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/bundid_auth.dart';
import 'package:app/common/auth/bundid_consent_view.dart';
import 'package:app/common/auth/confirm_logout.dart';
import 'package:app/common/auth/phone_auth.dart';
import 'package:app/common/auth/sms_error_message.dart';
import 'package:app/common/auth/strong_session.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/forms/app_phone_number_field.dart';
import 'package:app/components/forms/app_sms_code_field.dart';
import 'package:app/components/forms/app_text_field.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:app/routes/profil/my_account/pilot_project_section.dart';
import 'package:app/routes/volunteer_database/views/bundid_onboarding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'account_view.dart';
part 'bundid_managed_fields.dart';
part 'editable_account_fields.dart';
part 'logged_out_view.dart';
part 'phone_entry_or_sms_step.dart';
part 'phone_section.dart';
part 'reverification_notice.dart';

class MyAccountPage extends ConsumerStatefulWidget {
  const MyAccountPage({super.key});

  @override
  ConsumerState<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends ConsumerState<MyAccountPage> {
  bool _initialized = false;
  String _vorname = '';
  String _nachname = '';
  String _email = '';
  String _street = '';
  String _postalCode = '';
  String _city = '';
  String _country = '';
  bool _isSaving = false;
  String? _saveError;

  bool _isEditingProfile = false;

  bool _isChangingPhone = false;
  bool _isSmsStep = false;
  String _phoneNumber = '';
  String _smsCode = '';
  bool _isPhoneLoading = false;
  String? _phoneError;
  bool _requiresReverification = false;

  bool _isBundIdLoading = false;

  String? _greetingMessage;

  String? _pendingToken;
  BundIdProfileSuggestion? _pendingSuggestion;
  bool _isConfirmingRegistration = false;
  bool _isLoggingOutEverywhere = false;

  /// Deferred, because the account view already captured the old values in this frame.
  void _seedFrom(MyAccountProfile profile) {
    if (_initialized) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _initialized) return;
      setState(() {
        _vorname = profile.vorname ?? '';
        _nachname = profile.nachname ?? '';
        _email = profile.email ?? '';
        _street = profile.street ?? '';
        _postalCode = profile.postalCode ?? '';
        _city = profile.city ?? '';
        _country = profile.country ?? '';
        _isEditingProfile = profile.vorname == null && profile.nachname == null;
        _initialized = true;
      });
    });
  }

  void _resetLocalState() {
    _initialized = false;
    _isChangingPhone = false;
    _isSmsStep = false;
    _phoneNumber = '';
    _smsCode = '';
    _phoneError = null;
    _isPhoneLoading = false;
    _requiresReverification = false;
    _saveError = null;
    _pendingToken = null;
    _pendingSuggestion = null;
    _greetingMessage = null;
    _isEditingProfile = false;
  }

  String? _orNull(String value) => value.trim().isEmpty ? null : value.trim();

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    final success = await saveMyAccountProfile(
      ref,
      vorname: _orNull(_vorname),
      nachname: _orNull(_nachname),
      email: _orNull(_email),
      street: _orNull(_street),
      postalCode: _orNull(_postalCode),
      city: _orNull(_city),
      country: _orNull(_country),
    );

    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _saveError = success
          ? null
          : 'application.profil.my_account.errors.save'.tr();
      if (success) {
        _greetingMessage = null;
        _isEditingProfile = false;
      }
    });
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('application.profil.my_account.saved'.tr())),
      );
    }
  }

  Future<void> _sendPhoneCode() async {
    final localDigits = _phoneNumber.replaceAll(RegExp('[^0-9]'), '');
    if (localDigits.length < minGermanMobileNumberDigits) {
      setState(() {
        _phoneError = 'application.profil.my_account.errors.invalid_phone'.tr();
      });
      return;
    }

    setState(() {
      _isPhoneLoading = true;
      _phoneError = null;
    });

    final fullPhoneNumber = '+49$localDigits';
    final outcome = await requestSmsCode(
      ref.read(graphqlClientProvider),
      fullPhoneNumber,
    );

    if (!mounted) return;

    switch (outcome) {
      case RequestSmsCodeSameAsCurrentNumber():
        setState(() {
          _isPhoneLoading = false;
          _phoneError = 'application.profil.my_account.errors.same_phone_number'
              .tr();
        });
      case RequestSmsCodeBundIdLoginRequired():
        setState(() {
          _isPhoneLoading = false;
          _phoneError =
              'application.profil.my_account.errors.bundid_login_required'.tr();
        });
      case RequestSmsCodeInvalidPhone():
        setState(() {
          _isPhoneLoading = false;
          _phoneError = 'application.profil.my_account.errors.invalid_phone'
              .tr();
        });
      case RequestSmsCodeDeliveryFailed():
        setState(() {
          _isPhoneLoading = false;
          _phoneError =
              'application.profil.my_account.errors.sms_delivery_failed'.tr();
        });
      case RequestSmsCodeRateLimited(:final retryAfter):
        final message = rateLimitMessage(
          'application.profil.my_account.errors',
          retryAfter,
        );
        setState(() {
          _isPhoneLoading = false;
          _phoneError = message.key.tr(namedArgs: message.args);
        });
      case RequestSmsCodeFailure():
        setState(() {
          _isPhoneLoading = false;
          _phoneError = 'application.profil.my_account.errors.invalid_phone'
              .tr();
        });
      case RequestSmsCodeSuccess():
        setState(() {
          _isPhoneLoading = false;
          _isSmsStep = true;
          _phoneNumber = fullPhoneNumber;
          _smsCode = '';
        });
    }
  }

  Future<void> _confirmPhoneCode() async {
    if (_smsCode.length != 6) {
      setState(() {
        _phoneError = 'application.profil.my_account.errors.invalid_code'.tr();
      });
      return;
    }

    setState(() {
      _isPhoneLoading = true;
      _phoneError = null;
    });

    final container = ProviderScope.containerOf(context, listen: false);
    final outcome = await validateSmsCode(
      ref.read(graphqlClientProvider),
      telephoneNumber: _phoneNumber,
      code: _smsCode,
    );

    if (outcome case ValidateSmsCodeSuccess(
      :final token,
      :final refreshToken,
    )) {
      await activateStrongSession(
        container,
        token: token,
        refreshToken: refreshToken,
      );
      container.read(justLoggedOutProvider.notifier).set(false);
      container
        ..invalidate(myAccountProfileProvider)
        ..invalidate(hasStrongSessionProvider);
      container.read(volunteerAuthProvider.notifier).signIn();
    }
    if (!mounted) return;

    switch (outcome) {
      case ValidateSmsCodeRequiresBundIdReverification():
        setState(() {
          _isPhoneLoading = false;
          _requiresReverification = true;
        });
        return;
      case ValidateSmsCodeInvalidCode() ||
          ValidateSmsCodeLocked() ||
          ValidateSmsCodeRateLimited() ||
          ValidateSmsCodeFailure():
        final message = codeErrorMessage(
          'application.profil.my_account.errors',
          outcome,
        )!;
        setState(() {
          _isPhoneLoading = false;
          _phoneError = message.key.tr(namedArgs: message.args);
        });
        return;
      case ValidateSmsCodeExpired():
        setState(() {
          _isPhoneLoading = false;
          _phoneError = 'application.profil.my_account.errors.code_expired'
              .tr();
        });
        return;
      case ValidateSmsCodeNoCodeRequested():
        setState(() {
          _isPhoneLoading = false;
          _phoneError = 'application.profil.my_account.errors.no_code_requested'
              .tr();
        });
        return;
      case ValidateSmsCodeSuccess(:final isNewRegistration):
        setState(() {
          _resetLocalState();
          _greetingMessage = isNewRegistration
              ? 'application.profil.my_account.phone_registration_success'.tr()
              : 'application.common.bundid.welcome_back'.tr();
        });
    }
  }

  Future<void> _reverifyWithBundId() async {
    setState(() => _isPhoneLoading = true);
    final result = await loginWithBundIdDirect(ref);
    if (!mounted) return;
    setState(() => _isPhoneLoading = false);

    if (result.outcome == BundIdLoginOutcome.success) {
      ref.read(justLoggedOutProvider.notifier).set(false);
      ref
        ..invalidate(myAccountProfileProvider)
        ..invalidate(hasStrongSessionProvider);
      ref.read(volunteerAuthProvider.notifier).signIn();
      setState(_resetLocalState);
    }
  }

  Future<void> _logout() async {
    if (!await confirmLogout(context, ref) || !mounted) return;
    final app = ProviderScope.containerOf(context, listen: false);
    setState(_resetLocalState);
    await signOutAccount(app);
    _showLoggedOut('application.profil.my_account.logged_out'.tr());
  }

  Future<void> _logoutEverywhere() async {
    if (_isLoggingOutEverywhere) return;
    if (!await confirmLogoutEverywhere(context, ref) || !mounted) return;

    final app = ProviderScope.containerOf(context, listen: false);
    setState(() => _isLoggingOutEverywhere = true);
    final Enum_LogoutAllDevicesResult? result;
    try {
      result = await logOutEverywhere(
        app,
        beforeSignOut: () {
          if (mounted) setState(_resetLocalState);
        },
      );
    } finally {
      if (mounted) setState(() => _isLoggingOutEverywhere = false);
    }
    if (!mounted) return;

    switch (result) {
      case null:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'application.profil.my_account.errors.logout_everywhere'.tr(),
            ),
          ),
        );
      case Enum_LogoutAllDevicesResult.DEVICE_LOGIN_KEPT:
        await showDeviceLoginKept(context);
      case Enum_LogoutAllDevicesResult.LOGGED_OUT ||
          Enum_LogoutAllDevicesResult.$unknown:
        _showLoggedOut(
          'application.profil.my_account.logged_out_everywhere'.tr(),
        );
    }
  }

  void _showLoggedOut(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go('/profil/mein-konto');
    });
  }

  Future<void> _loginWithBundId() async {
    if (_isBundIdLoading) return;
    setState(() => _isBundIdLoading = true);
    ref.read(strongSessionExpiredProvider.notifier).set(false);

    final attempt = await startBundIdLogin(ref);
    if (!mounted) return;

    switch (attempt) {
      case BundIdLoginAttemptSuccess():
        ref.read(volunteerAuthProvider.notifier).signIn();
        ref.read(justLoggedOutProvider.notifier).set(false);
        ref
          ..invalidate(hasStrongSessionProvider)
          ..invalidate(myAccountProfileProvider);
        setState(() {
          _isBundIdLoading = false;
          _resetLocalState();
          _greetingMessage = 'application.common.bundid.welcome_back'.tr();
        });
      case BundIdLoginAttemptConsentRequired(:final token, :final suggestion):
        setState(() {
          _isBundIdLoading = false;
          _pendingToken = token;
          _pendingSuggestion = suggestion;
        });
      case BundIdLoginAttemptError(:final result):
        setState(() => _isBundIdLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(bundIdErrorMessage(result))));
    }
  }

  Future<void> _confirmRegistration() async {
    final token = _pendingToken;
    if (token == null || _isConfirmingRegistration) return;
    setState(() => _isConfirmingRegistration = true);

    final result = await confirmBundIdRegistrationWithRetry(ref, token);
    if (!mounted) return;

    if (result.outcome != BundIdLoginOutcome.success) {
      setState(() => _isConfirmingRegistration = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(bundIdErrorMessage(result))));
      return;
    }

    ref.read(volunteerAuthProvider.notifier).signIn();
    ref.read(justLoggedOutProvider.notifier).set(false);
    ref
      ..invalidate(hasStrongSessionProvider)
      ..invalidate(myAccountProfileProvider);

    if (!mounted) return;
    context.go(
      BundIdOnboardingPage.path,
      extra: (
        profileSuggestion: result.profileSuggestion,
        phoneNumberCollision: result.phoneNumberCollision,
      ),
    );
  }

  void _cancelPendingRegistration() {
    setState(() {
      _pendingToken = null;
      _pendingSuggestion = null;
    });
  }

  void _cancelChangingPhone() {
    setState(() {
      _isChangingPhone = false;
      _isSmsStep = false;
      _phoneNumber = '';
      _smsCode = '';
      _phoneError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingSuggestion != null) {
      return Scaffold(
        appBar: CommonAppBar(
          title: Text('application.profil.my_account.title'.tr()),
        ),
        body: BundIdConsentView(
          suggestion: _pendingSuggestion!,
          isConfirming: _isConfirmingRegistration,
          onConfirm: _confirmRegistration,
          onCancel: _cancelPendingRegistration,
        ),
      );
    }

    final loggedOutView = _LoggedOutView(
      isBundIdLoading: _isBundIdLoading,
      onLoginWithBundId: _loginWithBundId,
      requiresReverification: _requiresReverification,
      isPhoneLoading: _isPhoneLoading,
      onReverify: _reverifyWithBundId,
      isSmsStep: _isSmsStep,
      phoneNumber: _phoneNumber,
      onPhoneNumberChanged: (value) => setState(() {
        _phoneNumber = value;
        _phoneError = null;
      }),
      phoneError: _phoneError,
      smsCode: _smsCode,
      onSmsCodeChanged: (value) => _smsCode = value,
      onSendPhoneCode: _sendPhoneCode,
      onConfirmPhoneCode: _confirmPhoneCode,
      onCancel: _cancelChangingPhone,
    );

    if (ref.watch(justLoggedOutProvider)) {
      return Scaffold(
        appBar: CommonAppBar(
          title: Text('application.profil.my_account.title'.tr()),
        ),
        body: loggedOutView,
      );
    }

    final hasStrongSessionAsync = ref.watch(hasStrongSessionProvider);

    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.profil.my_account.title'.tr()),
      ),
      body: hasStrongSessionAsync.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Text('application.profil.my_account.errors.load'.tr()),
        ),
        data: (hasSession) => hasSession
            ? _AccountView(
                onProfileLoaded: _seedFrom,
                greetingMessage: _greetingMessage,
                vorname: _vorname,
                onVornameChanged: (value) => _vorname = value,
                nachname: _nachname,
                onNachnameChanged: (value) => _nachname = value,
                email: _email,
                onEmailChanged: (value) => _email = value,
                street: _street,
                onStreetChanged: (value) => _street = value,
                postalCode: _postalCode,
                onPostalCodeChanged: (value) => _postalCode = value,
                city: _city,
                onCityChanged: (value) => _city = value,
                country: _country,
                onCountryChanged: (value) => _country = value,
                fieldsKeySuffix: _initialized,
                isEditingProfile: _isEditingProfile,
                onStartEditing: () => setState(() => _isEditingProfile = true),
                isSaving: _isSaving,
                onSave: _save,
                saveError: _saveError,
                requiresReverification: _requiresReverification,
                isPhoneLoading: _isPhoneLoading,
                onReverify: _reverifyWithBundId,
                isChangingPhone: _isChangingPhone,
                onStartChangingPhone: () => setState(() {
                  _isChangingPhone = true;
                  _phoneNumber = '';
                  _phoneError = null;
                }),
                phoneNumber: _phoneNumber,
                onPhoneNumberChanged: (value) => setState(() {
                  _phoneNumber = value;
                  _phoneError = null;
                }),
                phoneError: _phoneError,
                isSmsStep: _isSmsStep,
                smsCode: _smsCode,
                onSmsCodeChanged: (value) => _smsCode = value,
                onSendPhoneCode: _sendPhoneCode,
                onConfirmPhoneCode: _confirmPhoneCode,
                onCancelChangingPhone: _cancelChangingPhone,
                onLogout: _logout,
                isLoggingOutEverywhere: _isLoggingOutEverywhere,
                onLogoutEverywhere: _logoutEverywhere,
              )
            : loggedOutView,
      ),
    );
  }
}
