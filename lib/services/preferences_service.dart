import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingHistoryEntry {
  final int topicId;
  final DateTime readAt;

  ReadingHistoryEntry({required this.topicId, required this.readAt});

  Map<String, dynamic> toJson() => {
        'topicId': topicId,
        'readAt': readAt.toIso8601String(),
      };

  factory ReadingHistoryEntry.fromJson(Map<String, dynamic> json) {
    return ReadingHistoryEntry(
      topicId: json['topicId'] as int,
      readAt: DateTime.parse(json['readAt'] as String),
    );
  }
}

class PreferencesService {
  static final PreferencesService instance = PreferencesService._();
  PreferencesService._();

  static const _localeKey = 'locale_code';
  static const _historyKey = 'reading_history';
  static const _badgesKey = 'unlocked_badges';
  static const _courseProgressKey = 'course_progress';
  static const _themeModeKey = 'theme_mode';
  static const _onboardingKey = 'onboarding_done';
  static const _preferredSchoolKey = 'preferred_school';
  static const _dailyReminderKey = 'daily_reminder';
  static const _lastDailyTopicDateKey = 'last_daily_topic_date';
  static const _topicLocalesKey = 'topic_locales';
  static const _practicalCasesKey = 'practical_cases_done';
  static const _readingStreakKey = 'reading_streak';
  static const _lastStreakDateKey = 'last_streak_date';
  static const _recentSearchesKey = 'recent_searches';
  static const _zenFontScaleKey = 'zen_font_scale';
  static const _maxHistory = 20;
  static const _maxRecentSearches = 8;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Locale? getLocale() {
    final code = _prefs?.getString(_localeKey);
    if (code == null) return null;
    return Locale(code);
  }

  Future<void> saveLocale(Locale locale) async {
    await _prefs?.setString(_localeKey, locale.languageCode);
  }

  List<ReadingHistoryEntry> getReadingHistory() {
    final raw = _prefs?.getString(_historyKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ReadingHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<ReadingHistoryEntry>> addToReadingHistory(int topicId) async {
    final history = getReadingHistory()
      ..removeWhere((e) => e.topicId == topicId);
    history.insert(0, ReadingHistoryEntry(topicId: topicId, readAt: DateTime.now()));
    if (history.length > _maxHistory) {
      history.removeRange(_maxHistory, history.length);
    }
    await _prefs?.setString(
      _historyKey,
      jsonEncode(history.map((e) => e.toJson()).toList()),
    );
    return history;
  }

  Set<String> getUnlockedBadges() {
    return _prefs?.getStringList(_badgesKey)?.toSet() ?? {};
  }

  Future<Set<String>> unlockBadge(String badgeKey) async {
    final badges = getUnlockedBadges()..add(badgeKey);
    await _prefs?.setStringList(_badgesKey, badges.toList());
    return badges;
  }

  Map<String, List<int>> getCourseProgress() {
    final raw = _prefs?.getString(_courseProgressKey);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, (v as List<dynamic>).cast<int>()));
    } catch (_) {
      return {};
    }
  }

  Future<Map<String, List<int>>> markCourseDay(String courseId, int dayIndex) async {
    final progress = getCourseProgress();
    final days = List<int>.from(progress[courseId] ?? []);
    if (!days.contains(dayIndex)) days.add(dayIndex);
    days.sort();
    progress[courseId] = days;
    await _prefs?.setString(_courseProgressKey, jsonEncode(progress));
    return progress;
  }

  ThemeMode getThemeMode() {
    final value = _prefs?.getString(_themeModeKey);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs?.setString(_themeModeKey, value);
  }

  bool hasCompletedOnboarding() => _prefs?.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingComplete() async {
    await _prefs?.setBool(_onboardingKey, true);
  }

  String? getPreferredSchool() => _prefs?.getString(_preferredSchoolKey);

  Future<void> savePreferredSchool(String? slug) async {
    if (slug == null) {
      await _prefs?.remove(_preferredSchoolKey);
    } else {
      await _prefs?.setString(_preferredSchoolKey, slug);
    }
  }

  bool getDailyReminderEnabled() => _prefs?.getBool(_dailyReminderKey) ?? false;

  Future<void> setDailyReminderEnabled(bool enabled) async {
    await _prefs?.setBool(_dailyReminderKey, enabled);
  }

  bool hasReadDailyTopicToday() {
    final saved = _prefs?.getString(_lastDailyTopicDateKey);
    if (saved == null) return false;
    final today = _dateKey(DateTime.now());
    return saved == today;
  }

  Future<void> markDailyTopicReadToday() async {
    await _prefs?.setString(_lastDailyTopicDateKey, _dateKey(DateTime.now()));
  }

  String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  Map<int, Set<String>> getTopicLocales() {
    final raw = _prefs?.getString(_topicLocalesKey);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(int.parse(k), (v as List<dynamic>).cast<String>().toSet()));
    } catch (_) {
      return {};
    }
  }

  Future<Map<int, Set<String>>> recordTopicLocale(int topicId, String localeCode) async {
    final map = getTopicLocales();
    final locales = Set<String>.from(map[topicId] ?? {})..add(localeCode);
    map[topicId] = locales;
    final encoded = map.map((k, v) => MapEntry(k.toString(), v.toList()));
    await _prefs?.setString(_topicLocalesKey, jsonEncode(encoded));
    return map;
  }

  bool hasPolyglotReading() {
    return getTopicLocales().values.any((locales) => locales.length >= 2);
  }

  Set<String> getCompletedPracticalCases() {
    return _prefs?.getStringList(_practicalCasesKey)?.toSet() ?? {};
  }

  Future<Set<String>> markPracticalCaseCompleted(String caseId) async {
    final done = getCompletedPracticalCases()..add(caseId);
    await _prefs?.setStringList(_practicalCasesKey, done.toList());
    return done;
  }

  int getReadingStreak() => _prefs?.getInt(_readingStreakKey) ?? 0;

  Future<int> updateReadingStreak() async {
    final today = _dateKey(DateTime.now());
    final last = _prefs?.getString(_lastStreakDateKey);
    final current = getReadingStreak();

    if (last == today) return current;

    final yesterday = _dateKey(DateTime.now().subtract(const Duration(days: 1)));
    final newStreak = last == yesterday ? current + 1 : 1;

    await _prefs?.setInt(_readingStreakKey, newStreak);
    await _prefs?.setString(_lastStreakDateKey, today);
    return newStreak;
  }

  List<String> getRecentSearches() {
    return _prefs?.getStringList(_recentSearchesKey) ?? [];
  }

  Future<List<String>> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return getRecentSearches();
    final list = getRecentSearches()..remove(trimmed);
    list.insert(0, trimmed);
    if (list.length > _maxRecentSearches) list.removeRange(_maxRecentSearches, list.length);
    await _prefs?.setStringList(_recentSearchesKey, list);
    return list;
  }

  Future<void> clearRecentSearches() async {
    await _prefs?.remove(_recentSearchesKey);
  }

  double getZenFontScale() => _prefs?.getDouble(_zenFontScaleKey) ?? 1.0;

  Future<void> saveZenFontScale(double scale) async {
    await _prefs?.setDouble(_zenFontScaleKey, scale);
  }

  Future<void> restoreUserData({
    String? localeCode,
    String? themeMode,
    String? preferredSchool,
    bool clearPreferredSchool = false,
    bool? dailyReminder,
    List<String>? badges,
    Map<String, List<int>>? courseProgress,
    List<String>? practicalCases,
    List<ReadingHistoryEntry>? readingHistory,
    int? readingStreak,
  }) async {
    if (localeCode != null) await saveLocale(Locale(localeCode));
    if (themeMode != null) {
      final mode = switch (themeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
      await saveThemeMode(mode);
    }
    if (clearPreferredSchool) {
      await savePreferredSchool(null);
    } else if (preferredSchool != null && preferredSchool.isNotEmpty) {
      await savePreferredSchool(preferredSchool);
    }
    if (dailyReminder != null) await setDailyReminderEnabled(dailyReminder);
    if (badges != null) await _prefs?.setStringList(_badgesKey, badges);
    if (courseProgress != null) {
      await _prefs?.setString(_courseProgressKey, jsonEncode(courseProgress));
    }
    if (practicalCases != null) {
      await _prefs?.setStringList(_practicalCasesKey, practicalCases);
    }
    if (readingHistory != null) {
      await _prefs?.setString(
        _historyKey,
        jsonEncode(readingHistory.map((e) => e.toJson()).toList()),
      );
    }
    if (readingStreak != null) {
      await _prefs?.setInt(_readingStreakKey, readingStreak);
    }
  }
}
