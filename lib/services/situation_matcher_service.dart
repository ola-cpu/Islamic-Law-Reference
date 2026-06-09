import 'dart:ui';
import '../data/practical_cases.dart';
import '../models/topic.dart';
import 'database_helper.dart';
import 'search_synonyms.dart';

class SituationMatch {
  final Topic? topic;
  final PracticalCase? practicalCase;
  final double score;

  const SituationMatch({this.topic, this.practicalCase, required this.score});
}

class SituationMatcherService {
  static const _situationKeywords = <String, List<String>>{
    'voyage': ['voyage', 'travel', 'avion', 'qasr', 'raccourcir', 'سفر'],
    'jeûne': ['jeûne', 'fasting', 'ramadan', 'iftar', 'suhur', 'صوم'],
    'prière': ['prière', 'prayer', 'salah', 'mosquée', 'imam', 'صلاة'],
    'mariage': ['mariage', 'marriage', 'nikah', 'dot', 'mahr', 'زواج'],
    'divorce': ['divorce', 'talak', 'khul', 'طلاق'],
    'héritage': ['héritage', 'inheritance', 'mira', 'testament', 'ميراث'],
    'zakat': ['zakat', 'aumône', 'nisab', 'زكاة'],
    'finance': ['riba', 'banque', 'crédit', 'intérêt', 'ربا'],
    'purification': ['wudu', 'ablutions', 'ghusl', 'tayammum', 'وضوء'],
    'hajj': ['hajj', 'omra', 'pèlerinage', 'pilgrimage', 'حج'],
  };

  static Future<List<SituationMatch>> match(String query, {required Locale locale}) async {
    if (query.trim().isEmpty) return [];

    final normalized = SearchSynonyms.normalize(query);
    final expanded = SearchSynonyms.expand(query).map(SearchSynonyms.normalize).toSet();

    final topicMatches = <SituationMatch>[];
    final topics = await DatabaseHelper().searchTopics(query, locale: locale);
    for (var i = 0; i < topics.length; i++) {
      final topic = topics[i];
      var score = 10.0 - i * 0.5;
      final title = SearchSynonyms.normalize(topic.title);
      final desc = SearchSynonyms.normalize(topic.description);
      for (final term in expanded) {
        if (title.contains(term) || desc.contains(term)) score += 3;
      }
      topicMatches.add(SituationMatch(topic: topic, score: score));
    }

    for (final entry in _situationKeywords.entries) {
      if (expanded.any((t) => entry.value.any((k) => t.contains(SearchSynonyms.normalize(k))))) {
        final extra = await DatabaseHelper().searchTopics(entry.key, locale: locale);
        for (final topic in extra.take(3)) {
          if (topicMatches.any((m) => m.topic?.id == topic.id)) continue;
          topicMatches.add(SituationMatch(topic: topic, score: 6));
        }
      }
    }

    final caseMatches = <SituationMatch>[];
    for (final c in PracticalCases.all) {
      var score = 0.0;
      final haystack = SearchSynonyms.normalize('${c.titleFr} ${c.scenarioFr}');
      for (final term in expanded) {
        if (haystack.contains(term)) score += 4;
      }
      if (normalized.isNotEmpty && haystack.contains(normalized)) score += 5;
      if (score > 0) caseMatches.add(SituationMatch(practicalCase: c, score: score));
    }

    final all = [...topicMatches, ...caseMatches]..sort((a, b) => b.score.compareTo(a.score));
    return all.take(12).toList();
  }
}
