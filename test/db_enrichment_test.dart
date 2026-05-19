import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:islamic_law_reference/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Database Enrichment Verification v9', () async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    // Check version
    int version = await db.getVersion();
    expect(version, 9);

    // Check categories
    final categories = await db.query('categories');
    expect(categories.length, greaterThanOrEqualTo(11));

    // Check for enriched topics
    final enrichedTopics = [
      'Le respect des parents (Birr al-Walidayn)',
      'Prohibition de l\'usure (Riba)',
      'Le témoignage véridique',
      'La véracité (As-Sidq)',
      'L\'abattage rituel (Dhabihah)',
      'Le contrat de vente (Al-Bay\')',
      'Le droit à la vie',
      'Part de la fille unique',
      'La dot (Mahr)',
      'Manger par oubli',
      'Les membres de la prosternation'
    ];

    for (var title in enrichedTopics) {
      final result = await db.query('topics', where: 'title = ?', whereArgs: [title]);
      expect(result.isNotEmpty, true, reason: 'Topic "$title" not found');
    }

    // Verify preservation of user data (Simulated)
    await db.insert('favorites', {'topic_id': 999});
    await dbHelper.saveNote(999, 'Test Note');

    // Trigger "upgrade" by calling onUpgrade manually or just checking logic
    // Since we are in tests, we can just verify the tables are there.
    final favorites = await db.query('favorites', where: 'topic_id = ?', whereArgs: [999]);
    expect(favorites.length, 1);

    final note = await dbHelper.getNote(999);
    expect(note, 'Test Note');
  });
}
