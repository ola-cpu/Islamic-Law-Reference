import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category.dart';
import '../models/topic.dart';
import '../models/law.dart';
import '../models/source.dart';
import '../models/school.dart';
import '../models/media_item.dart';
import '../data/extra_topics_seed.dart';
import 'search_synonyms.dart';
import 'content_json_loader.dart';
import 'content_locale_service.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static String? _testDatabaseName;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  @visibleForTesting
  static void setTestDatabaseName(String? name) {
    _testDatabaseName = name;
  }

  @visibleForTesting
  Future<void> closeForTesting() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbName = _testDatabaseName ?? 'islamic_law.db';
    String path;
    if (kIsWeb) {
      path = dbName;
    } else {
      path = join(await getDatabasesPath(), dbName);
    }
    return await openDatabase(
      path,
      version: 21,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 18) {
          await _dropTables(db, dropUserData: false);
          await _onCreate(db, newVersion);
        } else {
          if (oldVersion < 19) await _rebuildTopicsFts(db);
          if (oldVersion < 20) await _migrateToV20(db);
          if (oldVersion < 21) await _migrateToV21(db);
        }
      },
    );
  }

  Future<void> _dropTables(Database db, {bool dropUserData = false}) async {
    await db.execute('DROP TABLE IF EXISTS media');
    await db.execute('DROP TABLE IF EXISTS related_topics');
    await db.execute('DROP TABLE IF EXISTS topic_tags');
    await db.execute('DROP TABLE IF EXISTS tags');
    await db.execute('DROP TABLE IF EXISTS sources');
    await db.execute('DROP TABLE IF EXISTS laws');
    await db.execute('DROP TABLE IF EXISTS topics');
    await db.execute('DROP TABLE IF EXISTS categories');
    await db.execute('DROP TABLE IF EXISTS schools');
    if (dropUserData) {
      await db.execute('DROP TABLE IF EXISTS favorites');
      await db.execute('DROP TABLE IF EXISTS notes');
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parent_id INTEGER,
        name TEXT,
        name_en TEXT,
        name_ar TEXT,
        name_ru TEXT,
        name_zh TEXT,
        icon TEXT,
        image_url TEXT,
        FOREIGN KEY (parent_id) REFERENCES categories (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS schools(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        name_en TEXT,
        name_ar TEXT,
        name_ru TEXT,
        name_zh TEXT,
        description TEXT,
        description_en TEXT,
        description_ar TEXT,
        description_ru TEXT,
        description_zh TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS topics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        title TEXT,
        title_en TEXT,
        title_ar TEXT,
        title_ru TEXT,
        title_zh TEXT,
        description TEXT,
        description_en TEXT,
        description_ar TEXT,
        description_ru TEXT,
        description_zh TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS laws(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER,
        title TEXT,
        title_en TEXT,
        title_ar TEXT,
        title_ru TEXT,
        title_zh TEXT,
        content TEXT,
        content_en TEXT,
        content_ar TEXT,
        content_ru TEXT,
        content_zh TEXT,
        scholar_comments TEXT,
        scholar_comments_en TEXT,
        scholar_comments_ar TEXT,
        scholar_comments_ru TEXT,
        scholar_comments_zh TEXT,
        school_id INTEGER,
        FOREIGN KEY (topic_id) REFERENCES topics (id),
        FOREIGN KEY (school_id) REFERENCES schools (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sources(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        law_id INTEGER,
        type INTEGER,
        reference TEXT,
        reference_en TEXT,
        reference_ar TEXT,
        reference_ru TEXT,
        reference_zh TEXT,
        text TEXT,
        text_en TEXT,
        text_ar TEXT,
        text_ru TEXT,
        text_zh TEXT,
        authenticity INTEGER,
        citation TEXT,
        citation_en TEXT,
        citation_ar TEXT,
        citation_ru TEXT,
        citation_zh TEXT,
        isnad TEXT,
        FOREIGN KEY (law_id) REFERENCES laws (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER UNIQUE,
        FOREIGN KEY (topic_id) REFERENCES topics (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER UNIQUE,
        content TEXT,
        FOREIGN KEY (topic_id) REFERENCES topics (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS media(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER,
        type INTEGER,
        url TEXT,
        title TEXT,
        description TEXT,
        FOREIGN KEY (topic_id) REFERENCES topics (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tags(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS topic_tags(
        topic_id INTEGER,
        tag_id INTEGER,
        FOREIGN KEY (topic_id) REFERENCES topics (id),
        FOREIGN KEY (tag_id) REFERENCES tags (id),
        PRIMARY KEY (topic_id, tag_id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS related_topics(
        topic_id INTEGER,
        related_id INTEGER,
        FOREIGN KEY (topic_id) REFERENCES topics (id),
        FOREIGN KEY (related_id) REFERENCES topics (id),
        PRIMARY KEY (topic_id, related_id)
      )
    ''');

    await _seedDatabase(db);
    await ContentJsonLoader.loadAllRegisteredBatches(db);
    await _rebuildTopicsFts(db);
  }

  Future<void> _migrateToV20(Database db) async {
    try {
      await db.execute('ALTER TABLE sources ADD COLUMN isnad TEXT');
    } catch (_) {
      // Colonne déjà présente.
    }
    await ContentJsonLoader.loadAssetBatch(db, 'assets/content/topics_batch_1.json', metaKey: 'batch_1');
    await _rebuildTopicsFts(db);
  }

  Future<void> _migrateToV21(Database db) async {
    await ContentJsonLoader.loadAllRegisteredBatches(db);
    await _rebuildTopicsFts(db);
  }

  Future<void> _ensureFtsTable(Database db) async {
    await db.execute('''
      CREATE VIRTUAL TABLE IF NOT EXISTS topics_fts USING fts5(
        topic_id UNINDEXED,
        search_text,
        tokenize='unicode61 remove_diacritics 2'
      );
    ''');
  }

  Future<void> _rebuildTopicsFts(Database db) async {
    await _ensureFtsTable(db);
    await db.execute('DELETE FROM topics_fts');
    final topics = await db.query('topics');
    for (final row in topics) {
      final parts = <String>[
        row['title'] as String? ?? '',
        row['description'] as String? ?? '',
        row['title_en'] as String? ?? '',
        row['description_en'] as String? ?? '',
        row['title_ar'] as String? ?? '',
        row['description_ar'] as String? ?? '',
        row['title_ru'] as String? ?? '',
        row['description_ru'] as String? ?? '',
        row['title_zh'] as String? ?? '',
        row['description_zh'] as String? ?? '',
      ];
      await db.insert('topics_fts', {
        'topic_id': row['id'],
        'search_text': parts.where((p) => p.isNotEmpty).join(' '),
      });
    }
  }

  Future _seedDatabase(Database db) async {
    // Images locales via gradients UI — pas d'URL externes (100 % offline).
    const String imgPrayer = '';
    const String imgFasting = '';
    const String imgFamily = '';
    const String imgMarriage = '';
    const String imgEconomy = '';
    const String imgJustice = '';
    const String imgEthics = '';
    const String imgFood = '';
    const String imgContracts = '';
    const String imgRights = '';
    const String imgInheritance = '';

    // Schools
    int shHanafi = await db.insert('schools', {
      'name': 'Hanafi', 'name_en': 'Hanafi', 'name_ar': 'حنفي', 'name_ru': 'Ханафитский', 'name_zh': '哈乃斐',
      'description': 'L\'école de l\'Imam Abu Hanifa.', 'description_en': 'The school of Imam Abu Hanifa.'
    });
    int shMaliki = await db.insert('schools', {
      'name': 'Maliki', 'name_en': 'Maliki', 'name_ar': 'مالكي', 'name_ru': 'Маликитский', 'name_zh': '马立克',
      'description': 'L\'école de l\'Imam Malik.', 'description_en': 'The school of Imam Malik.'
    });
    int shShafii = await db.insert('schools', {
      'name': 'Shafi\'i', 'name_en': 'Shafi\'i', 'name_ar': 'شافعي', 'name_ru': 'Шафиитский', 'name_zh': '沙斐仪',
      'description': 'L\'école de l\'Imam Al-Shafi\'i.', 'description_en': 'The school of Imam Al-Shafi\'i.'
    });
    int shHanbali = await db.insert('schools', {
      'name': 'Hanbali', 'name_en': 'Hanbali', 'name_ar': 'حنبلي', 'name_ru': 'Ханбалитский', 'name_zh': '罕百里',
      'description': 'L\'école de l\'Imam Ahmad ibn Hanbal.', 'description_en': 'The school of Imam Ahmad ibn Hanbal.'
    });
    int shJafari = await db.insert('schools', {
      'name': 'Ja\'fari', 'name_en': 'Ja\'fari', 'name_ar': 'جعفري', 'name_ru': 'Джафаритский', 'name_zh': '贾法里',
      'description': 'L\'école de l\'Imam Ja\'far al-Sadiq.', 'description_en': 'The school of Imam Ja\'far al-Sadiq.'
    });

    // Categories
    int catCulte = await db.insert('categories', {
      'name': 'Prière et culte', 'name_en': 'Prayer and Worship', 'name_ar': 'الصلاة والعبادة', 'name_ru': 'Молитва и поклонение', 'name_zh': '祈祷与崇拜',
      'icon': 'mosque',
      'image_url': imgPrayer,
      'parent_id': null
    });
    int catJeune = await db.insert('categories', {
      'name': 'Jeûne, zakât et pèlerinage', 'name_en': 'Fasting, Zakat and Pilgrimage', 'name_ar': 'الصوم والزكاة والحج', 'name_ru': 'Пост, закят и паломничество', 'name_zh': '禁食、天课和朝觐',
      'icon': 'volunteer_activism',
      'image_url': imgFasting,
      'parent_id': null
    });
    int catFamille = await db.insert('categories', {
      'name': 'Relations sociales et familiales', 'name_en': 'Social and Family Relations', 'name_ar': 'العلاقات الاجتماعية والأسرية', 'name_ru': 'Социальные и семейные отношения', 'name_zh': '社会与家庭关系',
      'icon': 'people',
      'image_url': imgFamily,
      'parent_id': null
    });
    int catMariage = await db.insert('categories', {
      'name': 'Mariage, divorce et garde des enfants', 'name_en': 'Marriage, Divorce and Child Custody', 'name_ar': 'الزواج والطلاق وحضانة الأطفال', 'name_ru': 'Брак, развод и опека над детьми', 'name_zh': '婚姻、离婚和子女抚养',
      'icon': 'family_restroom',
      'image_url': imgMarriage,
      'parent_id': null
    });
    int catEconomie = await db.insert('categories', {
      'name': 'Économie, finance et commerce', 'name_en': 'Economy, Finance and Trade', 'name_ar': 'الاقتصاد والمالية والتجارة', 'name_ru': 'Экономика, финансы и торговля', 'name_zh': '经济、金融与贸易',
      'icon': 'monetization_on',
      'image_url': imgEconomy,
      'parent_id': null
    });
    int catJustice = await db.insert('categories', {
      'name': 'Justice et gouvernance', 'name_en': 'Justice and Governance', 'name_ar': 'العدل والحكم', 'name_ru': 'Правосудие и управление', 'name_zh': '司法与治理',
      'icon': 'gavel',
      'image_url': imgJustice,
      'parent_id': null
    });
    int catEthique = await db.insert('categories', {
      'name': 'Éthique et spiritualité', 'name_en': 'Ethics and Spirituality', 'name_ar': 'الأخلاق والروحانية', 'name_ru': 'Этика и духовность', 'name_zh': '伦理与灵性',
      'icon': 'favorite',
      'image_url': imgEthics,
      'parent_id': null
    });
    int catAlimentation = await db.insert('categories', {
      'name': 'Alimentation et règles de pureté', 'name_en': 'Food and Purity Rules', 'name_ar': 'الغذاء وقواعد الطهارة', 'name_ru': 'Питание и правила чистоты', 'name_zh': '饮食与纯净规则',
      'icon': 'restaurant',
      'image_url': imgFood,
      'parent_id': null
    });
    int catContrats = await db.insert('categories', {
      'name': 'Les contrats et engagements', 'name_en': 'Contracts and Commitments', 'name_ar': 'العقود والالتزامات', 'name_ru': 'Контракты и обязательства', 'name_zh': '合同与承诺',
      'icon': 'description',
      'image_url': imgContracts,
      'parent_id': null
    });
    int catDroits = await db.insert('categories', {
      'name': 'Les droits et devoirs individuels', 'name_en': 'Individual Rights and Duties', 'name_ar': 'الحقوق والواجبات الفردية', 'name_ru': 'Индивидуальные права и обязанности', 'name_zh': '个人权利与义务',
      'icon': 'accessibility',
      'image_url': imgRights,
      'parent_id': null
    });
    int catHeritage = await db.insert('categories', {
      'name': 'Héritage et succession (Farāʾiḍ)', 'name_en': 'Inheritance and Succession', 'name_ar': 'الميراث والوصية', 'name_ru': 'Наследование и преемственность', 'name_zh': '继承与继承',
      'icon': 'account_balance',
      'image_url': imgInheritance,
      'parent_id': null
    });

    // Sub-categories for Prayer
    int subAblutions = await db.insert('categories', {
      'name': 'Ablutions (Wudu\')', 'name_en': 'Ablutions (Wudu\')', 'name_ar': 'الوضوء', 'icon': 'water_drop', 'parent_id': catCulte
    });
    int subGhusl = await db.insert('categories', {
      'name': 'Grandes ablutions (Ghusl)', 'name_en': 'Full Ablution (Ghusl)', 'name_ar': 'الغسل', 'icon': 'shower', 'parent_id': catCulte
    });
    int subTayammum = await db.insert('categories', {
      'name': 'Ablution sèche (Tayammum)', 'name_en': 'Dry Ablution (Tayammum)', 'name_ar': 'التيمم', 'icon': 'landscape', 'parent_id': catCulte
    });
    int subPriereObligatoire = await db.insert('categories', {
      'name': 'Prières obligatoires', 'name_en': 'Obligatory Prayers', 'name_ar': 'الصلوات المفروضة', 'icon': 'mosque', 'parent_id': catCulte
    });
    int subPriereVoyageur = await db.insert('categories', {
      'name': 'Prière du voyageur', 'name_en': 'Traveler\'s Prayer', 'name_ar': 'صلاة المسافر', 'icon': 'flight', 'parent_id': catCulte
    });

    // Sub-categories for Marriage
    int subContratMariage = await db.insert('categories', {
      'name': 'Contrat de mariage', 'name_en': 'Marriage Contract', 'name_ar': 'عقد النكاح', 'icon': 'description', 'parent_id': catMariage
    });
    int subMahr = await db.insert('categories', {
      'name': 'La dot (Mahr)', 'name_en': 'Dowry (Mahr)', 'name_ar': 'المهر', 'icon': 'payments', 'parent_id': catMariage
    });
    int subDivorce = await db.insert('categories', {
      'name': 'Divorce (Talaq)', 'name_en': 'Divorce (Talaq)', 'name_ar': 'الطلاق', 'icon': 'unfold_less', 'parent_id': catMariage
    });

    // Sub-categories for Economy
    int subZakat = await db.insert('categories', {
      'name': 'Zakat', 'name_en': 'Zakat', 'name_ar': 'الزكاة', 'icon': 'volunteer_activism', 'parent_id': catJeune
    });
    int subFinance = await db.insert('categories', {
      'name': 'Finance et Intérêts', 'name_en': 'Finance and Interest', 'name_ar': 'المالية والربا', 'icon': 'trending_up', 'parent_id': catEconomie
    });

    // --- PRAYER AND WORSHIP ---
    // Tags
    int tagPurity = await db.insert('tags', {'name': 'Pureté'});
    int tagPrayer = await db.insert('tags', {'name': 'Prière'});
    int tagObligation = await db.insert('tags', {'name': 'Obligation'});

    // Ablutions (Wudu)
    int topWuduConditions = await db.insert('topics', {
      'category_id': subAblutions,
      'title': 'Conditions de validité du wuḍū’', 'title_en': 'Conditions of validity of Wuḍū’', 'title_ar': 'شروط صحة الوضوء',
      'description': 'Les prérequis nécessaires pour que les ablutions soient acceptées en Islam.',
    });
    await db.insert('topic_tags', {'topic_id': topWuduConditions, 'tag_id': tagPurity});

    // Hanafi Position on Wudu
    int lawWuduHanafi = await db.insert('laws', {
      'topic_id': topWuduConditions, 'school_id': shHanafi,
      'title': 'Position Hanafi', 'content': 'Quatre obligations : laver le visage, les bras jusqu\'aux coudes, passer les mains mouillées sur le quart de la tête, et laver les pieds jusqu\'aux chevilles.',
      'content_ar': 'فروض الوضوء أربعة: غسل الوجه، وغسل اليدين مع المرفقين، ومسح ربع الرأس، وغسل الرجلين مع الكعبين.',
    });
    await db.insert('sources', {
      'law_id': lawWuduHanafi, 'type': 0, 'reference': 'Coran 5:6',
      'text': 'Ô les croyants ! Lorsque vous vous levez pour la Salat, lavez vos visages et vos mains jusqu\'aux coudes; passez les mains mouillées sur vos têtes; et lavez-vous les pieds jusqu\'aux chevilles.',
      'text_ar': 'يَا أَيُّهَا الَّذِينَ آمَنُوا إِذَا قُمْتُمْ إِلَى الصَّلَاةِ فَاغْسِلُوا وُجُوهَكُمْ وَأَيْدِيَكُمْ إِلَى الْمَرَافِقِ وَامْسَحُوا بِرُءُوسِكُمْ وَأَرْجُلَكُمْ إِلَى الْكَعْبَيْنِ',
      'authenticity': 0
    });

    // Shafi'i Position on Wudu (adds Intention and Order)
    await db.insert('laws', {
      'topic_id': topWuduConditions, 'school_id': shShafii,
      'title': 'Position Shafi\'i', 'content': 'Six obligations : l\'intention, laver le visage, les bras, passer les mains sur une partie de la tête, les pieds, et respecter l\'ordre.',
      'content_ar': 'فروض الوضوء ستة: النية، وغسل الوجه، وغسل اليدين، ومسح شيء من الرأس، وغسل الرجلين، والترتيب.',
    });

    // Nullifiers of Wudu
    int topWuduNullifiers = await db.insert('topics', {
      'category_id': subAblutions,
      'title': 'Annulations du wuḍū’', 'title_en': 'Nullifiers of Wuḍū’', 'title_ar': 'نواقض الوضوء',
      'description': 'Les actes et situations qui invalident les ablutions.',
    });
    await db.insert('related_topics', {'topic_id': topWuduConditions, 'related_id': topWuduNullifiers});

    // Ghusl
    int topGhuslObligations = await db.insert('topics', {
      'category_id': subGhusl,
      'title': 'Obligations du Ghusl', 'title_en': 'Obligations of Ghusl', 'title_ar': 'فرائض الغسل',
      'description': 'Les piliers essentiels pour que le bain rituel soit valide.',
    });
    await db.insert('laws', {
      'topic_id': topGhuslObligations, 'school_id': shShafii,
      'title': 'Position Shafi\'i', 'content': 'Deux obligations : l\'intention et laver tout le corps (y compris les cheveux et la peau).',
      'content_ar': 'فروض الغسل اثنان: النية، وتعميم البدن بالماء.',
    });

    // Traveler's Prayer
    int topTravelPrayer = await db.insert('topics', {
      'category_id': subPriereVoyageur,
      'title': 'Le raccourcissement de la prière (Qasr)', 'title_en': 'Shortening of Prayer (Qasr)', 'title_ar': 'قصر الصلاة',
      'description': 'La permission de raccourcir les prières de quatre rak\'ats à deux pendant un voyage.',
    });
    await db.insert('laws', {
      'topic_id': topTravelPrayer, 'school_id': shHanafi,
      'title': 'Position Hanafi', 'content': 'Le raccourcissement est une obligation (Wajib) pour le voyageur.',
      'content_ar': 'القصر واجب على المسافر، ولا يجوز له الإتمام.',
    });
    await db.insert('laws', {
      'topic_id': topTravelPrayer, 'school_id': shShafii,
      'title': 'Position Shafi\'i', 'content': 'Le raccourcissement est une permission (Rukhsa), l\'individu a le choix.',
      'content_ar': 'القصر رخصة للمسافر، والإتمام جائز.',
    });

    // --- FASTING AND ZAKAT ---
    // Zakat
    int topZakatNisab = await db.insert('topics', {
      'category_id': subZakat,
      'title': 'Le Nisab de la Zakat', 'title_en': 'Nisab of Zakat', 'title_ar': 'نصاب الزكاة',
      'description': 'Le seuil minimal de richesse à partir duquel la Zakat devient obligatoire.',
    });
    int lawZakatHanafi = await db.insert('laws', {
      'topic_id': topZakatNisab, 'school_id': shHanafi,
      'title': 'Nisab de l\'or et de l\'argent', 'content': 'Le Nisab est de 85g d\'or ou 595g d\'argent. La Zakat est de 2,5% après un an de possession.',
      'content_ar': 'نصاب الذهب 85 جراماً، والفضة 595 جراماً، والقدر الواجب 2.5%.',
    });

    // Fasting Intention
    int topRamadanIntention = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'Intention du jeûne', 'title_en': 'Intention for Fasting', 'title_ar': 'نية الصيام',
      'description': 'L\'obligation de formuler l\'intention pour le jeûne de Ramadan.',
    });
    await db.insert('laws', {
      'topic_id': topRamadanIntention, 'school_id': shShafii,
      'title': 'Position Shafi\'i', 'content': 'L\'intention doit être renouvelée chaque nuit avant l\'aube.',
      'content_ar': 'يجب تبييت النية كل ليلة في صوم الفرض.',
    });
    await db.insert('laws', {
      'topic_id': topRamadanIntention, 'school_id': shMaliki,
      'title': 'Position Maliki', 'content': 'Une seule intention au début du mois de Ramadan suffit pour tout le mois.',
      'content_ar': 'تكفي نية واحدة في أول شهر رمضان لصوم الشهر كله.',
    });

    // --- MARRIAGE AND FAMILY ---
    // Marriage Contract
    int topNikahConditions = await db.insert('topics', {
      'category_id': subContratMariage,
      'title': 'Piliers du contrat de mariage', 'title_en': 'Pillars of Marriage Contract', 'title_ar': 'أركان عقد النكاح',
      'description': 'Les éléments essentiels sans lesquels le mariage est nul.',
    });
    await db.insert('laws', {
      'topic_id': topNikahConditions, 'school_id': shShafii,
      'title': 'Position Shafi\'i', 'content': 'Cinq piliers : l\'époux, l\'épouse, le tuteur (Wali), deux témoins et la formule (Ijab et Qabul).',
      'content_ar': 'أركان النكاح خمسة: زوج، وزوجة، وولي، وشاهدان، وصيغة.',
    });
    await db.insert('laws', {
      'topic_id': topNikahConditions, 'school_id': shHanafi,
      'title': 'Position Hanafi', 'content': 'Le pilier principal est la formule (Ijab et Qabul). La présence du tuteur n\'est pas une condition de validité pour une femme majeure et saine d\'esprit.',
      'content_ar': 'الركن هو الإيجاب والقبول. والولي ليس شرطاً لصحة نكاح الحرة العاقلة البالغة.',
    });

    // Mahr
    int topMahrRules = await db.insert('topics', {
      'category_id': subMahr,
      'title': 'Règles de la dot (Mahr)', 'title_en': 'Rules of Mahr', 'title_ar': 'أحكام المهر',
      'description': 'Le Mahr est un don obligatoire du mari à son épouse.',
    });
    await db.insert('laws', {
      'topic_id': topMahrRules, 'school_id': shShafii,
      'title': 'Obligation', 'content': 'Le Mahr est obligatoire par le simple fait du contrat, même s\'il n\'est pas mentionné.',
      'content_ar': 'المهر واجب بالعقد، ويستقر بالدخول.',
    });
    await db.insert('topic_tags', {'topic_id': topMahrRules, 'tag_id': tagObligation});
    await db.insert('related_topics', {'topic_id': topNikahConditions, 'related_id': topMahrRules});

    // --- ECONOMY AND FINANCE ---
    // Riba
    int topRibaDetailed = await db.insert('topics', {
      'category_id': subFinance,
      'title': 'Les types de Riba', 'title_en': 'Types of Riba', 'title_ar': 'أنواع الربا',
      'description': 'Distinction entre Riba al-Fadl et Riba al-Nasi\'ah.',
    });
    await db.insert('laws', {
      'topic_id': topRibaDetailed, 'school_id': shHanafi,
      'title': 'Riba al-Nasi\'ah', 'content': 'C\'est l\'intérêt stipulé sur un prêt ou un délai de paiement. Il est strictement interdit.',
      'content_ar': 'ربا النسيئة هو الزيادة المشروطة مقابل الأجل.',
    });
    await db.insert('sources', {
      'law_id': (await db.query('laws', where: 'topic_id = ?', whereArgs: [topRibaDetailed])).first['id'] as int,
      'type': 0, 'reference': 'Coran 2:275', 'text': 'Allah a rendu licite le commerce, et illicite l\'intérêt (Riba).',
      'text_ar': 'وَأَحَلَّ اللَّهُ الْبَيْعَ وَحَرَّمَ الرِّبَا', 'authenticity': 0
    });

    // --- Enriched Content (v9) ---

    // 1. Social Relations: Respect for Parents
    int topParents = await db.insert('topics', {
      'category_id': catFamille,
      'title': 'Le respect des parents (Birr al-Walidayn)', 'title_en': 'Respect for Parents', 'title_ar': 'بر الوالدين',
      'description': 'L\'obligation religieuse de traiter ses parents avec bonté, respect et obéissance. C\'est un pilier de la morale islamique.',
      'description_en': 'The religious obligation to treat parents with kindness, respect, and obedience.'
    });
    int lawParents = await db.insert('laws', {
      'topic_id': topParents,
      'title': 'Consensus', 'title_en': 'Consensus', 'title_ar': 'الإجماع',
      'content': 'Il est unanimement obligatoire de traiter ses parents avec excellence (Ihsan), de subvenir à leurs besoins s\'ils sont nécessiteux et de leur obéir dans tout ce qui ne contredit pas les ordres d\'Allah.',
      'content_ar': 'يجب على الولد بر والديه والإحسان إليهما وطاعتهما في غير معصية الله.',
      'scholar_comments': 'L\'obéissance aux parents est conditionnée par l\'absence de désobéissance au Créateur.',
      'scholar_comments_en': 'Obedience to parents is conditioned by the absence of disobedience to the Creator.',
      'school_id': shShafii
    });
    await db.insert('sources', {
      'law_id': lawParents,
      'type': 0, 'reference': 'Coran, 17:23', 'text': 'Et ton Seigneur a décrété : « N\'adorez que Lui ; et (marquez) de la bonté envers les pères et mères... »',
      'text_ar': 'وَقَضَىٰ رَبُّكَ أَلَّا تَعْبُدُوا إِلَّا إِيَّاهُ وَبِالْوَالِدَيْنِ إِحْسَانًا', 'authenticity': 0
    });
    await db.insert('sources', {
      'law_id': lawParents,
      'type': 1, 'reference': 'Bukhari 5977', 'text': 'Le Prophète a cité la désobéissance aux parents parmi les péchés majeurs.',
      'text_ar': 'عَنْ النَّبِيِّ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ قَالَ: الْكَبَائِرُ الإِشْرَاكُ بِاللَّهِ، وَعُقُوقُ الْوَالِدَيْنِ', 'authenticity': 0
    });

    // 2. Economy: Riba
    int topRiba = await db.insert('topics', {
      'category_id': catEconomie,
      'title': 'Prohibition de l\'usure (Riba)', 'title_en': 'Prohibition of Riba', 'title_ar': 'تحريم الربا',
      'description': 'L\'interdiction stricte de l\'usure et des intérêts dans les transactions financières. Le Riba est considéré comme une injustice sociale.',
      'description_en': 'The strict prohibition of usury and interest in financial transactions.'
    });
    int lawRiba = await db.insert('laws', {
      'topic_id': topRiba,
      'title': 'Consensus', 'title_en': 'Consensus', 'title_ar': 'الإجماع',
      'content': 'Le Riba est formellement interdit sous toutes ses formes. C\'est un péché majeur qui invalide les contrats. Cas pratique : Tout prêt stipulant un intérêt, même minime, est considéré comme Riba.',
      'content_ar': 'الربا محرم شرعاً وهو من الكبائر، ويشمل ربا الفضل وربا النسيئة.',
      'scholar_comments': 'La sagesse derrière cette interdiction est d\'empêcher l\'exploitation et de favoriser l\'économie réelle.',
      'school_id': shHanafi
    });
    await db.insert('sources', {
      'law_id': lawRiba,
      'type': 0, 'reference': 'Coran, 2:275', 'text': 'Allah a rendu licite le commerce, et illicite l\'intérêt (Riba).',
      'text_ar': 'وَأَحَلَّ اللَّهُ الْبَيْعَ وَحَرَّمَ الرِّبَا', 'authenticity': 0 // Sahih
    });

    // 3. Justice: Truthful Testimony
    int topJustice = await db.insert('topics', {
      'category_id': catJustice,
      'title': 'Le témoignage véridique', 'title_en': 'Truthful Testimony', 'title_ar': 'شهادة الحق',
      'description': 'L\'importance de porter un témoignage honnête devant la justice.',
      'description_en': 'The importance of bearing honest testimony before justice.'
    });
    int lawJustice = await db.insert('laws', {
      'topic_id': topJustice,
      'title': 'Obligation', 'title_en': 'Obligation', 'title_ar': 'الوجوب',
      'content': 'Porter témoignage est une obligation communautaire (Fard Kifaya). Le faux témoignage est un crime grave.',
      'content_ar': 'الشهادة واجبة عند الحاجة إليها، وشهادة الزور من أكبر الكبائر.',
      'school_id': shMaliki
    });
    await db.insert('sources', {
      'law_id': lawJustice,
      'type': 0, 'reference': 'Coran, 4:135', 'text': 'Ô les croyants ! Observez strictement la justice et soyez des témoins (véridiques) pour l\'amour d\'Allah...',
      'text_ar': 'يَا أَيُّهَا الَّذِينَ آمَنُوا كُونُوا قَوَّامِينَ بِالْقِسْطِ شُهَدَاءَ لِلَّهِ', 'authenticity': 0
    });

    // 4. Ethics: Truthfulness
    int topEthics = await db.insert('topics', {
      'category_id': catEthique,
      'title': 'La véracité (As-Sidq)', 'title_en': 'Truthfulness', 'title_ar': 'الصدق',
      'description': 'La vertu de dire la vérité en toutes circonstances.',
      'description_en': 'The virtue of telling the truth in all circumstances.'
    });
    int lawEthics = await db.insert('laws', {
      'topic_id': topEthics,
      'title': 'Vertu', 'title_en': 'Virtue', 'title_ar': 'فضيلة',
      'content': 'Le musulman doit s\'attacher à la véracité dans ses paroles et ses actes.',
      'content_ar': 'يجب على المسلم التزام الصدق في القول والعمل.',
      'school_id': shHanbali
    });
    await db.insert('sources', {
      'law_id': lawEthics,
      'type': 1, 'reference': 'Bukhari 6094', 'text': 'La véracité mène à la piété, et la piété mène au Paradis.',
      'text_ar': 'عَلَيْكُمْ بِالصِّدْقِ فَإِنَّ الصِّدْقَ يَهْدِي إِلَى الْبِرِّ وَإِنَّ الْبِرَّ يَهْدِي إِلَى الْجَنَّةِ', 'authenticity': 0
    });

    // 5. Food: Ritual Slaughter
    int topFood = await db.insert('topics', {
      'category_id': catAlimentation,
      'title': 'L\'abattage rituel (Dhabihah)', 'title_en': 'Ritual Slaughter', 'title_ar': 'الذكاة الشرعية',
      'description': 'Les conditions pour que la viande d\'un animal soit licite.',
      'description_en': 'Conditions for animal meat to be lawful.'
    });
    await db.insert('laws', {
      'topic_id': topFood,
      'title': 'Hanafi', 'title_en': 'Hanafi', 'title_ar': 'حنفي',
      'content': 'Mentionner le nom d\'Allah (Tasmiya) est obligatoire.',
      'content_ar': 'التسمية شرط عند الذبح، فإن تركها عمداً لم تؤكل الذبيحة.',
      'school_id': shHanafi
    });
    await db.insert('laws', {
      'topic_id': topFood,
      'title': 'Shafi\'i', 'title_en': 'Shafi\'i', 'title_ar': 'شافعي',
      'content': 'La Tasmiya est une Sunnah recommandée mais pas une condition de validité.',
      'content_ar': 'التسمية سنة وليست شرطاً لصحة الذبح، فلو تركها حلت الذبيحة.',
      'school_id': shShafii
    });

    // 6. Contracts: Sales
    int topContracts = await db.insert('topics', {
      'category_id': catContrats,
      'title': 'Le contrat de vente (Al-Bay\')', 'title_en': 'Sales Contract', 'title_ar': 'عقد البيع',
      'description': 'Les piliers de validité d\'une transaction commerciale.',
      'description_en': 'Pillars of validity of a commercial transaction.'
    });
    int lawContracts = await db.insert('laws', {
      'topic_id': topContracts,
      'title': 'Consentement', 'title_en': 'Consent', 'title_ar': 'التراضي',
      'content': 'Le consentement des deux parties est la base de la validité.',
      'content_ar': 'الرضا بين المتبايعين هو أساس صحة البيع.',
      'school_id': shHanafi
    });
    await db.insert('sources', {
      'law_id': lawContracts,
      'type': 0, 'reference': 'Coran, 4:29', 'text': '...à moins qu\'il ne s\'agisse d\'un commerce par consentement mutuel.',
      'text_ar': 'إِلَّا أَن تَكُونَ تِجَارَةً عَن تَرَاضٍ مِّنكُمْ', 'authenticity': 0
    });

    // 7. Rights: Life
    int topRights = await db.insert('topics', {
      'category_id': catDroits,
      'title': 'Le droit à la vie', 'title_en': 'Right to Life', 'title_ar': 'الحق في الحياة',
      'description': 'Le caractère sacré de la vie humaine.',
      'description_en': 'The sanctity of human life.'
    });
    int lawRights = await db.insert('laws', {
      'topic_id': topRights,
      'title': 'Sacralité', 'title_en': 'Sanctity', 'title_ar': 'حرمة النفس',
      'content': 'Porter atteinte à une vie innocente est l\'un des plus grands crimes.',
      'content_ar': 'حياة الإنسان مقدسة، والاعتداء عليها من أعظم الجرائم.',
      'school_id': shShafii
    });
    await db.insert('sources', {
      'law_id': lawRights,
      'type': 0, 'reference': 'Coran, 5:32', 'text': '...quiconque tue une person... c\'est comme s\'il avait tué tous les hommes.',
      'text_ar': 'مَن قَتَلَ نَفْسًا بِغَيْرِ نَفْسٍ أَوْ فَسَادٍ فِي الْأَرْضِ فَكَأَنَّمَا قَتَلَ النَّاسَ جَمِيعًا', 'authenticity': 0
    });

    // 8. Inheritance: Only Daughter
    int topInheritance = await db.insert('topics', {
      'category_id': catHeritage,
      'title': 'Part de la fille unique', 'title_en': 'Share of Only Daughter', 'title_ar': 'ميراث البنت الواحدة',
      'description': 'La part fixée pour une fille unique.',
      'description_en': 'Fixed share for an only daughter.'
    });
    await db.insert('laws', {
      'topic_id': topInheritance,
      'title': 'Sunnite', 'title_en': 'Sunni', 'title_ar': 'أهل السنة',
      'content': 'La fille unique reçoit la moitié (1/2) de l\'héritage.',
      'content_ar': 'للبنت الصلبية المنفردة النصف فرضاً، وما بقي فللعصبة.',
      'school_id': shMaliki
    });
    await db.insert('laws', {
      'topic_id': topInheritance,
      'title': 'Ja\'fari', 'title_en': 'Ja\'fari', 'title_ar': 'جعفري',
      'content': 'La fille unique reçoit la moitié par obligation, et le reste par Radd.',
      'content_ar': 'للبنت المنفردة النصف فرضاً، والباقي رداً.',
      'school_id': shJafari
    });

    // Food & Purity: Halal Meat
    int topHalalMeat = await db.insert('topics', {
      'category_id': catAlimentation,
      'title': 'Conditions de la viande Halal', 'title_en': 'Conditions of Halal Meat', 'title_ar': 'شروط اللحم الحلال',
      'description': 'Les critères pour qu\'un animal soit licite à la consommation.',
    });
    await db.insert('laws', {
      'topic_id': topHalalMeat, 'school_id': shShafii,
      'title': 'Position Shafi\'i', 'content': 'L\'animal doit être égorgé par un musulman ou une personne du Livre, en coupant la trachée et l\'œsophage.',
      'content_ar': 'يشترط ذكاة المسلم أو الكتابي بقطع الحلقوم والمريء.',
    });

    // Ethics: Truthfulness
    int topTruthfulness = await db.insert('topics', {
      'category_id': catEthique,
      'title': 'La sincérité (Ikhlas)', 'title_en': 'Sincerity (Ikhlas)', 'title_ar': 'الإخلاص',
      'description': 'L\'importance de l\'intention pure dans tous les actes d\'adoration.',
    });
    await db.insert('laws', {
      'topic_id': topTruthfulness, 'school_id': shShafii,
      'title': 'Consensus', 'content': 'Tout acte d\'adoration sans intention sincère pour Allah est nul ou sans récompense.',
      'content_ar': 'الإخلاص شرط لقبول الأعمال عند الله.',
    });

    // Rights: Neighbors
    int topNeighborRights = await db.insert('topics', {
      'category_id': catDroits,
      'title': 'Droits des voisins', 'title_en': 'Rights of Neighbors', 'title_ar': 'حقوق الجار',
      'description': 'Les obligations morales et sociales envers son voisinage.',
    });
    await db.insert('laws', {
      'topic_id': topNeighborRights, 'school_id': shMaliki,
      'title': 'Consensus', 'content': 'Il est interdit de nuire à son voisin, et recommandé de lui être bienfaisant.',
      'content_ar': 'حرمة أذية الجار ووجوب الإحسان إليه.',
    });
    await db.insert('sources', {
      'law_id': (await db.query('laws', where: 'topic_id = ?', whereArgs: [topNeighborRights])).first['id'] as int,
      'type': 1, 'reference': 'Bukhari 6016', 'text': 'Celui qui croit en Allah et au Jour dernier, qu\'il ne nuise pas à son voisin.',
      'text_ar': 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلا يُؤْذِ جَارَهُ', 'authenticity': 0
    });

    // --- TAYAMMUM ---
    int topTayammum = await db.insert('topics', {
      'category_id': subTayammum,
      'title': 'Conditions du Tayammum', 'title_en': 'Conditions of Tayammum', 'title_ar': 'شروط التيمم',
      'description': 'L\'ablution sèche en cas d\'absence d\'eau ou d\'impossibilité de l\'utiliser.',
    });
    int lawTayammumHanafi = await db.insert('laws', {
      'topic_id': topTayammum, 'school_id': shHanafi,
      'title': 'Hanafi', 'content': 'Le Tayammum est permis si l\'eau est à plus d\'un mille (env. 1.8km). On peut utiliser tout ce qui fait partie de la terre (sable, pierre, poussière).',
      'content_ar': 'يجوز التيمم إذا كان الماء بعيداً بمقدار ميل، ويجوز بكل ما كان من جنس الأرض.',
    });
    await db.insert('sources', {
      'law_id': lawTayammumHanafi, 'type': 2, 'reference': 'Al-Bahr al-Ra\'iq', 'text': 'La terre pure comprend tout ce qui ne brûle pas et ne fond pas.', 'citation': 'Ibn Nujaym, Vol 1, p. 150', 'authenticity': 4
    });

    // --- PRAYER PILLARS ---
    int topSalatPillars = await db.insert('topics', {
      'category_id': subPriereObligatoire,
      'title': 'Les piliers de la Salat', 'title_en': 'Pillars of Salat', 'title_ar': 'أركان الصلاة',
      'description': 'Les actes essentiels dont l\'omission invalide la prière.',
    });
    int lawSalatShafii = await db.insert('laws', {
      'topic_id': topSalatPillars, 'school_id': shShafii,
      'title': 'Position Shafi\'i', 'content': 'Treize piliers, incluant l\'intention, le Takbir, la Fatiha, l\'inclinaison, la prosternation et le salut final.',
      'content_ar': 'أركان الصلاة ثلاثة عشر: النية، وتكبيرة الإحرام، وقراءة الفاتحة...',
    });
    await db.insert('sources', {
      'law_id': lawSalatShafii, 'type': 2, 'reference': 'Minhaj al-Talibin', 'text': 'Le premier pilier est l\'intention liée au Takbir.', 'citation': 'Al-Nawawi, p. 25', 'authenticity': 4
    });

    // --- ZAKAT LIVESTOCK ---
    int topZakatLivestock = await db.insert('topics', {
      'category_id': subZakat,
      'title': 'Zakat sur le bétail', 'title_en': 'Zakat on Livestock', 'title_ar': 'زكاة الأنعام',
      'description': 'Règles concernant les bovins, ovins et camélidés.',
    });
    await db.insert('laws', {
      'topic_id': topZakatLivestock, 'school_id': shMaliki,
      'title': 'Maliki', 'content': 'La Zakat est due même sur les bêtes qui travaillent (labour, transport).',
      'content_ar': 'تجب الزكاة في الأنعام وإن كانت عوامل.',
    });

    // --- DIVORCE ---
    int topDivorceSunni = await db.insert('topics', {
      'category_id': subDivorce,
      'title': 'Le divorce sunnite', 'title_en': 'Sunni Divorce', 'title_ar': 'الطلاق السني',
      'description': 'Le divorce conforme à la tradition prophétique.',
    });
    await db.insert('laws', {
      'topic_id': topDivorceSunni, 'school_id': shHanbali,
      'title': 'Hanbali', 'content': 'Le divorce doit être prononcé pendant une période de pureté sans rapport sexuel.',
      'content_ar': 'الطلاق السني أن يطلقها في طهر لم يجامعها فيه طلقة واحدة.',
    });

    // --- INHERITANCE SPOUSE ---
    int topInheritanceSpouse = await db.insert('topics', {
      'category_id': catHeritage,
      'title': 'Part du conjoint', 'title_en': 'Spouse Share', 'title_ar': 'ميراث الزوجين',
      'description': 'Les parts fixées pour le mari et la femme.',
    });
    await db.insert('laws', {
      'topic_id': topInheritanceSpouse, 'school_id': shJafari,
      'title': 'Ja\'fari', 'content': 'Le mari hérite de tout si elle n\'a pas d\'autre héritier, mais la femme n\'hérite pas de tout par Radd (retour).',
      'content_ar': 'الزوج يرث الجميع بالفرض والرد إذا لم يكن غيره، والزوجة لا ترث بالرد.',
    });

    // --- PHASE 3: NEW TOPICS ---
    int topHajjRites = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'Les rites du Hajj', 'title_en': 'Hajj Rituals', 'title_ar': 'مناسك الحج',
      'description': 'Vue d\'ensemble des étapes du pèlerinage : Ihram, Arafat, Muzdalifah, lapidation et Tawaf.',
      'description_en': 'Overview of pilgrimage steps: Ihram, Arafat, Muzdalifah, stoning and Tawaf.',
      'description_ar': 'نظرة عامة على مناسك الحج: الإحرام، عرفات، مزدلفة، الرمي والطواف.',
    });
    await db.insert('laws', {
      'topic_id': topHajjRites, 'school_id': shShafii,
      'title': 'Position Shafi\'i', 'content': 'Les rites essentiels sont l\'Ihram, le séjour à Arafat, le Tawaf al-Ifada et le Sa\'y.',
      'content_ar': 'أركان الحج: الإحرام، الوقوف بعرفة، طواف الإفاضة والسعي.',
    });

    int topTarawih = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'La prière du Tarawih', 'title_en': 'Tarawih Prayer', 'title_ar': 'صلاة التراويح',
      'description': 'Prière nocturne spécifique au mois de Ramadan.',
      'description_en': 'Special nightly prayer during Ramadan.',
      'description_ar': 'صلاة ليلية خاصة بشهر رمضان.',
    });
    await db.insert('laws', {
      'topic_id': topTarawih, 'school_id': shHanafi,
      'title': 'Position Hanafi', 'content': 'Le Tarawih est une sunna muakkada (fortement recommandée), généralement 20 rak\'ats.',
      'content_ar': 'التراويح سنة مؤكدة، ويصليها الحنفية عشرين ركعة.',
    });

    int topZakatFitr = await db.insert('topics', {
      'category_id': subZakat,
      'title': 'La Zakat al-Fitr', 'title_en': 'Zakat al-Fitr', 'title_ar': 'زكاة الفطر',
      'description': 'Aumône obligatoire à la fin du Ramadan avant la prière de l\'Aïd.',
      'description_en': 'Mandatory charity at end of Ramadan before Eid prayer.',
      'description_ar': 'صدقة واجبة في آخر رمضان قبل صلاة العيد.',
    });
    await db.insert('laws', {
      'topic_id': topZakatFitr, 'school_id': shMaliki,
      'title': 'Position Maliki', 'content': 'Due pour chaque musulman, équivalent d\'environ 2,5 kg de dattes ou de nourriture de base.',
      'content_ar': 'تجب على كل مسلم، بمقدار صاع من طعام أهل البلد.',
    });

    int topAdhan = await db.insert('topics', {
      'category_id': subPriereObligatoire,
      'title': 'L\'Adhan et l\'Iqama', 'title_en': 'Adhan and Iqama', 'title_ar': 'الأذان والإقامة',
      'description': 'L\'appel à la prière et l\'annonce de son début.',
      'description_en': 'The call to prayer and announcement of its start.',
      'description_ar': 'النداء للصلاة وإعلان بدئها.',
    });
    await db.insert('laws', {
      'topic_id': topAdhan, 'school_id': shHanbali,
      'title': 'Position Hanbali', 'content': 'L\'Adhan est une sunna pour les prières obligatoires en commun. L\'Iqama est obligatoire pour le groupe.',
      'content_ar': 'الأذان سنة للفرض في الجماعة، والإقامة واجبة.',
    });

    int topWitr = await db.insert('topics', {
      'category_id': subPriereObligatoire,
      'title': 'La prière du Witr', 'title_en': 'Witr Prayer', 'title_ar': 'صلاة الوتر',
      'description': 'Prière impaire après les prières nocturnes, particulièrement en Ramadan.',
      'description_en': 'Odd-numbered prayer after night prayers, especially in Ramadan.',
      'description_ar': 'صلاة الوتر بعد العشاء، خاصة في رمضان.',
    });
    await db.insert('laws', {
      'topic_id': topWitr, 'school_id': shShafii,
      'title': 'Position Shafi\'i', 'content': 'Le Witr est une sunna muakkada, minimum 1 rak\'a, maximum 11.',
      'content_ar': 'الوتر سنة مؤكدة، أقله ركعة وأكثره إحدى عشرة.',
    });

    // --- PHASE 4: NEW TOPICS ---
    int topFastNullifiers = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'Les nullificateurs du jeûne', 'title_en': 'Nullifiers of Fasting', 'title_ar': 'مفطرات الصيام',
      'description': 'Les actes qui invalident le jeûne de Ramadan.',
      'description_en': 'Acts that invalidate the Ramadan fast.',
      'description_ar': 'الأفعال التي تبطل صوم رمضان.',
    });
    await db.insert('laws', {
      'topic_id': topFastNullifiers, 'school_id': shHanafi,
      'title': 'Hanafi', 'content': 'Manger, boire, relations sexuelles et vomissement volontaire annulent le jeûne.',
      'content_ar': 'الأكل والشرب والجماع والقيء عمداً من مفطرات الصيام.',
    });

    int topItikaf = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'L\'I\'tikaf en Ramadan', 'title_en': 'I\'tikaf in Ramadan', 'title_ar': 'الاعتكاف في رمضان',
      'description': 'Retraite spirituelle dans la mosquée, surtout les 10 derniers jours de Ramadan.',
      'description_en': 'Spiritual retreat in the mosque, especially last 10 days of Ramadan.',
      'description_ar': 'الاعتكاف في المسجد، خاصة في العشر الأواخر من رمضان.',
    });
    await db.insert('laws', {
      'topic_id': topItikaf, 'school_id': shMaliki,
      'title': 'Maliki', 'content': 'L\'I\'tikaf est une sunna ; l\'intention et le séjour dans la mosquée sont requis.',
      'content_ar': 'الاعتكاف سنة، ويشترط النية والمقام في المسجد.',
    });

    int topArafatFast = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'Le jeûne du jour de Arafat', 'title_en': 'Fasting on Day of Arafat', 'title_ar': 'صيام يوم عرفة',
      'description': 'Jeûne recommandé le 9 Dhul Hijjah pour les non-pèlerins.',
      'description_en': 'Recommended fast on 9 Dhul Hijjah for non-pilgrims.',
      'description_ar': 'صيام مستحب لغير الحاج في يوم عرفة.',
    });
    await db.insert('laws', {
      'topic_id': topArafatFast, 'school_id': shShafii,
      'title': 'Shafi\'i', 'content': 'Fortement recommandé (sunna muakkada) pour expier les péchés de l\'année passée et à venir.',
      'content_ar': 'سنة مؤكدة يكفر ذنوب سنتين.',
    });

    int topUmrah = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'L\'Umrah', 'title_en': 'Umrah', 'title_ar': 'العمرة',
      'description': 'Petit pèlerinage à La Mecque, réalisable toute l\'année.',
      'description_en': 'Lesser pilgrimage to Mecca, performable year-round.',
      'description_ar': 'العمرة إلى مكة، تجوز في أي وقت.',
    });
    await db.insert('laws', {
      'topic_id': topUmrah, 'school_id': shHanbali,
      'title': 'Hanbali', 'content': 'Ihram, Tawaf, Sa\'y et rasage/coupe des cheveux. Peut être combinée avec le Hajj.',
      'content_ar': 'الإحرام والطواف والسعي والتحلل. قد تُدمج مع الحج.',
    });

    int topJumuah = await db.insert('topics', {
      'category_id': subPriereObligatoire,
      'title': 'La prière du Jumu\'a', 'title_en': 'Friday Prayer (Jumu\'ah)', 'title_ar': 'صلاة الجمعة',
      'description': 'Prière du vendredi en congregation, avec khutba.',
      'description_en': 'Friday congregational prayer with sermon.',
      'description_ar': 'صلاة الجمعة جماعة مع الخطبة.',
    });
    await db.insert('laws', {
      'topic_id': topJumuah, 'school_id': shMaliki,
      'title': 'Maliki', 'content': 'Obligatoire pour l\'homme musulman libre, résident, en bonne santé. Remplace Dhuhr.',
      'content_ar': 'فرض عين على المسلم الحر المقيم القادر. تحل محل الظهر.',
    });

    int topSadaqah = await db.insert('topics', {
      'category_id': catEthique,
      'title': 'La Sadaqah (aumône volontaire)', 'title_en': 'Voluntary Charity (Sadaqah)', 'title_ar': 'الصدقة',
      'description': 'Aumône recommandée, distincte de la Zakat obligatoire.',
      'description_en': 'Recommended charity, distinct from obligatory Zakat.',
      'description_ar': 'صدقة مستحبة، غير الزكاة الواجبة.',
    });
    await db.insert('laws', {
      'topic_id': topSadaqah, 'school_id': shHanafi,
      'title': 'Hanafi', 'content': 'Recommandée en tout temps ; cache la misère de l\'aumône-donateur et du bénéficiaire.',
      'content_ar': 'مستحبة في كل وقت، وتُستر يد المعطي والآخذ.',
    });

    int topKhutba = await db.insert('topics', {
      'category_id': catJustice,
      'title': 'Les conditions du Khutba', 'title_en': 'Conditions of Khutba', 'title_ar': 'شروط الخطبة',
      'description': 'Règles du sermon du vendredi.',
      'description_en': 'Rules for the Friday sermon.',
      'description_ar': 'أحكام خطبة الجمعة.',
    });
    await db.insert('laws', {
      'topic_id': topKhutba, 'school_id': shShafii,
      'title': 'Shafi\'i', 'content': 'Deux khutbas séparées, en arabe, mention d\'Allah, assise entre les deux.',
      'content_ar': 'خطبتان، بالعربية، ذكر لله، وجلسة بينهما.',
    });

    int topEidPrayer = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'La prière de l\'Aïd', 'title_en': 'Eid Prayer', 'title_ar': 'صلاة العيد',
      'description': 'Prière des fêtes de l\'Aïd al-Fitr et al-Adha.',
      'description_en': 'Prayer for Eid al-Fitr and Eid al-Adha.',
      'description_ar': 'صلاة عيد الفطر وعيد الأضحى.',
    });
    await db.insert('laws', {
      'topic_id': topEidPrayer, 'school_id': shHanafi,
      'title': 'Hanafi', 'content': 'Sunna muakkada, 2 rak\'ats avec takbirs supplémentaires, suivie du khutba.',
      'content_ar': 'سنة مؤكدة ركعتان مع تكبيرات إضافية ثم خطبة.',
    });

    // --- PHASE 5: NEW TOPICS ---
    int topWali = await db.insert('topics', {
      'category_id': subContratMariage,
      'title': 'Le rôle du Wali', 'title_en': 'Role of the Wali', 'title_ar': 'دور الولي',
      'description': 'Le tuteur matrimonial et son rôle selon les écoles.',
      'description_en': 'The marriage guardian and his role across schools.',
      'description_ar': 'الولي في الزواج ودوره في المذاهب.',
    });
    await db.insert('laws', {
      'topic_id': topWali, 'school_id': shShafii,
      'title': 'Shafi\'i', 'content': 'Le Wali est obligatoire ; sans lui le contrat est nul.',
      'content_ar': 'الولي شرط، ولا يصح النكاح بدونه.',
    });

    int topSpousalRights = await db.insert('topics', {
      'category_id': catMariage,
      'title': 'Les droits et devoirs conjugaux', 'title_en': 'Spousal Rights and Duties', 'title_ar': 'الحقوق والواجبات الزوجية',
      'description': 'Les obligations réciproques entre époux en Islam.',
      'description_en': 'Mutual obligations between spouses in Islam.',
      'description_ar': 'الحقوق والواجبات المتبادلة بين الزوجين.',
    });
    await db.insert('laws', {
      'topic_id': topSpousalRights, 'school_id': shMaliki,
      'title': 'Maliki', 'content': 'Bonne companionship, entretien (nafaqa), et justice entre épouses.',
      'content_ar': 'المعاشرة بالمعروف والنفقة والعدل بين الزوجات.',
    });

    int topGhibah = await db.insert('topics', {
      'category_id': catEthique,
      'title': 'La médisance (Ghibah)', 'title_en': 'Backbiting (Ghibah)', 'title_ar': 'الغيبة',
      'description': 'Interdiction de parler mal d\'autrui en son absence.',
      'description_en': 'Prohibition of speaking ill of others in their absence.',
      'description_ar': 'تحريم ذكر الإنسان بما يكره في غيبته.',
    });
    await db.insert('laws', {
      'topic_id': topGhibah, 'school_id': shHanafi,
      'title': 'Hanafi', 'content': 'La Ghibah est un grand péché, équivalente à manger la chair du mort.',
      'content_ar': 'الغيبة من كبائر الذنوب، كأكل لحم أخيه ميتاً.',
    });

    int topShawwalFast = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'Le jeûne des six jours de Shawwal', 'title_en': 'Six Days of Shawwal Fasting', 'title_ar': 'صيام ستة أيام من شوال',
      'description': 'Jeûne surécompensé après le Ramadan.',
      'description_en': 'Highly rewarded fasting after Ramadan.',
      'description_ar': 'صيام مستحب مثاب عليه بعد رمضان.',
    });
    await db.insert('laws', {
      'topic_id': topShawwalFast, 'school_id': shShafii,
      'title': 'Shafi\'i', 'content': 'Sunna de jeûner six jours de Shawwal, séparément ou consécutivement.',
      'content_ar': 'سنة صيام ستة أيام من شوال، متفرقة أو متتابعة.',
    });

    int topCongregation = await db.insert('topics', {
      'category_id': subPriereObligatoire,
      'title': 'La prière en congregation', 'title_en': 'Congregational Prayer', 'title_ar': 'صلاة الجماعة',
      'description': 'Vertus et conditions de la prière en groupe.',
      'description_en': 'Virtues and conditions of group prayer.',
      'description_ar': 'فضائل وشروط صلاة الجماعة.',
    });
    await db.insert('laws', {
      'topic_id': topCongregation, 'school_id': shHanbali,
      'title': 'Hanbali', 'content': 'La prière en groupe est fortement recommandée pour l\'homme ; l\'Imam dirige.',
      'content_ar': 'صلاة الجماعة سنة مؤكدة للرجال، والإمام يؤم.',
    });

    int topIjara = await db.insert('topics', {
      'category_id': catContrats,
      'title': 'Le contrat de location (Ijara)', 'title_en': 'Lease Contract (Ijara)', 'title_ar': 'عقد الإجارة',
      'description': 'Location de biens ou services en droit islamique.',
      'description_en': 'Leasing of goods or services in Islamic law.',
      'description_ar': 'تأجير المنفعة أو الأعيان في الفقه.',
    });
    await db.insert('laws', {
      'topic_id': topIjara, 'school_id': shHanafi,
      'title': 'Hanafi', 'content': 'Contrat valide avec objet, loyer et durée définis ; usage licite requis.',
      'content_ar': 'صحيح بمعين ومأجور ومدة، واستعمال حلال.',
    });

    // --- PHASE 6: NEW TOPICS ---
    int topZakatBeneficiaries = await db.insert('topics', {
      'category_id': subZakat,
      'title': 'Les huit catégories de bénéficiaires', 'title_en': 'Eight Categories of Zakat Recipients', 'title_ar': 'مصارف الزكاة الثمانية',
      'description': 'À qui distribuer la zakat selon le Coran (9:60).',
      'description_en': 'Who may receive zakat per Quran (9:60).',
      'description_ar': 'من يستحق الزكاة وفق القرآن (9:60).',
    });
    await db.insert('laws', {
      'topic_id': topZakatBeneficiaries, 'school_id': shShafii,
      'title': 'Shafi\'i', 'content': 'Les huit catégories : pauvres, nécessiteux, collecteurs, réconciliation des cœurs, esclaves, endettés, cause d\'Allah, voyageurs.',
      'content_ar': 'الثمانية: الفقراء والمساكين والعاملين عليها والمؤلفة قلوبهم وفي الرقاب والغارمين وفي سبيل الله وابن السبيل.',
    });

    int topMurabaha = await db.insert('topics', {
      'category_id': catContrats,
      'title': 'La Murabaha', 'title_en': 'Murabaha', 'title_ar': 'المرابحة',
      'description': 'Vente à prix de revient plus marge connue — alternative au crédit à intérêt.',
      'description_en': 'Cost-plus sale with known markup — halal credit alternative.',
      'description_ar': 'بيع بثمن الكلفة وزيادة معلومة — بديل للقرض الربوي.',
    });
    await db.insert('laws', {
      'topic_id': topMurabaha, 'school_id': shHanafi,
      'title': 'Hanafi', 'content': 'Contrat valide si le prix d\'achat et la marge sont connus et acceptés au moment du contrat.',
      'content_ar': 'صحيحة إذا عُلم الثمن والربح ووافق الطرفان عند العقد.',
    });

    // --- PHASE 7: NEW TOPICS ---
    int topSickFasting = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'Le jeûne du malade', 'title_en': 'Fasting While Ill', 'title_ar': 'صيام المريض',
      'description': 'Règles du jeûne pour la personne malade.',
      'description_en': 'Fasting rules for the ill person.',
      'description_ar': 'أحكام صيام المريض.',
    });
    await db.insert('laws', {
      'topic_id': topSickFasting, 'school_id': shMaliki,
      'title': 'Maliki', 'content': 'Si le jeûne aggrave la maladie, rompre est permis avec qada ultérieur.',
      'content_ar': 'إن ضر بالمرض فالإفطار جائز مع القضاء.',
    });

    int topQunut = await db.insert('topics', {
      'category_id': subPriereObligatoire,
      'title': 'La Qunut dans la prière', 'title_en': 'Qunut in Prayer', 'title_ar': 'القنوت في الصلاة',
      'description': 'Invocation dans la prière, notamment Witr et Fajr.',
      'description_en': 'Supplication in prayer, especially Witr and Fajr.',
      'description_ar': 'الدعاء في الصلاة خاصة الوتر والفجر.',
    });
    await db.insert('laws', {
      'topic_id': topQunut, 'school_id': shHanafi,
      'title': 'Hanafi', 'content': 'Qunut en Witr recommandé ; en Fajr seulement en cas de calamité.',
      'content_ar': 'القنوت في الوتر مستحب؛ في الفجر عند نازلة فقط.',
    });

    int topKaffarah = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'La kaffarah du jeûne', 'title_en': 'Kaffarah for Breaking Fast', 'title_ar': 'كفارة الفطر',
      'description': 'Expiation pour rupture volontaire du jeûne de Ramadan.',
      'description_en': 'Expiation for voluntarily breaking Ramadan fast.',
      'description_ar': 'كفارة الإفطار المتعمد في رمضان.',
    });
    await db.insert('laws', {
      'topic_id': topKaffarah, 'school_id': shShafii,
      'title': 'Shafi\'i', 'content': 'Affranchir un esclave, ou jeûner 60 jours, ou nourrir 60 pauvres.',
      'content_ar': 'عتق رقبة أو صيام ستين يوماً أو إطعام ستين مسكيناً.',
    });

    int topSiblingInheritance = await db.insert('topics', {
      'category_id': catHeritage,
      'title': 'L\'héritage des frères et sœurs', 'title_en': 'Inheritance of Siblings', 'title_ar': 'ميراث الإخوة والأخوات',
      'description': 'Parts des frères et sœurs en l\'absence d\'enfants.',
      'description_en': 'Siblings\' shares when there are no children.',
      'description_ar': 'نصيب الإخوة عند عدم وجود أولاد.',
    });
    await db.insert('laws', {
      'topic_id': topSiblingInheritance, 'school_id': shHanafi,
      'title': 'Hanafi', 'content': 'Frère/soeur utérins : 1/6 chacun ; germains : plus selon présence d\'autres héritiers.',
      'content_ar': 'الأخ الشقيق/الأخت: السدس؛ الأخ لأم: السدس مع غيره.',
    });

    int topDuha = await db.insert('topics', {
      'category_id': subPriereObligatoire,
      'title': 'La prière du Duha', 'title_en': 'Duha Prayer', 'title_ar': 'صلاة الضحى',
      'description': 'Prière surécompensée entre le lever du soleil et midi.',
      'description_en': 'Highly rewarded prayer between sunrise and noon.',
      'description_ar': 'صلاة مثاب عليها بين الشروق والزوال.',
    });
    await db.insert('laws', {
      'topic_id': topDuha, 'school_id': shShafii,
      'title': 'Shafi\'i', 'content': 'Sunna muakkada, minimum 2 rak\'ats, idéalement 4 à 8.',
      'content_ar': 'سنة مؤكدة ركعتان فأكثر، والأفضل أربع إلى ثمان.',
    });

    int topSalam = await db.insert('topics', {
      'category_id': subFinance,
      'title': 'Le contrat de Salam', 'title_en': 'Salam Contract', 'title_ar': 'عقد السلم',
      'description': 'Vente à terme de biens non encore produits.',
      'description_en': 'Forward sale of goods not yet produced.',
      'description_ar': 'بيع سلم لسلعة غير موجودة عند العقد.',
    });
    await db.insert('laws', {
      'topic_id': topSalam, 'school_id': shHanbali,
      'title': 'Hanbali', 'content': 'Valide si l\'objet, le prix et le délai de livraison sont définis.',
      'content_ar': 'صحيح بذكر المسلم فيه والثمن والأجل.',
    });

    int topMusharakah = await db.insert('topics', {
      'category_id': subFinance,
      'title': 'La Musharakah', 'title_en': 'Musharakah Partnership', 'title_ar': 'المشاركة',
      'description': 'Association en capital et partage des profits/pertes.',
      'description_en': 'Capital partnership with shared profit/loss.',
      'description_ar': 'شركة في رأس المال والأرباح والخسائر.',
    });
    await db.insert('laws', {
      'topic_id': topMusharakah, 'school_id': shMaliki,
      'title': 'Maliki', 'content': 'Chaque associé est propriétaire de sa part ; profits selon accord ou au prorata.',
      'content_ar': 'لكل شريك نصيبه؛ الربح حسب الشرط أو النسبة.',
    });

    int topAmanah = await db.insert('topics', {
      'category_id': catEthique,
      'title': 'L\'Amanah (confiance)', 'title_en': 'Amanah (Trust)', 'title_ar': 'الأمانة',
      'description': 'Respect des dépôts et confiances confiées.',
      'description_en': 'Honoring entrusted deposits and trusts.',
      'description_ar': 'حفظ الأمانات والودائع.',
    });
    await db.insert('laws', {
      'topic_id': topAmanah, 'school_id': shHanafi,
      'title': 'Hanafi', 'content': 'Rendre l\'amanah est obligatoire ; la trahison est un grand péché.',
      'content_ar': 'رد الأمانة واجب؛ خيانة الأمانة من الكبائر.',
    });

    int topHijab = await db.insert('topics', {
      'category_id': catEthique,
      'title': 'Les conditions du hijab', 'title_en': 'Conditions of Hijab', 'title_ar': 'شروط الحجاب',
      'description': 'Couverture et pudeur selon les savants.',
      'description_en': 'Covering and modesty per scholars.',
      'description_ar': 'الستر والحياء في الشريعة.',
    });
    await db.insert('laws', {
      'topic_id': topHijab, 'school_id': shShafii,
      'title': 'Shafi\'i', 'content': 'Couvrir tout le corps sauf visage et mains ; vêtements non moulants ni transparents.',
      'content_ar': 'ستر جميع البدن إلا الوجه والكفين؛ لباس غير شفاف ولا ضيق.',
    });

    int topJamQasr = await db.insert('topics', {
      'category_id': subPriereVoyageur,
      'title': 'Le jam\' et qasr', 'title_en': 'Jam\' and Qasr', 'title_ar': 'الجمع والقصر',
      'description': 'Combiner et raccourcir les prières en voyage.',
      'description_en': 'Combining and shortening prayers while traveling.',
      'description_ar': 'جمع الصلاتين وقصرها للمسافر.',
    });
    await db.insert('laws', {
      'topic_id': topJamQasr, 'school_id': shHanbali,
      'title': 'Hanbali', 'content': 'Jam\' taqdim ou ta\'khir permis ; qasr pour Dhuhr, Asr et Isha.',
      'content_ar': 'الجمع تقديماً أو تأخيراً؛ والقصر في الظهر والعصر والعشاء.',
    });

    // --- PHASE 8: EXPAND TO 100+ TOPICS ---
    await ExtraTopicsSeed.insert(
      db,
      subAblutions: subAblutions,
      subGhusl: subGhusl,
      subPriereObligatoire: subPriereObligatoire,
      subPriereVoyageur: subPriereVoyageur,
      subZakat: subZakat,
      subFinance: subFinance,
      subContratMariage: subContratMariage,
      subDivorce: subDivorce,
      catJeune: catJeune,
      catMariage: catMariage,
      catFamille: catFamille,
      catEthique: catEthique,
      catEconomie: catEconomie,
      catContrats: catContrats,
      catJustice: catJustice,
      catAlimentation: catAlimentation,
      catHeritage: catHeritage,
      catDroits: catDroits,
      catCulte: catCulte,
      shHanafi: shHanafi,
      shMaliki: shMaliki,
      shShafii: shShafii,
      shHanbali: shHanbali,
      shJafari: shJafari,
    );

    // Media illustrations (built-in widgets, fully offline)
    await db.insert('media', {
      'topic_id': topWuduConditions,
      'type': 3,
      'url': 'widget:wudu_zones',
      'title': 'Zones du Wudu',
      'description': 'Visage, bras, tête et pieds — les quatre zones essentielles.',
    });
    await db.insert('media', {
      'topic_id': topGhuslObligations,
      'type': 3,
      'url': 'widget:ghusl_body',
      'title': 'Corps entier',
      'description': 'Le ghusl couvre l\'ensemble du corps.',
    });
    await db.insert('media', {
      'topic_id': topZakatNisab,
      'type': 3,
      'url': 'widget:zakat_nisab',
      'title': 'Seuils du Nisab',
      'description': '85g d\'or ou 595g d\'argent — taux de 2,5%.',
    });
    await db.insert('media', {
      'topic_id': topTravelPrayer,
      'type': 3,
      'url': 'widget:qasr_prayer',
      'title': 'Raccourcissement (Qasr)',
      'description': '4 rak\'ats réduites à 2 en voyage.',
    });
    await db.insert('media', {
      'topic_id': topInheritanceSpouse,
      'type': 3,
      'url': 'widget:inheritance_spouse',
      'title': 'Parts du conjoint',
      'description': 'Répartition selon les règles du Farāʾiḍ.',
    });
    await db.insert('media', {
      'topic_id': topHajjRites,
      'type': 3,
      'url': 'widget:qasr_prayer',
      'title': 'Étapes du Hajj',
      'description': 'Parcours du pèlerinage.',
    });
  }

  Future<List<Category>> getCategories({int? parentId, Locale? locale}) async {
    Database db = await database;
    var results = await db.query(
      'categories',
      where: parentId == null ? 'parent_id IS NULL' : 'parent_id = ?',
      whereArgs: parentId == null ? [] : [parentId]
    );

    return results.map((c) {
      Map<String, dynamic> map = Map.from(c);
      if (locale != null) {
        String lang = locale.languageCode;
        if (map['name_$lang'] != null) map['name'] = map['name_$lang'];
      }
      return Category.fromMap(map);
    }).toList();
  }

  Future<List<Topic>> getTopicsByCategory(int categoryId, {Locale? locale}) async {
    Database db = await database;
    var results = await db.query('topics', where: 'category_id = ?', whereArgs: [categoryId]);
    List<Topic> topics = [];
    for (var r in results) {
      Map<String, dynamic> map = Map.from(r);
      if (locale != null) {
        String lang = locale.languageCode;
        if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
        if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
      }
      int topicId = map['id'];
      List<String> tags = await getTagsForTopic(topicId);
      List<int> related = await _getRelatedTopicIds(topicId);
      topics.add(Topic.fromMap(map, tags: tags, relatedTopicIds: related));
    }
    return topics;
  }

  Future<List<Law>> getLawsByTopic(int topicId, {Locale? locale}) async {
    Database db = await database;
    var results = await db.query('laws', where: 'topic_id = ?', whereArgs: [topicId]);
    return results.map((l) {
      Map<String, dynamic> map = Map.from(l);
      if (locale != null) {
        String lang = locale.languageCode;
        if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
        if (map['content_$lang'] != null) map['content'] = map['content_$lang'];
        if (map['scholar_comments_$lang'] != null) map['scholar_comments'] = map['scholar_comments_$lang'];
      }
      return Law.fromMap(map);
    }).toList();
  }

  Future<List<Source>> getSourcesByLaw(int lawId, {Locale? locale}) async {
    Database db = await database;
    var results = await db.query('sources', where: 'law_id = ?', whereArgs: [lawId]);
    return results.map((s) {
      Map<String, dynamic> map = Map.from(s);
      if (locale != null) {
        String lang = locale.languageCode;
        if (map['reference_$lang'] != null) map['reference'] = map['reference_$lang'];
        if (map['text_$lang'] != null) map['text'] = map['text_$lang'];
        if (map['citation_$lang'] != null) map['citation'] = map['citation_$lang'];
      }
      return Source.fromMap(map);
    }).toList();
  }

  Future<School?> getSchoolById(int schoolId, {Locale? locale}) async {
    Database db = await database;
    var results = await db.query('schools', where: 'id = ?', whereArgs: [schoolId]);
    if (results.isNotEmpty) {
      Map<String, dynamic> map = Map.from(results.first);
      if (locale != null) {
        String lang = locale.languageCode;
        if (map['name_$lang'] != null) map['name'] = map['name_$lang'];
        if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
      }
      return School.fromMap(map);
    }
    return null;
  }

  Future<List<Topic>> searchTopics(String query, {Locale? locale, int? schoolId, int? categoryId}) async {
    Database db = await database;
    final trimmed = query.trim();

    List<Map<String, dynamic>> results = [];
    if (trimmed.isNotEmpty) {
      try {
        final ftsQuery = SearchSynonyms.ftsQuery(trimmed);
        final ftsRows = await db.rawQuery('''
          SELECT topic_id FROM topics_fts
          WHERE topics_fts MATCH ?
          ORDER BY rank
          LIMIT 80
        ''', [ftsQuery]);
        if (ftsRows.isNotEmpty) {
          final ids = ftsRows.map((r) => r['topic_id'] as int).toList();
          final placeholders = List.filled(ids.length, '?').join(',');
          var sql = 'SELECT * FROM topics WHERE id IN ($placeholders)';
          final args = <dynamic>[...ids];
          if (schoolId != null) {
            sql += ' AND id IN (SELECT topic_id FROM laws WHERE school_id = ?)';
            args.add(schoolId);
          }
          if (categoryId != null) {
            sql += ' AND category_id = ?';
            args.add(categoryId);
          }
          results = await db.rawQuery(sql, args);
        }
      } catch (_) {
        // Fallback to LIKE below.
      }
    }

    if (results.isEmpty && (trimmed.isNotEmpty || schoolId != null || categoryId != null)) {
      final terms = trimmed.isEmpty ? [''] : SearchSynonyms.expand(trimmed);
      final likeParts = <String>[];
      final likeArgs = <dynamic>[];
      for (final term in terms) {
        likeParts.add(
          '(title LIKE ? OR description LIKE ? OR title_en LIKE ? OR description_en LIKE ? OR title_ar LIKE ? OR description_ar LIKE ? OR title_ru LIKE ? OR description_ru LIKE ? OR title_zh LIKE ? OR description_zh LIKE ?)',
        );
        likeArgs.addAll(List.filled(10, '%$term%'));
      }
      var whereClause = trimmed.isEmpty ? '1=1' : '(${likeParts.join(' OR ')})';
      if (schoolId != null) {
        whereClause += ' AND id IN (SELECT topic_id FROM laws WHERE school_id = ?)';
        likeArgs.add(schoolId);
      }
      if (categoryId != null) {
        whereClause += ' AND category_id = ?';
        likeArgs.add(categoryId);
      }
      results = await db.query('topics', where: whereClause, whereArgs: likeArgs);
    }

    final topics = <Topic>[];
    for (final r in results) {
      final map = Map<String, dynamic>.from(r);
      if (locale != null) {
        final lang = locale.languageCode;
        if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
        if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
      }
      final topicId = map['id'] as int;
      final tags = await getTagsForTopic(topicId);
      final related = await _getRelatedTopicIds(topicId);
      topics.add(Topic.fromMap(map, tags: tags, relatedTopicIds: related));
    }
    return topics;
  }

  Future<bool> topicHasConsensus(int topicId) async {
    final laws = await getLawsByTopic(topicId);
    if (laws.length < 2) return false;
    final contents = laws.map((l) => l.content.trim().toLowerCase()).toSet();
    return contents.length == 1;
  }

  // Favorites
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

  // Notes
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

  // Media
  Future<List<MediaItem>> getMediaForTopic(int topicId) async {
    Database db = await database;
    var results = await db.query('media', where: 'topic_id = ?', whereArgs: [topicId]);
    return results.map((m) => MediaItem.fromMap(m)).toList();
  }

  Future<List<MediaItem>> getAllMedia() async {
    Database db = await database;
    var results = await db.query('media');
    return results.map((m) => MediaItem.fromMap(m)).toList();
  }

  // Tags and Related Topics
  Future<List<String>> getTagsForTopic(int topicId) async {
    Database db = await database;
    var results = await db.rawQuery('''
      SELECT t.name FROM tags t
      JOIN topic_tags tt ON t.id = tt.tag_id
      WHERE tt.topic_id = ?
    ''', [topicId]);
    return results.map((r) => r['name'] as String).toList();
  }

  Future<List<int>> _getRelatedTopicIds(int topicId) async {
    Database db = await database;
    var results = await db.query(
      'related_topics',
      where: 'topic_id = ?',
      whereArgs: [topicId],
      columns: ['related_id'],
    );
    return results.map((r) => r['related_id'] as int).toList();
  }

  Future<Topic?> getTopicByTitle(String title, {Locale? locale}) async {
    Database db = await database;
    var results = await db.query('topics', where: 'title = ?', whereArgs: [title], limit: 1);
    if (results.isEmpty) return null;
    final map = Map<String, dynamic>.from(results.first);
    if (locale != null) {
      final lang = locale.languageCode;
      if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
      if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
    }
    final topicId = map['id'] as int;
    final tags = await getTagsForTopic(topicId);
    final related = await _getRelatedTopicIds(topicId);
    return Topic.fromMap(map, tags: tags, relatedTopicIds: related);
  }

  Future<List<Topic>> getTopicsByTitles(List<String> titles, {Locale? locale}) async {
    final topics = <Topic>[];
    for (final title in titles) {
      final t = await getTopicByTitle(title, locale: locale);
      if (t != null) topics.add(t);
    }
    return topics;
  }

  Future<Topic?> getTopicById(int topicId, {Locale? locale}) async {
    Database db = await database;
    var results = await db.query('topics', where: 'id = ?', whereArgs: [topicId]);
    if (results.isNotEmpty) {
      Map<String, dynamic> map = Map.from(results.first);
      if (locale != null) ContentLocaleService.applyTopicLocale(map, locale);
      List<String> tags = await getTagsForTopic(topicId);
      List<int> related = await _getRelatedTopicIds(topicId);
      return Topic.fromMap(map, tags: tags, relatedTopicIds: related);
    }
    return null;
  }

  Future<bool> isTopicVerified(int topicId) async {
    final laws = await getLawsByTopic(topicId);
    if (laws.isEmpty) return false;
    for (final law in laws) {
      if (law.id == null) continue;
      final sources = await getSourcesByLaw(law.id!);
      if (sources.any((s) => s.authenticity == Authenticity.sahih || s.authenticity == Authenticity.hasan)) {
        return true;
      }
      if (law.scholarComments != null && law.scholarComments!.isNotEmpty) return true;
    }
    return false;
  }

  Future<bool> topicMatchesSchool(int topicId, String schoolSlug) async {
    final laws = await getLawsByTopic(topicId);
    final slug = schoolSlug.toLowerCase();
    for (final law in laws) {
      final school = await getSchoolById(law.schoolId);
      final name = (school?.name ?? law.title).toLowerCase();
      if (slug == 'hanafi' && name.contains('hanafi')) return true;
      if (slug == 'maliki' && name.contains('maliki')) return true;
      if (slug == 'shafii' && name.contains('shafi')) return true;
      if (slug == 'hanbali' && name.contains('hanbali')) return true;
      if (slug == 'jafari' && (name.contains('jafari') || name.contains("ja'fari"))) return true;
    }
    return false;
  }

  Future<List<Topic>> getRelatedTopics(int topicId, {Locale? locale}) async {
    List<int> ids = await _getRelatedTopicIds(topicId);
    List<Topic> topics = [];
    for (var id in ids) {
      var t = await getTopicById(id, locale: locale);
      if (t != null) topics.add(t);
    }
    return topics;
  }

  Future<List<Topic>> getTopicsByTag(String tagName, {Locale? locale}) async {
    Database db = await database;
    var results = await db.rawQuery('''
      SELECT t.* FROM topics t
      JOIN topic_tags tt ON t.id = tt.topic_id
      JOIN tags tag ON tag.id = tt.tag_id
      WHERE tag.name = ?
    ''', [tagName]);

    List<Topic> topics = [];
    for (var r in results) {
      Map<String, dynamic> map = Map.from(r);
      if (locale != null) {
        String lang = locale.languageCode;
        if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
        if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
      }
      int topicId = map['id'];
      List<String> tags = await getTagsForTopic(topicId);
      List<int> related = await _getRelatedTopicIds(topicId);
      topics.add(Topic.fromMap(map, tags: tags, relatedTopicIds: related));
    }
    return topics;
  }

  Future<List<Topic>> getTopicsWithComparisons({Locale? locale, bool consensusOnly = false}) async {
    Database db = await database;
    final results = await db.rawQuery('''
      SELECT t.* FROM topics t
      WHERE (
        SELECT COUNT(DISTINCT school_id) FROM laws WHERE topic_id = t.id
      ) >= 2
      ORDER BY t.title ASC
    ''');

    final topics = <Topic>[];
    for (final row in results) {
      final map = Map<String, dynamic>.from(row);
      final topicId = map['id'] as int;
      if (consensusOnly && !await topicHasConsensus(topicId)) continue;
      if (locale != null) {
        final lang = locale.languageCode;
        if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
        if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
      }
      final tags = await getTagsForTopic(topicId);
      final related = await _getRelatedTopicIds(topicId);
      topics.add(Topic.fromMap(map, tags: tags, relatedTopicIds: related));
    }
    return topics;
  }

  Future<List<School>> getAllSchools({Locale? locale}) async {
    Database db = await database;
    var results = await db.query('schools');
    return results.map((s) {
      Map<String, dynamic> map = Map.from(s);
      if (locale != null) {
        String lang = locale.languageCode;
        if (map['name_$lang'] != null) map['name'] = map['name_$lang'];
      }
      return School.fromMap(map);
    }).toList();
  }

  Future<int> getTopicCount() async {
    Database db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM topics');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Topic?> getSuggestedTopic(Set<int> readIds, {Locale? locale}) async {
    Database db = await database;
    final results = await db.query('topics', orderBy: 'id ASC');
    for (final row in results) {
      final id = row['id'] as int;
      if (readIds.contains(id)) continue;
      final map = Map<String, dynamic>.from(row);
      if (locale != null) {
        final lang = locale.languageCode;
        if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
        if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
      }
      final tags = await getTagsForTopic(id);
      final related = await _getRelatedTopicIds(id);
      return Topic.fromMap(map, tags: tags, relatedTopicIds: related);
    }
    return getDailyTopic(locale: locale);
  }

  Future<Topic?> getDailyTopic({Locale? locale}) async {
    Database db = await database;
    final results = await db.query('topics', orderBy: 'id ASC');
    if (results.isEmpty) return null;

    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final index = dayOfYear % results.length;
    final map = Map<String, dynamic>.from(results[index]);
    if (locale != null) {
      final lang = locale.languageCode;
      if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
      if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
    }
    final topicId = map['id'] as int;
    final tags = await getTagsForTopic(topicId);
    final related = await _getRelatedTopicIds(topicId);
    return Topic.fromMap(map, tags: tags, relatedTopicIds: related);
  }

  Future<List<Topic>> getTopicsByIds(List<int> ids, {Locale? locale}) async {
    if (ids.isEmpty) return [];
    final topics = <Topic>[];
    for (final id in ids) {
      final topic = await getTopicById(id, locale: locale);
      if (topic != null) topics.add(topic);
    }
    return topics;
  }

  Future<List<Topic>> getRandomTopics(int count, {Locale? locale, Set<int> excludeIds = const {}}) async {
    Database db = await database;
    final results = await db.rawQuery(
      'SELECT * FROM topics ORDER BY RANDOM() LIMIT ?',
      [count + excludeIds.length + 5],
    );
    final topics = <Topic>[];
    for (final row in results) {
      final map = Map<String, dynamic>.from(row);
      final id = map['id'] as int;
      if (excludeIds.contains(id)) continue;
      if (locale != null) {
        final lang = locale.languageCode;
        if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
        if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
      }
      final tags = await getTagsForTopic(id);
      final related = await _getRelatedTopicIds(id);
      topics.add(Topic.fromMap(map, tags: tags, relatedTopicIds: related));
      if (topics.length >= count) break;
    }
    return topics;
  }
}
