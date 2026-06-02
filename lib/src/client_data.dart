// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

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
