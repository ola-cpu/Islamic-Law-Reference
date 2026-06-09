import 'hijri_calendar.dart';

enum SeasonType { ramadan, hajj, shaaban }

class SeasonInfo {
  final SeasonType type;
  final List<String> topicTitlesFr;
  final HijriDate hijri;

  const SeasonInfo({
    required this.type,
    required this.topicTitlesFr,
    required this.hijri,
  });
}

class SeasonService {
  static SeasonType? getActiveSeason(HijriDate hijri) {
    switch (hijri.month) {
      case 8:
        return SeasonType.shaaban;
      case 9:
        return SeasonType.ramadan;
      case 12:
        return SeasonType.hajj;
      default:
        return null;
    }
  }

  static SeasonInfo? getSeasonInfo([DateTime? date]) {
    final hijri = HijriDate.fromGregorian(date ?? DateTime.now());
    final season = getActiveSeason(hijri);
    if (season == null) return null;

    final topics = switch (season) {
      SeasonType.ramadan || SeasonType.shaaban => _ramadanTopics,
      SeasonType.hajj => _hajjTopics,
    };

    return SeasonInfo(type: season, topicTitlesFr: topics, hijri: hijri);
  }

  static const _ramadanTopics = [
    'Intention du jeûne',
    'La prière du Tarawih',
    'La Zakat al-Fitr',
    'Les nullificateurs du jeûne',
  ];

  static const _hajjTopics = [
    'Les rites du Hajj',
    'Le jeûne du jour de Arafat',
    'L\'Umrah',
  ];
}
