/// Construit un sujet JSON à partir d'une entrée compacte du catalogue.
Map<String, dynamic> buildTopicJson({
  required String categoryIcon,
  required String titleFr,
  required String titleEn,
  required String titleAr,
  required String descriptionFr,
  required String descriptionEn,
  required List<Map<String, String>> laws,
}) {
  return {
    'category_icon': categoryIcon,
    'title_fr': titleFr,
    'title_en': titleEn,
    'title_ar': titleAr,
    'title_ru': titleEn,
    'title_zh': titleEn,
    'description_fr': descriptionFr,
    'description_en': descriptionEn,
    'description_ar': descriptionEn,
    'description_ru': descriptionEn,
    'description_zh': descriptionEn,
    'laws': laws
        .map(
          (l) => {
            'school': l['school']!,
            'content_fr': l['fr']!,
            'content_en': l['en'] ?? l['fr']!,
            if (l.containsKey('ar')) 'content_ar': l['ar'],
          },
        )
        .toList(),
  };
}

Map<String, String> law(String school, String fr, [String? en]) => {
      'school': school,
      'fr': fr,
      if (en != null) 'en': en,
    };

/// Entrée compacte pour les chapitres du catalogue.
Map<String, dynamic> catalogTopic(
  String icon,
  String fr,
  String en,
  String ar,
  String dFr,
  String dEn,
  String h,
  String m, [
  String? s,
  String? b,
]) {
  final laws = <Map<String, String>>[
    law('Hanafi', h),
    law('Maliki', m),
    if (s != null) law("Shafi'i", s),
    if (b != null) law('Hanbali', b),
  ];
  return buildTopicJson(
    categoryIcon: icon,
    titleFr: fr,
    titleEn: en,
    titleAr: ar,
    descriptionFr: dFr,
    descriptionEn: dEn,
    laws: laws,
  );
}
