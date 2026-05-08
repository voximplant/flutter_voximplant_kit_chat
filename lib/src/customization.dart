// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'dart:ui' show Color;

import '../voximplant_kit_chat.dart' show VoximplantKitChat;

/// Customization options for the chat screen.
///
/// To apply the customization, call the [VoximplantKitChat.applyCustomization] API.
class KitChatCustomization {
  const KitChatCustomization({
    this.colorScheme,
    this.stringsIos,
    this.iconsIos,
  });

  /// Color scheme configuration.
  final KitChatColorScheme? colorScheme;

  /// Chat screen strings customization on iOS.
  final KitChatStringsIos? stringsIos;

  /// Chat screen icons customization on iOS.
  final KitChatIconsIos? iconsIos;
}

/// Chat screen color scheme.
///
/// Each color is optional. When `null`, the default color is used.
class KitChatColorScheme {
  const KitChatColorScheme({
    this.avatarPlaceholder,
    this.brand,
    this.brandContainer,
    this.negative,
    this.negativeContainer,
    this.notification,
    this.onBrand,
    this.onBrandContainer,
    this.positive,
    this.positiveContainer,
  });

  /// Color that applies to the avatar placeholder.
  ///
  /// The default color is `0xFFABACC0`.
  final Color? avatarPlaceholder;

  /// Brand or accent color.
  ///
  /// The default color is `0xFF662EFF`.
  final Color? brand;

  /// Brand or accent color that applies to containers.
  ///
  /// The default color is `0xFFF2EEFF`.
  final Color? brandContainer;

  /// Color to highlight errors.
  ///
  /// The default color is `0xFFF74E57`.
  final Color? negative;

  /// Color that applies to containers to highlight errors.
  ///
  /// The default color is `0xFFFFF1F1`.
  final Color? negativeContainer;

  /// Color for the new message indicator that displays on the "go to the latest" button.
  ///
  /// Android only.
  ///
  /// The default color is `0xFFF5222D`.
  final Color? notification;

  /// Color that appears on top of a [brand] color.
  ///
  /// The default color is `0xFFFFFFFF`.
  final Color? onBrand;

  /// Color that appears on top of a [brandContainer] color.
  ///
  /// The default color is `0xFF311678`.
  final Color? onBrandContainer;

  /// Color to highlight success states.
  ///
  /// The default color is `0xFF5AD677`.
  final Color? positive;

  /// Color that applies to containers to highlight success states.
  ///
  /// The default color is `0xFFEDFBF0`.
  final Color? positiveContainer;
}

/// String overrides for the chat screen on iOS.
class KitChatStringsIos {
  const KitChatStringsIos({
    this.attachmentPicker,
    this.connectionState,
    this.contextMenu,
    this.error,
    this.notice,
    this.permission,
    this.sender,
    this.chatTitle,
    this.messagePlaceholder,
  });

  /// Labels for the attachment picker actions.
  final KitChatAttachmentPickerStringsIos? attachmentPicker;

  /// Labels for the connection state indicator.
  final KitChatConnectionStateStringsIos? connectionState;

  /// Labels for the message context menu actions.
  final KitChatContextMenuStringsIos? contextMenu;

  /// Labels for the file validation errors.
  final KitChatErrorStringsIos? error;

  /// Labels for the notices.
  final KitChatNoticeStringsIos? notice;

  /// Labels for the permission alert.
  final KitChatPermissionAlertStringsIos? permission;

  /// Labels for the senders.
  final KitChatSenderStringsIos? sender;

  /// Chat title.
  final String? chatTitle;

  /// Placeholder text for the message input field.
  final String? messagePlaceholder;
}

/// Labels for the attachment picker actions.
class KitChatAttachmentPickerStringsIos {
  const KitChatAttachmentPickerStringsIos({
    this.camera,
    this.file,
    this.gallery,
  });

  /// Label for the action to take a photo.
  final String? camera;

  /// Label for the action to choose a file from the device.
  final String? file;

  /// Label for the action to select an image from the gallery.
  final String? gallery;
}

/// Labels for the connection state indicator.
class KitChatConnectionStateStringsIos {
  const KitChatConnectionStateStringsIos({
    this.connecting,
    this.online,
    this.offline,
  });

  /// Label for the connecting state.
  final String? connecting;

  /// Label for the online state.
  final String? online;

  /// Label for the offline state.
  final String? offline;
}

/// Labels for the message context menu actions.
class KitChatContextMenuStringsIos {
  const KitChatContextMenuStringsIos({
    this.copyTextAction,
    this.resendMessageAction,
    this.saveImageAction,
  });

  /// Label for the action to copy text.
  final String? copyTextAction;

  /// Label for the action to resend a message.
  final String? resendMessageAction;

  /// Label for the action to save an image.
  final String? saveImageAction;
}

/// Labels for the file validation errors.
class KitChatErrorStringsIos {
  const KitChatErrorStringsIos({
    this.fileSizeError,
    this.fileTypeError,
    this.invalidFileError,
    this.multipleInvalidFilesError,
  });

  /// Error message that the attached file size exceeds the allowable limit.
  final String? fileSizeError;

  /// Error message that the attached file’s MIME type is not supported.
  final String? fileTypeError;

  /// Error message that the attached file is empty or corrupted.
  final String? invalidFileError;

  /// Error message that some file attachments do not meet the requirements.
  final String? multipleInvalidFilesError;
}

/// Labels for the notices.
class KitChatNoticeStringsIos {
  const KitChatNoticeStringsIos({
    this.accessFileError,
    this.copyTextSuccess,
    this.fileLimitError,
    this.openImageError,
    this.saveImageError,
    this.saveImageSuccess,
    this.sendInvalidFilesError,
  });

  /// Notice that a file cannot be accessed.
  final String? accessFileError;

  /// Notice that text has been copied.
  final String? copyTextSuccess;

  /// Notice that the file attachments limit for an outbound message has been exceeded.
  final String? fileLimitError;

  /// Notice that an image cannot be opened.
  final String? openImageError;

  /// Notice that an image has not been saved.
  final String? saveImageError;

  /// Notice that an image has been saved.
  final String? saveImageSuccess;

  /// Notice that an outbound message with invalid file attachments cannot be sent.
  final String? sendInvalidFilesError;
}

/// Labels for the camera access permission alert.
class KitChatPermissionAlertStringsIos {
  const KitChatPermissionAlertStringsIos({
    this.closeAction,
    this.settingsAction,
    this.title,
  });

  /// Label for the action to close the alert.
  final String? closeAction;

  /// Label for the action to open system settings.
  final String? settingsAction;

  /// Label for the alert title.
  final String? title;
}

/// Labels for the senders.
class KitChatSenderStringsIos {
  const KitChatSenderStringsIos({this.agentDisplayName, this.botDisplayName});

  /// Label for the agent’s default display name.
  final String? agentDisplayName;

  /// Label for the bot’s display name.
  final String? botDisplayName;
}

/// Icon set for the chat screen on iOS.
///
/// Each value should reference an image asset in the application's `Images.xcassets`.
class KitChatIconsIos {
  const KitChatIconsIos({
    this.actions,
    this.attachments,
    this.senders,
    this.error,
    this.success,
  });

  /// Icon set for the action buttons.
  final KitChatActionIconsIos? actions;

  /// Icon set for attachments visualization and attachments related actions.
  final KitChatAttachmentIconsIos? attachments;

  /// Icon set for the senders.
  final KitChatSenderIconsIos? senders;

  /// Icon to highlight errors.
  ///
  /// The recommended icon size is 16x16.
  final String? error;

  /// Icon to highlight success states.
  ///
  /// The recommended icon size is 16x16.
  final String? success;
}

/// Icon set for the action buttons.
class KitChatActionIconsIos {
  const KitChatActionIconsIos({
    this.add,
    this.back,
    this.chooseFile,
    this.copy,
    this.resend,
    this.save,
    this.selectFromGallery,
    this.send,
    this.share,
    this.takePhoto,
  });

  /// Icon that represents the action to add attachments to an outbound message.
  ///
  /// The recommended icon size is 24x24.
  final String? add;

  /// Icon that represents the action to go back on the navigation bar.
  ///
  /// The recommended icon size is 24x24.
  final String? back;

  /// Icon that represents the action to choose a file from the device.
  ///
  /// The recommended icon size is 24x24.
  final String? chooseFile;

  /// Icon that represents the action to copy text.
  ///
  /// The recommended icon size is 24x24.
  final String? copy;

  /// Icon that represents the action to resend a failed message.
  ///
  /// The recommended icon size is 24x24.
  final String? resend;

  /// Icon that represents the action to save an image.
  ///
  /// The recommended icon size is 24x24.
  final String? save;

  /// Icon that represents the action to select an image from the gallery.
  ///
  /// The recommended icon size is 24x24.
  final String? selectFromGallery;

  /// Icon that represents the action to send a message.
  ///
  /// The recommended icon size is 24x24.
  final String? send;

  /// Icon that represents the action to share files.
  ///
  /// The recommended icon size is 24x24.
  final String? share;

  /// Icon that represents the action to take a photo.
  ///
  /// The recommended icon size is 24x24.
  final String? takePhoto;
}

/// Icon set for attachments visualization and attachments related actions.
class KitChatAttachmentIconsIos {
  const KitChatAttachmentIconsIos({this.document, this.download, this.error});

  /// Icon that represents a document attachment in a message.
  ///
  /// The recommended icon size is 24x24.
  final String? document;

  /// Icon that represents the action to download an attachment.
  ///
  /// The recommended icon size is 24x24.
  final String? download;

  /// Icon that represents the attachment error state.
  ///
  /// The recommended icon size is 24x24.
  final String? error;
}

/// Icon set for senders.
class KitChatSenderIconsIos {
  const KitChatSenderIconsIos({this.agent, this.bot});

  /// Icon that represents the agent’s default avatar.
  ///
  /// The recommended icon size is 20x20.
  final String? agent;

  /// Icon that represents the bot’s default avatar.
  ///
  /// The recommended icon size is 20x20.
  final String? bot;
}
