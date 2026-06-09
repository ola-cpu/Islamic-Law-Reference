import 'package:flutter/material.dart';
import '../models/badge.dart';
import '../models/topic.dart';
import '../services/database_helper.dart';
import '../services/preferences_service.dart';
import '../services/notification_service.dart';

class UserProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final PreferencesService _prefs = PreferencesService.instance;

  List<int> _favorites = [];
  Map<int, String> _notes = {};
  List<ReadingHistoryEntry> _readingHistory = [];
  Set<String> _unlockedBadges = {};
  Map<String, List<int>> _courseProgress = {};
  Locale _locale = const Locale('fr');
  ThemeMode _themeMode = ThemeMode.system;
  bool _onboardingDone = false;
  String? _preferredSchool;
  bool _dailyReminder = false;
  Set<String> _practicalCasesDone = {};
  int _readingStreak = 0;
  double _zenFontScale = 1.0;
  bool _initialized = false;

  List<int> get favorites => List.unmodifiable(_favorites);
  Map<int, String> get notes => Map.unmodifiable(_notes);
  List<ReadingHistoryEntry> get readingHistory => List.unmodifiable(_readingHistory);
  List<int> get readingHistoryIds => _readingHistory.map((e) => e.topicId).toList();
  int get uniqueTopicsRead => _readingHistory.map((e) => e.topicId).toSet().length;
  Set<String> get unlockedBadgeKeys => Set.unmodifiable(_unlockedBadges);
  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get hasCompletedOnboarding => _onboardingDone;
  String? get preferredSchool => _preferredSchool;
  bool get dailyReminderEnabled => _dailyReminder;
  bool get hasReadDailyTopicToday => _prefs.hasReadDailyTopicToday();
  int get readingStreak => _readingStreak;
  double get zenFontScale => _zenFontScale;
  Map<String, List<int>> get courseProgressMap => Map.unmodifiable(_courseProgress);
  bool get isInitialized => _initialized;
  List<String> get recentSearches => _prefs.getRecentSearches();

  bool isPracticalCaseCompleted(String caseId) => _practicalCasesDone.contains(caseId);

  bool hasBadge(BadgeId id) => _unlockedBadges.contains(id.key);

  List<int> getCourseCompletedDays(String courseId) =>
      List.unmodifiable(_courseProgress[courseId] ?? []);

  Future<void> init() async {
    await _prefs.init();
    final savedLocale = _prefs.getLocale();
    if (savedLocale != null) _locale = savedLocale;
    _themeMode = _prefs.getThemeMode();
    _onboardingDone = _prefs.hasCompletedOnboarding();
    _preferredSchool = _prefs.getPreferredSchool();
    _dailyReminder = _prefs.getDailyReminderEnabled();
    _practicalCasesDone = _prefs.getCompletedPracticalCases();
    _readingStreak = _prefs.getReadingStreak();
    _zenFontScale = _prefs.getZenFontScale();
    _favorites = await _dbHelper.getFavorites();
    _notes = await _dbHelper.getAllNotes();
    _readingHistory = _prefs.getReadingHistory();
    _unlockedBadges = _prefs.getUnlockedBadges();
    _courseProgress = _prefs.getCourseProgress();
    await _checkExplorerBadges();
    _initialized = true;
    notifyListeners();
  }

  Future<Topic?> resolveTopicByTitle(String titleFr) async {
    return _dbHelper.getTopicByTitle(titleFr, locale: _locale);
  }

  Future<void> reloadFromStorage() async {
    _favorites = await _dbHelper.getFavorites();
    _notes = await _dbHelper.getAllNotes();
    _readingHistory = _prefs.getReadingHistory();
    _unlockedBadges = _prefs.getUnlockedBadges();
    _courseProgress = _prefs.getCourseProgress();
    _practicalCasesDone = _prefs.getCompletedPracticalCases();
    _readingStreak = _prefs.getReadingStreak();
    final savedLocale = _prefs.getLocale();
    if (savedLocale != null) _locale = savedLocale;
    _themeMode = _prefs.getThemeMode();
    _preferredSchool = _prefs.getPreferredSchool();
    _dailyReminder = _prefs.getDailyReminderEnabled();
    try {
      await syncDailyReminder();
    } catch (_) {
      // Notifications indisponibles (tests, web).
    }
    notifyListeners();
  }

  Future<void> recordRecentSearch(String query) async {
    await _prefs.addRecentSearch(query);
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    await _prefs.clearRecentSearches();
    notifyListeners();
  }

  Future<void> setZenFontScale(double scale) async {
    _zenFontScale = scale;
    await _prefs.saveZenFontScale(scale);
    notifyListeners();
  }

  Future<void> recordZenModeUsed() async {
    await unlockBadge(BadgeId.zenReader);
  }

  Future<void> completeOnboarding() async {
    await _prefs.setOnboardingComplete();
    _onboardingDone = true;
    notifyListeners();
  }

  Future<void> setPreferredSchool(String? slug) async {
    _preferredSchool = slug;
    await _prefs.savePreferredSchool(slug);
    notifyListeners();
  }

  Future<void> setDailyReminderEnabled(bool enabled) async {
    _dailyReminder = enabled;
    await _prefs.setDailyReminderEnabled(enabled);
    await syncDailyReminder();
    notifyListeners();
  }

  Future<void> syncDailyReminder() async {
    if (!_dailyReminder) {
      await NotificationService.instance.cancelDailyReminder();
      return;
    }
    final topic = await _dbHelper.getDailyTopic(locale: _locale);
    if (topic == null) return;
    await NotificationService.instance.scheduleDailyReminder(
      title: 'Islamic Law Reference',
      body: topic.title,
    );
  }

  Future<void> markDailyTopicRead() async {
    await _prefs.markDailyTopicReadToday();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _prefs.saveThemeMode(mode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale != locale) {
      _locale = locale;
      await _prefs.saveLocale(locale);
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int topicId) async {
    if (_favorites.contains(topicId)) {
      _favorites.remove(topicId);
      await _dbHelper.removeFavorite(topicId);
    } else {
      _favorites.add(topicId);
      await _dbHelper.addFavorite(topicId);
    }
    notifyListeners();
  }

  bool isFavorite(int topicId) => _favorites.contains(topicId);

  Future<void> addNote(int topicId, String note) async {
    _notes[topicId] = note;
    await _dbHelper.saveNote(topicId, note);
    notifyListeners();
  }

  String? getNote(int topicId) => _notes[topicId];

  Future<void> recordTopicRead(int topicId) async {
    _readingHistory = await _prefs.addToReadingHistory(topicId);
    await _prefs.recordTopicLocale(topicId, _locale.languageCode);
    _readingStreak = await _prefs.updateReadingStreak();
    if (_readingStreak >= 7) await unlockBadge(BadgeId.streakKeeper);
    if (_prefs.hasPolyglotReading()) await unlockBadge(BadgeId.polyglot);
    await _checkExplorerBadges();
    notifyListeners();
  }

  Future<void> recordPracticalCaseCompleted(String caseId) async {
    _practicalCasesDone = await _prefs.markPracticalCaseCompleted(caseId);
    if (_practicalCasesDone.length >= 3) await unlockBadge(BadgeId.caseSolver);
    notifyListeners();
  }

  Future<void> unlockBadge(BadgeId badge) async {
    if (_unlockedBadges.contains(badge.key)) return;
    _unlockedBadges = await _prefs.unlockBadge(badge.key);
    notifyListeners();
  }

  Future<void> recordComparisonViewed() async {
    await unlockBadge(BadgeId.comparer);
  }

  Future<void> recordShare() async {
    await unlockBadge(BadgeId.sharer);
  }

  Future<void> recordFlashcardDeckCompleted() async {
    await unlockBadge(BadgeId.flashcardPro);
  }

  Future<void> recordQuizScore(int percent) async {
    if (percent >= 70) await unlockBadge(BadgeId.quizMaster);
  }

  Future<void> markCourseDayComplete(String courseId, int dayIndex, {required int totalDays}) async {
    _courseProgress = await _prefs.markCourseDay(courseId, dayIndex);
    final days = _courseProgress[courseId] ?? [];
    if (days.length >= totalDays) {
      if (courseId == 'prayer_basics') await unlockBadge(BadgeId.courseGraduate);
      if (courseId == 'ramadan_fasting') await unlockBadge(BadgeId.ramadanScholar);
      if (courseId == 'marriage_basics') await unlockBadge(BadgeId.marriageExpert);
      if (courseId == 'zakat_finance') await unlockBadge(BadgeId.zakatExpert);
      if (courseId == 'purification_basics') await unlockBadge(BadgeId.purificationGuide);
      if (courseId == 'ethics_basics') await unlockBadge(BadgeId.ethicsScholar);
      if (courseId == 'inheritance_basics') await unlockBadge(BadgeId.inheritanceExpert);
    }
    notifyListeners();
  }

  Future<Topic?> getSuggestedTopic() async {
    final readIds = _readingHistory.map((e) => e.topicId).toSet();
    return _dbHelper.getSuggestedTopic(readIds, locale: _locale);
  }

  Future<void> _checkExplorerBadges() async {
    final count = uniqueTopicsRead;
    if (count >= 5) await unlockBadge(BadgeId.explorer);
    if (count >= 10) await unlockBadge(BadgeId.scholar);
    if (count >= 50) await unlockBadge(BadgeId.halfCentury);
    if (count >= 100) await unlockBadge(BadgeId.centuryReader);
  }
}
