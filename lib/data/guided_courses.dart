import 'package:flutter/material.dart';
import 'learning_content.dart';

class CourseDay {
  final int day;
  final String titleFr;
  final String? titleEn;
  final String? titleAr;
  final String summaryFr;
  final String? summaryEn;
  final String? summaryAr;
  final String topicTitleFr;

  const CourseDay({
    required this.day,
    required this.titleFr,
    required this.summaryFr,
    required this.topicTitleFr,
    this.titleEn,
    this.titleAr,
    this.summaryEn,
    this.summaryAr,
  });

  String title(Locale locale) => localizedLearningText(
        locale,
        fr: titleFr,
        en: titleEn,
        ar: titleAr,
      );

  String summary(Locale locale) => localizedLearningText(
        locale,
        fr: summaryFr,
        en: summaryEn,
        ar: summaryAr,
      );
}

class GuidedCourse {
  final String id;
  final String titleFr;
  final String? titleEn;
  final String? titleAr;
  final String descFr;
  final String? descEn;
  final String? descAr;
  final IconData icon;
  final List<CourseDay> days;

  const GuidedCourse({
    required this.id,
    required this.titleFr,
    required this.descFr,
    required this.icon,
    required this.days,
    this.titleEn,
    this.titleAr,
    this.descEn,
    this.descAr,
  });

  String title(Locale locale) => localizedLearningText(
        locale,
        fr: titleFr,
        en: titleEn,
        ar: titleAr,
      );

  String description(Locale locale) => localizedLearningText(
        locale,
        fr: descFr,
        en: descEn,
        ar: descAr,
      );
}

class GuidedCourses {
  static const prayerBasics = GuidedCourse(
    id: 'prayer_basics',
    titleFr: 'Les bases de la prière',
    titleEn: 'Prayer Basics',
    titleAr: 'أساسيات الصلاة',
    descFr: 'Parcours de 7 jours pour maîtriser les fondamentaux avant la salat.',
    descEn: 'A 7-day path to master the fundamentals before salat.',
    descAr: 'مسار 7 أيام لإتقان أساسيات الصلاة.',
    icon: Icons.mosque,
    days: [
      CourseDay(
        day: 1,
        titleFr: 'Jour 1 — Validité du wudu',
        titleEn: 'Day 1 — Wudu validity',
        titleAr: 'اليوم 1 — صحة الوضوء',
        summaryFr: 'Découvrez les conditions et obligations du wudu selon les écoles.',
        summaryEn: 'Learn wudu conditions and obligations across schools.',
        summaryAr: 'تعرّف على شروط الوضوء وفروضه.',
        topicTitleFr: 'Conditions de validité du wuḍū’',
      ),
      CourseDay(
        day: 2,
        titleFr: 'Jour 2 — Annulations du wudu',
        titleEn: 'Day 2 — Wudu nullifiers',
        titleAr: 'اليوم 2 — نواقض الوضوء',
        summaryFr: 'Identifiez ce qui invalide vos ablutions.',
        summaryEn: 'Identify what breaks your ablutions.',
        summaryAr: 'تعرّف على ما ينقض الوضوء.',
        topicTitleFr: 'Annulations du wuḍū’',
      ),
      CourseDay(
        day: 3,
        titleFr: 'Jour 3 — Le Ghusl',
        titleEn: 'Day 3 — Ghusl',
        titleAr: 'اليوم 3 — الغسل',
        summaryFr: 'Comprenez le bain rituel majeur et ses obligations.',
        summaryEn: 'Understand major ritual bathing and its rules.',
        summaryAr: 'افهم الغسل وفرائضه.',
        topicTitleFr: 'Obligations du Ghusl',
      ),
      CourseDay(
        day: 4,
        titleFr: 'Jour 4 — Le Tayammum',
        titleEn: 'Day 4 — Tayammum',
        titleAr: 'اليوم 4 — التيمم',
        summaryFr: 'L\'ablution sèche en l\'absence d\'eau.',
        summaryEn: 'Dry ablution when water is unavailable.',
        summaryAr: 'التيمم عند عدم توفر الماء.',
        topicTitleFr: 'Conditions du Tayammum',
      ),
      CourseDay(
        day: 5,
        titleFr: 'Jour 5 — Piliers de la Salat',
        titleEn: 'Day 5 — Pillars of Salat',
        titleAr: 'اليوم 5 — أركان الصلاة',
        summaryFr: 'Les piliers indispensables de la prière.',
        summaryEn: 'Essential pillars of prayer.',
        summaryAr: 'أركان الصلاة الضرورية.',
        topicTitleFr: 'Les piliers de la Salat',
      ),
      CourseDay(
        day: 6,
        titleFr: 'Jour 6 — Adhan et Iqama',
        titleEn: 'Day 6 — Adhan & Iqama',
        titleAr: 'اليوم 6 — الأذان والإقامة',
        summaryFr: 'L\'appel à la prière et ses règles.',
        summaryEn: 'The call to prayer and its rules.',
        summaryAr: 'الأذان وأحكامه.',
        topicTitleFr: 'L\'Adhan et l\'Iqama',
      ),
      CourseDay(
        day: 7,
        titleFr: 'Jour 7 — Prière du voyageur',
        titleEn: 'Day 7 — Traveler\'s prayer',
        titleAr: 'اليوم 7 — صلاة المسافر',
        summaryFr: 'Le raccourcissement (Qasr) et ses conditions.',
        summaryEn: 'Shortening (Qasr) and its conditions.',
        summaryAr: 'القصر وشروطه.',
        topicTitleFr: 'Le raccourcissement de la prière (Qasr)',
      ),
    ],
  );

  static const ramadanFasting = GuidedCourse(
    id: 'ramadan_fasting',
    titleFr: 'Jeûne & Ramadan',
    titleEn: 'Fasting & Ramadan',
    titleAr: 'الصيام ورمضان',
    descFr: 'Parcours de 5 jours pour comprendre les règles du jeûne.',
    descEn: 'A 5-day path to understand fasting rules.',
    descAr: 'مسار 5 أيام لفهم أحكام الصيام.',
    icon: Icons.nightlight_round,
    days: [
      CourseDay(
        day: 1,
        titleFr: 'Jour 1 — Intention du jeûne',
        titleEn: 'Day 1 — Fasting intention',
        titleAr: 'اليوم 1 — نية الصيام',
        summaryFr: 'Comment formuler l\'intention selon les écoles.',
        topicTitleFr: 'Intention du jeûne',
      ),
      CourseDay(
        day: 2,
        titleFr: 'Jour 2 — Nullificateurs',
        titleEn: 'Day 2 — Nullifiers',
        titleAr: 'اليوم 2 — مفطرات الصيام',
        summaryFr: 'Ce qui rompt le jeûne.',
        topicTitleFr: 'Les nullificateurs du jeûne',
      ),
      CourseDay(
        day: 3,
        titleFr: 'Jour 3 — Tarawih',
        titleEn: 'Day 3 — Tarawih',
        titleAr: 'اليوم 3 — التراويح',
        summaryFr: 'La prière nocturne de Ramadan.',
        topicTitleFr: 'La prière du Tarawih',
      ),
      CourseDay(
        day: 4,
        titleFr: 'Jour 4 — Zakat al-Fitr',
        titleEn: 'Day 4 — Zakat al-Fitr',
        titleAr: 'اليوم 4 — زكاة الفطر',
        summaryFr: 'L\'aumône de fin de Ramadan.',
        topicTitleFr: 'La Zakat al-Fitr',
      ),
      CourseDay(
        day: 5,
        titleFr: 'Jour 5 — I\'tikaf',
        titleEn: 'Day 5 — I\'tikaf',
        titleAr: 'اليوم 5 — الاعتكاف',
        summaryFr: 'Retraite spirituelle dans la mosquée.',
        topicTitleFr: 'L\'I\'tikaf en Ramadan',
      ),
    ],
  );

  static const marriageBasics = GuidedCourse(
    id: 'marriage_basics',
    titleFr: 'Fondements du mariage',
    titleEn: 'Marriage Foundations',
    titleAr: 'أساسيات الزواج',
    descFr: 'Parcours de 5 jours sur le nikah, la dot et le divorce.',
    descEn: 'A 5-day path on nikah, mahr and divorce.',
    descAr: 'مسار 5 أيام عن النكاح والمهر والطلاق.',
    icon: Icons.favorite,
    days: [
      CourseDay(
        day: 1,
        titleFr: 'Jour 1 — Contrat de mariage',
        titleEn: 'Day 1 — Marriage contract',
        titleAr: 'اليوم 1 — عقد النكاح',
        summaryFr: 'Les piliers essentiels du nikah.',
        topicTitleFr: 'Piliers du contrat de mariage',
      ),
      CourseDay(
        day: 2,
        titleFr: 'Jour 2 — La dot (Mahr)',
        titleEn: 'Day 2 — Dowry (Mahr)',
        titleAr: 'اليوم 2 — المهر',
        summaryFr: 'Règles et obligation de la dot.',
        topicTitleFr: 'Règles de la dot (Mahr)',
      ),
      CourseDay(
        day: 3,
        titleFr: 'Jour 3 — Le Wali',
        titleEn: 'Day 3 — The Wali',
        titleAr: 'اليوم 3 — الولي',
        summaryFr: 'Le rôle du tuteur dans le mariage.',
        topicTitleFr: 'Le rôle du Wali',
      ),
      CourseDay(
        day: 4,
        titleFr: 'Jour 4 — Droits conjugaux',
        titleEn: 'Day 4 — Spousal rights',
        titleAr: 'اليوم 4 — الحقوق الزوجية',
        summaryFr: 'Devoirs réciproques du mari et de la femme.',
        topicTitleFr: 'Les droits et devoirs conjugaux',
      ),
      CourseDay(
        day: 5,
        titleFr: 'Jour 5 — Divorce sunnite',
        titleEn: 'Day 5 — Sunni divorce',
        titleAr: 'اليوم 5 — الطلاق السني',
        summaryFr: 'Les règles du talaq conforme à la sunna.',
        topicTitleFr: 'Le divorce sunnite',
      ),
    ],
  );

  static const zakatFinance = GuidedCourse(
    id: 'zakat_finance',
    titleFr: 'Zakat & finances islamiques',
    titleEn: 'Zakat & Islamic Finance',
    titleAr: 'الزكاة والمعاملات المالية',
    descFr: 'Parcours de 5 jours sur la zakat, le riba et les contrats halal.',
    descEn: 'A 5-day path on zakat, riba and halal contracts.',
    descAr: 'مسار 5 أيام عن الزكاة والربا والعقود الحلال.',
    icon: Icons.savings,
    days: [
      CourseDay(
        day: 1,
        titleFr: 'Jour 1 — Le Nisab',
        titleEn: 'Day 1 — Nisab',
        titleAr: 'اليوم 1 — النصاب',
        summaryFr: 'Seuil minimum pour la zakat.',
        topicTitleFr: 'Le Nisab de la Zakat',
      ),
      CourseDay(
        day: 2,
        titleFr: 'Jour 2 — Bénéficiaires',
        titleEn: 'Day 2 — Beneficiaries',
        titleAr: 'اليوم 2 — المستحقون',
        summaryFr: 'Les huit catégories de bénéficiaires.',
        topicTitleFr: 'Les huit catégories de bénéficiaires',
      ),
      CourseDay(
        day: 3,
        titleFr: 'Jour 3 — Le Riba',
        titleEn: 'Day 3 — Riba',
        titleAr: 'اليوم 3 — الربا',
        summaryFr: 'Interdiction de l\'usure.',
        topicTitleFr: 'Les types de Riba',
      ),
      CourseDay(
        day: 4,
        titleFr: 'Jour 4 — Murabaha',
        titleEn: 'Day 4 — Murabaha',
        titleAr: 'اليوم 4 — المرابحة',
        summaryFr: 'Vente à marge connue, alternative halal.',
        topicTitleFr: 'La Murabaha',
      ),
      CourseDay(
        day: 5,
        titleFr: 'Jour 5 — Sadaqah',
        titleEn: 'Day 5 — Sadaqah',
        titleAr: 'اليوم 5 — الصدقة',
        summaryFr: 'L\'aumône volontaire.',
        topicTitleFr: 'La Sadaqah (aumône volontaire)',
      ),
    ],
  );

  static const purificationBasics = GuidedCourse(
    id: 'purification_basics',
    titleFr: 'Les bases de la purification',
    titleEn: 'Purification Basics',
    titleAr: 'أساسيات الطهارة',
    descFr: 'Parcours de 5 jours sur wudu, ghusl et tayammum.',
    descEn: 'A 5-day path on wudu, ghusl and tayammum.',
    descAr: 'مسار 5 أيام عن الوضوء والغسل والتيمم.',
    icon: Icons.water_drop,
    days: [
      CourseDay(
        day: 1,
        titleFr: 'Jour 1 — Validité du wudu',
        titleEn: 'Day 1 — Wudu validity',
        titleAr: 'اليوم 1 — صحة الوضوء',
        summaryFr: 'Conditions pour un wudu valide.',
        topicTitleFr: 'Conditions de validité du wuḍū’',
      ),
      CourseDay(
        day: 2,
        titleFr: 'Jour 2 — Annulations',
        titleEn: 'Day 2 — Nullifiers',
        titleAr: 'اليوم 2 — نواقض الوضوء',
        summaryFr: 'Ce qui annule le wudu.',
        topicTitleFr: 'Annulations du wuḍū’',
      ),
      CourseDay(
        day: 3,
        titleFr: 'Jour 3 — Ghusl',
        titleEn: 'Day 3 — Ghusl',
        titleAr: 'اليوم 3 — الغسل',
        summaryFr: 'Obligations du grand ablution.',
        topicTitleFr: 'Obligations du Ghusl',
      ),
      CourseDay(
        day: 4,
        titleFr: 'Jour 4 — Tayammum',
        titleEn: 'Day 4 — Tayammum',
        titleAr: 'اليوم 4 — التيمم',
        summaryFr: 'Ablution sèche en absence d\'eau.',
        topicTitleFr: 'Conditions du Tayammum',
      ),
      CourseDay(
        day: 5,
        titleFr: 'Jour 5 — Halal',
        titleEn: 'Day 5 — Halal',
        titleAr: 'اليوم 5 — الحلال',
        summaryFr: 'De la purification à la nourriture licite.',
        topicTitleFr: 'Conditions de la viande Halal',
      ),
    ],
  );

  static const ethicsBasics = GuidedCourse(
    id: 'ethics_basics',
    titleFr: 'Éthique & Akhlaq',
    titleEn: 'Ethics & Akhlaq',
    titleAr: 'الأخلاق والآداب',
    descFr: 'Parcours de 5 jours sur les vertus morales en Islam.',
    descEn: 'A 5-day path on moral virtues in Islam.',
    descAr: 'مسار 5 أيام عن الفضائل الأخلاقية في الإسلام.',
    icon: Icons.favorite,
    days: [
      CourseDay(
        day: 1,
        titleFr: 'Jour 1 — Véracité',
        titleEn: 'Day 1 — Truthfulness',
        titleAr: 'اليوم 1 — الصدق',
        summaryFr: 'La vertu de la sincérité et du vrai.',
        topicTitleFr: 'La véracité (As-Sidq)',
      ),
      CourseDay(
        day: 2,
        titleFr: 'Jour 2 — Médisance',
        titleEn: 'Day 2 — Backbiting',
        titleAr: 'اليوم 2 — الغيبة',
        summaryFr: 'Interdiction de parler mal d\'autrui.',
        topicTitleFr: 'La médisance (Ghibah)',
      ),
      CourseDay(
        day: 3,
        titleFr: 'Jour 3 — Patience',
        titleEn: 'Day 3 — Patience',
        titleAr: 'اليوم 3 — الصبر',
        summaryFr: 'Endurer avec foi et constance.',
        topicTitleFr: 'La patience (Sabr)',
      ),
      CourseDay(
        day: 4,
        titleFr: 'Jour 4 — Gratitude',
        titleEn: 'Day 4 — Gratitude',
        titleAr: 'اليوم 4 — الشكر',
        summaryFr: 'Reconnaissance envers Allah.',
        topicTitleFr: 'La gratitude (Shukr)',
      ),
      CourseDay(
        day: 5,
        titleFr: 'Jour 5 — Confiance',
        titleEn: 'Day 5 — Trust',
        titleAr: 'اليوم 5 — الأمانة',
        summaryFr: 'Respect des dépôts et engagements.',
        topicTitleFr: 'L\'Amanah (confiance)',
      ),
    ],
  );

  static const inheritanceBasics = GuidedCourse(
    id: 'inheritance_basics',
    titleFr: 'Héritage & Farāʾiḍ',
    titleEn: 'Inheritance & Faraid',
    titleAr: 'الميراث والفرائض',
    descFr: 'Parcours de 5 jours sur les règles de succession islamique.',
    descEn: 'A 5-day path on Islamic inheritance rules.',
    descAr: 'مسار 5 أيام عن أحكام الميراث الإسلامي.',
    icon: Icons.account_tree,
    days: [
      CourseDay(
        day: 1,
        titleFr: 'Jour 1 — La fille unique',
        titleEn: 'Day 1 — Only daughter',
        titleAr: 'اليوم 1 — البنت الواحدة',
        summaryFr: 'Part de la fille sans frère.',
        topicTitleFr: 'Part de la fille unique',
      ),
      CourseDay(
        day: 2,
        titleFr: 'Jour 2 — Le conjoint',
        titleEn: 'Day 2 — Spouse',
        titleAr: 'اليوم 2 — الزوجين',
        summaryFr: 'Parts du mari et de la femme.',
        topicTitleFr: 'Part du conjoint',
      ),
      CourseDay(
        day: 3,
        titleFr: 'Jour 3 — Frères et sœurs',
        titleEn: 'Day 3 — Siblings',
        titleAr: 'اليوم 3 — الإخوة',
        summaryFr: 'Héritage des frères et sœurs.',
        topicTitleFr: 'L\'héritage des frères et sœurs',
      ),
      CourseDay(
        day: 4,
        titleFr: 'Jour 4 — Le testament',
        titleEn: 'Day 4 — Will',
        titleAr: 'اليوم 4 — الوصية',
        summaryFr: 'Règles du wasiyyah.',
        topicTitleFr: 'Le testament (Wasiyyah)',
      ),
      CourseDay(
        day: 5,
        titleFr: 'Jour 5 — Le blocage',
        titleEn: 'Day 5 — Blocking',
        titleAr: 'اليوم 5 — الحجب',
        summaryFr: 'Exclusion partielle des héritiers.',
        topicTitleFr: 'Le blocage (Hajb)',
      ),
    ],
  );

  static List<GuidedCourse> get all => [
        prayerBasics,
        ramadanFasting,
        marriageBasics,
        zakatFinance,
        purificationBasics,
        ethicsBasics,
        inheritanceBasics,
      ];
}
