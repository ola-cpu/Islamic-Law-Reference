import 'chapters/prayer_chapter.dart';
import 'chapters/fasting_chapter.dart';
import 'chapters/family_chapter.dart';
import 'chapters/economy_chapter.dart';
import 'chapters/justice_chapter.dart';
import 'chapters/ethics_chapter.dart';
import 'chapters/food_chapter.dart';
import 'chapters/contracts_chapter.dart';
import 'chapters/rights_chapter.dart';
import 'chapters/inheritance_chapter.dart';
import 'chapters/misc_chapter.dart';

/// Catalogue encyclopédique axe 1 — ~400 sujets additionnels.
List<Map<String, dynamic>> buildFiqhTaxonomy() {
  final out = <Map<String, dynamic>>[];
  for (final chapter in [
    prayerChapterTopics,
    fastingChapterTopics,
    familyChapterTopics,
    economyChapterTopics,
    justiceChapterTopics,
    ethicsChapterTopics,
    foodChapterTopics,
    contractsChapterTopics,
    rightsChapterTopics,
    inheritanceChapterTopics,
    miscChapterTopics,
  ]) {
    out.addAll(chapter);
  }
  return out;
}
