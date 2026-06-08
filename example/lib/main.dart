// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:push/push.dart';
import 'package:voximplant_kit_chat/voximplant_kit_chat.dart';
import 'package:voximplant_kit_chat_example/data/repositories/credentials_repository.dart';
import 'package:voximplant_kit_chat_example/ui/core/themes/theme.dart';
import 'package:voximplant_kit_chat_example/ui/home/widgets/home_screen.dart';

import 'l10n/app_localizations.dart';

final ValueNotifier<int> _openChatRequestVersion = ValueNotifier<int>(0);

final Uri _kitChatDeepLinkUri = Uri(scheme: 'voximplant', host: 'kitchat');

Map<String, String> _toPushPayload(Map<String?, Object?>? data) {
  if (data == null) {
    return const <String, String>{};
  }
  return <String, String>{
    for (final entry in data.entries)
      if (entry.key != null) entry.key!: entry.value?.toString() ?? '',
  };
}

Future<VoximplantKitChat?> _createInitializedKitChatFromStorage() async {
  final credentials = await CredentialsRepository().getCredentials();
  final region = credentials.region;
  if (region == null ||
      credentials.channelUuid.isEmpty ||
      credentials.token.isEmpty ||
      credentials.clientId.isEmpty) {
    return null;
  }

  final kitChat = VoximplantKitChat();
  try {
    await kitChat.initialize(
      region: region,
      channelUuid: credentials.channelUuid,
      token: credentials.token,
      clientId: credentials.clientId,
    );
    return kitChat;
  } catch (error) {
    debugPrint('Failed to initialize KitChat from storage: $error');
    return null;
  }
}

Future<void> _handleIncomingPush(Map<String?, Object?>? data) async {
  final payload = _toPushPayload(data);
  if (payload.isEmpty) {
    return;
  }
  final kitChat = await _createInitializedKitChatFromStorage();
  if (kitChat == null) {
    return;
  }

  try {
    await kitChat.handlePushAndroid(payload);
  } catch (error) {
    debugPrint('Failed to handle push: $error');
  }
}

Future<void> _registerPushToken(String token) async {
  if (token.isEmpty) {
    return;
  }
  final kitChat = await _createInitializedKitChatFromStorage();
  if (kitChat == null) {
    return;
  }

  try {
    await kitChat.registerPushToken(token);
  } catch (error) {
    debugPrint('Failed to register push token: $error');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Push.instance.addOnMessage((message) {
    unawaited(_handleIncomingPush(message.data));
  });
  Push.instance.addOnBackgroundMessage((message) async {
    await _handleIncomingPush(message.data);
  });
  Push.instance.addOnNotificationTap((data) async {
    if (await VoximplantKitChat.isChatVisibleIos()) {
      return;
    }
    _openChatRequestVersion.value++;
    unawaited(_handleIncomingPush(data));
  });
  Push.instance.addOnNewToken((token) {
    unawaited(_registerPushToken(token));
  });

  Push.instance.notificationTapWhichLaunchedAppFromTerminated.then((
    data,
  ) async {
    if (data == null) {
      return;
    }
    if (await VoximplantKitChat.isChatVisibleIos()) {
      return;
    }
    _openChatRequestVersion.value++;
    unawaited(_handleIncomingPush(data));
  });

  final router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) =>
            HomeScreen(openChatRequestVersion: _openChatRequestVersion),
      ),
    ],
    redirect: (context, state) {
      final uri = state.uri;
      if (uri.scheme == _kitChatDeepLinkUri.scheme &&
          uri.host == _kitChatDeepLinkUri.host) {
        _openChatRequestVersion.value++;
        return '/';
      }
      return null;
    },
  );

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
