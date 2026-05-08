// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    copyrightHeader: 'pigeons/copyright.txt',
    dartOut: 'lib/src/messages.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/com/voximplant/voximplant_kit_chat/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.voximplant.voximplant_kit_chat'),
    swiftOut:
        'ios/voximplant_kit_chat/Sources/voximplant_kit_chat/Messages.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
enum KitChatRegion { ru, ru2, eu, us, br, kz }

enum KitChatAuthorizationError {
  invalidChannelUuid,
  invalidToken,
  invalidClientId,
  unknown,
}

class KitChatCredentials {
  late KitChatRegion region;
  late String channelUuid;
  late String token;
  late String clientId;
}

class KitChatColorScheme {
  int? avatarPlaceholder;
  int? brand;
  int? brandContainer;
  int? negative;
  int? negativeContainer;
  int? notification;
  int? onBrand;
  int? onBrandContainer;
  int? positive;
  int? positiveContainer;
}

class KitChatAttachmentPickerStringsIos {
  String? camera;
  String? file;
  String? gallery;
}

class KitChatConnectionStateStringsIos {
  String? connecting;
  String? online;
  String? offline;
}

class KitChatContextMenuStringsIos {
  String? copyTextAction;
  String? resendMessageAction;
  String? saveImageAction;
}

class KitChatErrorStringsIos {
  String? fileSizeError;
  String? fileTypeError;
  String? invalidFileError;
  String? multipleInvalidFilesError;
}

class KitChatNoticeStringsIos {
  String? accessFileError;
  String? copyTextSuccess;
  String? fileLimitError;
  String? openImageError;
  String? saveImageError;
  String? saveImageSuccess;
  String? sendInvalidFilesError;
}

class KitChatPermissionAlertStringsIos {
  String? closeAction;
  String? settingsAction;
  String? title;
}

class KitChatSenderStringsIos {
  String? agentDisplayName;
  String? botDisplayName;
}

class KitChatCustomizableStringsIos {
  KitChatAttachmentPickerStringsIos? attachmentPicker;
  KitChatConnectionStateStringsIos? connectionState;
  KitChatContextMenuStringsIos? contextMenu;
  KitChatErrorStringsIos? error;
  KitChatNoticeStringsIos? notice;
  KitChatPermissionAlertStringsIos? permission;
  KitChatSenderStringsIos? sender;
  String? chatTitle;
  String? messagePlaceholder;
}

class KitChatActionIconsIos {
  String? add;
  String? back;
  String? chooseFile;
  String? copy;
  String? resend;
  String? save;
  String? selectFromGallery;
  String? send;
  String? share;
  String? takePhoto;
}

class KitChatAttachmentIconsIos {
  String? document;
  String? download;
  String? error;
}

class KitChatSenderIconsIos {
  String? agent;
  String? bot;
}

class KitChatCustomizableIconsIos {
  KitChatActionIconsIos? actions;
  KitChatAttachmentIconsIos? attachments;
  KitChatSenderIconsIos? senders;
  String? error;
  String? success;
}

class KitChatCustomization {
  KitChatColorScheme? colorScheme;
  KitChatCustomizableStringsIos? customizableStringsIos;
  KitChatCustomizableIconsIos? customizableIconsIos;
}

class KitChatClientData {
  String? displayName;
  String? phone;
  String? avatarUrl;
  String? email;
  String? language;
}

@HostApi()
abstract class VoximplantKitChatApi {
  void initialize(KitChatCredentials credentials);

  void applyCustomization(KitChatCustomization customization);

  void openChat();

  bool isChatVisible();

  @async
  void setClientData(KitChatClientData data);

  @async
  void registerPushToken(String token);

  @async
  void unregisterPushToken(String token);

  @async
  void handlePush(Map<String, String> payload);
}

@FlutterApi()
abstract class VoximplantKitChatFlutterApi {
  void onAuthorizationError(KitChatAuthorizationError error);
}
