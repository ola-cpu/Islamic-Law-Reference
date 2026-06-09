import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:islamic_law_reference/models/badge.dart';
import 'package:islamic_law_reference/providers/user_provider.dart';
import 'package:islamic_law_reference/services/database_helper.dart';
import 'package:islamic_law_reference/services/preferences_service.dart';
import 'package:islamic_law_reference/services/backup_service.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    DatabaseHelper.setTestDatabaseName('test_provider_${DateTime.now().microsecondsSinceEpoch}.db');
  });

  tearDown(() async {
    await DatabaseHelper().closeForTesting();
  });

  test('UserProvider persists locale', () async {
    final provider = UserProvider();
    await provider.init();
    expect(provider.locale.languageCode, 'fr');

    await provider.setLocale(const Locale('en'));
    expect(provider.locale.languageCode, 'en');

    final prefs = PreferencesService.instance;
    await prefs.init();
    expect(prefs.getLocale()?.languageCode, 'en');
  });

  test('UserProvider tracks reading history', () async {
    final provider = UserProvider();
    await provider.init();

    await provider.recordTopicRead(1);
    await provider.recordTopicRead(2);
    await provider.recordTopicRead(1);

    expect(provider.readingHistoryIds.first, 1);
    expect(provider.readingHistoryIds.length, 2);
    expect(provider.uniqueTopicsRead, 2);
  });

  test('UserProvider toggles favorites', () async {
    final provider = UserProvider();
    await provider.init();

    expect(provider.isFavorite(1), false);
    await provider.toggleFavorite(1);
    expect(provider.isFavorite(1), true);
    await provider.toggleFavorite(1);
    expect(provider.isFavorite(1), false);
  });

  test('UserProvider persists theme mode', () async {
    final provider = UserProvider();
    await provider.init();

    await provider.setThemeMode(ThemeMode.dark);
    expect(provider.themeMode, ThemeMode.dark);

    final prefs = PreferencesService.instance;
    await prefs.init();
    expect(prefs.getThemeMode(), ThemeMode.dark);
  });

  test('UserProvider persists preferred school', () async {
    final provider = UserProvider();
    await provider.init();

    await provider.setPreferredSchool('hanafi');
    expect(provider.preferredSchool, 'hanafi');

    final prefs = PreferencesService.instance;
    await prefs.init();
    expect(prefs.getPreferredSchool(), 'hanafi');
  });

  test('UserProvider tracks reading streak', () async {
    final provider = UserProvider();
    await provider.init();

    await provider.recordTopicRead(1);
    expect(provider.readingStreak, greaterThanOrEqualTo(1));
  });

  test('BackupService roundtrip restores favorites', () async {
    final provider = UserProvider();
    await provider.init();

    await provider.toggleFavorite(1);
    await provider.addNote(2, 'Ma note test');
    final json = BackupService.buildBackupJson(provider);

    await provider.toggleFavorite(1);
    await provider.addNote(2, '');

    final result = await BackupService.restoreFromJson(json, provider);
    expect(result.ok, true, reason: result.error);
    expect(provider.isFavorite(1), true);
    expect(provider.getNote(2), 'Ma note test');
  });

  test('UserProvider unlocks badges', () async {
    final provider = UserProvider();
    await provider.init();

    expect(provider.hasBadge(BadgeId.sharer), false);
    await provider.recordShare();
    expect(provider.hasBadge(BadgeId.sharer), true);

    await provider.recordQuizScore(80);
    expect(provider.hasBadge(BadgeId.quizMaster), true);
  });
}
