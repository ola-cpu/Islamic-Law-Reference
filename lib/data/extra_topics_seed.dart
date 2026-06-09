import 'package:sqflite/sqflite.dart';

/// Bulk seed for Phase 8 — expands encyclopedia toward 100+ topics.
class ExtraTopicsSeed {
  static Future<void> insert(
    Database db, {
    required int subAblutions,
    required int subGhusl,
    required int subPriereObligatoire,
    required int subPriereVoyageur,
    required int subZakat,
    required int subFinance,
    required int subContratMariage,
    required int subDivorce,
    required int catJeune,
    required int catMariage,
    required int catFamille,
    required int catEthique,
    required int catEconomie,
    required int catContrats,
    required int catJustice,
    required int catAlimentation,
    required int catHeritage,
    required int catDroits,
    required int catCulte,
    required int shHanafi,
    required int shMaliki,
    required int shShafii,
    required int shHanbali,
    required int shJafari,
  }) async {
    final topics = <_Seed>[
      // Prière & culte
      _Seed(subPriereObligatoire, 'Les sunan autour de la prière', 'Sunnahs around Prayer', 'سنن حول الصلاة',
          'Gestes recommandés avant, pendant et après la salat.', shShafii, 'Adhan, iqama, douas et sunan rawatib.'),
      _Seed(subPriereObligatoire, 'La prière du Tahajjud', 'Tahajjud Prayer', 'صلاة التهجد',
          'Prière nocturne surécompensée.', shHanbali, 'Sunna muakkada entre Isha et Fajr, par paires.'),
      _Seed(subPriereObligatoire, 'Les conditions de l\'imam', 'Conditions of the Imam', 'شروط الإمام',
          'Qualités requises pour diriger la prière.', shMaliki, 'Juste, connaît les règles, voix audible.'),
      _Seed(catCulte, 'La prière funéraire (Janaza)', 'Funeral Prayer (Janaza)', 'صلاة الجنازة',
          'Prière communautaire pour le défunt.', shHanafi, '4 takbirs, pas de ruku ni sujud, sans adhan.'),
      _Seed(subPriereObligatoire, 'Le rattrapage des prières (Qada)', 'Making Up Missed Prayers', 'قضاء الصلاة',
          'Règles pour rattraper les prières manquées.', shShafii, 'Obligation de qada ; ordre recommandé selon écoles.'),
      _Seed(subPriereObligatoire, 'La prière de l\'Istikhara', 'Istikhara Prayer', 'صلاة الاستخارة',
          'Demander guidance divine pour une décision.', shHanafi, '2 rak\'ats puis doua spécifique du Prophète ﷺ.'),
      _Seed(subPriereVoyageur, 'La prière sur le cavalier/véhicule', 'Prayer on Mount/Vehicle', 'الصلاة على الدابة',
          'Prière en voyage sans descendre.', shMaliki, 'Permise en urgence ; gestes par signes si impossible.'),
      // Purification
      _Seed(subAblutions, 'Les sunan du wudu', 'Sunnahs of Wudu', 'سنن الوضوء',
          'Actes recommandés dans les ablutions.', shShafii, 'Bismillah, miswak, ordre, triple lavage.'),
      _Seed(subAblutions, 'Le mesh sur la tête', 'Wiping the Head', 'المسح على الرأس',
          'Comment passer les mains mouillées sur la tête.', shHanafi, 'Quart de la tête minimum pour Hanafi.'),
      _Seed(subGhusl, 'Le ghusl de janaba', 'Ghusl of Janaba', 'غسل الجنابة',
          'Grandes ablutions après état majeur.', shHanbali, 'Obligatoire après rapport ou émission.'),
      _Seed(subGhusl, 'Le ghusl du vendredi', 'Friday Ghusl', 'غسل الجمعة',
          'Ablution recommandée avant Jumu\'a.', shMaliki, 'Sunna pour celui qui assiste à la prière du vendredi.'),
      // Jeûne & Hajj
      _Seed(catJeune, 'Le jeûne des jours blancs', 'White Days Fasting', 'صيام الأيام البيض',
          'Jeûne des 13, 14 et 15 de chaque mois lunaire.', shShafii, 'Sunna muakkada, comme jeûne de Shawwal.'),
      _Seed(catJeune, 'Le jeûne de Ashura', 'Ashura Fasting', 'صيام عاشوراء',
          'Jeûne du 10 Muharram.', shHanafi, 'Sunna ; 9 et 10 ou 10 et 11 recommandés pour se distinguer.'),
      _Seed(catJeune, 'Le suhur et l\'iftar', 'Suhur and Iftar', 'السحور والإفطار',
          'Règles des repas avant et après le jeûne.', shMaliki, 'Suhur béni ; rompre à la tombée du soleil avec dattes.'),
      _Seed(catJeune, 'Les conditions du Hajj', 'Conditions of Hajj', 'شروط الحج',
          'Qui doit accomplir le pèlerinage.', shShafii, 'Musulman, pubère, sain d\'esprit, capacité physique et financière.'),
      _Seed(catJeune, 'Le sacrifice (Udhiyah)', 'Udhiyah Sacrifice', 'الأضحية',
          'Sacrifice de l\'Aïd al-Adha.', shHanbali, 'Sunna muakkada pour celui qui peut ; viande distribuée.'),
      _Seed(subZakat, 'Zakat sur les récoltes', 'Zakat on Crops', 'زكاة الزروع',
          'Aumône sur les produits agricoles.', shHanafi, '10% irrigation naturelle, 5% irrigation artificielle.'),
      _Seed(subZakat, 'Zakat sur le commerce', 'Zakat on Trade Goods', 'زكاة عروض التجارة',
          'Calcul sur les stocks marchands.', shMaliki, '2,5% sur valeur marchande après un an.'),
      // Mariage & famille
      _Seed(catMariage, 'La garde des enfants (Hadana)', 'Child Custody (Hadana)', 'الحضانة',
          'Droit de garde après séparation.', shShafii, 'À la mère pour le jeune enfant sauf intérêt de l\'enfant.'),
      _Seed(catFamille, 'L\'allaitement et ses règles', 'Breastfeeding Rules', 'أحكام الرضاعة',
          'Impact de l\'allaitement sur le mariage.', shHanafi, 'Cinq tétées établissent filiation de nourriture.'),
      _Seed(subDivorce, 'Le Khula (divorce par la femme)', 'Khula Divorce', 'الخلع',
          'Rupture initiée par l\'épouse avec compensation.', shMaliki, 'Valide avec accord et contrepartie (généralement Mahr).'),
      _Seed(subContratMariage, 'Les empêchements au mariage', 'Marriage Impediments', 'الموانع من النكاح',
          'Qui ne peut pas épouser qui.', shShafii, 'Consanguinité, allaitage, alliance, simultanéité interdites.'),
      _Seed(catFamille, 'Les droits des parents', 'Rights of Parents', 'حقوق الوالدين',
          'Obéissance et bienfaisance envers père et mère.', shHanafi, 'Birr al-walidayn obligatoire sauf ordre de désobéissance à Allah.'),
      // Éthique
      _Seed(catEthique, 'La patience (Sabr)', 'Patience (Sabr)', 'الصبر',
          'Endurance face aux épreuves.', shHanbali, 'Trois types : sur le décret, sur l\'obéissance, loin du péché.'),
      _Seed(catEthique, 'La gratitude (Shukr)', 'Gratitude (Shukr)', 'الشكر',
          'Reconnaissance envers Allah et les gens.', shShafii, 'Par le cœur, la langue et les actes.'),
      _Seed(catEthique, 'L\'humilité (Tawadu)', 'Humility (Tawadu)', 'التواضع',
          'Éviter l\'arrogance.', shMaliki, 'Vertu cardinale ; le Prophète ﷺ en est le modèle.'),
      _Seed(catEthique, 'Éviter l\'orgueil (Kibr)', 'Avoiding Pride (Kibr)', 'الكبر',
          'Interdiction de mépriser autrui.', shHanafi, 'Grain de moutarde de kibr suffit à empêcher l\'entrée au Paradis.'),
      _Seed(catEthique, 'La bienveillance (Ihsan)', 'Excellence (Ihsan)', 'الإحسان',
          'Faire le bien avec excellence.', shShafii, 'Adorer Allah comme si tu Le vois.'),
      // Économie & contrats
      _Seed(subFinance, 'La Mudaraba', 'Mudaraba Partnership', 'المضاربة',
          'Partenariat capital/travail.', shHanafi, 'Un apporte capital, l\'autre travail ; profits partagés.'),
      _Seed(catContrats, 'Le Gharar dans les contrats', 'Gharar in Contracts', 'الغرر في العقود',
          'Interdiction de l\'incertitude excessive.', shMaliki, 'Vente de poisson dans l\'eau ou oiseau dans l\'air nulle.'),
      _Seed(catContrats, 'La vente sous condition', 'Conditional Sale', 'البيع المعلق',
          'Validité des clauses suspensives.', shShafii, 'Condition licite ne doit contredire le contrat.'),
      _Seed(catEconomie, 'Le salaire équitable', 'Fair Wages', 'الأجر العادل',
          'Rémunération juste du travailleur.', shHanbali, 'Donner le salaire avant que sa sueur ne sèche (hadith).'),
      _Seed(subFinance, 'La monnaie et l\'échange', 'Currency Exchange', 'صرف العملات',
          'Règles du change (sarf).', shHanafi, 'Échange immédiat et quantités égales pour or/argent.'),
      // Justice
      _Seed(catJustice, 'Le Qisas (loi du talion)', 'Qisas (Retaliation)', 'القصاص',
          'Justice pour le meurtre et les blessures.', shMaliki, 'Droit de la victime ou héritiers ; pardon encouragé.'),
      _Seed(catJustice, 'La médiation (Sulh)', 'Mediation (Sulh)', 'الصلح',
          'Résolution amiable des conflits.', shShafii, 'Recommandée ; le juge peut proposer un compromis.'),
      _Seed(catJustice, 'Le faux témoignage', 'False Testimony', 'شهادة الزور',
          'Gravité de mentir sous serment.', shHanafi, 'Parmi les grands péchés ; annule la validité du témoignage.'),
      _Seed(catJustice, 'La gouvernance (Shura)', 'Governance (Shura)', 'الشورى',
          'Consultation dans les affaires publiques.', shHanbali, 'Principe coranique pour les décisions collectives.'),
      // Alimentation
      _Seed(catAlimentation, 'Les animaux interdits', 'Forbidden Animals', 'الحيوانات المحرمة',
          'Bêtes dont la consommation est haram.', shShafii, 'Porc, carnivores, oiseaux à serres, bêtes non égorgées.'),
      _Seed(catAlimentation, 'L\'alcool et les intoxicants', 'Alcohol and Intoxicants', 'الخمر والمسكرات',
          'Interdiction de toute substance enivrante.', shHanafi, 'Toute quantité enivrante en grande quantité est haram.'),
      _Seed(catAlimentation, 'La nourriture des gens du Livre', 'Food of People of the Book', 'طعام أهل الكتاب',
          'Permis de consommer leur viande abattue.', shMaliki, 'Permis selon majorité si abattage licite.'),
      // Héritage
      _Seed(catHeritage, 'Le testament (Wasiyyah)', 'Will (Wasiyyah)', 'الوصية',
          'Disposition pour après le décès.', shHanafi, 'Max 1/3 du patrimoine pour non-héritiers.'),
      _Seed(catHeritage, 'Le blocage (Hajb)', 'Blocking (Hajb)', 'الحجب',
          'Exclusion partielle d\'un héritier.', shShafii, 'Héritier proche bloque lointain.'),
      _Seed(catHeritage, 'Parts des parents', 'Parents\' Shares', 'ميراث الوالدين',
          'Fraction du père et de la mère.', shMaliki, 'Mère : 1/6 ou 1/3 ; père : 1/6 ou plus selon cas.'),
      // Droits
      _Seed(catDroits, 'Droits des enfants', 'Children\'s Rights', 'حقوق الأطفال',
          'Éducation, entretien et justice entre enfants.', shShafii, 'Nom juste, bonne éducation, traitement équitable.'),
      _Seed(catDroits, 'Droits des employés', 'Employees\' Rights', 'حقوق العمال',
          'Protection du travailleur en Islam.', shHanbali, 'Salaire juste, repos, pas de charge excessive.'),
      _Seed(catDroits, 'La liberté de conscience', 'Freedom of Conscience', 'حرية الاعتقاد',
          'Pas de contrainte en religion.', shHanafi, '« Pas de contrainte dans la religion » (Coran 2:256).'),
      // Divers culte
      _Seed(catCulte, 'Les mosquées et leurs règles', 'Mosques and Their Rules', 'أحكام المساجد',
          'Respect et usages dans la mosquée.', shMaliki, 'Purification, calme, pas de transactions commerciales.'),
      _Seed(catCulte, 'L\'appel à la prière (Adhan)', 'Call to Prayer Rules', 'أحكام الأذان',
          'Détails juridiques de l\'adhan.', shHanafi, 'Mérite élevé ; répéter après le muezzin.'),
      _Seed(catCulte, 'La prosternation de récitation', 'Prostration of Recitation', 'سجود التلاوة',
          'Sujud lors de lecture de verset de prosternation.', shShafii, 'Sunna pour qui entend ou lit le verset.'),
      _Seed(catJeune, 'Le jeûne du pèlerin', 'Fasting of the Pilgrim', 'صيام الحاج',
          'Peut-on jeûner pendant le Hajj ?', shHanbali, 'Déconseillé les jours de tashreeq ; permis autres jours.'),
      _Seed(catMariage, 'La polygamie en Islam', 'Polygamy in Islam', 'تعدد الزوجات',
          'Conditions de la pluralité d\'épouses.', shShafii, 'Max 4 ; justice obligatoire entre épouses.'),
      _Seed(catEthique, 'Le pardon (Afw)', 'Forgiveness (Afw)', 'العفو',
          'Vertu de pardonner autrui.', shMaliki, 'Allah aime les bienfaisants et les cléments.'),
      _Seed(catFamille, 'Les liens de parenté (Rahim)', 'Kinship Ties (Rahim)', 'صلة الرحم',
          'Maintenir les liens familiaux.', shHanafi, 'Rompre la parenté est péché ; maintenir est récompensé.'),
    ];

    for (final t in topics) {
      final id = await db.insert('topics', {
        'category_id': t.categoryId,
        'title': t.titleFr,
        'title_en': t.titleEn,
        'title_ar': t.titleAr,
        'description': t.descFr,
      });
      await db.insert('laws', {
        'topic_id': id,
        'school_id': t.schoolId,
        'title': _schoolName(t.schoolId, shHanafi, shMaliki, shShafii, shHanbali, shJafari),
        'content': t.lawContent,
      });
    }
  }

  static String _schoolName(int id, int hanafi, int maliki, int shafii, int hanbali, int jafari) {
    if (id == hanafi) return 'Hanafi';
    if (id == maliki) return 'Maliki';
    if (id == shafii) return 'Shafi\'i';
    if (id == hanbali) return 'Hanbali';
    if (id == jafari) return 'Ja\'fari';
    return 'Consensus';
  }
}

class _Seed {
  final int categoryId;
  final String titleFr;
  final String titleEn;
  final String titleAr;
  final String descFr;
  final int schoolId;
  final String lawContent;

  const _Seed(
    this.categoryId,
    this.titleFr,
    this.titleEn,
    this.titleAr,
    this.descFr,
    this.schoolId,
    this.lawContent,
  );
}
