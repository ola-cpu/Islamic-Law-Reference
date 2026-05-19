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
      version: 4,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
         // Simplified for this task: recreate tables if upgrading
         await _dropTables(db);
         await _onCreate(db, newVersion);
      },
    );
  }

  Future<void> _dropTables(Database db) async {
    await db.execute('DROP TABLE IF EXISTS media');
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
        image_url TEXT,
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
    // Schools
    int shHanafi = await db.insert('schools', {'name': 'Hanafi', 'description': 'L\'école de l\'Imam Abu Hanifa.'});
    int shMaliki = await db.insert('schools', {'name': 'Maliki', 'description': 'L\'école de l\'Imam Malik.'});
    int shShafii = await db.insert('schools', {'name': 'Shafi\'i', 'description': 'L\'école de l\'Imam Al-Shafi\'i.'});
    int shHanbali = await db.insert('schools', {'name': 'Hanbali', 'description': 'L\'école de l\'Imam Ahmad ibn Hanbal.'});
    int shJafari = await db.insert('schools', {'name': 'Ja\'fari', 'description': 'L\'école de l\'Imam Ja\'far al-Sadiq.'});

    // Categories
    int catCulte = await db.insert('categories', {
      'name': 'Prière et culte',
      'icon': 'mosque',
      'image_url': 'https://images.unsplash.com/photo-1542718610-a1d656d1884c?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });
    int catJeune = await db.insert('categories', {
      'name': 'Jeûne, zakât et pèlerinage',
      'icon': 'volunteer_activism',
      'image_url': 'https://images.unsplash.com/photo-1564121211835-e88c852648ab?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });
    int catFamille = await db.insert('categories', {
      'name': 'Relations sociales et familiales',
      'icon': 'people',
      'image_url': 'https://images.unsplash.com/photo-1511895426328-dc8714191300?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });
    int catMariage = await db.insert('categories', {
      'name': 'Mariage, divorce et garde des enfants',
      'icon': 'family_restroom',
      'image_url': 'https://images.unsplash.com/photo-1581333100576-b73bbe92c2cb?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });
    int catEconomie = await db.insert('categories', {
      'name': 'Économie, finance et commerce',
      'icon': 'monetization_on',
      'image_url': 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });
    int catJustice = await db.insert('categories', {
      'name': 'Justice et gouvernance',
      'icon': 'gavel',
      'image_url': 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });
    int catEthique = await db.insert('categories', {
      'name': 'Éthique et spiritualité',
      'icon': 'favorite',
      'image_url': 'https://images.unsplash.com/photo-1509021436665-8f07dbf5bf1d?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });
    int catAlimentation = await db.insert('categories', {
      'name': 'Alimentation et règles de pureté',
      'icon': 'restaurant',
      'image_url': 'https://images.unsplash.com/photo-1547573854-74d2a71d0826?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });
    int catContrats = await db.insert('categories', {
      'name': 'Les contrats et engagements',
      'icon': 'description',
      'image_url': 'https://images.unsplash.com/photo-1505664194779-8beaceb93744?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });
    int catDroits = await db.insert('categories', {
      'name': 'Les droits et devoirs individuels',
      'icon': 'accessibility',
      'image_url': 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });
    int catHeritage = await db.insert('categories', {
      'name': 'Héritage et succession (Farāʾiḍ)',
      'icon': 'account_balance',
      'image_url': 'https://images.unsplash.com/photo-14539414037aa4-944c883e585e?auto=format&fit=crop&q=80&w=1000',
      'parent_id': null
    });

    // Category 1: Prière et culte
    int topHands = await db.insert('topics', {
      'category_id': catCulte,
      'title': 'Lever les mains dans la prière',
      'description': 'Les règles concernant le fait de lever les mains à différents moments de la prière.'
    });
    await db.insert('topics', {'category_id': catCulte, 'title': 'Les conditions de la prière', 'description': 'Les prérequis nécessaires pour la validité de la prière.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Les horaires des prières', 'description': 'Les temps prescrits pour chacune des cinq prières obligatoires.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Les ablutions (wuḍū’)', 'description': 'La purification mineure avant la prière.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Le ghusl (grande purification)', 'description': 'Le bain rituel obligatoire dans certaines situations.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Le tayammum', 'description': 'La purification sèche en l\'absence d\'eau.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Les piliers et obligations de la prière', 'description': 'Les éléments essentiels qui constituent la prière.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Les prières surérogatoires (Nawāfil)', 'description': 'Les prières volontaires recommandées.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'La prière du vendredi (Jumu\'ah)', 'description': 'Les règles spécifiques à la prière collective du vendredi.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'La prière en voyage', 'description': 'Les allègements accordés au voyageur.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Les prières des fêtes (ʿĪd)', 'description': 'Les règles des prières de l\'Aïd al-Fitr et de l\'Aïd al-Adha.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'La prière funéraire (Janāzah)', 'description': 'La prière sur le défunt musulman.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Les invocations et adhkār', 'description': 'Les rappels et supplications liés à la prière.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Les règles de la mosquée', 'description': 'L\'étiquette et les dispositions légales liées au lieu de culte.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Les annulations et erreurs (Sujūd al-Sahw)', 'description': 'Comment corriger les oublis ou erreurs pendant la prière.'});
    await db.insert('topics', {'category_id': catCulte, 'title': 'Divergences entre écoles (Prière)', 'description': 'Les principaux points de désaccord sur les actes d\'adoration.'});

    // Category 2: Jeûne, Zakât et pèlerinage
    int subCatJeune = await db.insert('categories', {'name': 'Jeûne (Ṣawm)', 'icon': 'self_improvement', 'parent_id': catJeune});
    await db.insert('topics', {'category_id': subCatJeune, 'title': 'Conditions du jeûne', 'description': 'Les prérequis pour l\'obligation du jeûne.'});
    await db.insert('topics', {'category_id': subCatJeune, 'title': 'Invalidations du jeûne', 'description': 'Les actes qui rompent le jeûne.'});
    await db.insert('topics', {'category_id': subCatJeune, 'title': 'Jeûne de Ramadan', 'description': 'Les règles spécifiques au mois béni.'});
    await db.insert('topics', {'category_id': subCatJeune, 'title': 'Jeûnes volontaires', 'description': 'Les jours recommandés pour le jeûne surérogatoire.'});
    await db.insert('topics', {'category_id': subCatJeune, 'title': 'Rattrapage et expiation (Kaffārah)', 'description': 'Comment compenser les jours manqués.'});
    await db.insert('topics', {'category_id': subCatJeune, 'title': 'Jeûne du voyageur et du malade', 'description': 'Les dispenses accordées par la charia.'});
    await db.insert('topics', {'category_id': subCatJeune, 'title': 'Iʿtikāf', 'description': 'La retraite spirituelle à la mosquée.'});

    int subCatZakat = await db.insert('categories', {'name': 'Zakât', 'icon': 'volunteer_activism', 'parent_id': catJeune});
    await db.insert('topics', {'category_id': subCatZakat, 'title': 'Calcul de la zakât', 'description': 'Comment déterminer le montant dû.'});
    await db.insert('topics', {'category_id': subCatZakat, 'title': 'Le Nisāb', 'description': 'Le seuil de richesse au-delà duquel la zakât devient obligatoire.'});
    await db.insert('topics', {'category_id': subCatZakat, 'title': 'Catégories de biens concernés', 'description': 'Or, argent, bétail, récoltes et commerce.'});
    await db.insert('topics', {'category_id': subCatZakat, 'title': 'Bénéficiaires de la zakât', 'description': 'Les huit catégories de personnes pouvant recevoir la zakât.'});
    await db.insert('topics', {'category_id': subCatZakat, 'title': 'Zakāt al-fiṭr', 'description': 'L\'aumône obligatoire à la fin du Ramadan.'});
    await db.insert('topics', {'category_id': subCatZakat, 'title': 'Zakât commerciale et agricole', 'description': 'Règles spécifiques pour les commerçants et agriculteurs.'});

    int subCatHajj = await db.insert('categories', {'name': 'Pèlerinage (Ḥajj et ʿUmrah)', 'icon': 'mosque', 'parent_id': catJeune});
    await db.insert('topics', {'category_id': subCatHajj, 'title': 'Conditions du pèlerinage', 'description': 'Qui doit effectuer le Hajj.'});
    await db.insert('topics', {'category_id': subCatHajj, 'title': 'Rites du ḥajj', 'description': 'Le déroulement étape par étape.'});
    await db.insert('topics', {'category_id': subCatHajj, 'title': 'Iḥrām', 'description': 'L\'état de sacralisation et ses interdits.'});
    await db.insert('topics', {'category_id': subCatHajj, 'title': 'Tawāf et Saʿy', 'description': 'Les circumambulations et la marche entre Safa et Marwa.'});
    await db.insert('topics', {'category_id': subCatHajj, 'title': 'Sacrifices (Hady)', 'description': 'L\'offrande rituelles lors du pèlerinage.'});
    await db.insert('topics', {'category_id': subCatHajj, 'title': 'Erreurs et compensations (Fidyah)', 'description': 'Comment réparer les manquements aux rites.'});
    await db.insert('topics', {'category_id': subCatHajj, 'title': 'Différences entre ḥajj et ʿumrah', 'description': 'Comparaison des deux types de pèlerinage.'});

    // Category 3: Relations sociales et familiales
    await db.insert('topics', {'category_id': catFamille, 'title': 'Respect des parents', 'description': 'Le devoir de piété filiale en Islam.'});
    await db.insert('topics', {'category_id': catFamille, 'title': 'Droits des voisins', 'description': 'L\'importance du bon voisinage.'});
    await db.insert('topics', {'category_id': catFamille, 'title': 'Relations entre musulmans', 'description': 'Les bases de la fraternité islamique.'});
    await db.insert('topics', {'category_id': catFamille, 'title': 'Fraternité et solidarité', 'description': 'L\'entraide au sein de la communauté.'});
    await db.insert('topics', {'category_id': catFamille, 'title': 'Comportement en société (Adab)', 'description': 'L\'étiquette sociale et le savoir-vivre.'});
    await db.insert('topics', {'category_id': catFamille, 'title': 'Éducation des enfants', 'description': 'Les responsabilités des parents envers leur progéniture.'});
    await db.insert('topics', {'category_id': catFamille, 'title': 'Gestion des conflits', 'description': 'La médiation et la réconciliation.'});
    await db.insert('topics', {'category_id': catFamille, 'title': 'Droits des invités', 'description': 'Les règles de l\'hospitalité.'});
    await db.insert('topics', {'category_id': catFamille, 'title': 'Relations avec les non-musulmans', 'description': 'La coexistence et le respect mutuel.'});
    await db.insert('topics', {'category_id': catFamille, 'title': 'Visites et salutations', 'description': 'Les règles du Salam et des visites.'});

    // Category 4: Mariage, divorce et garde des enfants
    int topMahr = await db.insert('topics', {
      'category_id': catMariage,
      'title': 'La Dot (Mahr)',
      'description': 'Les règles concernant le don obligatoire du mari à son épouse lors du mariage.'
    });
    await db.insert('topics', {'category_id': catMariage, 'title': 'Conditions du mariage (Nikāḥ)', 'description': 'Les éléments requis pour la validité du contrat.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Contrat de mariage', 'description': 'La rédaction et les clauses du contrat.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Droits et devoirs des époux', 'description': 'Les obligations mutuelles dans le couple.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Polygamie', 'description': 'Les règles et conditions de la polygamie.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Causes de divorce', 'description': 'Quand le divorce devient une nécessité.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Le ṭalāq', 'description': 'La répudiation par le mari.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Le khulʿ', 'description': 'Le divorce à l\'initiative de l\'épouse.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Période de viduité (ʿiddah)', 'description': 'Le temps d\'attente après une séparation.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Pension et entretien (Nafaqah)', 'description': 'La prise en charge financière de la famille.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Garde des enfants (Ḥaḍānah)', 'description': 'À qui revient la garde en cas de divorce.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Filiation et Adoption (Kafālah)', 'description': 'La reconnaissance de l\'enfant et la prise en charge d\'orphelins.'});
    await db.insert('topics', {'category_id': catMariage, 'title': 'Médiation familiale', 'description': 'Chercher la conciliation avant la rupture.'});

    // Category 5: Économie, finance et commerce
    int topRiba = await db.insert('topics', {
      'category_id': catEconomie,
      'title': 'Le Riba (Intérêt)',
      'description': 'L\'interdiction de l\'usure et de l\'intérêt dans les transactions financières.'
    });
    await db.insert('topics', {'category_id': catEconomie, 'title': 'Commerce Halal', 'description': 'Les principes de base des échanges licites.'});
    await db.insert('topics', {'category_id': catEconomie, 'title': 'Contrats commerciaux', 'description': 'Les différents types de contrats en Islam.'});
    await db.insert('topics', {'category_id': catEconomie, 'title': 'Partenariats (Mushārakah)', 'description': 'Le partage des profits et des pertes.'});
    await db.insert('topics', {'category_id': catEconomie, 'title': 'Investissements et ventes interdites', 'description': 'Ce qu\'il n\'est pas permis de commercialiser.'});
    await db.insert('topics', {'category_id': catEconomie, 'title': 'Dette et crédit', 'description': 'L\'éthique de l\'emprunt et du remboursement.'});
    await db.insert('topics', {'category_id': catEconomie, 'title': 'Finance et Banques Islamiques', 'description': 'Le fonctionnement du système bancaire sans Riba.'});
    await db.insert('topics', {'category_id': catEconomie, 'title': 'Assurances Islamiques (Takāful)', 'description': 'Le concept d\'assurance mutuelle.'});
    await db.insert('topics', {'category_id': catEconomie, 'title': 'Commerce électronique', 'description': 'Les règles modernes de la vente en ligne.'});
    await db.insert('topics', {'category_id': catEconomie, 'title': 'Fraude et tromperie', 'description': 'L\'interdiction de la triche dans les transactions.'});
    await db.insert('topics', {'category_id': catEconomie, 'title': 'Monnaies numériques', 'description': 'Le statut juridique des cryptomonnaies.'});

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

    // Seed Media for 'Lever les mains'
    await db.insert('media', {
      'topic_id': topHands,
      'type': 0, // Image
      'url': 'https://images.unsplash.com/photo-1597933971247-a95054881729?auto=format&fit=crop&q=80&w=1000',
      'title': 'Positions des mains',
      'description': 'Illustration des différentes positions des mains selon les écoles.'
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

    // Category 6: Justice et gouvernance
    int topWitness = await db.insert('topics', {
      'category_id': catJustice,
      'title': 'Le Témoignage (Shahada)',
      'description': 'Les conditions pour qu\'un témoignage soit accepté devant un juge.'
    });
    await db.insert('topics', {'category_id': catJustice, 'title': 'Justice Islamique', 'description': 'Les principes fondamentaux de l\'équité.'});
    await db.insert('topics', {'category_id': catJustice, 'title': 'Preuves et procédures', 'description': 'Le déroulement d\'un procès en Islam.'});
    await db.insert('topics', {'category_id': catJustice, 'title': 'Droits des citoyens', 'description': 'Les garanties individuelles face à l\'État.'});
    await db.insert('topics', {'category_id': catJustice, 'title': 'Responsabilités des gouvernants', 'description': 'Les devoirs de ceux qui détiennent l\'autorité.'});
    await db.insert('topics', {'category_id': catJustice, 'title': 'Consultation (Shūrā)', 'description': 'Le principe de participation politique.'});
    await db.insert('topics', {'category_id': catJustice, 'title': 'Arbitrage et médiation', 'description': 'Le règlement amiable des litiges.'});
    await db.insert('topics', {'category_id': catJustice, 'title': 'Sanctions et peines (Hudūd et Ta\'zīr)', 'description': 'Le système pénal islamique.'});
    await db.insert('topics', {'category_id': catJustice, 'title': 'Protection des biens et des personnes', 'description': 'La sécurité publique en Islam.'});
    await db.insert('topics', {'category_id': catJustice, 'title': 'Équité sociale', 'description': 'La justice distributive.'});
    await db.insert('topics', {'category_id': catJustice, 'title': 'Gouvernance éthique', 'description': 'La morale dans l\'exercice du pouvoir.'});

    // Category 7: Éthique et spiritualité
    int topSincerity = await db.insert('topics', {
      'category_id': catEthique,
      'title': 'L\'Importance de l\'Intention',
      'description': 'La place de l\'intention (Niyya) dans les actes d\'adoration.'
    });
    await db.insert('topics', {'category_id': catEthique, 'title': 'La Sincérité (Ikhlāṣ)', 'description': 'Agir uniquement pour l\'agrément d\'Allah.'});
    await db.insert('topics', {'category_id': catEthique, 'title': 'Patience et Gratitude', 'description': 'Les deux piliers de la foi.'});
    await db.insert('topics', {'category_id': catEthique, 'title': 'Confiance en Allah (Tawakkul)', 'description': 'S\'en remettre à Dieu après avoir agi.'});
    await db.insert('topics', {'category_id': catEthique, 'title': 'Repentance (Tawbah)', 'description': 'Le retour vers Allah après une faute.'});
    await db.insert('topics', {'category_id': catEthique, 'title': 'Modestie et humilité', 'description': 'La vertu de se rabaisser devant Dieu.'});
    await db.insert('topics', {'category_id': catEthique, 'title': 'Purification du cœur', 'description': 'Lutter contre l\'orgueil, la jalousie et la colère.'});
    await db.insert('topics', {'category_id': catEthique, 'title': 'Bonnes manières (Husn al-Khuluq)', 'description': 'L\'excellence du comportement.'});
    await db.insert('topics', {'category_id': catEthique, 'title': 'Développement personnel islamique', 'description': 'S\'améliorer en tant que croyant.'});
    await db.insert('topics', {'category_id': catEthique, 'title': 'Spiritualité quotidienne', 'description': 'Vivre sa foi à chaque instant.'});

    // Category 8: Alimentation et règles de pureté
    await db.insert('topics', {'category_id': catAlimentation, 'title': 'Aliments Halal et Haram', 'description': 'Ce qui est licite et illicite à consommer.'});
    await db.insert('topics', {'category_id': catAlimentation, 'title': 'Abattage rituel (Dhabīḥah)', 'description': 'Les règles pour rendre la viande licite.'});
    await db.insert('topics', {'category_id': catAlimentation, 'title': 'Boissons interdites', 'description': 'L\'interdiction de l\'alcool et des stupéfiants.'});
    await db.insert('topics', {'category_id': catAlimentation, 'title': 'Impuretés (Najāsāt)', 'description': 'Identifier et nettoyer les substances impures.'});
    await db.insert('topics', {'category_id': catAlimentation, 'title': 'Purification des vêtements et lieux', 'description': 'Comment rendre son environnement pur.'});
    await db.insert('topics', {'category_id': catAlimentation, 'title': 'Hygiène personnelle', 'description': 'Les règles de la Fitrah et de la propreté.'});
    await db.insert('topics', {'category_id': catAlimentation, 'title': 'Règles liées aux animaux', 'description': 'Pureté et licéité des animaux.'});
    await db.insert('topics', {'category_id': catAlimentation, 'title': 'Ustensiles et récipients', 'description': 'Ce qu\'il est permis d\'utiliser pour manger et boire.'});

    // Category 9: Contrats et engagements
    await db.insert('topics', {'category_id': catContrats, 'title': 'Promesses et engagements', 'description': 'L\'obligation de respecter sa parole.'});
    await db.insert('topics', {'category_id': catContrats, 'title': 'Location (Ijārah)', 'description': 'Les règles du louage de services ou de biens.'});
    await db.insert('topics', {'category_id': catContrats, 'title': 'Prêts et Garanties', 'description': 'Sécuriser les transactions financières.'});
    await db.insert('topics', {'category_id': catContrats, 'title': 'Contrats de travail', 'description': 'Les droits des employeurs et des salariés.'});
    await db.insert('topics', {'category_id': catContrats, 'title': 'Donations et Testaments (Waṣiyyah)', 'description': 'Disposer de ses biens de son vivant ou pour après sa mort.'});
    await db.insert('topics', {'category_id': catContrats, 'title': 'Responsabilité contractuelle', 'description': 'Les conséquences du non-respect des engagements.'});
    await db.insert('topics', {'category_id': catContrats, 'title': 'Conditions de validité des contrats', 'description': 'Les éléments essentiels de tout accord.'});
    await db.insert('topics', {'category_id': catContrats, 'title': 'Annulation et litiges', 'description': 'Comment mettre fin à un contrat.'});

    // Category 10: Droits et devoirs individuels
    await db.insert('topics', {'category_id': catDroits, 'title': 'Droits fondamentaux', 'description': 'La protection de la vie, des biens et de l\'honneur.'});
    await db.insert('topics', {'category_id': catDroits, 'title': 'Liberté et responsabilité', 'description': 'Le libre arbitre au sein de la loi divine.'});
    await db.insert('topics', {'category_id': catDroits, 'title': 'Droit à l\'éducation', 'description': 'L\'obligation de rechercher la science.'});
    await db.insert('topics', {'category_id': catDroits, 'title': 'Droit au travail', 'description': 'Gagner sa vie honnêtement.'});
    await db.insert('topics', {'category_id': catDroits, 'title': 'Droits des femmes', 'description': 'Le statut et les garanties accordés aux femmes.'});
    await db.insert('topics', {'category_id': catDroits, 'title': 'Droits des enfants', 'description': 'La protection et l\'éducation de la jeunesse.'});
    await db.insert('topics', {'category_id': catDroits, 'title': 'Comportement civique', 'description': 'Les devoirs envers la société.'});
    await db.insert('topics', {'category_id': catDroits, 'title': 'Responsabilité morale', 'description': 'Répondre de ses actes devant Dieu et les hommes.'});

    // Category 11: Héritage et succession (Farāʾiḍ)
    await db.insert('topics', {'category_id': catHeritage, 'title': 'Parts d\'héritage', 'description': 'Les quotités fixées par le Coran.'});
    await db.insert('topics', {'category_id': catHeritage, 'title': 'Héritiers prioritaires', 'description': 'Ceux qui ne peuvent être exclus de la succession.'});
    await db.insert('topics', {'category_id': catHeritage, 'title': 'Héritage des époux et enfants', 'description': 'Les règles spécifiques pour le noyau familial.'});
    await db.insert('topics', {'category_id': catHeritage, 'title': 'Héritage des parents, frères et sœurs', 'description': 'Le partage entre les ascendants et collatéraux.'});
    await db.insert('topics', {'category_id': catHeritage, 'title': 'Empêchements à l\'héritage', 'description': 'Les causes qui privent d\'une part successorale.'});
    await db.insert('topics', {'category_id': catHeritage, 'title': 'Calcul des parts', 'description': 'La méthodologie pratique de partage.'});
    await db.insert('topics', {'category_id': catHeritage, 'title': 'Dettes et testaments dans la succession', 'description': 'Ce qui doit être prélevé avant le partage.'});
    await db.insert('topics', {'category_id': catHeritage, 'title': 'Divergences entre écoles sur la succession', 'description': 'Les points de désaccord entre les madhahib.'});
    await db.insert('topics', {'category_id': catHeritage, 'title': 'Calculateur d\'héritage', 'description': 'Outil d\'aide au calcul des parts successorales.'});

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
