import 'dart:ui';

/// Remplit les champs RU/ZH manquants à la lecture (fallback EN puis FR).
class ContentLocaleService {
  static String pick(Map<String, dynamic> map, String baseKey, Locale locale) {
    final lang = locale.languageCode;
    final localized = map['${baseKey}_$lang'];
    if (localized != null && localized.toString().isNotEmpty) return localized as String;
    if (lang == 'ru' || lang == 'zh') {
      final en = map['${baseKey}_en'];
      if (en != null && en.toString().isNotEmpty) return en as String;
    }
    return map[baseKey] as String? ?? '';
  }

  static void applyTopicLocale(Map<String, dynamic> map, Locale locale) {
    map['title'] = pick(map, 'title', locale);
    map['description'] = pick(map, 'description', locale);
  }

  static void applyLawLocale(Map<String, dynamic> map, Locale locale) {
    final lang = locale.languageCode;
    if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
    if (map['content_$lang'] != null) map['content'] = map['content_$lang'];
    if (lang == 'ru' || lang == 'zh') {
      map['content'] ??= map['content_en'] ?? map['content'];
    }
  }
}
