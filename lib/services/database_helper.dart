import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category.dart';
import '../models/topic.dart';
import '../models/law.dart';
import '../models/source.dart';
import '../models/school.dart';
import '../models/media_item.dart';

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
      version: 11, // Bumped to 11 for improved content and book references
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 11) {
          // Upgrade to re-seed enriched content while preserving user data
          await _dropTables(db, dropUserData: false);
          await _onCreate(db, newVersion);
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
  }

  Future _seedDatabase(Database db) async {
    // Reliable images
    const String imgPrayer = 'https://images.unsplash.com/photo-1591604466107-ec97de577aff?auto=format&fit=crop&q=80&w=1000';
    const String imgFasting = 'https://images.unsplash.com/photo-1564121211835-e88c852648ab?auto=format&fit=crop&q=80&w=1000';
    const String imgFamily = 'https://images.unsplash.com/photo-1511895426328-dc8714191300?auto=format&fit=crop&q=80&w=1000';
    const String imgMarriage = 'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?auto=format&fit=crop&q=80&w=1000';
    const String imgEconomy = 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?auto=format&fit=crop&q=80&w=1000';
    const String imgJustice = 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&q=80&w=1000';
    const String imgEthics = 'https://images.unsplash.com/photo-1509021436665-8f07dbf5bf1d?auto=format&fit=crop&q=80&w=1000';
    const String imgFood = 'https://images.unsplash.com/photo-1547573854-74d2a71d0826?auto=format&fit=crop&q=80&w=1000';
    const String imgContracts = 'https://images.unsplash.com/photo-1505664194779-8beaceb93744?auto=format&fit=crop&q=80&w=1000';
    const String imgRights = 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&q=80&w=1000';
    const String imgInheritance = 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&q=80&w=1000';

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
    String whereClause = '(title LIKE ? OR description LIKE ? OR title_en LIKE ? OR description_en LIKE ? OR title_ar LIKE ? OR description_ar LIKE ? OR title_ru LIKE ? OR description_ru LIKE ? OR title_zh LIKE ? OR description_zh LIKE ?)';
    List<dynamic> whereArgs = List.filled(10, '%$query%');

    if (schoolId != null) {
      whereClause += ' AND id IN (SELECT topic_id FROM laws WHERE school_id = ?)';
      whereArgs.add(schoolId);
    }
    if (categoryId != null) {
      whereClause += ' AND category_id = ?';
      whereArgs.add(categoryId);
    }

    var results = await db.query('topics',
      where: whereClause,
      whereArgs: whereArgs
    );

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
    var results = await db.query('related_topics', where: 'topic_id = ?', columns: ['related_id']);
    return results.map((r) => r['related_id'] as int).toList();
  }

  Future<Topic?> getTopicById(int topicId, {Locale? locale}) async {
    Database db = await database;
    var results = await db.query('topics', where: 'id = ?', whereArgs: [topicId]);
    if (results.isNotEmpty) {
      Map<String, dynamic> map = Map.from(results.first);
      if (locale != null) {
        String lang = locale.languageCode;
        if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
        if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
      }
      List<String> tags = await getTagsForTopic(topicId);
      List<int> related = await _getRelatedTopicIds(topicId);
      return Topic.fromMap(map, tags: tags, relatedTopicIds: related);
    }
    return null;
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
}
