import 'package:flutter/material.dart';

String localizedLearningText(
  Locale locale, {
  required String fr,
  String? en,
  String? ar,
  String? ru,
  String? zh,
}) {
  switch (locale.languageCode) {
    case 'en':
      return en ?? fr;
    case 'ar':
      return ar ?? fr;
    case 'ru':
      return ru ?? fr;
    case 'zh':
      return zh ?? fr;
    default:
      return fr;
  }
}

class FlashcardItem {
  final String questionFr;
  final String answerFr;
  final String? questionEn;
  final String? answerEn;
  final String? questionAr;
  final String? answerAr;

  const FlashcardItem({
    required this.questionFr,
    required this.answerFr,
    this.questionEn,
    this.answerEn,
    this.questionAr,
    this.answerAr,
  });

  String question(Locale locale) => localizedLearningText(
        locale,
        fr: questionFr,
        en: questionEn,
        ar: questionAr,
      );

  String answer(Locale locale) => localizedLearningText(
        locale,
        fr: answerFr,
        en: answerEn,
        ar: answerAr,
      );
}

class FlashcardDeck {
  final String id;
  final String titleFr;
  final String? titleEn;
  final String? titleAr;
  final IconData icon;
  final List<FlashcardItem> cards;

  const FlashcardDeck({
    required this.id,
    required this.titleFr,
    this.titleEn,
    this.titleAr,
    required this.icon,
    required this.cards,
  });

  String title(Locale locale) => localizedLearningText(
        locale,
        fr: titleFr,
        en: titleEn,
        ar: titleAr,
      );
}

class QuizQuestion {
  final String questionFr;
  final List<String> optionsFr;
  final int correctIndex;
  final String explanationFr;
  final String? questionEn;
  final List<String>? optionsEn;
  final String? explanationEn;
  final String? questionAr;
  final List<String>? optionsAr;
  final String? explanationAr;
  final String categoryId;

  const QuizQuestion({
    required this.questionFr,
    required this.optionsFr,
    required this.correctIndex,
    required this.explanationFr,
    required this.categoryId,
    this.questionEn,
    this.optionsEn,
    this.explanationEn,
    this.questionAr,
    this.optionsAr,
    this.explanationAr,
  });

  String question(Locale locale) => localizedLearningText(
        locale,
        fr: questionFr,
        en: questionEn,
        ar: questionAr,
      );

  List<String> options(Locale locale) {
    if (locale.languageCode == 'en' && optionsEn != null) return optionsEn!;
    if (locale.languageCode == 'ar' && optionsAr != null) return optionsAr!;
    return optionsFr;
  }

  String explanation(Locale locale) => localizedLearningText(
        locale,
        fr: explanationFr,
        en: explanationEn,
        ar: explanationAr,
      );
}

class LearningContent {
  static const purificationDeck = FlashcardDeck(
    id: 'purification',
    titleFr: 'Purification (Wudu & Ghusl)',
    titleEn: 'Purification (Wudu & Ghusl)',
    titleAr: 'الطهارة (الوضوء والغسل)',
    icon: Icons.water_drop,
    cards: [
      FlashcardItem(
        questionFr: 'Combien de parties du corps le Hanafi considère-t-il obligatoires dans le wudu ?',
        answerFr: 'Quatre : visage, bras jusqu\'aux coudes, quart de la tête, pieds jusqu\'aux chevilles.',
        questionEn: 'How many body parts does Hanafi consider obligatory in wudu?',
        answerEn: 'Four: face, arms to elbows, quarter of head, feet to ankles.',
        questionAr: 'كم عدد أعضاء الوضوء عند الحنفية؟',
        answerAr: 'أربعة: الوجه، واليدان إلى المرفقين، وربع الرأس، والرجلان إلى الكعبين.',
      ),
      FlashcardItem(
        questionFr: 'Qu\'est-ce qui annule le wudu selon le consensus majoritaire ?',
        answerFr: 'Les impuretés sortant des voies naturelles (urine, selles, gaz).',
        questionEn: 'What nullifies wudu by majority consensus?',
        answerEn: 'Impurity exiting natural passages (urine, stool, gas).',
        questionAr: 'ما الذي ينقض الوضوء بالإجماع؟',
        answerAr: 'خروج النجاسة من السبيلين (بول، غائط، ريح).',
      ),
      FlashcardItem(
        questionFr: 'Quelles sont les deux obligations du ghusl selon Shafi\'i ?',
        answerFr: 'L\'intention et laver tout le corps avec de l\'eau.',
        questionEn: 'What are the two ghusl obligations in Shafi\'i?',
        answerEn: 'Intention and washing the entire body with water.',
        questionAr: 'ما فريضتا الغسل عند الشافعية؟',
        answerAr: 'النية وإيصال الماء إلى جميع البدن.',
      ),
      FlashcardItem(
        questionFr: 'Quand le tayammum est-il permis ?',
        answerFr: 'En absence d\'eau ou impossibilité de l\'utiliser (maladie, froid extrême).',
        questionEn: 'When is tayammum permitted?',
        answerEn: 'When water is absent or unusable (illness, extreme cold).',
        questionAr: 'متى يجوز التيمم؟',
        answerAr: 'عند عدم وجود الماء أو العجز عن استعماله.',
      ),
      FlashcardItem(
        questionFr: 'Le Shafi\'i ajoute-t-il des obligations au wudu par rapport au Hanafi ?',
        answerFr: 'Oui : l\'intention, l\'ordre (tartib) et la continuité (muwalat).',
        questionEn: 'Does Shafi\'i add wudu obligations vs Hanafi?',
        answerEn: 'Yes: intention, order (tartib), and continuity (muwalat).',
        questionAr: 'هل يزيد الشافعي فروضاً على الحنفية في الوضوء؟',
        answerAr: 'نعم: النية والترتيب والموالاة.',
      ),
    ],
  );

  static const prayerDeck = FlashcardDeck(
    id: 'prayer',
    titleFr: 'Prière (Salat)',
    titleEn: 'Prayer (Salat)',
    titleAr: 'الصلاة',
    icon: Icons.mosque,
    cards: [
      FlashcardItem(
        questionFr: 'Combien de rak\'ats compte la prière du Dhuhr ?',
        answerFr: 'Quatre rak\'ats obligatoires.',
        questionEn: 'How many rak\'ats in Dhuhr prayer?',
        answerEn: 'Four obligatory rak\'ats.',
        questionAr: 'كم ركعة في صلاة الظهر؟',
        answerAr: 'أربع ركعات فرضاً.',
      ),
      FlashcardItem(
        questionFr: 'Le Qasr (raccourcissement) s\'applique à quelles prières ?',
        answerFr: 'Dhuhr, Asr et Isha (4 rak\'ats → 2) pour le voyageur éligible.',
        questionEn: 'Which prayers does Qasr apply to?',
        answerEn: 'Dhuhr, Asr and Isha (4 → 2 rak\'ats) for eligible travelers.',
        questionAr: 'في أي صلوات يجري القصر؟',
        answerAr: 'الظهر والعصر والعشاء (من أربع إلى ركعتين) للمسافر.',
      ),
      FlashcardItem(
        questionFr: 'Position Hanafi sur le Qasr ?',
        answerFr: 'Obligation (wajib) pour le voyageur qualifié.',
        questionEn: 'Hanafi position on Qasr?',
        answerEn: 'Obligation (wajib) for the qualified traveler.',
        questionAr: 'موقف الحنفية من القصر؟',
        answerAr: 'واجب على المسافر المستوفي للشروط.',
      ),
      FlashcardItem(
        questionFr: 'Position Shafi\'i sur le Qasr ?',
        answerFr: 'Permission (rukhsa) — le voyageur peut choisir entre raccourcir ou compléter.',
        questionEn: 'Shafi\'i position on Qasr?',
        answerEn: 'Permission (rukhsa) — traveler may shorten or complete.',
        questionAr: 'موقف الشافعية من القصر؟',
        answerAr: 'رخصة — للمسافر التخيير بين القصر والإتمام.',
      ),
      FlashcardItem(
        questionFr: 'Quels sont les piliers (arkan) de la salat ?',
        answerFr: 'Debout, takbir, récitation, inclinaison, prosternation, assise finale, salam.',
        questionEn: 'What are the pillars (arkan) of salat?',
        answerEn: 'Standing, takbir, recitation, bowing, prostration, final sitting, salam.',
        questionAr: 'ما أركان الصلاة؟',
        answerAr: 'القيام، التكبير، القراءة، الركوع، السجود، الجلسة الأخيرة، التسليم.',
      ),
    ],
  );

  static const fastingDeck = FlashcardDeck(
    id: 'fasting',
    titleFr: 'Jeûne & Zakat',
    titleEn: 'Fasting & Zakat',
    titleAr: 'الصيام والزكاة',
    icon: Icons.nightlight_round,
    cards: [
      FlashcardItem(
        questionFr: 'Quel est le nisab de l\'or pour la zakat ?',
        answerFr: '85 grammes d\'or pur (taux : 2,5%).',
        questionEn: 'What is the gold nisab for zakat?',
        answerEn: '85 grams of pure gold (rate: 2.5%).',
        questionAr: 'ما نصاب الذهب للزكاة؟',
        answerAr: '85 غراماً من الذهب الخالص (2.5%).',
      ),
      FlashcardItem(
        questionFr: 'Position Shafi\'i sur l\'intention du jeûne de Ramadan ?',
        answerFr: 'Renouveler l\'intention chaque nuit avant l\'aube.',
        questionEn: 'Shafi\'i on Ramadan fasting intention?',
        answerEn: 'Renew intention each night before dawn.',
        questionAr: 'موقف الشافعية من نية صوم رمضان؟',
        answerAr: 'تبييت النية كل ليلة قبل الفجر.',
      ),
      FlashcardItem(
        questionFr: 'Position Maliki sur l\'intention du jeûne de Ramadan ?',
        answerFr: 'Une intention au début du mois suffit pour tout Ramadan.',
        questionEn: 'Maliki on Ramadan fasting intention?',
        answerEn: 'One intention at month start suffices for all Ramadan.',
        questionAr: 'موقف المالكية من نية رمضان؟',
        answerAr: 'نية واحدة في أول الشهر تكفي لجميع أيامه.',
      ),
      FlashcardItem(
        questionFr: 'Que se passe-t-il si on mange par oubli pendant le jeûne ?',
        answerFr: 'Le jeûne reste valide selon le hadith authentique.',
        questionEn: 'What if one eats forgetfully while fasting?',
        answerEn: 'The fast remains valid per authentic hadith.',
        questionAr: 'ماذا لو أكل الصائم ناسياً؟',
        answerAr: 'صومه صحيح بحسب الحديث الصحيح.',
      ),
      FlashcardItem(
        questionFr: 'Sur quoi la zakat est-elle due en plus de l\'or et l\'argent ?',
        answerFr: 'Bétail, récoltes, commerce — selon conditions de chaque catégorie.',
        questionEn: 'Besides gold and silver, zakat is due on?',
        answerEn: 'Livestock, crops, trade goods — per each category\'s conditions.',
        questionAr: 'على ماذا تجب الزكاة غير الذهب والفضة؟',
        answerAr: 'الأنعام، الزروع، عروض التجارة — بحسب شروط كل نوع.',
      ),
    ],
  );

  static List<FlashcardDeck> get allDecks =>
      [purificationDeck, prayerDeck, fastingDeck, marriageDeck, zakatDeck];

  static const marriageDeck = FlashcardDeck(
    id: 'marriage',
    titleFr: 'Mariage (Nikah)',
    titleEn: 'Marriage (Nikah)',
    titleAr: 'الزواج (النكاح)',
    icon: Icons.favorite,
    cards: [
      FlashcardItem(
        questionFr: 'Quels sont les piliers du nikah selon Shafi\'i ?',
        answerFr: 'Époux, épouse, tuteur (Wali), deux témoins, et formule (Ijab/Qabul).',
        questionEn: 'Shafi\'i pillars of nikah?',
        answerEn: 'Groom, bride, wali, two witnesses, and offer/acceptance formula.',
        questionAr: 'أركان النكاح عند الشافعية؟',
        answerAr: 'الزوج والزوجة والولي والشاهدان والإيجاب والقبول.',
      ),
      FlashcardItem(
        questionFr: 'Le Mahr est-il obligatoire si non mentionné ?',
        answerFr: 'Oui, il devient obligatoire par le simple fait du contrat.',
        questionEn: 'Is mahr obligatory if not mentioned?',
        answerEn: 'Yes, it becomes obligatory by the contract itself.',
        questionAr: 'هل المهر واجب إن لم يُذكر؟',
        answerAr: 'نعم، يجب بالعقد ولو لم يُسم.',
      ),
      FlashcardItem(
        questionFr: 'Position Hanafi sur le Wali ?',
        answerFr: 'Non obligatoire pour une femme majeure saine d\'esprit.',
        questionEn: 'Hanafi on wali?',
        answerEn: 'Not required for a mature sane woman.',
        questionAr: 'موقف الحنفية من الولي؟',
        answerAr: 'ليس بشرط لكمال العقد للبالغة الرشيدة.',
      ),
      FlashcardItem(
        questionFr: 'Condition Hanbali pour un divorce sunnite ?',
        answerFr: 'Prononcé en période de pureté sans rapport conjugal.',
        questionEn: 'Hanbali condition for sunni divorce?',
        answerEn: 'Pronounced during purity without intercourse.',
        questionAr: 'شرط الطلاق السني عند الحنابلة؟',
        answerAr: 'في طهر لم يمس فيه بالجماع.',
      ),
      FlashcardItem(
        questionFr: 'Le consentement des deux parties est-il requis ?',
        answerFr: 'Oui, le consentement libre est une condition de validité.',
        questionEn: 'Is mutual consent required?',
        answerEn: 'Yes, free consent is a validity condition.',
        questionAr: 'هل يشترط رضا الطرفين؟',
        answerAr: 'نعم، الرضا شرط لصحة العقد.',
      ),
    ],
  );

  static const zakatDeck = FlashcardDeck(
    id: 'zakat',
    titleFr: 'Zakat & finances',
    titleEn: 'Zakat & Finance',
    titleAr: 'الزكاة والمعاملات',
    icon: Icons.savings,
    cards: [
      FlashcardItem(
        questionFr: 'Quel est le nisab de l\'or ?',
        answerFr: 'Environ 85 grammes d\'or pur.',
        questionEn: 'What is the gold nisab?',
        answerEn: 'About 85 grams of pure gold.',
        questionAr: 'ما نصاب الذهب؟',
        answerAr: 'نحو 85 غراماً من الذهب الخالص.',
      ),
      FlashcardItem(
        questionFr: 'Quel taux de zakat sur l\'épargne ?',
        answerFr: '2,5 % (1/40) après une année lunaire de possession.',
        questionEn: 'Zakat rate on savings?',
        answerEn: '2.5% (1/40) after one lunar year of ownership.',
        questionAr: 'نسبة زكاة المال؟',
        answerAr: '2,5% (1/40) بعد حول كامل.',
      ),
      FlashcardItem(
        questionFr: 'Combien de catégories de bénéficiaires de la zakat ?',
        answerFr: 'Huit catégories mentionnées dans le Coran (9:60).',
        questionEn: 'How many zakat recipient categories?',
        answerEn: 'Eight categories in Quran (9:60).',
        questionAr: 'كم مصرفاً للزكاة؟',
        answerAr: 'ثمانية مصارف في القرآن (9:60).',
      ),
      FlashcardItem(
        questionFr: 'Qu\'est-ce que la Murabaha ?',
        answerFr: 'Vente à prix de revient plus marge connue — alternative halal au crédit à intérêt.',
        questionEn: 'What is Murabaha?',
        answerEn: 'Cost-plus sale with known markup — halal credit alternative.',
        questionAr: 'ما المرابحة؟',
        answerAr: 'بيع بثمن الكلفة وزيادة معلومة — بديل حلال للقرض الربوي.',
      ),
      FlashcardItem(
        questionFr: 'Le Riba est-il permis en cas de nécessité ?',
        answerFr: 'Non — interdit par consensus, sans exception pour les intérêts bancaires.',
        questionEn: 'Is Riba permitted in necessity?',
        answerEn: 'No — forbidden by consensus, no exception for bank interest.',
        questionAr: 'هل يجوز الربا للضرورة؟',
        answerAr: 'لا — محرم بالإجماع بلا استثناء للفوائد البنكية.',
      ),
    ],
  );

  static List<QuizQuestion> get quizQuestions => [
    QuizQuestion(
      categoryId: 'purification',
      questionFr: 'Combien de fard (obligations) le wudu compte-t-il selon Hanafi ?',
      optionsFr: ['3', '4', '6', '7'],
      correctIndex: 1,
      explanationFr: 'Le madhhab hanafi compte 4 obligations dans le wudu.',
      questionEn: 'How many fard in wudu per Hanafi?',
      optionsEn: ['3', '4', '6', '7'],
      explanationEn: 'Hanafi madhhab counts 4 obligations in wudu.',
      questionAr: 'كم فريضة في الوضوء عند الحنفية؟',
      optionsAr: ['3', '4', '6', '7'],
      explanationAr: 'الحنفية يعدون أربع فروض في الوضوء.',
    ),
    QuizQuestion(
      categoryId: 'purification',
      questionFr: 'Le tayammum remplace quoi ?',
      optionsFr: ['Le jeûne', 'Le wudu et/ou le ghusl', 'La zakat', 'La prière'],
      correctIndex: 1,
      explanationFr: 'Le tayammum est une alternative rituelle au wudu ou ghusl en absence d\'eau.',
      questionEn: 'Tayammum replaces what?',
      optionsEn: ['Fasting', 'Wudu and/or ghusl', 'Zakat', 'Prayer'],
      explanationEn: 'Tayammum substitutes wudu or ghusl when water is unavailable.',
    ),
    QuizQuestion(
      categoryId: 'prayer',
      questionFr: 'Le Qasr réduit une prière de combien de rak\'ats ?',
      optionsFr: ['1', '2', '3', 'Aucune'],
      correctIndex: 1,
      explanationFr: 'Les prières de 4 rak\'ats passent à 2 pour le voyageur.',
      questionEn: 'Qasr reduces prayer by how many rak\'ats?',
      optionsEn: ['1', '2', '3', 'None'],
      explanationEn: '4-rak\'at prayers become 2 for the traveler.',
    ),
    QuizQuestion(
      categoryId: 'prayer',
      questionFr: 'Quelle école considère le Qasr comme wajib (obligatoire) ?',
      optionsFr: ['Maliki', 'Hanafi', 'Shafi\'i', 'Ja\'fari'],
      correctIndex: 1,
      explanationFr: 'Les Hanafites considèrent le raccourcissement obligatoire pour le voyageur.',
      questionEn: 'Which school considers Qasr wajib?',
      optionsEn: ['Maliki', 'Hanafi', 'Shafi\'i', 'Ja\'fari'],
      explanationEn: 'Hanafis consider shortening obligatory for the traveler.',
    ),
    QuizQuestion(
      categoryId: 'fasting',
      questionFr: 'Quel est le taux de la zakat sur l\'épargne ?',
      optionsFr: ['1%', '2,5%', '5%', '10%'],
      correctIndex: 1,
      explanationFr: 'Le taux standard de la zakat est de 2,5% (1/40).',
      questionEn: 'What is the zakat rate on savings?',
      optionsEn: ['1%', '2.5%', '5%', '10%'],
      explanationEn: 'Standard zakat rate is 2.5% (1/40).',
    ),
    QuizQuestion(
      categoryId: 'fasting',
      questionFr: 'Quand renouveler l\'intention de jeûne selon Shafi\'i ?',
      optionsFr: ['Une fois par an', 'Chaque nuit', 'Chaque semaine', 'Jamais'],
      correctIndex: 1,
      explanationFr: 'Shafi\'i exige la niyyah chaque nuit pour le jeûne obligatoire.',
      questionEn: 'When to renew fasting intention per Shafi\'i?',
      optionsEn: ['Once a year', 'Each night', 'Each week', 'Never'],
      explanationEn: 'Shafi\'i requires nightly niyyah for obligatory fasts.',
    ),
    QuizQuestion(
      categoryId: 'purification',
      questionFr: 'Que faut-il laver en entier pour un ghusl valide ?',
      optionsFr: ['Seulement les mains', 'Tout le corps', 'Seulement la tête', 'Les pieds uniquement'],
      correctIndex: 1,
      explanationFr: 'Le ghusl requiert que l\'eau atteigne chaque partie du corps.',
      questionEn: 'What must be washed fully for valid ghusl?',
      optionsEn: ['Hands only', 'Entire body', 'Head only', 'Feet only'],
      explanationEn: 'Ghusl requires water reaching every part of the body.',
    ),
    QuizQuestion(
      categoryId: 'prayer',
      questionFr: 'Combien de rak\'ats a la prière du Maghrib ?',
      optionsFr: ['2', '3', '4', '5'],
      correctIndex: 1,
      explanationFr: 'Maghrib comporte 3 rak\'ats obligatoires.',
      questionEn: 'How many rak\'ats in Maghrib?',
      optionsEn: ['2', '3', '4', '5'],
      explanationEn: 'Maghrib has 3 obligatory rak\'ats.',
    ),
    QuizQuestion(
      categoryId: 'fasting',
      questionFr: 'Le nisab de l\'argent est environ :',
      optionsFr: ['85g', '200g', '595g', '1000g'],
      correctIndex: 2,
      explanationFr: 'Le nisab argent est d\'environ 595g selon les savants.',
      questionEn: 'Silver nisab is approximately:',
      optionsEn: ['85g', '200g', '595g', '1000g'],
      explanationEn: 'Silver nisab is about 595g per scholars.',
    ),
    QuizQuestion(
      categoryId: 'fasting',
      questionFr: 'Manger par oubli pendant Ramadan :',
      optionsFr: ['Annule le jeûne', 'N\'annule pas le jeûne', 'Remplace par un autre jeûne obligatoire', 'Interdit sans expiation'],
      correctIndex: 1,
      explanationFr: 'Allah a nourri et abreuvé le jeûneur — le jeûne reste valide.',
      questionEn: 'Eating forgetfully during Ramadan:',
      optionsEn: ['Breaks the fast', 'Does not break the fast', 'Must substitute another fast', 'Forbidden without kaffarah'],
      explanationEn: 'Allah fed the fasting person — the fast remains valid.',
    ),
    QuizQuestion(
      categoryId: 'marriage',
      questionFr: 'Combien de témoins pour un nikah valide (consensus) ?',
      optionsFr: ['1', '2', '3', '4'],
      correctIndex: 1,
      explanationFr: 'Deux témoins musulmans justes sont requis selon le consensus.',
      questionEn: 'How many witnesses for valid nikah?',
      optionsEn: ['1', '2', '3', '4'],
      explanationEn: 'Two just Muslim witnesses are required by consensus.',
    ),
    QuizQuestion(
      categoryId: 'marriage',
      questionFr: 'Le Mahr appartient à :',
      optionsFr: ['La famille de la mariée', 'L\'épouse', 'Le Wali', 'Les témoins'],
      correctIndex: 1,
      explanationFr: 'Le Mahr est un droit exclusif de l\'épouse.',
      questionEn: 'Mahr belongs to:',
      optionsEn: ['Bride\'s family', 'The wife', 'The wali', 'Witnesses'],
      explanationEn: 'Mahr is the exclusive right of the wife.',
    ),
    QuizQuestion(
      categoryId: 'marriage',
      questionFr: 'Le divorce en période de menstruation est :',
      optionsFr: ['Recommandé', 'Sunni', 'Bid\'a (innovation)', 'Obligatoire'],
      correctIndex: 2,
      explanationFr: 'Le divorce pendant les règles est une bid\'a selon la sunna.',
      questionEn: 'Divorce during menstruation is:',
      optionsEn: ['Recommended', 'Sunni', 'Bid\'a (innovation)', 'Obligatory'],
      explanationEn: 'Divorce during menses is bid\'a per the sunna.',
    ),
    QuizQuestion(
      categoryId: 'economy',
      questionFr: 'Le Riba est :',
      optionsFr: ['Permis', 'Déconseillé', 'Strictement interdit', 'Obligatoire'],
      correctIndex: 2,
      explanationFr: 'L\'usure est haram par consensus des savants.',
      questionEn: 'Riba is:',
      optionsEn: ['Permitted', 'Discouraged', 'Strictly forbidden', 'Obligatory'],
      explanationEn: 'Interest is haram by scholarly consensus.',
    ),
    QuizQuestion(
      categoryId: 'economy',
      questionFr: 'La Murabaha est :',
      optionsFr: [
        'Un prêt à intérêt',
        'Une vente à marge connue',
        'Une aumône obligatoire',
        'Un type de jeûne',
      ],
      correctIndex: 1,
      explanationFr: 'La Murabaha est une vente halal avec prix et marge déclarés.',
      questionEn: 'Murabaha is:',
      optionsEn: ['Interest loan', 'Cost-plus sale', 'Obligatory charity', 'A type of fast'],
      explanationEn: 'Murabaha is a halal sale with declared cost and markup.',
    ),
    QuizQuestion(
      categoryId: 'economy',
      questionFr: 'Combien de catégories de bénéficiaires de la zakat ?',
      optionsFr: ['4', '6', '8', '10'],
      correctIndex: 2,
      explanationFr: 'Le Coran (9:60) mentionne huit catégories de bénéficiaires.',
      questionEn: 'How many zakat beneficiary categories?',
      optionsEn: ['4', '6', '8', '10'],
      explanationEn: 'Quran (9:60) lists eight beneficiary categories.',
    ),
    QuizQuestion(
      categoryId: 'ethics',
      questionFr: 'La médisance (Ghibah) consiste à :',
      optionsFr: ['Louer quelqu\'un', 'Parler mal de quelqu\'un en son absence', 'Donner la zakat', 'Jeûner'],
      correctIndex: 1,
      explanationFr: 'Ghibah = mentionner ce qu\'une personne détesterait entendre en son absence.',
      questionEn: 'Ghibah (backbiting) is:',
      optionsEn: ['Praising someone', 'Speaking ill of someone in their absence', 'Giving zakat', 'Fasting'],
      explanationEn: 'Ghibah is mentioning what someone would dislike in their absence.',
    ),
  ];
}
