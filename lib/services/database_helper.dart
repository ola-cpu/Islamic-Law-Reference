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
      version: 9, // Bumped to 9 for enriched content
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 9) {
          // Destructive upgrade to re-seed enriched content
          await _dropTables(db);
          await _onCreate(db, newVersion);
        }
      },
    );
  }

  Future<void> _dropTables(Database db, {bool dropUserData = false}) async {
    await db.execute('DROP TABLE IF EXISTS media');
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
      CREATE TABLE categories(
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
      CREATE TABLE schools(
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
      CREATE TABLE topics(
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
      CREATE TABLE laws(
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
      CREATE TABLE sources(
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
    await db.execute('''
      CREATE TABLE media(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER,
        type INTEGER,
        url TEXT,
        title TEXT,
        description TEXT,
        FOREIGN KEY (topic_id) REFERENCES topics (id)
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

    // Topics
    int topHands = await db.insert('topics', {
      'category_id': catCulte,
      'title': 'Lever les mains dans la prière', 'title_en': 'Raising hands in prayer', 'title_ar': 'رفع اليدين في الصلاة', 'title_ru': 'Поднятие рук в молитве', 'title_zh': '祈祷时举手',
      'description': 'Les règles concernant le fait de lever les mains à différents moments de la prière.', 'description_en': 'Rules concerning raising hands at different moments of prayer.'
    });

    // Law Hanafi
    int lawHanafi = await db.insert('laws', {
      'topic_id': topHands,
      'title': 'Position Hanafi', 'title_en': 'Hanafi Position', 'title_ar': 'موقف الحنفية', 'title_ru': 'Позиция Ханафи', 'title_zh': '哈乃斐立场',
      'content': 'On lève les mains seulement au début de la prière (Takbir d\'ouverture).',
      'content_en': 'The hands are raised only at the beginning of the prayer (Opening Takbir).',
      'content_ar': 'يرفع يديه في التكبيرة الأولى فقط',
      'content_ru': 'Руки поднимаются только в начале молитвы (вступительный такбир).',
      'content_zh': '仅在祈祷开始时（开端大赞）举手。',
      'scholar_comments': 'Basé sur la pratique des gens de Koufa.',
      'scholar_comments_en': 'Based on the practice of the people of Kufa.',
      'scholar_comments_ru': 'Основано на практике жителей Куфы.',
      'scholar_comments_zh': '基于库法人的实践。',
      'school_id': shHanafi
    });
    await db.insert('sources', {
      'law_id': lawHanafi,
      'type': 1, // Hadith
      'reference': 'Sunan Abi Dawood, Hadith 748',
      'reference_en': 'Sunan Abi Dawood, Hadith 748',
      'reference_ru': 'Сунан Аби Давуд, Хадис 748',
      'reference_zh': '苏南·阿布·达乌德，圣训 748',
      'text': 'Ibn Mas\'ud a dit : "Ne vais-je pas vous montrer la prière du Messager d\'Allah ?" Il a alors prié et n\'a levé les mains qu\'une seule fois.',
      'text_en': 'Ibn Mas\'ud said: "Shall I not show you the prayer of the Messenger of Allah?" He then prayed and only raised his hands once.',
      'text_ar': 'عن ابن مسعود قال: ألا أصلي بكم صلاة رسول الله صلى الله عليه وسلم؟ فصلى فلم يرفع يديه إلا في أول مرة',
      'text_ru': 'Ибн Масуд сказал: «Не показать ли мне вам, как молился Посланник Аллаха?» Затем он совершил молитву и поднял руки только один раз.',
      'text_zh': '伊本·马苏德说：“我难道不向你们展示安拉使者的祈祷吗？”然后他祈祷了，只举了一次手。',
      'authenticity': 1, // Hasan
      'citation': 'Abu Dawood, Kitab al-Salat'
    });

    // --- More Sample Data ---
    // Fasting Category
    int topRamadan = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'Intention du jeûne', 'title_en': 'Intention for Fasting', 'title_ar': 'نية الصيام', 'title_ru': 'Намерение для поста', 'title_zh': '禁食的意图',
      'description': 'L\'obligation de l\'intention avant le début du jeûne de Ramadan.', 'description_en': 'The obligation of intention before the start of the Ramadan fast.'
    });

    int lawShafiiRamadan = await db.insert('laws', {
      'topic_id': topRamadan,
      'title': 'Position Shafi\'i', 'title_en': 'Shafi\'i Position', 'title_ar': 'موقف الشافعية', 'title_ru': 'Позиция Шафии', 'title_zh': '沙斐仪立场',
      'content': 'L\'intention doit être formulée chaque nuit avant l\'aube pour chaque jour de Ramadan.',
      'content_en': 'The intention must be made every night before dawn for each day of Ramadan.',
      'content_ar': 'يجب تبييت النية كل ليلة لكل يوم من رمضان',
      'content_ru': 'Намерение должно быть сформулировано каждую ночь перед рассветом для каждого дня Рамадана.',
      'content_zh': '在拉马丹月的每一天，必须在黎明前的每个晚上表达意图。',
      'school_id': shShafii
    });

    // Marriage Category
    int topWali = await db.insert('topics', {
      'category_id': catMariage,
      'title': 'Présence du tuteur (Wali)', 'title_en': 'Presence of the Guardian (Wali)', 'title_ar': 'وجود الولي في النكاح', 'title_ru': 'Присутствие опекуна (Вали)', 'title_zh': '监护人 (Wali) 的出席',
      'description': 'La nécessité du tuteur pour la validité du mariage.', 'description_en': 'The necessity of a guardian for the validity of marriage.'
    });

    int lawMalikiWali = await db.insert('laws', {
      'topic_id': topWali,
      'title': 'Position Maliki', 'title_en': 'Maliki Position', 'title_ar': 'موقف المالكية', 'title_ru': 'Позиция Малики', 'title_zh': '马立克立场',
      'content': 'Le mariage n\'est pas valide sans la présence et l\'accord d\'un tuteur (Wali).',
      'content_en': 'Marriage is not valid without the presence and consent of a guardian (Wali).',
      'content_ar': 'لا يصح النكاح إلا بولي',
      'content_ru': 'Брак недействителен без присутствия и согласия опекуна (Вали).',
      'content_zh': '没有监护人（Wali）的出席和同意，婚姻 est 无效的。',
      'school_id': shMaliki
    });

    // Marriage: Mahr
    int topMahr = await db.insert('topics', {
      'category_id': catMariage,
      'title': 'La dot (Mahr)', 'title_en': 'Dowry (Mahr)', 'title_ar': 'المهر',
      'description': 'Le droit de l\'épouse à recevoir une dot lors du mariage.',
    });
    await db.insert('laws', {
      'topic_id': topMahr,
      'title': 'Obligation', 'title_en': 'Obligation', 'title_ar': 'الوجوب',
      'content': 'Le Mahr est un droit obligatoire de l\'épouse. Il peut être de l\'argent, des biens ou même un service.',
      'content_ar': 'المهر حق واجب للمرأة على زوجها بالعقد عليها.',
      'school_id': shShafii
    });

    // Fasting: Breaking fast out of forgetfulness
    int topForget = await db.insert('topics', {
      'category_id': catJeune,
      'title': 'Manger par oubli', 'title_en': 'Eating out of forgetfulness', 'title_ar': 'الأكل ناسياً في الصيام',
      'description': 'Le jugement sur celui qui mange ou boit par oubli pendant le jeûne.',
    });
    await db.insert('laws', {
      'topic_id': topForget,
      'title': 'Consensus Sunnite', 'title_en': 'Sunni Consensus', 'title_ar': 'جمهور العلماء',
      'content': 'Le jeûne n\'est pas rompu si l\'on mange ou boit par oubli. Il faut s\'arrêter dès que l\'on s\'en rappelle.',
      'content_ar': 'من أكل أو شرب ناسياً فليتم صومه، فإنما أطعمه الله وسقاه.',
      'school_id': shHanafi
    });

    // Prayer: Prostration (Sujud)
    int topSujud = await db.insert('topics', {
      'category_id': catCulte,
      'title': 'Les membres de la prosternation', 'title_en': 'Members of Prostration', 'title_ar': 'أعضاء السجود',
      'description': 'Les parties du corps qui doivent toucher le sol pendant le Sujud.',
    });
    await db.insert('laws', {
      'topic_id': topSujud,
      'title': 'Position Majoritaire', 'title_en': 'Majority Position', 'title_ar': 'قول الجمهور',
      'content': 'La prosternation doit se faire sur sept membres : le front (avec le nez), les deux mains, les deux genoux et les deux pieds.',
      'content_ar': 'أمرت أن أسجد على سبعة أعظم: الجبهة، واليدين، والركبتين، وأطراف القدمين.',
      'school_id': shShafii
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
      'type': 0, 'reference': 'Coran, 5:32', 'text': '...quiconque tue une personne... c\'est comme s\'il avait tué tous les hommes.',
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
    return results.map((t) {
      Map<String, dynamic> map = Map.from(t);
      if (locale != null) {
        String lang = locale.languageCode;
        if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
        if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
      }
      return Topic.fromMap(map);
    }).toList();
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

  Future<List<Topic>> searchTopics(String query, {Locale? locale}) async {
    Database db = await database;
    var results = await db.query('topics',
      where: 'title LIKE ? OR description LIKE ? OR title_en LIKE ? OR description_en LIKE ? OR title_ar LIKE ? OR description_ar LIKE ? OR title_ru LIKE ? OR description_ru LIKE ? OR title_zh LIKE ? OR description_zh LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%', '%$query%', '%$query%', '%$query%', '%$query%', '%$query%', '%$query%']
    );
    return results.map((t) {
      Map<String, dynamic> map = Map.from(t);
      if (locale != null) {
        String lang = locale.languageCode;
        if (map['title_$lang'] != null) map['title'] = map['title_$lang'];
        if (map['description_$lang'] != null) map['description'] = map['description_$lang'];
      }
      return Topic.fromMap(map);
    }).toList();
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
}
