// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voximplant_kit_chat/voximplant_kit_chat.dart';
import 'package:voximplant_kit_chat_example/domain/models/credentials.dart';

class CredentialsRepository {
  static const String _regionKey = 'chat_region';
  static const String _channelUuidKey = 'chat_channel_uuid';
  static const String _tokenKey = 'chat_token';
  static const String _clientIdKey = 'chat_client_id';

  CredentialsRepository({
    FlutterSecureStorage? secureStorage,
    Future<SharedPreferences>? prefsFuture,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _prefsFuture = prefsFuture ?? SharedPreferences.getInstance();

  final FlutterSecureStorage _secureStorage;
  final Future<SharedPreferences> _prefsFuture;

  Future<Credentials> getCredentials() async {
    final prefs = await _prefsFuture;
    final savedRegion = prefs.getString(_regionKey);
    final region =
        savedRegion == null
            ? null
            : KitChatRegion.values.asNameMap()[savedRegion];
    String token = '';

    try {
      token = await _secureStorage.read(key: _tokenKey) ?? '';
    } on PlatformException catch (error) {
      developer.log(
        'Failed to get token from secure storage',
        name: 'CredentialsRepository',
        error: error,
        level: 900,
      );
    }

    return Credentials(
      region: region,
      channelUuid: prefs.getString(_channelUuidKey) ?? '',
      token: token,
      clientId: prefs.getString(_clientIdKey) ?? '',
    );
  }

  Future<void> saveCredentials({
    required KitChatRegion? region,
    required String channelUuid,
    required String token,
    required String clientId,
  }) async {
    final prefs = await _prefsFuture;

    if (region == null) {
      await prefs.remove(_regionKey);
    } else {
      await prefs.setString(_regionKey, region.name);
    }

    await prefs.setString(_channelUuidKey, channelUuid);
    await prefs.setString(_clientIdKey, clientId);

    try {
      if (token.isEmpty) {
        await _secureStorage.delete(key: _tokenKey);
      } else {
        await _secureStorage.write(key: _tokenKey, value: token);
      }
    } on PlatformException catch (error) {
      developer.log(
        'Failed to save token to secure storage',
        name: 'CredentialsRepository',
        error: error,
        level: 900,
      );
    }
  }
}
