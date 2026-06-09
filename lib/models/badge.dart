import 'package:flutter/material.dart';

enum BadgeId {
  explorer,
  scholar,
  quizMaster,
  flashcardPro,
  sharer,
  comparer,
  courseGraduate,
  ramadanScholar,
  marriageExpert,
  polyglot,
  caseSolver,
  zakatExpert,
  streakKeeper,
  purificationGuide,
  halfCentury,
  centuryReader,
  ethicsScholar,
  zenReader,
  inheritanceExpert,
  methodologyReader,
  examAce,
  encyclopediaExam,
  comparatorPro,
}

extension BadgeIdExt on BadgeId {
  String get key => name;

  static BadgeId? fromKey(String key) {
    for (final b in BadgeId.values) {
      if (b.name == key) return b;
    }
    return null;
  }
}

class BadgeDefinition {
  final BadgeId id;
  final String titleFr;
  final String descFr;
  final String? titleEn;
  final String? descEn;
  final String? titleAr;
  final String? descAr;
  final IconData icon;

  const BadgeDefinition({
    required this.id,
    required this.titleFr,
    required this.descFr,
    required this.icon,
    this.titleEn,
    this.descEn,
    this.titleAr,
    this.descAr,
  });
}

class BadgeCatalog {
  static const all = [
    BadgeDefinition(
      id: BadgeId.explorer,
      titleFr: 'Explorateur',
      descFr: 'Lire 5 sujets différents',
      titleEn: 'Explorer',
      descEn: 'Read 5 different topics',
      titleAr: 'المستكشف',
      descAr: 'قراءة 5 مواضيع مختلفة',
      icon: Icons.explore,
    ),
    BadgeDefinition(
      id: BadgeId.scholar,
      titleFr: 'Érudit',
      descFr: 'Lire 10 sujets différents',
      titleEn: 'Scholar',
      descEn: 'Read 10 different topics',
      titleAr: 'العالم',
      descAr: 'قراءة 10 مواضيع مختلفة',
      icon: Icons.menu_book,
    ),
    BadgeDefinition(
      id: BadgeId.quizMaster,
      titleFr: 'Maître du quiz',
      descFr: 'Obtenir 70% ou plus au quiz',
      titleEn: 'Quiz Master',
      descEn: 'Score 70% or higher on the quiz',
      titleAr: 'بطل الاختبار',
      descAr: 'الحصول على 70% أو أكثر في الاختبار',
      icon: Icons.quiz,
    ),
    BadgeDefinition(
      id: BadgeId.flashcardPro,
      titleFr: 'Mémoriseur',
      descFr: 'Terminer un jeu de flashcards',
      titleEn: 'Memorizer',
      descEn: 'Complete a flashcard deck',
      titleAr: 'الحافظ',
      descAr: 'إكمال مجموعة بطاقات',
      icon: Icons.style,
    ),
    BadgeDefinition(
      id: BadgeId.sharer,
      titleFr: 'Partageur',
      descFr: 'Partager une citation',
      titleEn: 'Sharer',
      descEn: 'Share a citation',
      titleAr: 'المشارك',
      descAr: 'مشاركة اقتباس',
      icon: Icons.share,
    ),
    BadgeDefinition(
      id: BadgeId.comparer,
      titleFr: 'Comparateur',
      descFr: 'Consulter un tableau comparatif',
      titleEn: 'Comparer',
      descEn: 'View a comparison table',
      titleAr: 'المقارن',
      descAr: 'عرض جدول مقارنة',
      icon: Icons.compare_arrows,
    ),
    BadgeDefinition(
      id: BadgeId.courseGraduate,
      titleFr: 'Diplômé',
      descFr: 'Terminer le parcours « Les bases de la prière »',
      titleEn: 'Graduate',
      descEn: 'Complete the Prayer Basics course',
      titleAr: 'الخريج',
      descAr: 'إكمال مسار أساسيات الصلاة',
      icon: Icons.school,
    ),
    BadgeDefinition(
      id: BadgeId.ramadanScholar,
      titleFr: 'Savant du Ramadan',
      descFr: 'Terminer le parcours Jeûne & Ramadan',
      titleEn: 'Ramadan Scholar',
      descEn: 'Complete the Fasting & Ramadan course',
      titleAr: 'عالم رمضان',
      descAr: 'إكمال مسار الصيام ورمضان',
      icon: Icons.nightlight_round,
    ),
    BadgeDefinition(
      id: BadgeId.marriageExpert,
      titleFr: 'Expert en mariage',
      descFr: 'Terminer le parcours Fondements du mariage',
      titleEn: 'Marriage Expert',
      descEn: 'Complete the Marriage Foundations course',
      titleAr: 'خبير الزواج',
      descAr: 'إكمال مسار أساسيات الزواج',
      icon: Icons.favorite,
    ),
    BadgeDefinition(
      id: BadgeId.polyglot,
      titleFr: 'Polyglotte',
      descFr: 'Lire un même sujet en deux langues',
      titleEn: 'Polyglot',
      descEn: 'Read the same topic in two languages',
      titleAr: 'متعدد اللغات',
      descAr: 'قراءة نفس الموضوع بلغتين',
      icon: Icons.translate,
    ),
    BadgeDefinition(
      id: BadgeId.caseSolver,
      titleFr: 'Juriste pratique',
      descFr: 'Résoudre 3 cas pratiques',
      titleEn: 'Case Solver',
      descEn: 'Solve 3 practical cases',
      titleAr: 'فقيه عملي',
      descAr: 'حل 3 حالات عملية',
      icon: Icons.psychology,
    ),
    BadgeDefinition(
      id: BadgeId.zakatExpert,
      titleFr: 'Expert Zakat',
      descFr: 'Terminer le parcours Zakat & finances',
      titleEn: 'Zakat Expert',
      descEn: 'Complete the Zakat & Finance course',
      titleAr: 'خبير الزكاة',
      descAr: 'إكمال مسار الزكاة والمال',
      icon: Icons.savings,
    ),
    BadgeDefinition(
      id: BadgeId.streakKeeper,
      titleFr: 'Régularité',
      descFr: 'Lire un sujet 7 jours consécutifs',
      titleEn: 'Consistency',
      descEn: 'Read a topic 7 days in a row',
      titleAr: 'المواظبة',
      descAr: 'قراءة موضوع 7 أيام متتالية',
      icon: Icons.local_fire_department,
    ),
    BadgeDefinition(
      id: BadgeId.purificationGuide,
      titleFr: 'Guide de la purification',
      descFr: 'Terminer le parcours Purification',
      titleEn: 'Purification Guide',
      descEn: 'Complete the Purification course',
      titleAr: 'دليل الطهارة',
      descAr: 'إكمال مسار الطهارة',
      icon: Icons.water_drop,
    ),
    BadgeDefinition(
      id: BadgeId.halfCentury,
      titleFr: 'Demi-siècle',
      descFr: 'Lire 50 sujets différents',
      titleEn: 'Half Century',
      descEn: 'Read 50 different topics',
      titleAr: 'نصف المئة',
      descAr: 'قراءة 50 موضوعاً مختلفاً',
      icon: Icons.auto_stories,
    ),
    BadgeDefinition(
      id: BadgeId.centuryReader,
      titleFr: 'Centurion',
      descFr: 'Lire 100 sujets différents',
      titleEn: 'Centurion',
      descEn: 'Read 100 different topics',
      titleAr: 'قارئ المئة',
      descAr: 'قراءة 100 موضوع مختلف',
      icon: Icons.military_tech,
    ),
    BadgeDefinition(
      id: BadgeId.ethicsScholar,
      titleFr: 'Savant en éthique',
      descFr: 'Terminer le parcours Éthique & Akhlaq',
      titleEn: 'Ethics Scholar',
      descEn: 'Complete the Ethics & Akhlaq course',
      titleAr: 'عالم الأخلاق',
      descAr: 'إكمال مسار الأخلاق والآداب',
      icon: Icons.volunteer_activism,
    ),
    BadgeDefinition(
      id: BadgeId.zenReader,
      titleFr: 'Lecteur zen',
      descFr: 'Utiliser le mode lecture zen',
      titleEn: 'Zen Reader',
      descEn: 'Use zen reading mode',
      titleAr: 'القارئ المتأمل',
      descAr: 'استخدام وضع القراءة الهادئة',
      icon: Icons.chrome_reader_mode,
    ),
    BadgeDefinition(
      id: BadgeId.inheritanceExpert,
      titleFr: 'Expert en héritage',
      descFr: 'Terminer le parcours Héritage & Farāʾiḍ',
      titleEn: 'Inheritance Expert',
      descEn: 'Complete the Inheritance course',
      titleAr: 'خبير الميراث',
      descAr: 'إكمال مسار الميراث والفرائض',
      icon: Icons.account_tree,
    ),
    BadgeDefinition(
      id: BadgeId.methodologyReader,
      titleFr: 'Esprit critique',
      descFr: 'Consulter la méthodologie de l\'application',
      titleEn: 'Critical Mind',
      descEn: 'Read the app methodology',
      titleAr: 'العقل النقدي',
      descAr: 'قراءة منهجية التطبيق',
      icon: Icons.verified_user,
    ),
    BadgeDefinition(
      id: BadgeId.examAce,
      titleFr: 'As du examen',
      descFr: 'Réussir un quiz en mode examen (≥ 80 %)',
      titleEn: 'Exam Ace',
      descEn: 'Pass an exam-mode quiz (≥ 80%)',
      titleAr: 'نجم الاختبار',
      descAr: 'النجاح في اختبار الوضع الامتحاني (≥ 80%)',
      icon: Icons.military_tech,
    ),
    BadgeDefinition(
      id: BadgeId.encyclopediaExam,
      titleFr: 'Expert encyclopédique',
      descFr: 'Réussir l\'examen encyclopédique (≥ 70 %)',
      titleEn: 'Encyclopedia Expert',
      descEn: 'Pass the encyclopedia exam (≥ 70%)',
      titleAr: 'خبير الموسوعة',
      descAr: 'النجاح في امتحان الموسوعة (≥ 70%)',
      icon: Icons.library_books,
    ),
    BadgeDefinition(
      id: BadgeId.comparatorPro,
      titleFr: 'Comparateur pro',
      descFr: 'Exporter une comparaison de madhhabs en PDF',
      titleEn: 'Comparator Pro',
      descEn: 'Export a madhhab comparison as PDF',
      titleAr: 'محترف المقارنة',
      descAr: 'تصدير مقارنة المذاهب بصيغة PDF',
      icon: Icons.picture_as_pdf,
    ),
  ];

  static BadgeDefinition? find(BadgeId id) {
    for (final b in all) {
      if (b.id == id) return b;
    }
    return null;
  }
}
