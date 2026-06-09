class SearchSynonyms {
  static final _arabicDiacritics = RegExp(r'[\u064B-\u065F\u0670]');

  static const _map = <String, List<String>>{
    'wudu': ['ablutions', 'wudhu', 'وضوء', 'طهارة'],
    'ablutions': ['wudu', 'wudhu', 'wuḍū', 'طهارة'],
    'ghusl': ['grandes ablutions', 'غسل'],
    'zakat': ['zakât', 'aumône', 'زكاة'],
    'prière': ['salah', 'salat', 'صلاة', 'prayer'],
    'prayer': ['prière', 'salah', 'salat', 'صلاة'],
    'jeûne': ['fasting', 'ramadan', 'صوم', 'sawm'],
    'fasting': ['jeûne', 'ramadan', 'صوم'],
    'mariage': ['nikah', 'nikkah', 'نكاح', 'marriage'],
    'marriage': ['mariage', 'nikah', 'نكاح'],
    'héritage': ['inheritance', 'mira', 'ميراث', 'faraid'],
    'inheritance': ['héritage', 'mira', 'ميراث'],
    'riba': ['usure', 'interest', 'ربا'],
    'hajj': ['pèlerinage', 'pilgrimage', 'حج'],
    'pilgrimage': ['hajj', 'pèlerinage', 'حج'],
    'tayammum': ['ablution sèche', 'تيمم'],
    'halal': ['licite', 'حلال'],
    'haram': ['interdit', 'حرام'],
  };

  static String normalize(String input) {
    var s = input.trim().toLowerCase();
    s = normalizeArabic(s);
    return s;
  }

  static String normalizeArabic(String input) {
    return input.replaceAll(_arabicDiacritics, '');
  }

  /// Returns unique search terms including synonyms.
  static List<String> expand(String query) {
    if (query.trim().isEmpty) return [];
    final normalized = normalize(query);
    final terms = <String>{normalized, query.trim()};
    for (final entry in _map.entries) {
      if (normalized.contains(entry.key) || entry.value.any((v) => normalized.contains(normalize(v)))) {
        terms.add(entry.key);
        terms.addAll(entry.value);
      }
    }
    return terms.where((t) => t.isNotEmpty).toList();
  }

  static String ftsQuery(String query) {
    final terms = expand(query);
    if (terms.isEmpty) return query;
    return terms.map((t) => '"${t.replaceAll('"', '')}"').join(' OR ');
  }
}
