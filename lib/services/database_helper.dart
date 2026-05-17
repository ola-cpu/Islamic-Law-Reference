import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category.dart';
import '../models/topic.dart';
import '../models/law.dart';
import '../models/source.dart';
import '../models/school.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'islamic_law.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
         // Simplified for this task: recreate tables if upgrading
         await _dropTables(db);
         await _onCreate(db, newVersion);
      },
    );
  }

  Future<void> _dropTables(Database db) async {
    await db.execute('DROP TABLE IF EXISTS sources');
    await db.execute('DROP TABLE IF EXISTS favorites');
    await db.execute('DROP TABLE IF EXISTS notes');
    await db.execute('DROP TABLE IF EXISTS laws');
    await db.execute('DROP TABLE IF EXISTS topics');
    await db.execute('DROP TABLE IF EXISTS categories');
    await db.execute('DROP TABLE IF EXISTS schools');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parent_id INTEGER,
        name TEXT,
        icon TEXT,
        FOREIGN KEY (parent_id) REFERENCES categories (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE schools(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE topics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        title TEXT,
        description TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE laws(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER,
        title TEXT,
        content TEXT,
        content_ar TEXT,
        scholar_comments TEXT,
        school_id INTEGER,
        FOREIGN KEY (topic_id) REFERENCES topics (id),
        FOREIGN KEY (school_id) REFERENCES schools (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE sources(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        law_id INTEGER,
        type INTEGER,
        reference TEXT,
        text TEXT,
        text_ar TEXT,
        authenticity INTEGER,
        citation TEXT,
        FOREIGN KEY (law_id) REFERENCES laws (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER UNIQUE,
        FOREIGN KEY (topic_id) REFERENCES topics (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER UNIQUE,
        content TEXT,
        FOREIGN KEY (topic_id) REFERENCES topics (id)
      )
    ''');

    await _seedDatabase(db);
  }

  Future _seedDatabase(Database db) async {
    // Schools
    int shHanafi = await db.insert('schools', {'name': 'Hanafi', 'description': 'L\'école de l\'Imam Abu Hanifa.'});
    int shMaliki = await db.insert('schools', {'name': 'Maliki', 'description': 'L\'école de l\'Imam Malik.'});
    int shShafii = await db.insert('schools', {'name': 'Shafi\'i', 'description': 'L\'école de l\'Imam Al-Shafi\'i.'});
    int shHanbali = await db.insert('schools', {'name': 'Hanbali', 'description': 'L\'école de l\'Imam Ahmad ibn Hanbal.'});

    // Categories
    int catCulte = await db.insert('categories', {'name': 'Culte (Ibadat)', 'icon': 'mosque', 'parent_id': null});
    int catPriere = await db.insert('categories', {'name': 'Prière (Salat)', 'icon': 'church', 'parent_id': catCulte});

    // Topic: Lever les mains dans la prière
    int topHands = await db.insert('topics', {
      'category_id': catPriere,
      'title': 'Lever les mains dans la prière',
      'description': 'Les règles concernant le fait de lever les mains à différents moments de la prière.'
    });

    // Law Hanafi
    int lawHanafi = await db.insert('laws', {
      'topic_id': topHands,
      'title': 'Position Hanafi',
      'content': 'On lève les mains seulement au début de la prière (Takbir d\'ouverture).',
      'content_ar': 'يرفع يديه في التكبيرة الأولى فقط',
      'scholar_comments': 'Basé sur la pratique des gens de Koufa.',
      'school_id': shHanafi
    });
    await db.insert('sources', {
      'law_id': lawHanafi,
      'type': 1, // Hadith
      'reference': 'Sunan Abi Dawood, Hadith 748',
      'text': 'Ibn Mas\'ud a dit : "Ne vais-je pas vous montrer la prière du Messager d\'Allah ?" Il a alors prié et n\'a levé les mains qu\'une seule fois.',
      'text_ar': 'عن ابن مسعود قال: ألا أصلي بكم صلاة رسول الله صلى الله عليه وسلم؟ فصلى فلم يرفع يديه إلا في أول مرة',
      'authenticity': 1, // Hasan
      'citation': 'Abu Dawood, Kitab al-Salat'
    });

    // Law Shafii
    int lawShafii = await db.insert('laws', {
      'topic_id': topHands,
      'title': 'Position Shafi\'i',
      'content': 'On lève les mains au début, avant l\'inclinaison (ruku\'), et en se relevant de l\'inclinaison.',
      'content_ar': 'يرفع يديه عند الافتتاح، وعند الركوع، وعند الرفع منه',
      'scholar_comments': 'Considéré comme Sunnah fortement recommandée.',
      'school_id': shShafii
    });
    await db.insert('sources', {
      'law_id': lawShafii,
      'type': 1, // Hadith
      'reference': 'Sahih Bukhari, Hadith 735',
      'text': 'Abdullah ibn Umar a rapporté que le Messager d\'Allah levait ses mains au niveau de ses épaules lorsqu\'il commençait la prière, lorsqu\'il disait le Takbir pour l\'inclinaison, et lorsqu\'il relevait sa tête de l\'inclinaison.',
      'text_ar': 'عن عبد الله بن عمر رضي الله عنهما أن رسول الله صلى الله عليه وسلم كان يرفع يديه حذو منكبيه إذا افتتح الصلاة، وإذا كبر للركوع، وإذا رفع رأسه من الركوع',
      'authenticity': 0, // Sahih
      'citation': 'Bukhari, Kitab Adhan'
    });
  }

  Future<List<Category>> getCategories({int? parentId}) async {
    Database db = await database;
    var categories = await db.query(
      'categories',
      where: parentId == null ? 'parent_id IS NULL' : 'parent_id = ?',
      whereArgs: parentId == null ? [] : [parentId]
    );
    return categories.map((c) => Category.fromMap(c)).toList();
  }

  Future<List<Topic>> getTopicsByCategory(int categoryId) async {
    Database db = await database;
    var topics = await db.query('topics', where: 'category_id = ?', whereArgs: [categoryId]);
    return topics.map((t) => Topic.fromMap(t)).toList();
  }

  Future<List<Law>> getLawsByTopic(int topicId) async {
    Database db = await database;
    var laws = await db.query('laws', where: 'topic_id = ?', whereArgs: [topicId]);
    return laws.map((l) => Law.fromMap(l)).toList();
  }

  Future<List<Source>> getSourcesByLaw(int lawId) async {
    Database db = await database;
    var sources = await db.query('sources', where: 'law_id = ?', whereArgs: [lawId]);
    return sources.map((s) => Source.fromMap(s)).toList();
  }

  Future<School?> getSchoolById(int schoolId) async {
    Database db = await database;
    var schools = await db.query('schools', where: 'id = ?', whereArgs: [schoolId]);
    if (schools.isNotEmpty) {
      return School.fromMap(schools.first);
    }
    return null;
  }

  Future<List<Topic>> searchTopics(String query) async {
    Database db = await database;
    var topics = await db.query('topics', where: 'title LIKE ? OR description LIKE ?', whereArgs: ['%$query%', '%$query%']);
    return topics.map((t) => Topic.fromMap(t)).toList();
  }

  // Favorites (linked to Topics now)
  Future<void> addFavorite(int topicId) async {
    Database db = await database;
    await db.insert('favorites', {'topic_id': topicId}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeFavorite(int topicId) async {
    Database db = await database;
    await db.delete('favorites', where: 'topic_id = ?', whereArgs: [topicId]);
  }

  Future<List<int>> getFavorites() async {
    Database db = await database;
    var results = await db.query('favorites');
    return results.map((r) => r['topic_id'] as int).toList();
  }

  // Notes (linked to Topics)
  Future<void> saveNote(int topicId, String content) async {
    Database db = await database;
    await db.insert(
      'notes',
      {'topic_id': topicId, 'content': content},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getNote(int topicId) async {
    Database db = await database;
    var results = await db.query('notes', where: 'topic_id = ?', whereArgs: [topicId]);
    if (results.isNotEmpty) {
      return results.first['content'] as String;
    }
    return null;
  }

  Future<Map<int, String>> getAllNotes() async {
    Database db = await database;
    var results = await db.query('notes');
    return { for (var r in results) r['topic_id'] as int : r['content'] as String };
  }
}
