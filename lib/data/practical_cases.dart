import 'package:flutter/material.dart';
import 'learning_content.dart';

class SchoolRuling {
  final String schoolSlug;
  final String rulingFr;
  final String? rulingEn;
  final String? rulingAr;

  const SchoolRuling({
    required this.schoolSlug,
    required this.rulingFr,
    this.rulingEn,
    this.rulingAr,
  });

  String ruling(Locale locale) => localizedLearningText(
        locale,
        fr: rulingFr,
        en: rulingEn,
        ar: rulingAr,
      );
}

class PracticalCase {
  final String id;
  final String titleFr;
  final String scenarioFr;
  final List<String> optionsFr;
  final int correctIndex;
  final String explanationFr;
  final List<SchoolRuling> schoolRulings;
  final IconData icon;
  final String? titleEn;
  final String? titleAr;
  final String? scenarioEn;
  final String? scenarioAr;
  final List<String>? optionsEn;
  final List<String>? optionsAr;
  final String? explanationEn;
  final String? explanationAr;

  const PracticalCase({
    required this.id,
    required this.titleFr,
    required this.scenarioFr,
    required this.optionsFr,
    required this.correctIndex,
    required this.explanationFr,
    required this.schoolRulings,
    required this.icon,
    this.titleEn,
    this.titleAr,
    this.scenarioEn,
    this.scenarioAr,
    this.optionsEn,
    this.optionsAr,
    this.explanationEn,
    this.explanationAr,
  });

  String title(Locale locale) => localizedLearningText(locale, fr: titleFr, en: titleEn, ar: titleAr);

  String scenario(Locale locale) =>
      localizedLearningText(locale, fr: scenarioFr, en: scenarioEn, ar: scenarioAr);

  List<String> options(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return optionsEn ?? optionsFr;
      case 'ar':
        return optionsAr ?? optionsFr;
      default:
        return optionsFr;
    }
  }

  String explanation(Locale locale) =>
      localizedLearningText(locale, fr: explanationFr, en: explanationEn, ar: explanationAr);
}

class PracticalCases {
  static const all = [
    PracticalCase(
      id: 'fasting_intention',
      icon: Icons.nightlight_round,
      titleFr: 'Intention de jeûne oubliée',
      titleEn: 'Forgotten fasting intention',
      titleAr: 'نسيان نية الصيام',
      scenarioFr:
          'Vous vous réveillez un matin de Ramadan sans avoir formulé l\'intention de jeûner la veille. Que se passe-t-il selon les écoles ?',
      scenarioEn:
          'You wake up on a Ramadan morning without having formed the intention to fast the night before. What happens per the schools?',
      scenarioAr: 'استيقظت صباح رمضان دون نية الصيام من الليلة السابقة. ماذا يقول المذاهب؟',
      optionsFr: [
        'Le jeûne est invalide pour tous',
        'Shafi\'i : invalide ; Maliki : valide si intention au début du mois',
        'Tous acceptent sans intention',
        'Il faut rompre le jeûne immédiatement',
      ],
      optionsEn: [
        'Fast is invalid for all',
        'Shafi\'i: invalid; Maliki: valid if monthly intention',
        'All accept without intention',
        'Must break fast immediately',
      ],
      optionsAr: [
        'الصيام باطل عند الجميع',
        'الشافعي: باطل؛ المالكي: صحيح بنية الشهر',
        'الجميع يقبلون بلا نية',
        'يجب الإفطار فوراً',
      ],
      correctIndex: 1,
      explanationFr: 'Les Shafi\'ites exigent la niyyah chaque nuit ; les Malikites acceptent une intention pour tout le mois.',
      explanationEn: 'Shafi\'is require nightly niyyah; Malikis accept one intention for the whole month.',
      explanationAr: 'الشافعية يشترطون النية كل ليلة؛ المالكية يكتفون بنية الشهر.',
      schoolRulings: [
        SchoolRuling(
          schoolSlug: 'shafii',
          rulingFr: 'Le jeûne est invalide sans niyyah avant l\'aube.',
          rulingEn: 'Fast is invalid without niyyah before dawn.',
          rulingAr: 'لا يصح الصيام بلا نية قبل الفجر.',
        ),
        SchoolRuling(
          schoolSlug: 'maliki',
          rulingFr: 'Une intention au début de Ramadan suffit pour tout le mois.',
          rulingEn: 'Intention at start of Ramadan suffices for the whole month.',
          rulingAr: 'نية بداية رمضان تكفي للشهر كله.',
        ),
      ],
    ),
    PracticalCase(
      id: 'traveler_qasr',
      icon: Icons.directions_walk,
      titleFr: 'Voyageur et Qasr',
      titleEn: 'Traveler and Qasr',
      titleAr: 'المسافر والقصر',
      scenarioFr: 'Vous voyagez plus de 80 km. Comment raccourcir la prière de Dhuhr (4 rak\'ats) ?',
      scenarioEn: 'You travel over 80 km. How to shorten Dhuhr prayer (4 rak\'ats)?',
      scenarioAr: 'سافرت أكثر من 80 كم. كيف تقصر صلاة الظهر؟',
      optionsFr: [
        'Pas de raccourcissement possible',
        '2 rak\'ats — Hanafi : obligatoire ; Shafi\'i : permission',
        '3 rak\'ats seulement',
        'Remplacer par 2 prières séparées',
      ],
      optionsEn: [
        'No shortening allowed',
        '2 rak\'ats — Hanafi: obligatory; Shafi\'i: permission',
        '3 rak\'ats only',
        'Replace with 2 separate prayers',
      ],
      optionsAr: [
        'لا قصر',
        'ركعتان — حنفي: واجب؛ شافعي: رخصة',
        '3 ركعات فقط',
        'صلاتان منفصلتان',
      ],
      correctIndex: 1,
      explanationFr: 'Le Qasr réduit les prières de 4 à 2 rak\'ats ; Hanafi le rend wajib, Shafi\'i le considère rukhsa.',
      explanationEn: 'Qasr reduces 4-rak\'at prayers to 2; Hanafi makes it wajib, Shafi\'i considers it rukhsa.',
      explanationAr: 'القصر يحول الرباعية إلى ركعتين؛ الحنفية يوجبونه والشافعية يجيزونه.',
      schoolRulings: [
        SchoolRuling(
          schoolSlug: 'hanafi',
          rulingFr: 'Le raccourcissement est wajib (obligatoire) pour le voyageur.',
          rulingEn: 'Shortening is wajib for the traveler.',
          rulingAr: 'القصر واجب على المسافر.',
        ),
        SchoolRuling(
          schoolSlug: 'shafii',
          rulingFr: 'Le raccourcissement est une rukhsa (permission), au choix du voyageur.',
          rulingEn: 'Shortening is rukhsa (permission), traveler\'s choice.',
          rulingAr: 'القصر رخصة يختارها المسافر.',
        ),
      ],
    ),
    PracticalCase(
      id: 'forgetful_eating',
      icon: Icons.restaurant,
      titleFr: 'Manger par oubli',
      titleEn: 'Eating forgetfully',
      titleAr: 'الأكل ناسياً',
      scenarioFr: 'Pendant Ramadan, vous mangez par oubli puis vous vous souvenez. Que faire ?',
      scenarioEn: 'During Ramadan you eat forgetfully then remember. What to do?',
      scenarioAr: 'أكلت ناسياً في رمضان ثم تذكرت. ماذا تفعل؟',
      optionsFr: [
        'Le jeûne est rompu — kaffarah obligatoire',
        'Continuer le jeûne — il reste valide',
        'Recommencer le jeûne le lendemain',
        'Jeûner 60 jours consécutifs',
      ],
      optionsEn: [
        'Fast broken — kaffarah required',
        'Continue fasting — it remains valid',
        'Restart fast tomorrow',
        'Fast 60 consecutive days',
      ],
      optionsAr: [
        'انقطع الصيام — كفارة',
        'أكمل الصيام — يبقى صحيحاً',
        'أعد الصيام غداً',
        'صم 60 يوماً متتابعاً',
      ],
      correctIndex: 1,
      explanationFr: 'Par consensus, l\'oubli n\'annule pas le jeûne — Allah a nourri le jeûneur.',
      explanationEn: 'By consensus, forgetfulness does not break the fast.',
      explanationAr: 'بالإجماع لا يفطر النسيان — أطعم الله وأسقاه.',
      schoolRulings: [
        SchoolRuling(
          schoolSlug: 'hanafi',
          rulingFr: 'Le jeûne reste valide ; continuer sans manger.',
          rulingEn: 'Fast remains valid; continue without eating.',
          rulingAr: 'يبقى الصيام صحيحاً؛ أكمل بلا أكل.',
        ),
        SchoolRuling(
          schoolSlug: 'shafii',
          rulingFr: 'Même règle : l\'oubli est pardonné, le jeûne continue.',
          rulingEn: 'Same rule: forgetfulness is forgiven, fast continues.',
          rulingAr: 'نفس الحكم: النسيان معذور والصيام مستمر.',
        ),
      ],
    ),
    PracticalCase(
      id: 'interest_loan',
      icon: Icons.account_balance,
      titleFr: 'Prêt avec intérêt',
      titleEn: 'Interest-bearing loan',
      titleAr: 'قرض بفائدة',
      scenarioFr: 'Une banque propose un prêt avec 5% d\'intérêt annuel pour acheter une maison. Permis ?',
      scenarioEn: 'A bank offers a 5% annual interest loan to buy a house. Permitted?',
      scenarioAr: 'بنك يعرض قرضاً بفائدة 5% لشراء بيت. هل يجوز؟',
      optionsFr: [
        'Permis si besoin urgent',
        'Permis avec intention sincère',
        'Strictement interdit (Riba)',
        'Permis pour les non-musulmans seulement',
      ],
      optionsEn: [
        'Permitted if urgent need',
        'Permitted with sincere intention',
        'Strictly forbidden (Riba)',
        'Permitted for non-Muslims only',
      ],
      optionsAr: [
        'يجوز للضرورة',
        'يجوز بنية صالحة',
        'حرام (ربا)',
        'لغير المسلمين فقط',
      ],
      correctIndex: 2,
      explanationFr: 'Le Riba est haram par consensus, quelle que soit le montant ou le contexte.',
      explanationEn: 'Riba is haram by consensus, regardless of amount or context.',
      explanationAr: 'الربا حرام بالإجماع بغض النظر عن المقدار.',
      schoolRulings: [
        SchoolRuling(
          schoolSlug: 'hanafi',
          rulingFr: 'Tout intérêt stipulé sur un prêt est Riba al-Nasi\'ah, strictement interdit.',
          rulingEn: 'Any stipulated interest on a loan is Riba al-Nasi\'ah, strictly forbidden.',
          rulingAr: 'كل فائدة مشروطة في القرض ربا نسيئة محرم.',
        ),
        SchoolRuling(
          schoolSlug: 'maliki',
          rulingFr: 'Le contrat est nul ; alternatives halal : Murabaha, Ijara, partenariat.',
          rulingEn: 'Contract is void; halal alternatives: Murabaha, Ijara, partnership.',
          rulingAr: 'العقد باطل؛ البديل: المرابحة والإجارة والمشاركة.',
        ),
      ],
    ),
    PracticalCase(
      id: 'wali_requirement',
      icon: Icons.favorite,
      titleFr: 'Mariage sans Wali',
      titleEn: 'Marriage without Wali',
      titleAr: 'زواج بلا ولي',
      scenarioFr: 'Une femme majeure conclut son nikah sans Wali, avec deux témoins. Valide ?',
      scenarioEn: 'An adult woman concludes nikah without a wali, with two witnesses. Valid?',
      scenarioAr: 'امرأة بالغة تتزوج بلا ولي مع شاهدين. هل يصح؟',
      optionsFr: [
        'Valide pour toutes les écoles',
        'Invalide pour Shafi\'i ; Hanafi : valide pour majeure',
        'Valide seulement avec 4 témoins',
        'Interdit dans tous les cas',
      ],
      optionsEn: [
        'Valid for all schools',
        'Invalid for Shafi\'i; Hanafi: valid for adult',
        'Valid only with 4 witnesses',
        'Forbidden in all cases',
      ],
      optionsAr: [
        'صحيح عند الجميع',
        'باطل عند الشافعي؛ حنفي: يصح للبالغة',
        'يصح بأربعة شهود فقط',
        'محرم دائماً',
      ],
      correctIndex: 1,
      explanationFr: 'Shafi\'i exige le Wali ; Hanafi considère la formule (ijab/qabul) suffisante pour une majeure.',
      explanationEn: 'Shafi\'i requires wali; Hanafi considers formula sufficient for an adult.',
      explanationAr: 'الشافعي يشترط الولي؛ الحنفي يكتفي بالصيغة للبالغة.',
      schoolRulings: [
        SchoolRuling(
          schoolSlug: 'shafii',
          rulingFr: 'Le Wali est obligatoire — sans lui le contrat est nul.',
          rulingEn: 'Wali is obligatory — without him contract is void.',
          rulingAr: 'الولي شرط — بلا ولي لا يصح النكاح.',
        ),
        SchoolRuling(
          schoolSlug: 'hanafi',
          rulingFr: 'Pour une femme majeure saine d\'esprit, le Wali n\'est pas condition de validité.',
          rulingEn: 'For a sane adult woman, wali is not a validity condition.',
          rulingAr: 'للبالغة العاقلة ليس الولي شرطاً لصحة العقد.',
        ),
      ],
    ),
  ];
}
