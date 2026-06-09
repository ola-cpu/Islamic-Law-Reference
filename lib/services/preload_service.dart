import '../providers/user_provider.dart';
import 'database_helper.dart';

/// Préchargement au démarrage (sujet du jour + FTS chaud).
class PreloadService {
  static Future<void> warmUp(UserProvider user) async {
    final db = DatabaseHelper();
    await db.getDailyTopic(locale: user.locale);
    await db.getTopicCount();
    if (user.lastReadEntry != null) {
      await db.getTopicById(user.lastReadEntry!.topicId, locale: user.locale);
    }
  }
}
