import 'srs_service.dart';

/// Révision espacée pour les sujets encyclopédiques.
class TopicSrsService {
  static String topicKey(int topicId) => 'topic_$topicId';

  static Future<List<int>> dueTopicIds(List<int> candidateIds) async {
    final all = await SrsService.loadAll();
    final now = DateTime.now();
    final due = <int>[];
    for (final id in candidateIds) {
      final key = topicKey(id);
      final state = all[key];
      if (state == null || !state.nextReview.isAfter(now)) due.add(id);
    }
    return due.isEmpty ? candidateIds : due;
  }

  static Future<void> reviewTopic(int topicId, {required bool knew}) async {
    await SrsService.review(topicKey(topicId), good: knew);
  }
}
