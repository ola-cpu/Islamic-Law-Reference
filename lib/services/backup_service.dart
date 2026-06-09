import 'dart:convert';
import 'package:flutter/material.dart';
import '../providers/user_provider.dart';
import 'preferences_service.dart';
import 'database_helper.dart';

/// Export / import des données personnelles (hors contenu encyclopédique).
class BackupService {
  static const backupVersion = 1;

  static Map<String, dynamic> buildBackup(UserProvider user) {
    final history = user.readingHistory
        .map((e) => {'topicId': e.topicId, 'readAt': e.readAt.toIso8601String()})
        .toList();

    return {
      'version': backupVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'locale': user.locale.languageCode,
      'themeMode': _themeToString(user.themeMode),
      'preferredSchool': user.preferredSchool,
      'dailyReminder': user.dailyReminderEnabled,
      'favorites': user.favorites,
      'notes': user.notes.map((k, v) => MapEntry(k.toString(), v)),
      'badges': user.unlockedBadgeKeys.toList(),
      'courseProgress': user.courseProgressMap,
      'readingHistory': history,
      'readingStreak': user.readingStreak,
    };
  }

  static String buildBackupJson(UserProvider user) {
    final map = buildBackup(user);
    // Include practical cases via prefs
    final prefs = PreferencesService.instance;
    map['practicalCases'] = prefs.getCompletedPracticalCases().toList();
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  static Future<BackupResult> restoreFromJson(String raw, UserProvider user) async {
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final version = data['version'] as int? ?? 0;
      if (version > backupVersion) {
        return BackupResult.failure('Version de sauvegarde non supportée');
      }

      final db = DatabaseHelper();
      final prefs = PreferencesService.instance;

      // Favorites
      final favIds = (data['favorites'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [];
      final currentFavs = await db.getFavorites();
      for (final id in currentFavs) {
        await db.removeFavorite(id);
      }
      for (final id in favIds) {
        await db.addFavorite(id);
      }

      // Notes
      final notesMap = data['notes'] as Map<String, dynamic>? ?? {};
      for (final entry in notesMap.entries) {
        final topicId = int.parse(entry.key);
        await db.saveNote(topicId, entry.value as String);
      }

      await prefs.restoreUserData(
        localeCode: data['locale'] as String?,
        themeMode: data['themeMode'] as String?,
        preferredSchool: data.containsKey('preferredSchool')
            ? data['preferredSchool'] as String?
            : null,
        clearPreferredSchool: data.containsKey('preferredSchool') && data['preferredSchool'] == null,
        dailyReminder: data['dailyReminder'] as bool?,
        badges: (data['badges'] as List<dynamic>?)?.cast<String>(),
        courseProgress: _parseCourseProgress(data['courseProgress']),
        practicalCases: (data['practicalCases'] as List<dynamic>?)?.cast<String>(),
        readingHistory: (data['readingHistory'] as List<dynamic>?)
            ?.map((e) => ReadingHistoryEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        readingStreak: data['readingStreak'] as int?,
      );

      await user.reloadFromStorage();
      return BackupResult.success();
    } catch (e) {
      return BackupResult.failure(e.toString());
    }
  }

  static Map<String, List<int>> _parseCourseProgress(dynamic raw) {
    if (raw is! Map<String, dynamic>) return {};
    return raw.map(
      (k, v) => MapEntry(k, (v as List<dynamic>).map((e) => (e as num).toInt()).toList()),
    );
  }

  static String _themeToString(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
}

class BackupResult {
  final bool ok;
  final String? error;

  const BackupResult._({required this.ok, this.error});

  factory BackupResult.success() => const BackupResult._(ok: true);
  factory BackupResult.failure(String message) => BackupResult._(ok: false, error: message);
}
