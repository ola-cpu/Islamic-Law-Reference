// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Islamic Law Reference';

  @override
  String get searchHint => 'Search for a law...';

  @override
  String get noResults => 'No results found.';

  @override
  String get sources => 'Sources and References:';

  @override
  String get comments => 'Scholar Comments:';

  @override
  String get school => 'Legal School:';

  @override
  String get personalNotes => 'My Personal Notes:';

  @override
  String get addNoteHint => 'Add a note...';

  @override
  String get saveNote => 'Save Note';

  @override
  String get noteSaved => 'Note saved!';

  @override
  String get noLaws => 'No laws found.';

  @override
  String get noSources => 'No sources available.';

  @override
  String get schoolHanafi => 'Hanafi';

  @override
  String get schoolMaliki => 'Maliki';

  @override
  String get schoolShafii => 'Shafi\'i';

  @override
  String get schoolHanbali => 'Hanbali';

  @override
  String get schoolJafari => 'Ja\'fari';
}
