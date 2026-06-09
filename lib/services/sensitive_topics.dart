class SensitiveTopics {
  static const _keywords = [
    'héritage', 'inheritance', 'mira', 'faraid', 'farāʾiḍ',
    'divorce', 'talak', 'khul', 'طلاق',
    'riba', 'usure', 'ربا',
    'testament', 'wasiyyah', 'وصية',
    'mahr', 'dot', 'صداق',
    'hajb', 'blocage',
    'finance', 'banque', 'crédit',
  ];

  static bool isSensitive(String title, {List<String> tags = const []}) {
    final haystack = '${title.toLowerCase()} ${tags.join(' ').toLowerCase()}';
    return _keywords.any(haystack.contains);
  }
}
