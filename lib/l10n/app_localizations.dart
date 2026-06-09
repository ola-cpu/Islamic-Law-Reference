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

  /// No description provided for @relatedTopics.
  ///
  /// In en, this message translates to:
  /// **'Related Topics'**
  String get relatedTopics;

  /// No description provided for @filterBySchool.
  ///
  /// In en, this message translates to:
  /// **'Filter by School'**
  String get filterBySchool;

  /// No description provided for @filterByCategory.
  ///
  /// In en, this message translates to:
  /// **'Filter by Category'**
  String get filterByCategory;

  /// No description provided for @dailyTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic of the Day'**
  String get dailyTopic;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more →'**
  String get readMore;

  /// No description provided for @myLibrary.
  ///
  /// In en, this message translates to:
  /// **'My Library'**
  String get myLibrary;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @readingHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get readingHistory;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet. Tap the heart on a topic to save it here.'**
  String get noFavorites;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No reading history yet. Explore topics to see them here.'**
  String get noHistory;

  /// No description provided for @topicsExplored.
  ///
  /// In en, this message translates to:
  /// **'{read} topics explored out of {total}'**
  String topicsExplored(int read, int total);

  /// No description provided for @learnHub.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnHub;

  /// No description provided for @learnHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review with flashcards and test your knowledge with quizzes.'**
  String get learnHubSubtitle;

  /// No description provided for @flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards;

  /// No description provided for @cardCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String cardCount(int count);

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @quizGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Fiqh Quiz'**
  String get quizGeneral;

  /// No description provided for @quizQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String quizQuestionCount(int count);

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @tapToFlip.
  ///
  /// In en, this message translates to:
  /// **'Tap the card to flip'**
  String get tapToFlip;

  /// No description provided for @reviewAgain.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewAgain;

  /// No description provided for @knewIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get knewIt;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @deckComplete.
  ///
  /// In en, this message translates to:
  /// **'Deck complete!'**
  String get deckComplete;

  /// No description provided for @deckCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'You reviewed all {count} cards.'**
  String deckCompleteMessage(int count);

  /// No description provided for @quizResults.
  ///
  /// In en, this message translates to:
  /// **'Quiz Results'**
  String get quizResults;

  /// No description provided for @quizScore.
  ///
  /// In en, this message translates to:
  /// **'{score} / {total} correct'**
  String quizScore(int score, int total);

  /// No description provided for @quizPassed.
  ///
  /// In en, this message translates to:
  /// **'Well done! You earned the Quiz Master badge.'**
  String get quizPassed;

  /// No description provided for @quizTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Keep studying — you can do better!'**
  String get quizTryAgain;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next question'**
  String get nextQuestion;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @badgesProgress.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} / {total} badges unlocked'**
  String badgesProgress(int unlocked, int total);

  /// No description provided for @guidedCourses.
  ///
  /// In en, this message translates to:
  /// **'Guided Courses'**
  String get guidedCourses;

  /// No description provided for @guidedCoursesDesc.
  ///
  /// In en, this message translates to:
  /// **'Structured 7-day paths to learn step by step.'**
  String get guidedCoursesDesc;

  /// No description provided for @courseProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} days completed'**
  String courseProgress(int done, int total);

  /// No description provided for @courseCount.
  ///
  /// In en, this message translates to:
  /// **'{count} course(s) available'**
  String courseCount(int count);

  /// No description provided for @courseComplete.
  ///
  /// In en, this message translates to:
  /// **'Course completed! You earned the Graduate badge.'**
  String get courseComplete;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @zakatCalculator.
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get zakatCalculator;

  /// No description provided for @zakatCalculatorShort.
  ///
  /// In en, this message translates to:
  /// **'Estimate your zakat based on nisab'**
  String get zakatCalculatorShort;

  /// No description provided for @zakatCalculatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your wealth to check if you reach nisab (85g gold) and calculate 2.5% zakat.'**
  String get zakatCalculatorDesc;

  /// No description provided for @goldGrams.
  ///
  /// In en, this message translates to:
  /// **'Gold (grams)'**
  String get goldGrams;

  /// No description provided for @goldGramsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50'**
  String get goldGramsHint;

  /// No description provided for @silverGrams.
  ///
  /// In en, this message translates to:
  /// **'Silver (grams)'**
  String get silverGrams;

  /// No description provided for @silverGramsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 200'**
  String get silverGramsHint;

  /// No description provided for @cashAmount.
  ///
  /// In en, this message translates to:
  /// **'Cash & savings'**
  String get cashAmount;

  /// No description provided for @cashAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5000'**
  String get cashAmountHint;

  /// No description provided for @goldPricePerGram.
  ///
  /// In en, this message translates to:
  /// **'Gold price per gram'**
  String get goldPricePerGram;

  /// No description provided for @goldPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Local currency'**
  String get goldPriceHint;

  /// No description provided for @calculateZakat.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculateZakat;

  /// No description provided for @zakatDue.
  ///
  /// In en, this message translates to:
  /// **'Zakat due: {amount}'**
  String zakatDue(String amount);

  /// No description provided for @belowNisab.
  ///
  /// In en, this message translates to:
  /// **'Below nisab — no zakat due'**
  String get belowNisab;

  /// No description provided for @zakatCalcDetail.
  ///
  /// In en, this message translates to:
  /// **'Gold: {gold}g · Silver: {silver}g · Cash: {cash} · Nisab ≈ {nisab}'**
  String zakatCalcDetail(String gold, String silver, String cash, String nisab);

  /// No description provided for @zakatRateNote.
  ///
  /// In en, this message translates to:
  /// **'Rate: 2.5% after one lunar year of possession.'**
  String get zakatRateNote;

  /// No description provided for @learnMoreZakat.
  ///
  /// In en, this message translates to:
  /// **'Learn more about Zakat'**
  String get learnMoreZakat;

  /// No description provided for @zakatTopicHint.
  ///
  /// In en, this message translates to:
  /// **'Open the Nisab topic'**
  String get zakatTopicHint;

  /// No description provided for @seasonRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Season'**
  String get seasonRamadan;

  /// No description provided for @seasonRamadanDesc.
  ///
  /// In en, this message translates to:
  /// **'Featured topics for fasting and worship'**
  String get seasonRamadanDesc;

  /// No description provided for @seasonHajj.
  ///
  /// In en, this message translates to:
  /// **'Hajj Season'**
  String get seasonHajj;

  /// No description provided for @seasonHajjDesc.
  ///
  /// In en, this message translates to:
  /// **'Featured topics for pilgrimage'**
  String get seasonHajjDesc;

  /// No description provided for @listenQuran.
  ///
  /// In en, this message translates to:
  /// **'Listen to verse'**
  String get listenQuran;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @hijriDate.
  ///
  /// In en, this message translates to:
  /// **'Hijri date'**
  String get hijriDate;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSetting;

  /// No description provided for @themeSetting.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSetting;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @seasonShaaban.
  ///
  /// In en, this message translates to:
  /// **'Sha\'ban — Prepare for Ramadan'**
  String get seasonShaaban;

  /// No description provided for @seasonShaabanDesc.
  ///
  /// In en, this message translates to:
  /// **'Featured topics to prepare for the holy month'**
  String get seasonShaabanDesc;

  /// No description provided for @allSchools.
  ///
  /// In en, this message translates to:
  /// **'All schools'**
  String get allSchools;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyFilters;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @explorationLevel.
  ///
  /// In en, this message translates to:
  /// **'Exploration: {percent}%'**
  String explorationLevel(int percent);

  /// No description provided for @coursesCompleted.
  ///
  /// In en, this message translates to:
  /// **'{done} courses of {total}'**
  String coursesCompleted(int done, int total);

  /// No description provided for @courseProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Course progress'**
  String get courseProgressTitle;

  /// No description provided for @exportLibrary.
  ///
  /// In en, this message translates to:
  /// **'Export library'**
  String get exportLibrary;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Offline fiqh encyclopedia'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Browse hundreds of Islamic legal topics, organized by category and school.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Learn by doing'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Flashcards, quizzes, guided courses and badges to reinforce your knowledge.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Track your progress'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Favorites, personal notes and a dashboard to follow your journey.'**
  String get onboardingDesc3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @myMadhhab.
  ///
  /// In en, this message translates to:
  /// **'My madhhab'**
  String get myMadhhab;

  /// No description provided for @myMadhhabDesc.
  ///
  /// In en, this message translates to:
  /// **'Highlight your preferred school in topic pages'**
  String get myMadhhabDesc;

  /// No description provided for @myMadhhabLabel.
  ///
  /// In en, this message translates to:
  /// **'My school'**
  String get myMadhhabLabel;

  /// No description provided for @noSchoolPreference.
  ///
  /// In en, this message translates to:
  /// **'No preference'**
  String get noSchoolPreference;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily topic reminder'**
  String get dailyReminder;

  /// No description provided for @dailyReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Show a reminder on home until today\'s topic is read'**
  String get dailyReminderDesc;

  /// No description provided for @dailyReminderBanner.
  ///
  /// In en, this message translates to:
  /// **'Today\'s topic — read it today'**
  String get dailyReminderBanner;

  /// No description provided for @practicalCases.
  ///
  /// In en, this message translates to:
  /// **'Practical cases'**
  String get practicalCases;

  /// No description provided for @practicalCasesDesc.
  ///
  /// In en, this message translates to:
  /// **'\"What if…?\" scenarios with school positions'**
  String get practicalCasesDesc;

  /// No description provided for @caseCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get caseCompleted;

  /// No description provided for @casePending.
  ///
  /// In en, this message translates to:
  /// **'To solve'**
  String get casePending;

  /// No description provided for @chooseAnswer.
  ///
  /// In en, this message translates to:
  /// **'Choose an answer'**
  String get chooseAnswer;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get checkAnswer;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correctAnswer;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Not quite — here\'s the explanation'**
  String get wrongAnswer;

  /// No description provided for @finishCase.
  ///
  /// In en, this message translates to:
  /// **'Finish case'**
  String get finishCase;

  /// No description provided for @schoolPositions.
  ///
  /// In en, this message translates to:
  /// **'School positions'**
  String get schoolPositions;

  /// No description provided for @readingStreak.
  ///
  /// In en, this message translates to:
  /// **'{days} day streak'**
  String readingStreak(int days);

  /// No description provided for @readingStreakDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'re reading regularly — keep it up!'**
  String get readingStreakDesc;

  /// No description provided for @suggestedTopic.
  ///
  /// In en, this message translates to:
  /// **'Suggested for you'**
  String get suggestedTopic;

  /// No description provided for @homeWidget.
  ///
  /// In en, this message translates to:
  /// **'Home screen widget'**
  String get homeWidget;

  /// No description provided for @homeWidgetDesc.
  ///
  /// In en, this message translates to:
  /// **'Add the Daily Topic widget from your Android widget menu'**
  String get homeWidgetDesc;

  /// No description provided for @pushNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily topic'**
  String get pushNotificationTitle;

  /// No description provided for @exportAsText.
  ///
  /// In en, this message translates to:
  /// **'Export as text'**
  String get exportAsText;

  /// No description provided for @exportAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportAsPdf;

  /// No description provided for @noneLabel.
  ///
  /// In en, this message translates to:
  /// **'(none)'**
  String get noneLabel;

  /// No description provided for @backupData.
  ///
  /// In en, this message translates to:
  /// **'Data backup'**
  String get backupData;

  /// No description provided for @backupDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Favorites, notes, progress, badges and settings'**
  String get backupDataDesc;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get importBackup;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully'**
  String get backupRestored;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed'**
  String get backupFailed;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @clearRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearRecentSearches;

  /// No description provided for @zenMode.
  ///
  /// In en, this message translates to:
  /// **'Zen reading mode'**
  String get zenMode;

  /// No description provided for @readAloud.
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get readAloud;

  /// No description provided for @increaseFont.
  ///
  /// In en, this message translates to:
  /// **'Increase font size'**
  String get increaseFont;

  /// No description provided for @decreaseFont.
  ///
  /// In en, this message translates to:
  /// **'Decrease font size'**
  String get decreaseFont;

  /// No description provided for @compareSchools.
  ///
  /// In en, this message translates to:
  /// **'Compare schools'**
  String get compareSchools;

  /// No description provided for @compareHubDesc.
  ///
  /// In en, this message translates to:
  /// **'Topics with positions from multiple madhhabs'**
  String get compareHubDesc;

  /// No description provided for @noComparisonAvailable.
  ///
  /// In en, this message translates to:
  /// **'No comparison available'**
  String get noComparisonAvailable;

  /// No description provided for @fullComparison.
  ///
  /// In en, this message translates to:
  /// **'Full comparison'**
  String get fullComparison;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get continueReading;

  /// No description provided for @dailyQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question of the day'**
  String get dailyQuestion;

  /// No description provided for @experienceLevel.
  ///
  /// In en, this message translates to:
  /// **'Experience level'**
  String get experienceLevel;

  /// No description provided for @experienceLevelDesc.
  ///
  /// In en, this message translates to:
  /// **'Adapt how topics are displayed'**
  String get experienceLevelDesc;

  /// No description provided for @beginnerMode.
  ///
  /// In en, this message translates to:
  /// **'Beginner mode'**
  String get beginnerMode;

  /// No description provided for @beginnerModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Summary and one school at a time'**
  String get beginnerModeDesc;

  /// No description provided for @studentMode.
  ///
  /// In en, this message translates to:
  /// **'Student mode'**
  String get studentMode;

  /// No description provided for @studentModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Full comparison and detailed sources'**
  String get studentModeDesc;

  /// No description provided for @beginnerModeActive.
  ///
  /// In en, this message translates to:
  /// **'Beginner mode active'**
  String get beginnerModeActive;

  /// No description provided for @showAllSchools.
  ///
  /// In en, this message translates to:
  /// **'Show all schools'**
  String get showAllSchools;

  /// No description provided for @methodology.
  ///
  /// In en, this message translates to:
  /// **'Methodology'**
  String get methodology;

  /// No description provided for @methodologyShort.
  ///
  /// In en, this message translates to:
  /// **'Sources, limits and guidance'**
  String get methodologyShort;

  /// No description provided for @methodologyTitle.
  ///
  /// In en, this message translates to:
  /// **'How we work'**
  String get methodologyTitle;

  /// No description provided for @methodologyBody.
  ///
  /// In en, this message translates to:
  /// **'Positions are drawn from recognized manuals of the five madhhabs. Each topic cites sources (Quran, hadith, books) with authenticity grades when available. This app does not replace a qualified scholar for your personal case.'**
  String get methodologyBody;

  /// No description provided for @methodologySources.
  ///
  /// In en, this message translates to:
  /// **'Sources and authenticity'**
  String get methodologySources;

  /// No description provided for @methodologySourcesBody.
  ///
  /// In en, this message translates to:
  /// **'Hadiths are graded (sahih, hasan, daif, mawdu) when information is available. References allow verifying the original text.'**
  String get methodologySourcesBody;

  /// No description provided for @askScholar.
  ///
  /// In en, this message translates to:
  /// **'Ask a scholar'**
  String get askScholar;

  /// No description provided for @askScholarDesc.
  ///
  /// In en, this message translates to:
  /// **'For a personal fatwa, use a recognized platform:'**
  String get askScholarDesc;

  /// No description provided for @disclaimerGeneral.
  ///
  /// In en, this message translates to:
  /// **'This app is educational. For complex cases (inheritance, divorce, finance), always consult a competent scholar.'**
  String get disclaimerGeneral;

  /// No description provided for @sensitiveTopicDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Sensitive topic — rules vary by situation. Consult a scholar before any decision.'**
  String get sensitiveTopicDisclaimer;

  /// No description provided for @sourceReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get sourceReference;

  /// No description provided for @skillTree.
  ///
  /// In en, this message translates to:
  /// **'Skill tree'**
  String get skillTree;

  /// No description provided for @skillProgress.
  ///
  /// In en, this message translates to:
  /// **'{read}/{total} topics'**
  String skillProgress(int read, int total);

  /// No description provided for @srsMode.
  ///
  /// In en, this message translates to:
  /// **'Spaced repetition (due cards)'**
  String get srsMode;

  /// No description provided for @examMode.
  ///
  /// In en, this message translates to:
  /// **'Exam mode'**
  String get examMode;

  /// No description provided for @examModeDesc.
  ///
  /// In en, this message translates to:
  /// **'No instant feedback — results at the end'**
  String get examModeDesc;

  /// No description provided for @consensusOnly.
  ///
  /// In en, this message translates to:
  /// **'Consensus only'**
  String get consensusOnly;

  /// No description provided for @noConsensusFound.
  ///
  /// In en, this message translates to:
  /// **'No consensus found between schools'**
  String get noConsensusFound;

  /// No description provided for @scenarioFinder.
  ///
  /// In en, this message translates to:
  /// **'Find a scenario'**
  String get scenarioFinder;

  /// No description provided for @scenarioFinderDesc.
  ///
  /// In en, this message translates to:
  /// **'Describe your situation to find a practical case'**
  String get scenarioFinderDesc;

  /// No description provided for @scenarioFinderHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. fasting, travel, marriage…'**
  String get scenarioFinderHint;

  /// No description provided for @noScenariosFound.
  ///
  /// In en, this message translates to:
  /// **'No scenarios found'**
  String get noScenariosFound;

  /// No description provided for @exportCertificate.
  ///
  /// In en, this message translates to:
  /// **'Export certificate'**
  String get exportCertificate;

  /// No description provided for @certificateTitle.
  ///
  /// In en, this message translates to:
  /// **'Course certificate'**
  String get certificateTitle;

  /// No description provided for @certificateDate.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get certificateDate;

  /// No description provided for @situationAdvisor.
  ///
  /// In en, this message translates to:
  /// **'Situation advisor'**
  String get situationAdvisor;

  /// No description provided for @situationAdvisorDesc.
  ///
  /// In en, this message translates to:
  /// **'Describe your case — suggested topics and scenarios'**
  String get situationAdvisorDesc;

  /// No description provided for @situationAdvisorHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. I travel by plane during Ramadan and…'**
  String get situationAdvisorHint;

  /// No description provided for @situationAdvisorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Describe your situation to get suggestions'**
  String get situationAdvisorEmpty;

  /// No description provided for @analyzeSituation.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get analyzeSituation;

  /// No description provided for @noSituationMatches.
  ///
  /// In en, this message translates to:
  /// **'No suggestions — try other keywords'**
  String get noSituationMatches;

  /// No description provided for @encyclopediaExam.
  ///
  /// In en, this message translates to:
  /// **'Encyclopedia exam'**
  String get encyclopediaExam;

  /// No description provided for @encyclopediaExamDesc.
  ///
  /// In en, this message translates to:
  /// **'10 topics, timer, self-assessment'**
  String get encyclopediaExamDesc;

  /// No description provided for @examTopicPrompt.
  ///
  /// In en, this message translates to:
  /// **'Do you know this topic?'**
  String get examTopicPrompt;

  /// No description provided for @revealAnswer.
  ///
  /// In en, this message translates to:
  /// **'Reveal summary'**
  String get revealAnswer;

  /// No description provided for @readFullTopic.
  ///
  /// In en, this message translates to:
  /// **'Read full topic'**
  String get readFullTopic;

  /// No description provided for @needStudy.
  ///
  /// In en, this message translates to:
  /// **'Need study'**
  String get needStudy;

  /// No description provided for @examResults.
  ///
  /// In en, this message translates to:
  /// **'Exam results'**
  String get examResults;

  /// No description provided for @examKnownCount.
  ///
  /// In en, this message translates to:
  /// **'{known} / {total} mastered'**
  String examKnownCount(int known, int total);

  /// No description provided for @noExamTopics.
  ///
  /// In en, this message translates to:
  /// **'Not enough topics for the exam'**
  String get noExamTopics;

  /// No description provided for @exportComparisonPdf.
  ///
  /// In en, this message translates to:
  /// **'Export comparison as PDF'**
  String get exportComparisonPdf;

  /// No description provided for @encryptedSync.
  ///
  /// In en, this message translates to:
  /// **'Encrypted sync'**
  String get encryptedSync;

  /// No description provided for @encryptedSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'AES backup for iCloud, Drive, etc.'**
  String get encryptedSyncDesc;

  /// No description provided for @exportEncryptedBackup.
  ///
  /// In en, this message translates to:
  /// **'Export encrypted backup'**
  String get exportEncryptedBackup;

  /// No description provided for @importEncryptedBackup.
  ///
  /// In en, this message translates to:
  /// **'Import encrypted backup'**
  String get importEncryptedBackup;

  /// No description provided for @enterPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get enterPassphrase;

  /// No description provided for @passphrase.
  ///
  /// In en, this message translates to:
  /// **'Password (8+ chars)'**
  String get passphrase;

  /// No description provided for @confirmPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmPassphrase;

  /// No description provided for @encryptedSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed — check your passphrase'**
  String get encryptedSyncFailed;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @homeWidgetDescIos.
  ///
  /// In en, this message translates to:
  /// **'iOS & Android widget — add Daily Topic from home screen'**
  String get homeWidgetDescIos;

  /// No description provided for @verifiedContent.
  ///
  /// In en, this message translates to:
  /// **'Verified content'**
  String get verifiedContent;

  /// No description provided for @isnadChain.
  ///
  /// In en, this message translates to:
  /// **'Chain of transmission (isnād)'**
  String get isnadChain;

  /// No description provided for @disclaimerHomeBanner.
  ///
  /// In en, this message translates to:
  /// **'Educational tool — does not replace a scholar\'s ruling. See methodology.'**
  String get disclaimerHomeBanner;

  /// No description provided for @liteMode.
  ///
  /// In en, this message translates to:
  /// **'Lite mode'**
  String get liteMode;

  /// No description provided for @liteModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Reduces animations for slower devices or accessibility'**
  String get liteModeDesc;

  /// No description provided for @globalMadhhabFilter.
  ///
  /// In en, this message translates to:
  /// **'Global madhhab filter'**
  String get globalMadhhabFilter;

  /// No description provided for @globalMadhhabFilterDesc.
  ///
  /// In en, this message translates to:
  /// **'Hide topics without a position from your preferred school'**
  String get globalMadhhabFilterDesc;

  /// No description provided for @ijmaSection.
  ///
  /// In en, this message translates to:
  /// **'Consensus (ijmāʿ)'**
  String get ijmaSection;

  /// No description provided for @ijmaSectionDesc.
  ///
  /// In en, this message translates to:
  /// **'The four main Sunni schools agree on this point.'**
  String get ijmaSectionDesc;

  /// No description provided for @divergenceTimeline.
  ///
  /// In en, this message translates to:
  /// **'Divergence timeline'**
  String get divergenceTimeline;

  /// No description provided for @contextualShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get contextualShortcuts;

  /// No description provided for @shortcutZakat.
  ///
  /// In en, this message translates to:
  /// **'Zakat calculator'**
  String get shortcutZakat;
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
