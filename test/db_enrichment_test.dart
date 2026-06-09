import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:islamic_law_reference/services/database_helper.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    DatabaseHelper.setTestDatabaseName('test_enrichment.db');
  });

  tearDown(() async {
    await DatabaseHelper().closeForTesting();
  });

  test('Database enrichment verification v18', () async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    final version = await db.getVersion();
    expect(version, 18);

    final categories = await db.query('categories');
    expect(categories.length, greaterThan(11));

    const enrichedTopics = [
      'Conditions de validité du wuḍū’',
      'Annulations du wuḍū’',
      'Le Nisab de la Zakat',
      'Intention du jeûne',
      'Piliers du contrat de mariage',
      'Règles de la dot (Mahr)',
      'Les types de Riba',
      'Le rôle du Wali',
      'Les droits et devoirs conjugaux',
      'La médisance (Ghibah)',
      'Les huit catégories de bénéficiaires',
      'La Murabaha',
      'Le jeûne du malade',
      'La Qunut dans la prière',
      'Les sunan autour de la prière',
      'La patience (Sabr)',
    ];

    for (final title in enrichedTopics) {
      final result = await db.query('topics', where: 'title = ?', whereArgs: [title]);
      expect(result.isNotEmpty, true, reason: 'Topic "$title" not found');
    }

    final media = await db.query('media');
    expect(media.length, greaterThanOrEqualTo(5));

    final dailyTopic = await dbHelper.getDailyTopic();
    expect(dailyTopic, isNotNull);

    final topicCount = await dbHelper.getTopicCount();
    expect(topicCount, greaterThanOrEqualTo(100));

    final itikaf = await dbHelper.getTopicByTitle('L\'I\'tikaf en Ramadan');
    expect(itikaf, isNotNull);

    await db.insert('favorites', {'topic_id': 999}, conflictAlgorithm: ConflictAlgorithm.replace);
    await dbHelper.saveNote(999, 'Test Note');

    final favorites = await db.query('favorites', where: 'topic_id = ?', whereArgs: [999]);
    expect(favorites.length, 1);

    final note = await dbHelper.getNote(999);
    expect(note, 'Test Note');
  });
}
