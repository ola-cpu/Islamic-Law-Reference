import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SrsCardState {
  final int intervalDays;
  final double ease;
  final DateTime nextReview;

  const SrsCardState({
    required this.intervalDays,
    required this.ease,
    required this.nextReview,
  });

  Map<String, dynamic> toJson() => {
        'intervalDays': intervalDays,
        'ease': ease,
        'nextReview': nextReview.toIso8601String(),
      };

  factory SrsCardState.fromJson(Map<String, dynamic> json) {
    return SrsCardState(
      intervalDays: json['intervalDays'] as int? ?? 1,
      ease: (json['ease'] as num?)?.toDouble() ?? 2.5,
      nextReview: DateTime.parse(json['nextReview'] as String),
    );
  }

  static SrsCardState initial() => SrsCardState(
        intervalDays: 1,
        ease: 2.5,
        nextReview: DateTime.now(),
      );
}

class SrsService {
  static const _key = 'srs_flashcards';

  static Future<Map<String, SrsCardState>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, SrsCardState.fromJson(v as Map<String, dynamic>)));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveAll(Map<String, SrsCardState> data) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = data.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_key, jsonEncode(encoded));
  }

  static String cardKey(String deckId, int index) => '${deckId}_$index';

  /// SM-2 simplified: quality 3 = good, 1 = again.
  static Future<SrsCardState> review(String key, {required bool good}) async {
    final all = await loadAll();
    final current = all[key] ?? SrsCardState.initial();
    final now = DateTime.now();

    late SrsCardState next;
    if (good) {
      final newInterval = current.intervalDays < 1 ? 1 : (current.intervalDays * current.ease).round().clamp(1, 60);
      final newEase = (current.ease + 0.1).clamp(1.3, 3.0);
      next = SrsCardState(
        intervalDays: newInterval,
        ease: newEase,
        nextReview: now.add(Duration(days: newInterval)),
      );
    } else {
      next = SrsCardState(
        intervalDays: 1,
        ease: (current.ease - 0.2).clamp(1.3, 3.0),
        nextReview: now.add(const Duration(hours: 4)),
      );
    }

    all[key] = next;
    await saveAll(all);
    return next;
  }

  static Future<List<int>> dueIndices(String deckId, int cardCount) async {
    final all = await loadAll();
    final now = DateTime.now();
    final due = <int>[];
    for (var i = 0; i < cardCount; i++) {
      final key = cardKey(deckId, i);
      final state = all[key];
      if (state == null || !state.nextReview.isAfter(now)) due.add(i);
    }
    return due.isEmpty ? List.generate(cardCount, (i) => i) : due;
  }
}
