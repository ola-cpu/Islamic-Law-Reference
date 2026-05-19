import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:islamic_law_reference/services/database_helper.dart';
import 'dart:io';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbHelper = DatabaseHelper();
  final db = await dbHelper.database;

  print('--- Category Coverage Report ---');
  final categories = await db.query('categories');
  for (var cat in categories) {
    final catId = cat['id'];
    final catName = cat['name'];

    final topics = await db.query('topics', where: 'category_id = ?', whereArgs: [catId]);
    int lawCount = 0;
    int sourceCount = 0;

    for (var topic in topics) {
      final topicId = topic['id'];
      final laws = await db.query('laws', where: 'topic_id = ?', whereArgs: [topicId]);
      lawCount += laws.length;

      for (var law in laws) {
        final lawId = law['id'];
        final sources = await db.query('sources', where: 'law_id = ?', whereArgs: [lawId]);
        sourceCount += sources.length;
      }
    }

    print('Category [$catId]: $catName');
    print('  Topics: ${topics.length}');
    print('  Laws: $lawCount');
    print('  Sources: $sourceCount');
  }

  print('\n--- Overall Statistics ---');
  final totalTopics = (await db.rawQuery('SELECT COUNT(*) as count FROM topics')).first['count'];
  final totalLaws = (await db.rawQuery('SELECT COUNT(*) as count FROM laws')).first['count'];
  final totalSources = (await db.rawQuery('SELECT COUNT(*) as count FROM sources')).first['count'];
  final totalSchools = (await db.rawQuery('SELECT COUNT(*) as count FROM schools')).first['count'];

  print('Total Topics: $totalTopics');
  print('Total Laws: $totalLaws');
  print('Total Sources: $totalSources');
  print('Total Schools: $totalSchools');

  exit(0);
}
