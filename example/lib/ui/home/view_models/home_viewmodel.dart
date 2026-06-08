// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:push/push.dart';
import 'package:voximplant_kit_chat/voximplant_kit_chat.dart';
import 'package:voximplant_kit_chat_example/data/repositories/credentials_repository.dart';
import 'package:voximplant_kit_chat_example/domain/models/credentials_field_error.dart';

class HomeViewModel extends ChangeNotifier {
  static const List<KitChatRegion> regions = KitChatRegion.values;

  HomeViewModel({CredentialsRepository? repository, VoximplantKitChat? kitChat})
    : _repository = repository ?? CredentialsRepository(),
      _kitChat = kitChat ?? VoximplantKitChat() {
    _authorizationErrorSubscription = _kitChat.authorizationErrors.listen(
      _onAuthorizationError,
    );
  }

  final CredentialsRepository _repository;
  final VoximplantKitChat _kitChat;
  StreamSubscription<KitChatAuthorizationError>?
  _authorizationErrorSubscription;

  KitChatRegion? _selectedRegion;
  String _channelUuid = '';
  String _token = '';
  String _clientId = '';
  bool _isPushTokenRegistrationError = false;
  bool _isPushTokenRegistrationInProgress = false;
  bool _isNotificationPermissionGranted = false;

  CredentialsFieldError? _regionError;
  CredentialsFieldError? _channelUuidError;
  CredentialsFieldError? _tokenError;
  CredentialsFieldError? _clientIdError;

  KitChatRegion? get selectedRegion => _selectedRegion;

  String get channelUuid => _channelUuid;

  String get token => _token;

  String get clientId => _clientId;

  CredentialsFieldError? get regionError => _regionError;

  CredentialsFieldError? get channelUuidError => _channelUuidError;

  CredentialsFieldError? get tokenError => _tokenError;

  CredentialsFieldError? get clientIdError => _clientIdError;

  bool get isPushTokenRegistrationError => _isPushTokenRegistrationError;

  bool get isPushTokenRegistrationInProgress =>
      _isPushTokenRegistrationInProgress;

  bool get isNotificationPermissionGranted => _isNotificationPermissionGranted;

  Future<void> loadSavedCredentials() async {
    final savedCredentials = await _repository.getCredentials();
    _selectedRegion = savedCredentials.region;
    _channelUuid = savedCredentials.channelUuid;
    _token = savedCredentials.token;
    _clientId = savedCredentials.clientId;

    notifyListeners();
  }

  void onRegionChanged(KitChatRegion? value) {
    _selectedRegion = value;
    if (value != null) {
      _regionError = null;
    }
    notifyListeners();
    unawaited(_saveCredentials());
  }

  void onChannelUuidChanged(String value) {
    _channelUuid = value.trim();
    if (_channelUuidError != null && _channelUuid.isNotEmpty) {
      _channelUuidError = null;
      notifyListeners();
    }
    unawaited(_saveCredentials());
  }

  void onTokenChanged(String value) {
    _token = value.trim();
    if (_tokenError != null && _token.isNotEmpty) {
      _tokenError = null;
      notifyListeners();
    }
    unawaited(_saveCredentials());
  }

  void onClientIdChanged(String value) {
    _clientId = value.trim();
    if (_clientIdError != null && _clientId.isNotEmpty) {
      _clientIdError = null;
      notifyListeners();
    }
    unawaited(_saveCredentials());
  }

  bool validateCredentials() {
    _regionError = _selectedRegion == null ? CredentialsFieldError.empty : null;
    _channelUuidError = _channelUuid.isEmpty
        ? CredentialsFieldError.empty
        : null;
    _tokenError = _token.isEmpty ? CredentialsFieldError.empty : null;
    _clientIdError = _clientId.isEmpty ? CredentialsFieldError.empty : null;

    notifyListeners();

    return _regionError == null &&
        _channelUuidError == null &&
        _tokenError == null &&
        _clientIdError == null;
  }

  Future<void> _initializeKitChat() async {
    final region = _selectedRegion;
    if (region == null) {
      return;
    }

    await _kitChat.initialize(
      region: region,
      channelUuid: _channelUuid,
      token: _token,
      clientId: _clientId,
    );
    // Call applyCustomization before openChat to apply customization settings.
    // _kitChat.applyCustomization(KitChatCustomization());
  }

  Future<void> openChat({required String regionNotSelectedError}) async {
    await _initializeKitChat();
    unawaited(_registerCurrentPushToken());
    await _kitChat.openChat();
  }

  void retryPushTokenRegistration() {
    unawaited(_registerCurrentPushToken());
  }

  Future<void> refreshNotificationPermissionStatus() async {
    try {
      final isEnabled = defaultTargetPlatform == TargetPlatform.iOS
          ? await _readIOSNotificationPermission()
          : await Push.instance.areNotificationsEnabled();
      _setNotificationPermissionGranted(isEnabled);
    } catch (error, stackTrace) {
      debugPrint('Failed to read notification permission status: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<bool> _readIOSNotificationPermission() async {
    final settings = await Push.instance.getNotificationSettings();
    switch (settings.authorizationStatus) {
      case UNAuthorizationStatus.authorized:
      case UNAuthorizationStatus.provisional:
      case UNAuthorizationStatus.ephemeral:
        return true;
      case UNAuthorizationStatus.notDetermined:
      case UNAuthorizationStatus.denied:
      case null:
        return false;
    }
  }

  Future<void> requestNotificationPermission() async {
    if (_isNotificationPermissionGranted) {
      return;
    }

    try {
      await Push.instance.requestPermission();
    } catch (error, stackTrace) {
      debugPrint('Failed to request notification permission: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    await refreshNotificationPermissionStatus();
  }

  void _setNotificationPermissionGranted(bool isGranted) {
    if (_isNotificationPermissionGranted == isGranted) {
      return;
    }
    _isNotificationPermissionGranted = isGranted;
    notifyListeners();
  }

  @override
  void dispose() {
    _authorizationErrorSubscription?.cancel();
    super.dispose();
  }

  Future<void> _saveCredentials() async {
    await _repository.saveCredentials(
      region: _selectedRegion,
      channelUuid: _channelUuid,
      token: _token,
      clientId: _clientId,
    );
  }

  void _onAuthorizationError(KitChatAuthorizationError error) {
    switch (error) {
      case KitChatAuthorizationError.invalidChannelUuid:
        _channelUuidError = CredentialsFieldError.invalidValue;
      case KitChatAuthorizationError.invalidToken:
        _tokenError = CredentialsFieldError.invalidValue;
      case KitChatAuthorizationError.invalidClientId:
        _clientIdError = CredentialsFieldError.invalidValue;
      case KitChatAuthorizationError.unknown:
        return;
    }

    notifyListeners();
  }

  Future<void> _registerCurrentPushToken() async {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }
    if (_isPushTokenRegistrationInProgress) {
      return;
    }

    _isPushTokenRegistrationInProgress = true;
    _isPushTokenRegistrationError = false;
    notifyListeners();

    try {
      final token = await Push.instance.token;
      if (token == null || token.isEmpty) {
        _isPushTokenRegistrationError = true;
        return;
      }
      await _kitChat.registerPushToken(token);
      _isPushTokenRegistrationError = false;
    } catch (error, stackTrace) {
      _isPushTokenRegistrationError = true;
      debugPrint('Failed to register push token: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isPushTokenRegistrationInProgress = false;
      notifyListeners();
    }
  }
}
