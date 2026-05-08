// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

/// Base exception class for all exceptions in the Voximplant Kit Chat SDK.
sealed class KitChatException implements Exception {
  const KitChatException({required this.code, this.message, this.details});

  /// Error code identifying the exception kind.
  final String code;

  /// Error message detail.
  final String? message;

  /// Optional platform-specific payload attached to the error.
  final Object? details;

  @override
  String toString() => '$runtimeType(code: $code, $message, $details)';
}

/// Thrown to indicate that the SDK has not been initialized, or that
/// initialization could not be completed (for example, the Android
/// application `Context` is unavailable, or the iOS Flutter view controller
/// is not embedded in a `UINavigationController`).
final class KitChatInitializationException extends KitChatException {
  const KitChatInitializationException({super.message, super.details})
    : super(code: 'INITIALIZATION');
}

/// Thrown to indicate that an invalid argument has been supplied to the SDK
/// (for example, an empty client data field or an empty push token).
final class KitChatIllegalArgumentException extends KitChatException {
  const KitChatIllegalArgumentException({super.message, super.details})
    : super(code: 'ILLEGAL_ARGUMENT');
}

/// Thrown to indicate that a method has been called when the connection to
/// Voximplant Kit is not established.
final class KitChatConnectionRequiredException extends KitChatException {
  const KitChatConnectionRequiredException({super.message, super.details})
    : super(code: 'CONNECTION_REQUIRED');
}

/// Thrown to indicate that an operation has not been completed in time.
final class KitChatTimeoutException extends KitChatException {
  const KitChatTimeoutException({super.message, super.details})
    : super(code: 'TIMEOUT');
}

/// Thrown to indicate that an internal error has occurred in the underlying
/// native SDK.
final class KitChatInternalException extends KitChatException {
  const KitChatInternalException({
    required super.code,
    super.message,
    super.details,
  });
}

/// Thrown when an error does not match any documented category.
final class KitChatUnknownException extends KitChatException {
  const KitChatUnknownException({
    required super.code,
    super.message,
    super.details,
  });
}
