# Voximplant Kit Chat SDK for Flutter

The Voximplant Kit Chat SDK allows you to add in-app messaging to your Flutter application with a ready-to-use user experience. Explore our documentation and learn how to add an interface into your app, customize colors and strings so that the messaging user interface looks natural. Enhance your user experience with push notifications, customer data, and other features.

Supported languages: English, Spanish, Portuguese, Russian.

<img src="https://raw.githubusercontent.com/voximplant/flutter_voximplant_kit_chat/refs/heads/main/screenshots/chat_screen_android.png" width=200> <img src="https://raw.githubusercontent.com/voximplant/flutter_voximplant_kit_chat/refs/heads/main/screenshots/chat_screen_ios.png" width=208>

## Supported platforms

| Platform | Minimum version |
| -------- | --------------- |
| Android  | `5.0 (API 21)`  |
| iOS      | `13.0`          |

## Requirements

- Flutter `>= 3.29.0`
- Dart SDK `^3.7.0`
- Android: JDK 17, Android Gradle Plugin and Kotlin versions that support `compileSdk 35` (AGP 8.6+, Kotlin 2.x are recommended)
- iOS: Xcode 15+, Swift 5.9+

## Getting started

To get started, register a Voximplant Kit account and configure a mobile channel:
- Create and set up a mobile channel - [guide](https://voximplant.com/kit/docs/setup/conversations/channels/mobilechat).
- Upload push notification certificates - [guide](https://voximplant.com/kit/docs/setup/conversations/pushcertificates).

## Installation

Add the dependency to your application's `pubspec.yaml`:

```yaml
dependencies:
  voximplant_kit_chat: ^1.1.0
```

Then run:

```bash
flutter pub get
```

### iOS setup

#### Info.plist

The chat lets users attach photos from the camera and save images to the gallery.

To enable these actions, add `NSCameraUsageDescription` and `NSPhotoLibraryAddUsageDescription` entries to your application's `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required to take photos and attach them in chat</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Photo library access is required to save chat images</string>
```

#### Root view controller

`openChat()` pushes the chat view controller onto the application navigation stack, so the Flutter view
controller must be embedded in a `UINavigationController`. See
[`example/ios/Runner/SceneDelegate.swift`](example/ios/Runner/SceneDelegate.swift) for a reference setup.

## Usage

### Initialization

`VoximplantKitChat` is the main SDK class that provides access to its functionality. You should initialize it with your mobile channel credentials and the unique customer identifier before opening the chat.

```dart
import 'package:voximplant_kit_chat/voximplant_kit_chat.dart';

final kitChat = VoximplantKitChat();

await kitChat.initialize(
  region: '<account-region>',
  channelUuid: '<channel-uuid>',
  token: '<channel-token>',
  clientId: '<client-id>',
);
```

#### Authorization errors

Subscribe to the `authorizationErrors` stream to be notified if the credentials supplied to the `initialize` API are rejected. 

These errors are intended for debugging and logging — avoid surfacing them directly to the end user:

```dart
kitChat.authorizationErrors.listen((error) {
  debugPrint('KitChat authorization error: $error');
});
```

### Open the chat

Once the VoximplantKitChat instance is initialized, open the chat:

```dart
await kitChat.openChat();
```

The chat opens as the topmost screen on both platforms.

### Set client data

Use the `setClientData` API to update the customer profile in the agent's workspace:

```dart
await kitChat.setClientData(const KitChatClientData(
  displayName: 'Jane Doe',
  email: 'jane@example.com',
  phone: '+15551234567',
  avatarUrl: 'https://example.com/avatar.png',
  language: 'en',
));
```

### Push notifications

Push notifications notify users about new incoming messages.

A complete push notification flow (token registration, foreground / background / terminated handling, deep linking) is implemented in [`the example project`](example/lib/main.dart).

#### Setup

##### iOS

Add the `remote-notification` background mode capability in `Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```


#### Get and register a push token

To receive the push notifications for the new messages, you should register a push token to Voximplant Kit using the `registerPushToken` API.
A push notification token should be obtained on the application side using any 3rd party plugin (for example [`firebase_messaging`](https://pub.dev/packages/firebase_messaging) or [`push`](https://pub.dev/packages/push)) that exposes the following required token types to the flutter API:
- **Android:** Firebase Cloud Messaging (FCM) tokens.
- **iOS:** APNs token encoded as a hex string.

> [!IMPORTANT]
> FCM tokens are not acceptble on iOS. If you use `firebase_messaging`, request the APNs token explicitly using the `FirebaseMessaging.instance.getAPNSToken()` API.

Once you have a token, register it with the SDK:

```dart
await kitChat.registerPushToken(token);
```

To stop receiving push notifications:

```dart
await kitChat.unregisterPushToken(token);
```

#### Receive and handle push notifications

##### Android

To display chat notifications on Android 13+, declare the `POST_NOTIFICATIONS` permission in your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

The user must grant this runtime permission for chat notifications to be shown.

> [!NOTE]
> The SDK does not request this permission itself — the application is responsible for requesting the permission from the user.

The SDK provides the handlePushAndroid API that processes the push payload data and shows a new message notification. The notification contains a pending intent that allows to open the chat on the notification tap.

When the user taps the notification, Android application receives the intent with the `voximplant://kitchat` URI. The application can use this data to navigate to the chat screen.

Declare the following intent filter in the application manifest:

```xml
<activity
    android:name=".MainActivity"
    android:launchMode="singleTask"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:host="kitchat" android:scheme="voximplant"/>
    </intent-filter>
</activity>
```

##### iOS

Push notifications are displayed by the operating system. To customize foreground presentation, set up a custom `UNUserNotificationCenterDelegate` (see [`example/ios/Runner/AppDelegate.swift`](example/ios/Runner/AppDelegate.swift)).

Push notifications are displayed automatically by the operating system upon being received. To customize the notifications, use the native `UNUserNotificationCenterDelegate` API.
The SDK also provides the `isChatVisibleIos` API that allows to determine whether the application is in the foreground state with the chat screen opened. This API may be used to prevent the new message notifications to be shown while the user is on the chat screen.

```dart
if (await VoximplantKitChat.isChatVisibleIos()) {
  // Skip showing the in-app notification banner.
}
```

## Customization

The SDK provides the `applyCustomization` API to customize colors, icons, and strings.

Android strings and icons are not part of `KitChatCustomization`. Override them through the host application resources — see the **Android strings** and **Android icons** tables below.

iOS custom icons should be added to the `Images.xcassets` of the host application. Reference each asset by its name through `KitChatIconsIos`.

> [!IMPORTANT]
> Apply customization once before opening the chat.

```dart
const colorScheme = KitChatColorScheme(
  brand: Color(0xFF662EFF),
  brandContainer: Color(0xFFF2EEFF),
  …
);

const stringsIos = KitChatStringsIos(
  chatTitle: 'Chat',
  messagePlaceholder: 'Type a message…',
  sender: KitChatSenderStringsIos(
    agentDisplayName: 'Agent',
    botDisplayName: 'Bot',
  ),
  …
);

const iconsIos = KitChatIconsIos(
  senders: KitChatSenderIconsIos(agent: 'myAgentIcon', bot: 'myBotIcon'),
  actions: KitChatActionIconsIos(send: 'mySendIcon'),
  …
);

const customization = KitChatCustomization(
  colorScheme: colorScheme,
  stringsIos: stringsIos,
  iconsIos: iconsIos,
);

await kitChat.applyCustomization(customization);
```

### Android strings

Android strings are overridden through the application resources. Place a `strings.xml` file with the keys
listed below in `./<app>/android/app/src/main/res/values/` (and the localized variants in `values-<locale>/`).

| Key                                              | Description                                                                                               |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| `kit_action_close`                               | Localized string that represents the Close action                                                         |
| `kit_action_open_settings`                       | Localized string that represents the action to open the application's system settings                     |
| `kit_attachments_pick_file`                      | Localized strings configuration for the document picker action                                            |
| `kit_attachments_pick_media`                     | Localized strings configuration for the media picker action                                               |
| `kit_attachments_take_photo`                     | Localized strings configuration for the camera picker action                                              |
| `kit_camera_permission_text`                     | Localized string that represents the description of the camera access permission                          |
| `kit_chat_title`                                 | Localized string that represents the chat title                                                           |
| `kit_connection_state_connecting`                | Localized string for the connecting state                                                                 |
| `kit_connection_state_offline`                   | Localized string for the offline state                                                                    |
| `kit_connection_state_online`                    | Localized string for the online state                                                                     |
| `kit_copied`                                     | Localized string for the notice that text has been copied                                                 |
| `kit_error_file_action_access`                   | Localized string for the file access error action                                                         |
| `kit_error_file_action_open`                     | Localized string for the file open error action                                                           |
| `kit_error_file_action_save`                     | Localized string for the file save error action                                                           |
| `kit_error_file_limit`                           | Localized string for the notice that the file attachments limit for an outbound message has been exceeded |
| `kit_error_send_message_invalid_files`           | Localized string for invalid files in an outbound message                                                 |
| `kit_error_validation_file_invalid`              | Localized string for an invalid file                                                                      |
| `kit_error_validation_file_invalid_extension`    | Localized string for an invalid file extension                                                            |
| `kit_error_validation_file_invalid_size`         | Localized string for an invalid file size                                                                 |
| `kit_error_validation_files_invalid`             | Localized string for invalid files                                                                        |
| `kit_file_saved`                                 | Localized string indicating that a file has been saved                                                    |
| `kit_file_saved_to_downloads`                    | Localized string indicating that a file has been saved to the Downloads directory                         |
| `kit_notification_channel_chat_description`      | Localized string that represents the chat notification channel description                                |
| `kit_notification_channel_chat_name`             | Localized string that represents the chat notification channel name                                       |
| `kit_notification_channel_upload_description`    | Localized string that represents the upload notification channel description                              |
| `kit_notification_channel_upload_name`           | Localized string that represents the upload notification channel name                                     |
| `kit_notification_new_message_content_text`      | Localized string that represents the description text for a new inbound message                           |
| `kit_notification_new_message_title`             | Localized string that represents the title text for a new inbound message                                 |
| `kit_notification_upload_progress_title`         | Localized plural string for the upload progress title in a notification                                   |
| `kit_placeholder_message`                        | Localized string that represents placeholder text for an outbound message                                 |
| `kit_sender_display_name_agent_unnamed`          | Localized string for the agent’s default display name                                                     |
| `kit_sender_display_name_bot`                    | Localized string for the bot’s display name                                                               |
| `kit_unit_bytes`                                 | Localized string for the bytes unit                                                                       |
| `kit_unit_kilobytes`                             | Localized string for the kilobytes unit                                                                   |
| `kit_unit_megabytes`                             | Localized string for the megabytes unit                                                                   |

### Android icons

Android icons are overridden through drawable resources. Place an XML / vector drawable with the same name
listed below into `./<app>/android/app/src/main/res/drawable/` to override the SDK default at build time.

| Key                                            | Description                                                                       |
| ---------------------------------------------- | --------------------------------------------------------------------------------- |
| `ic_kit_action_back_s.xml`                     | Icon that represents the action to go back on the navigation bar                  |
| `ic_kit_action_close_s.xml`                    | Icon that represents the action to close the selection mode on the navigation bar |
| `ic_kit_action_copy_s.xml`                     | Icon that represents the action to copy text in a message                         |
| `ic_kit_action_save_s.xml`                     | Icon that represents the action to save an attachment file                        |
| `ic_kit_add_attachments_s.xml`                 | Icon that represents the action to add attachments to an outbound message         |
| `ic_kit_attachment_download_s.xml`             | Icon that represents the action to download an attachment                         |
| `ic_kit_attachment_preview_document_s.xml`     | Icon that represents a placeholder for a document attachment in a message         |
| `ic_kit_attachment_preview_media_s.xml`        | Icon that represents a placeholder for a media attachment in a message            |
| `ic_kit_avatar_agent_xs.xml`                   | Icon that represents the agent’s default avatar                                   |
| `ic_kit_avatar_bot_xs.xml`                     | Icon that represents the bot’s avatar                                     |
| `ic_kit_chat_notification_message.xml`         | Icon that represents a new message in a notification                              |
| `ic_kit_chat_notification_upload.xml`          | Icon that represents the upload in notification                                   |
| `ic_kit_error_xxs.xml`                         | Icon that represents the outbound message error state                             |
| `ic_kit_picker_camera_s.xml`                   | Icon that represents the action to the open camera                                |
| `ic_kit_picker_file_s.xml`                     | Icon that represents the action to open the document picker                       |
| `ic_kit_picker_media_s.xml`                    | Icon that represents the action to open the media picker                          |
| `ic_kit_remove_s.xml`                          | Icon that represents the action to remove an attached file in an outbound message |
| `ic_kit_scroll_down_s.xml`                     | Icon that represents the action to scroll the page to the latest messages         |
| `ic_kit_send_message_s.xml`                    | Icon that represents the action to send a message                                 |
| `ic_kit_success_xxs.xml`                       | Icon to highlight success states                                                  |
| `ic_kit_warning_s.xml`                         | Icon that represents the attachment error state                                   |

## Error handling

All asynchronous methods may throw exceptions based on `KitChatException`:

| Exception                              | When it is thrown                                                                |
| -------------------------------------- | -------------------------------------------------------------------------------- |
| `KitChatInitializationException`       | The SDK is not initialized, the Android context is missing, or initialization fails |
| `KitChatIllegalArgumentException`      | One of the arguments is invalid (for example, an empty client data field or an empty push token) |
| `KitChatConnectionRequiredException`   | The operation requires an active connection but the device is offline            |
| `KitChatTimeoutException`              | The operation timed out                                                          |
| `KitChatInternalException`             | An unrecoverable error reported by the underlying native SDK                     |
| `KitChatUnknownException`              | An unexpected error that does not match any of the categories above              |

```dart
try {
  await kitChat.setClientData(const KitChatClientData(displayName: 'Jane'));
} on KitChatConnectionRequiredException {
  // Retry once the device is back online.
} on KitChatException catch (error) {
  debugPrint('KitChat error: $error');
}
```

## Example

A complete example that demonstrates initialization, customization, push notifications and deep linking is
available in [`example/lib/main.dart`](example/lib/main.dart). To run it:

```bash
cd example
flutter pub get
flutter run
```

## License

Licensed under the [Apache License, Version 2.0](LICENSE).
