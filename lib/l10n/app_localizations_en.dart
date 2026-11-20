// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'EduSnap';

  @override
  String get list => 'List';

  @override
  String get settings => 'Settings';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get back => 'Back';

  @override
  String get title => 'Title';

  @override
  String get note => 'Note';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get cameraAccessNeeded => 'Camera access is needed to take a photo.';

  @override
  String get photoLibraryAccessNeeded =>
      'Photo library access is needed to choose a photo.';

  @override
  String get notNow => 'Not now';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get titleMissing => 'Title is missing';

  @override
  String get ok => 'OK';

  @override
  String get noPhoto => 'No photo';

  @override
  String get emptyValue => '-';

  @override
  String get noEntries => 'No entries yet. Tap + to add one.';

  @override
  String createdOn(String date) {
    return 'Created on $date';
  }

  @override
  String get language => 'Language';

  @override
  String get storageUsage => 'Storage usage';

  @override
  String storageUsed(String size) {
    return '$size KB used';
  }

  @override
  String get formatData => 'Format / Clear Data';

  @override
  String get confirmClearTitle1 => 'Clear all data?';

  @override
  String get confirmClearMsg1 =>
      'This will delete all journal entries and photos.';

  @override
  String get confirmClearTitle2 => 'Are you absolutely sure?';

  @override
  String get confirmClearMsg2 => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Build number';
}
