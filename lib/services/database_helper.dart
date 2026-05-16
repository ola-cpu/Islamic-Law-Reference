import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category.dart';
import '../models/law.dart';
import '../models/source.dart';

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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        icon TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE laws(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        title TEXT,
        content TEXT,
        scholar_comments TEXT,
        school TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE sources(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        law_id INTEGER,
        type INTEGER,
        reference TEXT,
        text TEXT,
        FOREIGN KEY (law_id) REFERENCES laws (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        law_id INTEGER UNIQUE,
        FOREIGN KEY (law_id) REFERENCES laws (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        law_id INTEGER UNIQUE,
        content TEXT,
        FOREIGN KEY (law_id) REFERENCES laws (id)
      )
    ''');

    await _seedDatabase(db);
  }

  Future _seedDatabase(Database db) async {
    // Categories
    int catCulte = await db.insert('categories', {'name': 'Prière et Culte', 'icon': 'mosque'});
    int catCommerce = await db.insert('categories', {'name': 'Économie et Commerce', 'icon': 'business'});
    int catFamille = await db.insert('categories', {'name': 'Famille et Mariage', 'icon': 'family_restroom'});

    // Law 1: Prière (Culte)
    int law1 = await db.insert('laws', {
      'category_id': catCulte,
      'title': 'L’obligation de la prière',
      'content': 'La prière est une obligation pour tout musulman pubère et doué de raison.',
      'scholar_comments': 'C\'est le deuxième pilier de l\'islam.',
      'school': 'Toutes'
    });
    await db.insert('sources', {
      'law_id': law1,
      'type': 0, // Quran
      'reference': 'Sourate 2, Verset 43',
      'text': 'Et accomplissez la Salat, et acquittez la Zakat, et inclinez-vous avec ceux qui s’inclinent.'
    });

    // Law 2: Riba (Économie)
    int law2 = await db.insert('laws', {
      'category_id': catCommerce,
      'title': 'Interdiction de l’usure (Riba)',
      'content': 'L\'islam interdit formellement toute forme d\'usure ou d\'intérêt dans les transactions financières.',
      'scholar_comments': 'Le Riba est considéré comme un péché majeur.',
      'school': 'Toutes'
    });
    await db.insert('sources', {
      'law_id': law2,
      'type': 0, // Quran
      'reference': 'Sourate 2, Verset 275',
      'text': 'Alors qu’Allah a rendu licite le commerce, et illicite l’intérêt.'
    });

    // Law 3: Mariage (Famille)
    int law3 = await db.insert('laws', {
      'category_id': catFamille,
      'title': 'La dot (Mahr)',
      'content': 'Le mari doit verser une dot à son épouse lors du contrat de mariage.',
      'scholar_comments': 'La dot appartient exclusivement à la femme.',
      'school': 'Maliki'
    });
    await db.insert('sources', {
      'law_id': law3,
      'type': 0, // Quran
      'reference': 'Sourate 4, Verset 4',
      'text': 'Et donnez aux épouses leur mahr, de bonne grâce.'
    });
  }

  Future<List<Category>> getCategories() async {
    Database db = await database;
    var categories = await db.query('categories');
    return categories.map((c) => Category.fromMap(c)).toList();
  }

  Future<List<Law>> getLawsByCategory(int categoryId) async {
    Database db = await database;
    var laws = await db.query('laws', where: 'category_id = ?', whereArgs: [categoryId]);
    return laws.map((l) => Law.fromMap(l)).toList();
  }

  Future<List<Source>> getSourcesByLaw(int lawId) async {
    Database db = await database;
    var sources = await db.query('sources', where: 'law_id = ?', whereArgs: [lawId]);
    return sources.map((s) => Source.fromMap(s)).toList();
  }

  Future<List<Law>> searchLaws(String query) async {
    Database db = await database;
    var laws = await db.query('laws', where: 'title LIKE ? OR content LIKE ?', whereArgs: ['%$query%', '%$query%']);
    return laws.map((l) => Law.fromMap(l)).toList();
  }

  // Favorites
  Future<void> addFavorite(int lawId) async {
    Database db = await database;
    await db.insert('favorites', {'law_id': lawId}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeFavorite(int lawId) async {
    Database db = await database;
    await db.delete('favorites', where: 'law_id = ?', whereArgs: [lawId]);
  }

  Future<List<int>> getFavorites() async {
    Database db = await database;
    var results = await db.query('favorites');
    return results.map((r) => r['law_id'] as int).toList();
  }

  // Notes
  Future<void> saveNote(int lawId, String content) async {
    Database db = await database;
    await db.insert(
      'notes',
      {'law_id': lawId, 'content': content},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getNote(int lawId) async {
    Database db = await database;
    var results = await db.query('notes', where: 'law_id = ?', whereArgs: [lawId]);
    if (results.isNotEmpty) {
      return results.first['content'] as String;
    }
    return null;
  }

  Future<Map<int, String>> getAllNotes() async {
    Database db = await database;
    var results = await db.query('notes');
    return { for (var r in results) r['law_id'] as int : r['content'] as String };
  }
}
