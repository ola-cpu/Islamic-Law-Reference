import 'dart:ui';
import '../models/category.dart';
import '../providers/user_provider.dart';
import 'database_helper.dart';

class SkillNode {
  final Category category;
  final int totalTopics;
  final int readTopics;

  const SkillNode({
    required this.category,
    required this.totalTopics,
    required this.readTopics,
  });

  double get progress => totalTopics == 0 ? 0 : readTopics / totalTopics;
}

class SkillTreeService {
  static Future<List<SkillNode>> load(UserProvider user, {Locale? locale}) async {
    final db = DatabaseHelper();
    final loc = locale ?? user.locale;
    final roots = await db.getCategories(locale: loc);
    final readIds = user.readingHistoryIds.toSet();
    final nodes = <SkillNode>[];

    for (final cat in roots) {
      if (cat.id == null) continue;
      final topics = await db.getTopicsByCategory(cat.id!, locale: loc);
      final read = topics.where((t) => t.id != null && readIds.contains(t.id)).length;
      nodes.add(SkillNode(category: cat, totalTopics: topics.length, readTopics: read));
    }

    nodes.sort((a, b) => b.progress.compareTo(a.progress));
    return nodes;
  }
}
