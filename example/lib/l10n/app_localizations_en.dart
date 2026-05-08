// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get region => 'Region';

  @override
  String get selectRegion => 'Select region';

  @override
  String get channelUuid => 'Channel UUID';

  @override
  String get enterChannelUuid => 'Enter channel UUID';

  @override
  String get token => 'Token';

  @override
  String get enterToken => 'Enter token';

  @override
  String get clientId => 'Client ID';

  @override
  String get enterClientId => 'Enter client ID';

  @override
  String get openChat => 'Open chat';

  @override
  String get allowNotifications => 'Allow notifications';

  @override
  String get fieldCannotBeEmpty => 'The field cannot be empty';

  @override
  String get invalidValue => 'Invalid value';

  @override
  String get regionIsNotSelected => 'Region is not selected';

  @override
  String get errorOfRegistrationOfThePushToken =>
      'Push token registration error';

  @override
  String get tryAgain => 'Try again';

  @override
  String get repeatAttempt => 'Attempt in progress…';
}
