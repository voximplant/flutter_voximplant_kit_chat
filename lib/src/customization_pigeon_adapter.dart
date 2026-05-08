// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'customization.dart';
import 'messages.g.dart' as messages;

extension KitChatCustomizationPigeonAdapter on KitChatCustomization {
  messages.KitChatCustomization toPigeon() {
    return messages.KitChatCustomization(
      colorScheme: colorScheme?.toPigeon(),
      customizableStringsIos: stringsIos?.toPigeon(),
      customizableIconsIos: iconsIos?.toPigeon(),
    );
  }
}

extension KitChatColorSchemePigeonAdapter on KitChatColorScheme {
  messages.KitChatColorScheme toPigeon() {
    return messages.KitChatColorScheme(
      avatarPlaceholder: avatarPlaceholder?.toARGB32(),
      brand: brand?.toARGB32(),
      brandContainer: brandContainer?.toARGB32(),
      negative: negative?.toARGB32(),
      negativeContainer: negativeContainer?.toARGB32(),
      notification: notification?.toARGB32(),
      onBrand: onBrand?.toARGB32(),
      onBrandContainer: onBrandContainer?.toARGB32(),
      positive: positive?.toARGB32(),
      positiveContainer: positiveContainer?.toARGB32(),
    );
  }
}

extension KitChatStringsIosPigeonAdapter on KitChatStringsIos {
  messages.KitChatCustomizableStringsIos toPigeon() {
    return messages.KitChatCustomizableStringsIos(
      attachmentPicker: attachmentPicker?.toPigeon(),
      connectionState: connectionState?.toPigeon(),
      contextMenu: contextMenu?.toPigeon(),
      error: error?.toPigeon(),
      notice: notice?.toPigeon(),
      permission: permission?.toPigeon(),
      sender: sender?.toPigeon(),
      chatTitle: chatTitle,
      messagePlaceholder: messagePlaceholder,
    );
  }
}

extension KitChatAttachmentPickerStringsIosPigeonAdapter
    on KitChatAttachmentPickerStringsIos {
  messages.KitChatAttachmentPickerStringsIos toPigeon() {
    return messages.KitChatAttachmentPickerStringsIos(
      camera: camera,
      file: file,
      gallery: gallery,
    );
  }
}

extension KitChatConnectionStateStringsIosPigeonAdapter
    on KitChatConnectionStateStringsIos {
  messages.KitChatConnectionStateStringsIos toPigeon() {
    return messages.KitChatConnectionStateStringsIos(
      connecting: connecting,
      online: online,
      offline: offline,
    );
  }
}

extension KitChatContextMenuStringsIosPigeonAdapter
    on KitChatContextMenuStringsIos {
  messages.KitChatContextMenuStringsIos toPigeon() {
    return messages.KitChatContextMenuStringsIos(
      copyTextAction: copyTextAction,
      resendMessageAction: resendMessageAction,
      saveImageAction: saveImageAction,
    );
  }
}

extension KitChatErrorStringsIosPigeonAdapter on KitChatErrorStringsIos {
  messages.KitChatErrorStringsIos toPigeon() {
    return messages.KitChatErrorStringsIos(
      fileSizeError: fileSizeError,
      fileTypeError: fileTypeError,
      invalidFileError: invalidFileError,
      multipleInvalidFilesError: multipleInvalidFilesError,
    );
  }
}

extension KitChatNoticeStringsIosPigeonAdapter on KitChatNoticeStringsIos {
  messages.KitChatNoticeStringsIos toPigeon() {
    return messages.KitChatNoticeStringsIos(
      accessFileError: accessFileError,
      copyTextSuccess: copyTextSuccess,
      fileLimitError: fileLimitError,
      openImageError: openImageError,
      saveImageError: saveImageError,
      saveImageSuccess: saveImageSuccess,
      sendInvalidFilesError: sendInvalidFilesError,
    );
  }
}

extension KitChatPermissionAlertStringsIosPigeonAdapter
    on KitChatPermissionAlertStringsIos {
  messages.KitChatPermissionAlertStringsIos toPigeon() {
    return messages.KitChatPermissionAlertStringsIos(
      closeAction: closeAction,
      settingsAction: settingsAction,
      title: title,
    );
  }
}

extension KitChatSenderStringsIosPigeonAdapter on KitChatSenderStringsIos {
  messages.KitChatSenderStringsIos toPigeon() {
    return messages.KitChatSenderStringsIos(
      agentDisplayName: agentDisplayName,
      botDisplayName: botDisplayName,
    );
  }
}

extension KitChatIconsIosPigeonAdapter on KitChatIconsIos {
  messages.KitChatCustomizableIconsIos toPigeon() {
    return messages.KitChatCustomizableIconsIos(
      actions: actions?.toPigeon(),
      attachments: attachments?.toPigeon(),
      senders: senders?.toPigeon(),
      error: error,
      success: success,
    );
  }
}

extension KitChatActionIconsIosPigeonAdapter on KitChatActionIconsIos {
  messages.KitChatActionIconsIos toPigeon() {
    return messages.KitChatActionIconsIos(
      add: add,
      back: back,
      chooseFile: chooseFile,
      copy: copy,
      resend: resend,
      save: save,
      selectFromGallery: selectFromGallery,
      send: send,
      share: share,
      takePhoto: takePhoto,
    );
  }
}

extension KitChatAttachmentIconsIosPigeonAdapter on KitChatAttachmentIconsIos {
  messages.KitChatAttachmentIconsIos toPigeon() {
    return messages.KitChatAttachmentIconsIos(
      document: document,
      download: download,
      error: error,
    );
  }
}

extension KitChatSenderIconsIosPigeonAdapter on KitChatSenderIconsIos {
  messages.KitChatSenderIconsIos toPigeon() {
    return messages.KitChatSenderIconsIos(agent: agent, bot: bot);
  }
}
