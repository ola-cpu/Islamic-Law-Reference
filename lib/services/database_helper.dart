import 'package:flutter/foundation.dart' show kIsWeb;
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
    String path;
    if (kIsWeb) {
      path = 'islamic_law.db';
    } else {
      path = join(await getDatabasesPath(), 'islamic_law.db');
    }
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
    int shJafari = await db.insert('schools', {'name': 'Ja\'fari', 'description': 'L\'école de l\'Imam Ja\'far al-Sadiq.'});

    // Categories
    int catCulte = await db.insert('categories', {'name': 'Culte (Ibadat)', 'icon': 'mosque', 'parent_id': null});
    int catPriere = await db.insert('categories', {'name': 'Prière (Salat)', 'icon': 'mosque', 'parent_id': catCulte});
    int catFamille = await db.insert('categories', {'name': 'Relations sociales et familiales', 'icon': 'people', 'parent_id': null});
    int catEconomie = await db.insert('categories', {'name': 'Économie et commerce', 'icon': 'monetization_on', 'parent_id': null});
    int catJustice = await db.insert('categories', {'name': 'Justice et gouvernance', 'icon': 'gavel', 'parent_id': null});
    int catEthique = await db.insert('categories', {'name': 'Éthique et spiritualité', 'icon': 'favorite', 'parent_id': null});

    // Subcategories
    int catMariage = await db.insert('categories', {'name': 'Mariage (Nikah)', 'icon': 'people', 'parent_id': catFamille});
    int catCommerce = await db.insert('categories', {'name': 'Transactions (Muamalat)', 'icon': 'monetization_on', 'parent_id': catEconomie});
    int catQada = await db.insert('categories', {'name': 'Jugements (Qada)', 'icon': 'gavel', 'parent_id': catJustice});
    int catIkhlas = await db.insert('categories', {'name': 'Sincérité (Ikhlas)', 'icon': 'favorite', 'parent_id': catEthique});

    // Topic: Lever les mains dans la prière
    int topHands = await db.insert('topics', {
      'category_id': catPriere,
      'title': 'Lever les mains dans la prière',
      'description': 'Les règles concernant le fait de lever les mains à différents moments de la prière.'
    });

    // Topic: La Dot (Mahr)
    int topMahr = await db.insert('topics', {
      'category_id': catMariage,
      'title': 'La Dot (Mahr)',
      'description': 'Les règles concernant le don obligatoire du mari à son épouse lors du mariage.'
    });

    // Topic: Le Riba (Intérêt)
    int topRiba = await db.insert('topics', {
      'category_id': catCommerce,
      'title': 'Le Riba (Intérêt)',
      'description': 'L\'interdiction de l\'usure et de l\'intérêt dans les transactions financières.'
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

    // Law Maliki
    int lawMaliki = await db.insert('laws', {
      'topic_id': topHands,
      'title': 'Position Maliki',
      'content': 'L\'avis célèbre dans l\'école Maliki (notamment dans la Mudawwana) est que l\'on ne lève les mains que pour le Takbir initial.',
      'content_ar': 'المشهور في المذهب المالكي رفع اليدين عند تكبيرة الإحرام فقط',
      'scholar_comments': 'C\'est l\'avis privilégié par l\'Imam Malik dans sa pratique ultérieure.',
      'school_id': shMaliki
    });
    await db.insert('sources', {
      'law_id': lawMaliki,
      'type': 2, // Fiqh Book
      'reference': 'Al-Mudawwana',
      'text': 'L\'Imam Malik a dit qu\'il ne connaissait pas le fait de lever les mains dans une autre position que le premier Takbir.',
      'text_ar': 'قال مالك: لا أعرف رفع اليدين في شيء من صلاة المصلي، إلا في افتتاح الصلاة',
      'authenticity': 4, // None
      'citation': 'Al-Mudawwana al-Kubra'
    });

    // Law Hanbali
    int lawHanbali = await db.insert('laws', {
      'topic_id': topHands,
      'title': 'Position Hanbali',
      'content': 'On lève les mains au Takbir initial, au moment de s\'incliner, en se redressant, et selon l\'avis prépondérant, en se levant pour la 3ème rak\'ah.',
      'content_ar': 'يرفع يديه عند الإحرام، والركوع، والرفع منه، وعند القيام إلى الثالثة',
      'scholar_comments': 'L\'école Hanbali suit strictement les hadiths authentiques sur ce point.',
      'school_id': shHanbali
    });
    await db.insert('sources', {
      'law_id': lawHanbali,
      'type': 1, // Hadith
      'reference': 'Sahih Bukhari, Hadith 739',
      'text': 'Nafi\' a rapporté qu\'Ibn Umar levait les mains lorsqu\'il se levait après deux rak\'ahs et il attribuait cela au Prophète.',
      'text_ar': 'عن نافع أن ابن عمر كان إذا قام من الركعتين رفع يديه، ورفع ذلك ابن عمر إلى نبي الله صلى الله عليه وسلم',
      'authenticity': 0, // Sahih
      'citation': 'Bukhari, Kitab al-Adhan'
    });

    // Law Jafari
    int lawJafari = await db.insert('laws', {
      'topic_id': topHands,
      'title': 'Position Ja\'fari',
      'content': 'Il est recommandé de lever les mains à chaque Takbir (Takbirat al-Intiqal), et trois fois au début (Takbirat al-Ihram).',
      'content_ar': 'يستحب رفع اليدين عند كل تكبيرة، خاصة في افتتاح الصلاة ثلاثا',
      'scholar_comments': 'Le lever de mains est considéré comme un embellissement de la prière.',
      'school_id': shJafari
    });
    await db.insert('sources', {
      'law_id': lawJafari,
      'type': 1, // Hadith
      'reference': 'Wasa\'il al-Shia, Vol 6, p. 28',
      'text': 'L\'Imam al-Sadiq a dit : "Levez vos mains lors de chaque Takbir."',
      'text_ar': 'عن أبي عبد الله عليه السلام قال: ارفع يديك في كل تكبيرة',
      'authenticity': 1, // Hasan (contextual)
      'citation': 'Wasa\'il al-Shia, Kitab al-Salat'
    });

    // Mahr (Dot) - Maliki Example
    int lawMahrMaliki = await db.insert('laws', {
      'topic_id': topMahr,
      'title': 'Position Maliki sur la Dot',
      'content': 'La dot est une condition essentielle du mariage. Elle ne peut être inférieure à un quart de dinar d\'or ou trois dirhams d\'argent.',
      'content_ar': 'الصداق شرط في صحة النكاح، وأقله ربع دينار أو ثلاثة دراهم',
      'scholar_comments': 'La dot doit avoir une valeur minimale pour garantir la dignité du contrat.',
      'school_id': shMaliki
    });
    await db.insert('sources', {
      'law_id': lawMahrMaliki,
      'type': 0, // Quran
      'reference': 'Sourate An-Nisa (4), Verset 4',
      'text': 'Et donnez aux épouses leur dot, de bonne grâce.',
      'text_ar': 'وَآتُوا النِّسَاءَ صَدُقَاتِهِنَّ نِحْلَةً',
      'authenticity': 4,
      'citation': 'Le Saint Coran'
    });
    await db.insert('sources', {
      'law_id': lawMahrMaliki,
      'type': 2, // Fiqh Book
      'reference': 'Mukhtasar Khalil, Chapitre du Mariage',
      'text': 'Le minimum de la dot est de trois dirhams purs ou un quart de dinar.',
      'text_ar': 'أقل الصداق ثلاثة دراهم خالصة أو ربع دينار',
      'authenticity': 4,
      'citation': 'Mukhtasar Khalil, p. 95'
    });

    // Riba - General Prohibiton
    int lawRibaShafii = await db.insert('laws', {
      'topic_id': topRiba,
      'title': 'Position Shafi\'i sur le Riba',
      'content': 'Le Riba est strictement interdit dans l\'Islam. Il concerne l\'intérêt sur les prêts et l\'inégalité dans l\'échange de certains biens.',
      'content_ar': 'الربا محرم شرعا وهو من الكبائر',
      'scholar_comments': 'L\'interdiction est absolue selon le consensus des savants.',
      'school_id': shShafii
    });
    await db.insert('sources', {
      'law_id': lawRibaShafii,
      'type': 0, // Quran
      'reference': 'Sourate Al-Baqarah (2), Verset 275',
      'text': 'Alors qu\'Allah a rendu licite le commerce, et illicite l\'intérêt (le Riba).',
      'text_ar': 'وَأَحَلَّ اللَّهُ الْبَيْعَ وَحَرَّمَ الرِّبَا',
      'authenticity': 4,
      'citation': 'Le Saint Coran'
    });
    await db.insert('sources', {
      'law_id': lawRibaShafii,
      'type': 1, // Hadith
      'reference': 'Sahih Muslim, Hadith 1598',
      'text': 'Le Messager d\'Allah a maudit celui qui consomme le Riba, celui qui le donne, celui qui l\'écrit et les deux témoins.',
      'text_ar': 'لعن رسول الله صلى الله عليه وسلم آكل الربا وموكله وكاتبه وشاهديه',
      'authenticity': 0, // Sahih
      'citation': 'Muslim, Kitab al-Musaqat'
    });

    // Topic: Le Témoignage
    int topWitness = await db.insert('topics', {
      'category_id': catQada,
      'title': 'Le Témoignage (Shahada)',
      'description': 'Les conditions pour qu\'un témoignage soit accepté devant un juge.'
    });

    int lawWitnessMaliki = await db.insert('laws', {
      'topic_id': topWitness,
      'title': 'Position Maliki sur le Témoignage',
      'content': 'Le témoin doit être juste (\'Adl), pubère, et ne pas avoir de lien de parenté direct ou d\'intérêt avec l\'une des parties.',
      'content_ar': 'يشترط في الشاهد العدالة والحرية والبلوغ',
      'scholar_comments': 'La justice du témoin est au cœur de la procédure judiciaire Maliki.',
      'school_id': shMaliki
    });
    await db.insert('sources', {
      'law_id': lawWitnessMaliki,
      'type': 0, // Quran
      'reference': 'Sourate Al-Baqarah (2), Verset 282',
      'text': 'Et faites-en témoigner par deux témoins d\'entre vos hommes.',
      'text_ar': 'وَاسْتَشْهِدُوا شَهِيدَيْنِ مِنْ رِجَالِكُمْ',
      'authenticity': 4,
      'citation': 'Le Saint Coran'
    });

    // Topic: La Sincérité
    int topSincerity = await db.insert('topics', {
      'category_id': catIkhlas,
      'title': 'L\'Importance de l\'Intention',
      'description': 'La place de l\'intention (Niyya) dans les actes d\'adoration.'
    });

    int lawSincerityHanafi = await db.insert('laws', {
      'topic_id': topSincerity,
      'title': 'Position Hanafi sur l\'Intention',
      'content': 'L\'intention est nécessaire pour distinguer l\'adoration de l\'habitude, mais elle n\'est pas toujours une condition de validité pour certains actes comme le remboursement d\'une dette.',
      'content_ar': 'النية شرط في العبادات لتمييزها عن العادات',
      'scholar_comments': 'L\'école Hanafi met l\'accent sur la finalité de l\'acte.',
      'school_id': shHanafi
    });
    await db.insert('sources', {
      'law_id': lawSincerityHanafi,
      'type': 1, // Hadith
      'reference': 'Sahih Bukhari, Hadith 1',
      'text': 'Les actions ne valent que par les intentions.',
      'text_ar': 'إنما الأعمال بالنيات',
      'authenticity': 0, // Sahih
      'citation': 'Bukhari, Bad\' al-Wahy'
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
