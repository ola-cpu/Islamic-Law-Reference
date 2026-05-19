import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:islamic_law_reference/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Database Enrichment Verification v10', () async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    // Check version
    int version = await db.getVersion();
    expect(version, 10);

    // Check categories (Main categories + Subcategories)
    final categories = await db.query('categories');
    expect(categories.length, greaterThan(11));

    // Check for enriched topics
    final enrichedTopics = [
      'Conditions de validité du wuḍū’',
      'Annulations du wuḍū’',
      'Le Nisab de la Zakat',
      'Intention du jeûne',
      'Piliers du contrat de mariage',
      'Règles de la dot (Mahr)',
      'Les types de Riba',
    ];

    for (var title in enrichedTopics) {
      final result = await db.query('topics', where: 'title = ?', whereArgs: [title]);
      expect(result.isNotEmpty, true, reason: 'Topic "$title" not found');
    }

    // Verify preservation of user data (Simulated)
    await db.insert('favorites', {'topic_id': 999}, conflictAlgorithm: ConflictAlgorithm.replace);
    await dbHelper.saveNote(999, 'Test Note');

    final favorites = await db.query('favorites', where: 'topic_id = ?', whereArgs: [999]);
    expect(favorites.length, 1);

    final note = await dbHelper.getNote(999);
    expect(note, 'Test Note');
  });
}
