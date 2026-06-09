import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'content_batch_registry.dart';

/// Charge des sujets depuis JSON (pipeline extensible sans recompiler le seed Dart).
class ContentJsonLoader {
  static const _schoolNames = ['Hanafi', 'Maliki', "Shafi'i", 'Hanbali', "Ja'fari"];

  /// Charge tous les lots enregistrés non encore importés.
  static Future<int> loadAllRegisteredBatches(Database db) async {
    var total = 0;
    for (final batch in ContentBatchRegistry.batches) {
      total += await loadAssetBatch(db, batch.asset, metaKey: batch.metaKey);
    }
    return total;
  }

  static Future<int> loadAssetBatch(Database db, String assetPath, {String metaKey = 'json_loaded'}) async {
    if (await _isLoaded(db, metaKey)) return 0;

    final raw = await rootBundle.loadString(assetPath);
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final topics = data['topics'] as List<dynamic>? ?? [];
    final enrichMode = data['mode'] == 'enrich';
    var inserted = 0;
    var enriched = 0;

    final schools = <String, int>{};
    for (final name in _schoolNames) {
      final row = await db.query('schools', where: 'name = ?', whereArgs: [name], limit: 1);
      if (row.isNotEmpty) schools[name] = row.first['id'] as int;
    }

    for (final item in topics) {
      final t = item as Map<String, dynamic>;
      final titleFr = t['title_fr'] as String;
      final existing = await db.query('topics', where: 'title = ?', whereArgs: [titleFr], limit: 1);

      int topicId;
      if (existing.isNotEmpty) {
        if (!enrichMode) continue;
        topicId = existing.first['id'] as int;
        await _patchTopicLocales(db, topicId, t);
        enriched += await _insertLawsForTopic(db, topicId, titleFr, t, schools, skipExistingSchools: true);
        continue;
      }

      final catIcon = t['category_icon'] as String? ?? 'mosque';
      final catRow = await db.query(
        'categories',
        where: 'icon = ? AND parent_id IS NULL',
        whereArgs: [catIcon],
        limit: 1,
      );
      if (catRow.isEmpty) continue;
      final categoryId = catRow.first['id'] as int;

      topicId = await db.insert('topics', {
        'category_id': categoryId,
        'title': titleFr,
        'title_en': t['title_en'],
        'title_ar': t['title_ar'],
        'title_ru': t['title_ru'] ?? t['title_en'],
        'title_zh': t['title_zh'] ?? t['title_en'],
        'description': t['description_fr'],
        'description_en': t['description_en'],
        'description_ar': t['description_ar'],
        'description_ru': t['description_ru'] ?? t['description_en'],
        'description_zh': t['description_zh'] ?? t['description_en'],
      });

      await _insertLawsForTopic(db, topicId, titleFr, t, schools);
      inserted++;
    }

    await _markLoaded(db, metaKey, assetPath);
    return inserted + enriched;
  }

  static Future<void> _patchTopicLocales(Database db, int topicId, Map<String, dynamic> t) async {
    final row = (await db.query('topics', where: 'id = ?', whereArgs: [topicId], limit: 1)).first;
    final patch = <String, Object?>{};
    void setIfEmpty(String col, String? value) {
      if (value == null || value.isEmpty) return;
      final current = row[col] as String?;
      if (current == null || current.isEmpty || current == row['title_en']) {
        patch[col] = value;
      }
    }

    void setArabicIfProvided(String col, String? value) {
      if (value == null || value.isEmpty) return;
      patch[col] = value;
    }

    setArabicIfProvided('description_ar', t['description_ar'] as String?);
    setArabicIfProvided('title_ar', t['title_ar'] as String?);
    setIfEmpty('description_en', t['description_en'] as String?);
    setIfEmpty('description_ru', t['description_ru'] as String?);
    setIfEmpty('description_zh', t['description_zh'] as String?);
    if (patch.isNotEmpty) {
      await db.update('topics', patch, where: 'id = ?', whereArgs: [topicId]);
    }
  }

  static Future<int> _insertLawsForTopic(
    Database db,
    int topicId,
    String titleFr,
    Map<String, dynamic> t,
    Map<String, int> schools, {
    bool skipExistingSchools = false,
  }) async {
    var added = 0;
    final laws = t['laws'] as List<dynamic>? ?? [];
    for (final law in laws) {
      final l = law as Map<String, dynamic>;
      final schoolName = l['school'] as String;
      final schoolId = schools[schoolName];
      if (schoolId == null) continue;
      if (skipExistingSchools) {
        final exists = await db.query(
          'laws',
          where: 'topic_id = ? AND school_id = ?',
          whereArgs: [topicId, schoolId],
          limit: 1,
        );
        if (exists.isNotEmpty) continue;
      }
      final lawId = await db.insert('laws', {
        'topic_id': topicId,
        'school_id': schoolId,
        'title': '$schoolName — ${l['title_fr'] ?? titleFr}',
        'content': l['content_fr'],
        'content_en': l['content_en'],
        'content_ar': l['content_ar'],
        'content_ru': l['content_ru'] ?? l['content_en'],
        'content_zh': l['content_zh'] ?? l['content_en'],
      });
      final sources = l['sources'] as List<dynamic>? ?? [];
      for (final s in sources) {
        final src = s as Map<String, dynamic>;
        await db.insert('sources', {
          'law_id': lawId,
          'type': src['type'] ?? 1,
          'reference': src['reference'],
          'text': src['text'],
          'text_ar': src['text_ar'],
          'authenticity': src['authenticity'] ?? 0,
          'citation': src['citation'],
          'isnad': src['isnad'],
        });
      }
      added++;
    }
    return added;
  }

  static Future<bool> _isLoaded(Database db, String key) async {
    await _ensureMetaTable(db);
    final rows = await db.query('app_meta', where: 'key = ?', whereArgs: [key]);
    return rows.isNotEmpty;
  }

  static Future<void> _markLoaded(Database db, String key, String path) async {
    await _ensureMetaTable(db);
    await db.insert('app_meta', {'key': key, 'value': path}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> ensureMetaTable(Database db) => _ensureMetaTable(db);

  static Future<void> _ensureMetaTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_meta(
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }
}
