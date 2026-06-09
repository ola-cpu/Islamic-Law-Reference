import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:islamic_law_reference/services/database_helper.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('upgrade v17 preserves favorites and notes without dropping content', () async {
    final dbName = 'test_legacy_${DateTime.now().microsecondsSinceEpoch}.db';
    final dbPath = p.join(await getDatabasesPath(), dbName);

    final legacy = await openDatabase(
      dbPath,
      version: 17,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            parent_id INTEGER,
            name TEXT,
            name_en TEXT,
            name_ar TEXT,
            icon TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE schools(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE topics(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_id INTEGER,
            title TEXT,
            title_en TEXT,
            title_ar TEXT,
            description TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE laws(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            topic_id INTEGER,
            school_id INTEGER,
            title TEXT,
            content TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE sources(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            law_id INTEGER,
            type INTEGER,
            reference TEXT,
            text TEXT,
            authenticity INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            topic_id INTEGER UNIQUE
          )
        ''');
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            topic_id INTEGER UNIQUE,
            content TEXT
          )
        ''');

        final catId = await db.insert('categories', {
          'name': 'Prière',
          'name_en': 'Prayer',
          'name_ar': 'صلاة',
          'icon': 'mosque',
        });
        await db.insert('schools', {'name': 'Hanafi'});
        final topicId = await db.insert('topics', {
          'category_id': catId,
          'title': 'Sujet legacy',
          'title_en': 'Legacy topic',
          'title_ar': 'موضوع',
          'description': 'Description test',
        });
        await db.insert('favorites', {'topic_id': topicId});
        await db.insert('notes', {'topic_id': topicId, 'content': 'Note legacy'});
      },
    );
    await legacy.close();

    DatabaseHelper.setTestDatabaseName(dbName);
    final helper = DatabaseHelper();
    final db = await helper.database;

    expect(await db.getVersion(), 23);

    final favorites = await db.query('favorites', where: 'topic_id = ?', whereArgs: [1]);
    expect(favorites.length, 1);

    final notes = await db.query('notes', where: 'topic_id = ?', whereArgs: [1]);
    expect(notes.first['content'], 'Note legacy');

    final legacyTopic = await db.query('topics', where: 'title = ?', whereArgs: ['Sujet legacy']);
    expect(legacyTopic, isNotEmpty);

    final premiumMeta = await db.query('app_meta', where: 'key = ?', whereArgs: ['premium_enriched_2']);
    expect(premiumMeta, isNotEmpty);

    await helper.closeForTesting();
    await deleteDatabase(dbPath);
    DatabaseHelper.setTestDatabaseName(null);
  });
}
