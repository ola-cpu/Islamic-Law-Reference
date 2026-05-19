import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Law Reference'**
  String get appTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a law...'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResults;

  /// No description provided for @sources.
  ///
  /// In en, this message translates to:
  /// **'Sources and References:'**
  String get sources;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Scholar Comments:'**
  String get comments;

  /// No description provided for @school.
  ///
  /// In en, this message translates to:
  /// **'Legal School:'**
  String get school;

  /// No description provided for @personalNotes.
  ///
  /// In en, this message translates to:
  /// **'My Personal Notes:'**
  String get personalNotes;

  /// No description provided for @addNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note...'**
  String get addNoteHint;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save Note'**
  String get saveNote;

  /// No description provided for @noteSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved!'**
  String get noteSaved;

  /// No description provided for @noLaws.
  ///
  /// In en, this message translates to:
  /// **'No laws found.'**
  String get noLaws;

  /// No description provided for @noSources.
  ///
  /// In en, this message translates to:
  /// **'No sources available.'**
  String get noSources;

  /// No description provided for @schoolHanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get schoolHanafi;

  /// No description provided for @schoolMaliki.
  ///
  /// In en, this message translates to:
  /// **'Maliki'**
  String get schoolMaliki;

  /// No description provided for @schoolShafii.
  ///
  /// In en, this message translates to:
  /// **'Shafi\'i'**
  String get schoolShafii;

  /// No description provided for @schoolHanbali.
  ///
  /// In en, this message translates to:
  /// **'Hanbali'**
  String get schoolHanbali;

  /// No description provided for @schoolJafari.
  ///
  /// In en, this message translates to:
  /// **'Ja\'fari'**
  String get schoolJafari;

  /// No description provided for @mediaLibrary.
  ///
  /// In en, this message translates to:
  /// **'Media Library'**
  String get mediaLibrary;

  /// No description provided for @comparisonTable.
  ///
  /// In en, this message translates to:
  /// **'Comparative table of schools'**
  String get comparisonTable;

  /// No description provided for @schoolTitle.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get schoolTitle;

  /// No description provided for @legalOpinion.
  ///
  /// In en, this message translates to:
  /// **'Legal Opinion'**
  String get legalOpinion;

  /// No description provided for @mediaSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Media and Illustrations'**
  String get mediaSectionTitle;

  /// No description provided for @illustration.
  ///
  /// In en, this message translates to:
  /// **'Illustration'**
  String get illustration;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @hajjSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps of the Pilgrimage (Hajj)'**
  String get hajjSteps;

  /// No description provided for @noMediaFound.
  ///
  /// In en, this message translates to:
  /// **'No media found.'**
  String get noMediaFound;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageFr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFr;

  /// No description provided for @languageAr.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageAr;

  /// No description provided for @languageRu.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRu;

  /// No description provided for @languageZh.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageZh;

  /// No description provided for @hajjStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Entering the state of Ihram.'**
  String get hajjStep1Desc;

  /// No description provided for @hajjStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Departure for Mina on the 8th of Dhul-Hijjah.'**
  String get hajjStep2Desc;

  /// No description provided for @hajjStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Day of Arafat (The climax of Hajj).'**
  String get hajjStep3Desc;

  /// No description provided for @hajjStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Collecting pebbles at Muzdalifah.'**
  String get hajjStep4Desc;

  /// No description provided for @hajjStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Stoning the pillars at Mina.'**
  String get hajjStep5Desc;

  /// No description provided for @hajjStep6Desc.
  ///
  /// In en, this message translates to:
  /// **'Tawaf and Sa\'y at Mecca.'**
  String get hajjStep6Desc;

  /// No description provided for @hajjStep7Desc.
  ///
  /// In en, this message translates to:
  /// **'Sacrifice and end of Hajj rituals.'**
  String get hajjStep7Desc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
