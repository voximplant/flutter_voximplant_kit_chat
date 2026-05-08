// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'dart:async';

import 'package:flutter/services.dart';

import 'src/customization.dart';
import 'src/customization_pigeon_adapter.dart';
import 'src/kit_chat_exception.dart';
import 'src/messages.g.dart' as messages;

export 'src/customization.dart';
export 'src/kit_chat_exception.dart';

/// Account region for a mobile channel.
enum KitChatRegion { ru, ru2, eu, us, br, kz }

/// Authorization error reported by the Voximplant Kit Chat SDK.
enum KitChatAuthorizationError {
  /// Invalid mobile channel UUID.
  invalidChannelUuid,

  /// Invalid mobile channel token.
  invalidToken,

  /// Invalid client ID.
  invalidClientId,

  /// Unknown authorization error.
  unknown,
}

/// Customer information that can be displayed in the agent's workspace.
class KitChatClientData {
  const KitChatClientData({
    this.displayName,
    this.phone,
    this.avatarUrl,
    this.email,
    this.language,
  });

  /// Customer display name.
  final String? displayName;

  /// Customer phone number.
  final String? phone;

  /// Customer avatar URL string.
  final String? avatarUrl;

  /// Customer email.
  final String? email;

  /// Customer language.
  final String? language;
}

/// The main entry point of the Voximplant Kit Chat SDK.
///
/// Provides functionality to configure, customize, and open the chat screen,
/// set customer data, manage push notification tokens, and subscribe to
/// authorization errors.
class VoximplantKitChat {
  VoximplantKitChat() {
    if (!_isFlutterApiSetup) {
      messages.VoximplantKitChatFlutterApi.setUp(_flutterApiBridge);
      _isFlutterApiSetup = true;
    }
  }

  final messages.VoximplantKitChatApi _api = messages.VoximplantKitChatApi();
  static bool _isFlutterApiSetup = false;
  static final _KitChatFlutterApiBridge _flutterApiBridge =
      _KitChatFlutterApiBridge();
  static final StreamController<KitChatAuthorizationError>
  _authorizationErrorController =
      StreamController<KitChatAuthorizationError>.broadcast();

  /// A broadcast stream of [KitChatAuthorizationError]s reported by the Voximplant Kit Chat SDK.
  Stream<KitChatAuthorizationError> get authorizationErrors =>
      _authorizationErrorController.stream;

  /// Initializes the Voximplant Kit Chat SDK with the provided credentials.
  ///
  /// All parameters are required and should be non-empty.
  /// [clientId] should contain at most 100 characters, each from the set
  /// `a-z`, `A-Z`, `0-9`, `$`, `-`, `_`, `.`, `+`, `!`, `*`, `'`, `(`, `)`, `,`, `:`, `@`, `=`.
  ///
  /// Throws a [KitChatInitializationException] if initialization fails.
  /// Throws a [KitChatIllegalArgumentException] if one of the values is rejected by the Voximplant Kit Chat SDK.
  Future<void> initialize({
    required KitChatRegion region,
    required String channelUuid,
    required String token,
    required String clientId,
  }) async {
    try {
      return await _api.initialize(
        messages.KitChatCredentials(
          region: _toPigeonRegion(region),
          channelUuid: channelUuid,
          token: token,
          clientId: clientId,
        ),
      );
    } on PlatformException catch (exception) {
      throw _mapPlatformException(exception);
    }
  }

  /// Opens the chat screen.
  ///
  /// Throws a [KitChatInitializationException] if the [VoximplantKitChat] instance is not initialized.
  Future<void> openChat() async {
    try {
      return await _api.openChat();
    } on PlatformException catch (exception) {
      throw _mapPlatformException(exception);
    }
  }

  /// Sets customer information to the agent's workspace.
  ///
  /// Throws a [KitChatConnectionRequiredException] if the device is offline.
  /// Throws a [KitChatTimeoutException] if the operation times out.
  /// Throws a [KitChatInternalException] if the SDK reports an internal failure.
  Future<void> setClientData(KitChatClientData data) async {
    try {
      return await _api.setClientData(
        messages.KitChatClientData(
          displayName: data.displayName,
          phone: data.phone,
          avatarUrl: data.avatarUrl,
          email: data.email,
          language: data.language,
        ),
      );
    } on PlatformException catch (exception) {
      throw _mapPlatformException(exception);
    }
  }

  /// Registers a push notification token for the current device.
  ///
  /// Supports only a FCM token on android and an APNs token on iOS.
  ///
  /// Throws a [KitChatIllegalArgumentException] if the [token] is empty or invalid.
  /// Throws a [KitChatConnectionRequiredException] if the device is offline.
  /// Throws a [KitChatTimeoutException] if the operation times out.
  /// Throws a [KitChatInternalException] if the SDK reports an internal failure.
  Future<void> registerPushToken(String token) async {
    try {
      return await _api.registerPushToken(token);
    } on PlatformException catch (exception) {
      throw _mapPlatformException(exception);
    }
  }

  /// Unregisters a push notification token previously registered with the [registerPushToken] API.
  ///
  /// Throws a [KitChatIllegalArgumentException] if the [token] is empty or invalid.
  /// Throws a [KitChatConnectionRequiredException] if the device is offline.
  /// Throws a [KitChatTimeoutException] if the operation times out.
  /// Throws a [KitChatInternalException] if the SDK reports an internal failure.
  Future<void> unregisterPushToken(String token) async {
    try {
      return await _api.unregisterPushToken(token);
    } on PlatformException catch (exception) {
      throw _mapPlatformException(exception);
    }
  }

  /// Handles a push notification [payload] received by the Android application.
  ///
  /// Android-only. Forward FCM data payloads received by your push library
  /// (`firebase_messaging`, `push`, …) to this method so the SDK can display
  /// the corresponding chat notification.
  ///
  /// On iOS, the native VoximplantKitChat iOS SDK handles push notifications
  /// through APNs delegates, so calling this method on iOS is a no-op.
  Future<void> handlePushAndroid(Map<String, String> payload) async {
    try {
      return await _api.handlePush(payload);
    } on PlatformException catch (exception) {
      throw _mapPlatformException(exception);
    }
  }

  /// Whether the chat screen is currently on top of the navigation
  /// stack on iOS.
  ///
  /// Use this method to suppress in-app banners while the user is actively
  /// reading messages. On Android chat visibility is not tracked by the
  /// native SDK and the method always returns `false`.
  static Future<bool> isChatVisibleIos() async {
    try {
      return await messages.VoximplantKitChatApi().isChatVisible();
    } on PlatformException catch (exception) {
      throw _mapPlatformException(exception);
    }
  }

  /// Applies a [KitChatCustomization] to the chat screen.
  ///
  /// The customization should be applied before calling the [openChat] API.
  /// Calling this method multiple times overrides the previous values.
  ///
  /// Android strings and icons are customized through the host application resources.
  Future<void> applyCustomization(KitChatCustomization customization) {
    return _api.applyCustomization(customization.toPigeon());
  }

  messages.KitChatRegion _toPigeonRegion(KitChatRegion region) {
    return switch (region) {
      KitChatRegion.ru => messages.KitChatRegion.ru,
      KitChatRegion.ru2 => messages.KitChatRegion.ru2,
      KitChatRegion.eu => messages.KitChatRegion.eu,
      KitChatRegion.us => messages.KitChatRegion.us,
      KitChatRegion.br => messages.KitChatRegion.br,
      KitChatRegion.kz => messages.KitChatRegion.kz,
    };
  }

  static KitChatAuthorizationError _fromPigeonAuthorizationError(
    messages.KitChatAuthorizationError error,
  ) {
    return switch (error) {
      messages.KitChatAuthorizationError.invalidChannelUuid =>
        KitChatAuthorizationError.invalidChannelUuid,
      messages.KitChatAuthorizationError.invalidToken =>
        KitChatAuthorizationError.invalidToken,
      messages.KitChatAuthorizationError.invalidClientId =>
        KitChatAuthorizationError.invalidClientId,
      messages.KitChatAuthorizationError.unknown =>
        KitChatAuthorizationError.unknown,
    };
  }

  static KitChatException _mapPlatformException(PlatformException exception) {
    return switch (exception.code) {
      'NO_CONTEXT' ||
      'NOT_INITIALIZED' ||
      'INITIALIZATION_FAILED' ||
      'MISSING_VIEW_CONTROLLER' => KitChatInitializationException(
        message: exception.message,
        details: exception.details,
      ),
      'ILLEGAL_ARGUMENT' => KitChatIllegalArgumentException(
        message: exception.message,
        details: exception.details,
      ),
      'CONNECTION_REQUIRED' => KitChatConnectionRequiredException(
        message: exception.message,
        details: exception.details,
      ),
      'TIMEOUT' => KitChatTimeoutException(
        message: exception.message,
        details: exception.details,
      ),
      'INTERNAL' => KitChatInternalException(
        code: exception.code,
        message: exception.message,
        details: exception.details,
      ),
      'UNKNOWN' => KitChatUnknownException(
        code: exception.code,
        message: exception.message,
        details: exception.details,
      ),
      'channel-error' || 'null-error' => KitChatInternalException(
        code: exception.code,
        message: exception.message,
        details: exception.details,
      ),
      _ => KitChatUnknownException(
        code: exception.code,
        message: exception.message,
        details: exception.details,
      ),
    };
  }
}

class _KitChatFlutterApiBridge extends messages.VoximplantKitChatFlutterApi {
  @override
  void onAuthorizationError(messages.KitChatAuthorizationError error) {
    VoximplantKitChat._authorizationErrorController.add(
      VoximplantKitChat._fromPigeonAuthorizationError(error),
    );
  }
}
