// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voximplant_kit_chat/voximplant_kit_chat.dart';
import 'package:voximplant_kit_chat_example/domain/models/credentials_field_error.dart';
import 'package:voximplant_kit_chat_example/l10n/app_localizations.dart';
import 'package:voximplant_kit_chat_example/ui/core/themes/colors.dart';
import 'package:voximplant_kit_chat_example/ui/core/themes/theme.dart';
import 'package:voximplant_kit_chat_example/ui/home/view_models/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.openChatRequestVersion});

  final ValueListenable<int> openChatRequestVersion;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final HomeViewModel _viewModel = HomeViewModel();
  final TextEditingController _channelUuidController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  late final VoidCallback _openChatRequestListener;
  int _lastHandledOpenChatRequestVersion = 0;
  late final Future<void> _initDataFuture;
  Future<void>? _openChatOperation;
  Completer<void>? _appResumedCompleter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _openChatRequestListener = _onOpenChatRequestVersionChanged;
    widget.openChatRequestVersion.addListener(_openChatRequestListener);
    _initDataFuture = _initData();
    _onOpenChatRequestVersionChanged();
    unawaited(_viewModel.refreshNotificationPermissionStatus());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.openChatRequestVersion.removeListener(_openChatRequestListener);
    final completer = _appResumedCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
    _appResumedCompleter = null;
    _channelUuidController.dispose();
    _tokenController.dispose();
    _clientIdController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final completer = _appResumedCompleter;
      if (completer != null && !completer.isCompleted) {
        completer.complete();
      }
      _appResumedCompleter = null;
      unawaited(_viewModel.refreshNotificationPermissionStatus());
    }
  }

  Future<void> _waitUntilAppResumed() {
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      return Future.value();
    }
    final completer = _appResumedCompleter ??= Completer<void>();
    return completer.future;
  }

  Future<void> _initData() async {
    await _viewModel.loadSavedCredentials();

    if (!mounted) {
      return;
    }

    _channelUuidController.text = _viewModel.channelUuid;
    _tokenController.text = _viewModel.token;
    _clientIdController.text = _viewModel.clientId;
  }

  Future<void> _onOpenChatPressed() async {
    if (_openChatOperation != null) {
      return;
    }
    if (!_viewModel.validateCredentials()) {
      return;
    }

    final operation = () async {
      await _viewModel.openChat(
        regionNotSelectedError: AppLocalizations.of(
          context,
        )!.regionIsNotSelected,
      );
    }();
    _openChatOperation = operation;

    try {
      await operation;
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      _openChatOperation = null;
    }
  }

  Future<void> _openChatAfterDataReady() async {
    await _initDataFuture;
    if (!mounted) {
      return;
    }
    await _waitUntilAppResumed();
    if (!mounted) {
      return;
    }
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      return;
    }
    await _onOpenChatPressed();
  }

  void _onOpenChatRequestVersionChanged() {
    final currentVersion = widget.openChatRequestVersion.value;
    if (currentVersion <= _lastHandledOpenChatRequestVersion) {
      return;
    }
    _lastHandledOpenChatRequestVersion = currentVersion;
    unawaited(_openChatAfterDataReady());
  }

  void _onRequestPermissionPressed() {
    unawaited(_viewModel.requestNotificationPermission());
  }

  InputDecoration _fieldDecoration({
    required String hintText,
    required bool hasError,
  }) {
    final theme = Theme.of(context);
    final decoration = InputDecoration(
      hintText: hintText,
    ).applyDefaults(theme.inputDecorationTheme);

    if (!hasError) {
      return decoration;
    }

    return decoration.copyWith(
      border: decoration.errorBorder ?? decoration.border,
      enabledBorder: decoration.errorBorder ?? decoration.enabledBorder,
      focusedBorder: decoration.focusedErrorBorder ?? decoration.focusedBorder,
    );
  }

  String? _resolveErrorText(CredentialsFieldError? error) {
    final l10n = AppLocalizations.of(context)!;
    return switch (error) {
      null => null,
      CredentialsFieldError.empty => l10n.fieldCannotBeEmpty,
      CredentialsFieldError.invalidValue => l10n.invalidValue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_viewModel.isPushTokenRegistrationInProgress)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 8,
                                right: 16,
                              ),
                              child: _PushTokenUpdateBanner(
                                repeatAttemptText: AppLocalizations.of(
                                  context,
                                )!.repeatAttempt,
                              ),
                            )
                          else if (_viewModel.isPushTokenRegistrationError)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 8,
                                right: 16,
                              ),
                              child: _PushTokenRegistrationErrorBanner(
                                errorText: AppLocalizations.of(
                                  context,
                                )!.errorOfRegistrationOfThePushToken,
                                tryAgainText: AppLocalizations.of(
                                  context,
                                )!.tryAgain,
                                onBannerClick:
                                    _viewModel.retryPushTokenRegistration,
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _FieldLabel(
                                  text: AppLocalizations.of(context)!.region,
                                ),
                                DropdownButtonFormField<KitChatRegion>(
                                  key: ValueKey<String>(
                                    'region:${_viewModel.selectedRegion?.name}',
                                  ),
                                  initialValue: _viewModel.selectedRegion,
                                  decoration: _fieldDecoration(
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.selectRegion,
                                    hasError: _viewModel.regionError != null,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  items: HomeViewModel.regions
                                      .map(
                                        (region) =>
                                            DropdownMenuItem<KitChatRegion>(
                                              value: region,
                                              child: Text(region.name),
                                            ),
                                      )
                                      .toList(),
                                  onChanged: _viewModel.onRegionChanged,
                                ),
                                _FieldErrorText(
                                  errorText: _resolveErrorText(
                                    _viewModel.regionError,
                                  ),
                                ),
                                _FieldLabel(
                                  text: AppLocalizations.of(
                                    context,
                                  )!.channelUuid,
                                ),
                                TextFormField(
                                  controller: _channelUuidController,
                                  decoration: _fieldDecoration(
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.enterChannelUuid,
                                    hasError:
                                        _viewModel.channelUuidError != null,
                                  ),
                                  onChanged: _viewModel.onChannelUuidChanged,
                                ),
                                _FieldErrorText(
                                  errorText: _resolveErrorText(
                                    _viewModel.channelUuidError,
                                  ),
                                ),
                                _FieldLabel(
                                  text: AppLocalizations.of(context)!.token,
                                ),
                                TextFormField(
                                  controller: _tokenController,
                                  decoration: _fieldDecoration(
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.enterToken,
                                    hasError: _viewModel.tokenError != null,
                                  ),
                                  onChanged: _viewModel.onTokenChanged,
                                ),
                                _FieldErrorText(
                                  errorText: _resolveErrorText(
                                    _viewModel.tokenError,
                                  ),
                                ),
                                _FieldLabel(
                                  text: AppLocalizations.of(context)!.clientId,
                                ),
                                TextFormField(
                                  controller: _clientIdController,
                                  minLines: 1,
                                  maxLines: 3,
                                  decoration: _fieldDecoration(
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.enterClientId,
                                    hasError: _viewModel.clientIdError != null,
                                  ),
                                  onChanged: _viewModel.onClientIdChanged,
                                ),
                                _FieldErrorText(
                                  errorText: _resolveErrorText(
                                    _viewModel.clientIdError,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _ButtonsBar(
                    isNotificationPermissionGranted:
                        _viewModel.isNotificationPermissionGranted,
                    allowNotificationsText: AppLocalizations.of(
                      context,
                    )!.allowNotifications,
                    openChatText: AppLocalizations.of(context)!.openChat,
                    onRequestPermissionClick: _onRequestPermissionPressed,
                    onOpenChatClick: () {
                      unawaited(_onOpenChatPressed());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).extension<AppThemeExtension>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: appTheme.fieldLabelStyle),
    );
  }
}

class _FieldErrorText extends StatelessWidget {
  const _FieldErrorText({required this.errorText});

  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).extension<AppThemeExtension>()!;

    return SizedBox(
      height: 18,
      child: Align(
        alignment: Alignment.centerLeft,
        child: errorText == null
            ? null
            : Text(
                errorText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appTheme.fieldErrorStyle,
              ),
      ),
    );
  }
}

class _ButtonsBar extends StatelessWidget {
  const _ButtonsBar({
    required this.isNotificationPermissionGranted,
    required this.allowNotificationsText,
    required this.openChatText,
    required this.onRequestPermissionClick,
    required this.onOpenChatClick,
  });

  final bool isNotificationPermissionGranted;
  final String allowNotificationsText;
  final String openChatText;
  final VoidCallback onRequestPermissionClick;
  final VoidCallback onOpenChatClick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.extension<AppThemeExtension>()!;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (!isNotificationPermissionGranted)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton.icon(
                onPressed: onRequestPermissionClick,
                icon: const Icon(Icons.notifications_outlined),
                label: Text(allowNotificationsText),
                style: FilledButton.styleFrom(
                  backgroundColor: appTheme.secondaryButtonBackground,
                  foregroundColor: appTheme.secondaryButtonForeground,
                  textStyle: theme.filledButtonTheme.style?.textStyle?.resolve(
                    {},
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton(
              onPressed: onOpenChatClick,
              child: Text(openChatText),
            ),
          ),
        ],
      ),
    );
  }
}

class _PushTokenRegistrationErrorBanner extends StatelessWidget {
  const _PushTokenRegistrationErrorBanner({
    required this.errorText,
    required this.tryAgainText,
    required this.onBannerClick,
  });

  final String errorText;
  final String tryAgainText;
  final VoidCallback onBannerClick;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.red95,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onBannerClick,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 32,
                    color: AppColors.red50,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          errorText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 38),
                  Text(
                    tryAgainText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.red50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PushTokenUpdateBanner extends StatelessWidget {
  const _PushTokenUpdateBanner({required this.repeatAttemptText});

  final String repeatAttemptText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.purple90,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.gray10,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            height: 32,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                repeatAttemptText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
