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

  @override
  String get mediaLibrary => 'Media Library';

  @override
  String get comparisonTable => 'Comparative table of schools';

  @override
  String get schoolTitle => 'School';

  @override
  String get legalOpinion => 'Legal Opinion';

  @override
  String get mediaSectionTitle => 'Media and Illustrations';

  @override
  String get illustration => 'Illustration';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get close => 'Close';

  @override
  String get hajjSteps => 'Steps of the Pilgrimage (Hajj)';

  @override
  String get noMediaFound => 'No media found.';

  @override
  String get languageEn => 'English';

  @override
  String get languageFr => 'French';

  @override
  String get languageAr => 'Arabic';

  @override
  String get languageRu => 'Russian';

  @override
  String get languageZh => 'Chinese';

  @override
  String get hajjStep1Desc => 'Entering the state of Ihram.';

  @override
  String get hajjStep2Desc => 'Departure for Mina on the 8th of Dhul-Hijjah.';

  @override
  String get hajjStep3Desc => 'Day of Arafat (The climax of Hajj).';

  @override
  String get hajjStep4Desc => 'Collecting pebbles at Muzdalifah.';

  @override
  String get hajjStep5Desc => 'Stoning the pillars at Mina.';

  @override
  String get hajjStep6Desc => 'Tawaf and Sa\'y at Mecca.';

  @override
  String get hajjStep7Desc => 'Sacrifice and end of Hajj rituals.';

  @override
  String get relatedTopics => 'Related Topics';

  @override
  String get filterBySchool => 'Filter by School';

  @override
  String get filterByCategory => 'Filter by Category';

  @override
  String get dailyTopic => 'Topic of the Day';

  @override
  String get readMore => 'Read more →';

  @override
  String get myLibrary => 'My Library';

  @override
  String get favorites => 'Favorites';

  @override
  String get readingHistory => 'History';

  @override
  String get noFavorites =>
      'No favorites yet. Tap the heart on a topic to save it here.';

  @override
  String get noHistory =>
      'No reading history yet. Explore topics to see them here.';

  @override
  String topicsExplored(int read, int total) {
    return '$read topics explored out of $total';
  }

  @override
  String get learnHub => 'Learn';

  @override
  String get learnHubSubtitle =>
      'Review with flashcards and test your knowledge with quizzes.';

  @override
  String get flashcards => 'Flashcards';

  @override
  String cardCount(int count) {
    return '$count cards';
  }

  @override
  String get quiz => 'Quiz';

  @override
  String get quizGeneral => 'General Fiqh Quiz';

  @override
  String quizQuestionCount(int count) {
    return '$count questions';
  }

  @override
  String get question => 'Question';

  @override
  String get answer => 'Answer';

  @override
  String get tapToFlip => 'Tap the card to flip';

  @override
  String get reviewAgain => 'Review';

  @override
  String get knewIt => 'Got it';

  @override
  String get finish => 'Finish';

  @override
  String get deckComplete => 'Deck complete!';

  @override
  String deckCompleteMessage(int count) {
    return 'You reviewed all $count cards.';
  }

  @override
  String get quizResults => 'Quiz Results';

  @override
  String quizScore(int score, int total) {
    return '$score / $total correct';
  }

  @override
  String get quizPassed => 'Well done! You earned the Quiz Master badge.';

  @override
  String get quizTryAgain => 'Keep studying — you can do better!';

  @override
  String get nextQuestion => 'Next question';

  @override
  String get share => 'Share';

  @override
  String get badges => 'Badges';

  @override
  String badgesProgress(int unlocked, int total) {
    return '$unlocked / $total badges unlocked';
  }

  @override
  String get guidedCourses => 'Guided Courses';

  @override
  String get guidedCoursesDesc =>
      'Structured 7-day paths to learn step by step.';

  @override
  String courseProgress(int done, int total) {
    return '$done / $total days completed';
  }

  @override
  String courseCount(int count) {
    return '$count course(s) available';
  }

  @override
  String get courseComplete =>
      'Course completed! You earned the Graduate badge.';

  @override
  String get tools => 'Tools';

  @override
  String get zakatCalculator => 'Zakat Calculator';

  @override
  String get zakatCalculatorShort => 'Estimate your zakat based on nisab';

  @override
  String get zakatCalculatorDesc =>
      'Enter your wealth to check if you reach nisab (85g gold) and calculate 2.5% zakat.';

  @override
  String get goldGrams => 'Gold (grams)';

  @override
  String get goldGramsHint => 'e.g. 50';

  @override
  String get silverGrams => 'Silver (grams)';

  @override
  String get silverGramsHint => 'e.g. 200';

  @override
  String get cashAmount => 'Cash & savings';

  @override
  String get cashAmountHint => 'e.g. 5000';

  @override
  String get goldPricePerGram => 'Gold price per gram';

  @override
  String get goldPriceHint => 'Local currency';

  @override
  String get calculateZakat => 'Calculate';

  @override
  String zakatDue(String amount) {
    return 'Zakat due: $amount';
  }

  @override
  String get belowNisab => 'Below nisab — no zakat due';

  @override
  String zakatCalcDetail(
    String gold,
    String silver,
    String cash,
    String nisab,
  ) {
    return 'Gold: ${gold}g · Silver: ${silver}g · Cash: $cash · Nisab ≈ $nisab';
  }

  @override
  String get zakatRateNote => 'Rate: 2.5% after one lunar year of possession.';

  @override
  String get learnMoreZakat => 'Learn more about Zakat';

  @override
  String get zakatTopicHint => 'Open the Nisab topic';

  @override
  String get seasonRamadan => 'Ramadan Season';

  @override
  String get seasonRamadanDesc => 'Featured topics for fasting and worship';

  @override
  String get seasonHajj => 'Hajj Season';

  @override
  String get seasonHajjDesc => 'Featured topics for pilgrimage';

  @override
  String get listenQuran => 'Listen to verse';

  @override
  String get settings => 'Settings';

  @override
  String get hijriDate => 'Hijri date';

  @override
  String get languageSetting => 'Language';

  @override
  String get themeSetting => 'Theme';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get about => 'About';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get seasonShaaban => 'Sha\'ban — Prepare for Ramadan';

  @override
  String get seasonShaabanDesc =>
      'Featured topics to prepare for the holy month';

  @override
  String get allSchools => 'All schools';

  @override
  String get allCategories => 'All categories';

  @override
  String get applyFilters => 'Apply';

  @override
  String get dashboard => 'Dashboard';

  @override
  String explorationLevel(int percent) {
    return 'Exploration: $percent%';
  }

  @override
  String coursesCompleted(int done, int total) {
    return '$done courses of $total';
  }

  @override
  String get courseProgressTitle => 'Course progress';

  @override
  String get exportLibrary => 'Export library';

  @override
  String get onboardingTitle1 => 'Offline fiqh encyclopedia';

  @override
  String get onboardingDesc1 =>
      'Browse hundreds of Islamic legal topics, organized by category and school.';

  @override
  String get onboardingTitle2 => 'Learn by doing';

  @override
  String get onboardingDesc2 =>
      'Flashcards, quizzes, guided courses and badges to reinforce your knowledge.';

  @override
  String get onboardingTitle3 => 'Track your progress';

  @override
  String get onboardingDesc3 =>
      'Favorites, personal notes and a dashboard to follow your journey.';

  @override
  String get getStarted => 'Get started';

  @override
  String get skip => 'Skip';

  @override
  String get myMadhhab => 'My madhhab';

  @override
  String get myMadhhabDesc => 'Highlight your preferred school in topic pages';

  @override
  String get myMadhhabLabel => 'My school';

  @override
  String get noSchoolPreference => 'No preference';

  @override
  String get dailyReminder => 'Daily topic reminder';

  @override
  String get dailyReminderDesc =>
      'Show a reminder on home until today\'s topic is read';

  @override
  String get dailyReminderBanner => 'Today\'s topic — read it today';

  @override
  String get practicalCases => 'Practical cases';

  @override
  String get practicalCasesDesc =>
      '\"What if…?\" scenarios with school positions';

  @override
  String get caseCompleted => 'Completed';

  @override
  String get casePending => 'To solve';

  @override
  String get chooseAnswer => 'Choose an answer';

  @override
  String get checkAnswer => 'Check';

  @override
  String get correctAnswer => 'Correct!';

  @override
  String get wrongAnswer => 'Not quite — here\'s the explanation';

  @override
  String get finishCase => 'Finish case';

  @override
  String get schoolPositions => 'School positions';

  @override
  String readingStreak(int days) {
    return '$days day streak';
  }

  @override
  String get readingStreakDesc => 'You\'re reading regularly — keep it up!';

  @override
  String get suggestedTopic => 'Suggested for you';

  @override
  String get homeWidget => 'Home screen widget';

  @override
  String get homeWidgetDesc =>
      'Add the Daily Topic widget from your Android widget menu';

  @override
  String get pushNotificationTitle => 'Daily topic';

  @override
  String get exportAsText => 'Export as text';

  @override
  String get exportAsPdf => 'Export as PDF';

  @override
  String get noneLabel => '(none)';

  @override
  String get backupData => 'Data backup';

  @override
  String get backupDataDesc =>
      'Favorites, notes, progress, badges and settings';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get importBackup => 'Restore backup';

  @override
  String get backupRestored => 'Backup restored successfully';

  @override
  String get backupFailed => 'Restore failed';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearRecentSearches => 'Clear';

  @override
  String get zenMode => 'Zen reading mode';

  @override
  String get readAloud => 'Read aloud';

  @override
  String get increaseFont => 'Increase font size';

  @override
  String get decreaseFont => 'Decrease font size';

  @override
  String get compareSchools => 'Compare schools';

  @override
  String get compareHubDesc => 'Topics with positions from multiple madhhabs';

  @override
  String get noComparisonAvailable => 'No comparison available';

  @override
  String get fullComparison => 'Full comparison';
}
