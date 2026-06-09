import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/learning_content.dart';

class AdaptiveQuizService {
  static const _key = 'quiz_mistakes';

  static Future<Map<String, int>> loadMistakes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, v as int));
    } catch (_) {
      return {};
    }
  }

  static Future<void> recordMistake(String questionKey) async {
    final prefs = await SharedPreferences.getInstance();
    final mistakes = await loadMistakes();
    mistakes[questionKey] = (mistakes[questionKey] ?? 0) + 1;
    await prefs.setString(_key, jsonEncode(mistakes));
  }

  static Future<void> recordCorrect(String questionKey) async {
    final prefs = await SharedPreferences.getInstance();
    final mistakes = await loadMistakes();
    if (mistakes.containsKey(questionKey)) {
      mistakes[questionKey] = (mistakes[questionKey]! - 1).clamp(0, 99);
      if (mistakes[questionKey] == 0) mistakes.remove(questionKey);
    }
    await prefs.setString(_key, jsonEncode(mistakes));
  }

  static String questionKey(QuizQuestion q) => '${q.categoryId}_${q.questionFr.hashCode}';

  static Future<List<QuizQuestion>> orderedQuestions() async {
    final mistakes = await loadMistakes();
    final questions = List<QuizQuestion>.from(LearningContent.quizQuestions);
    questions.sort((a, b) {
      final ma = mistakes[questionKey(a)] ?? 0;
      final mb = mistakes[questionKey(b)] ?? 0;
      return mb.compareTo(ma);
    });
    return questions;
  }
}
