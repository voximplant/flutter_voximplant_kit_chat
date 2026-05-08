# voximplant_kit_chat_example

Demo app for validating the `voximplant_kit_chat` Flutter plugin.

## Quick Start

```bash
flutter pub get
flutter run
```

## Run

```bash
flutter run
```

If you run into iOS dependency errors, do a full cleanup:

```bash
flutter clean
flutter pub get
flutter run
```

## Regenerating Flutter Localizations (gen_l10n)

When updating localization files in `lib/l10n/*.arb`, regenerate localization classes from the `example` directory:

```bash
flutter gen-l10n
```

## SPM for Flutter Plugins (iOS)

If you are testing Swift Package Manager in the plugin:

1. Enable SPM globally:
   - `flutter config --enable-swift-package-manager`
2. Rebuild `example` after cleanup (see the section above).
3. Ensure `example/.flutter-plugins-dependencies` has `swift_package_manager_enabled: true` for iOS.
