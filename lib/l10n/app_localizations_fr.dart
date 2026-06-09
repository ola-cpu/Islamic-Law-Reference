// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Référence de Loi Islamique';

  @override
  String get searchHint => 'Rechercher une loi...';

  @override
  String get noResults => 'Aucun résultat trouvé.';

  @override
  String get sources => 'Sources et Références :';

  @override
  String get comments => 'Commentaires d\'érudits :';

  @override
  String get school => 'École juridique :';

  @override
  String get personalNotes => 'Mes Notes Personnelles :';

  @override
  String get addNoteHint => 'Ajouter une note...';

  @override
  String get saveNote => 'Sauvegarder la note';

  @override
  String get noteSaved => 'Note sauvegardée !';

  @override
  String get noLaws => 'Aucune loi trouvée.';

  @override
  String get noSources => 'Aucune source disponible.';

  @override
  String get schoolHanafi => 'Hanafi';

  @override
  String get schoolMaliki => 'Maliki';

  @override
  String get schoolShafii => 'Shafi\'i';

  @override
  String get schoolHanbali => 'Hanbali';

  @override
  String get schoolJafari => 'Ja\'fari';

  @override
  String get mediaLibrary => 'Bibliothèque Média';

  @override
  String get comparisonTable => 'Tableau comparatif des écoles';

  @override
  String get schoolTitle => 'École';

  @override
  String get legalOpinion => 'Avis Juridique';

  @override
  String get mediaSectionTitle => 'Médias et Illustrations';

  @override
  String get illustration => 'Illustration';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get close => 'Fermer';

  @override
  String get hajjSteps => 'Étapes du Pèlerinage (Hajj)';

  @override
  String get noMediaFound => 'Aucun média trouvé.';

  @override
  String get languageEn => 'Anglais';

  @override
  String get languageFr => 'Français';

  @override
  String get languageAr => 'Arabe';

  @override
  String get languageRu => 'Russe';

  @override
  String get languageZh => 'Chinois';

  @override
  String get hajjStep1Desc => 'Entrée en état de sacralisation.';

  @override
  String get hajjStep2Desc => 'Départ pour Mina le 8 Dhul-Hijjah.';

  @override
  String get hajjStep3Desc => 'Le jour d\'Arafat (le point culminant).';

  @override
  String get hajjStep4Desc => 'Ramassage des cailloux.';

  @override
  String get hajjStep5Desc => 'Lapidation des stèles à Mina.';

  @override
  String get hajjStep6Desc => 'Circumambulation de la Kaaba.';

  @override
  String get hajjStep7Desc => 'Offrande et fin du Hajj.';

  @override
  String get relatedTopics => 'Sujets Connexes';

  @override
  String get filterBySchool => 'Filtrer par École';

  @override
  String get filterByCategory => 'Filtrer par Catégorie';

  @override
  String get dailyTopic => 'Sujet du jour';

  @override
  String get readMore => 'Lire la suite →';

  @override
  String get myLibrary => 'Ma bibliothèque';

  @override
  String get favorites => 'Favoris';

  @override
  String get readingHistory => 'Historique';

  @override
  String get noFavorites =>
      'Aucun favori pour l\'instant. Appuyez sur le cœur d\'un sujet pour l\'enregistrer ici.';

  @override
  String get noHistory =>
      'Aucun historique pour l\'instant. Explorez des sujets pour les retrouver ici.';

  @override
  String topicsExplored(int read, int total) {
    return '$read sujets explorés sur $total';
  }

  @override
  String get learnHub => 'Apprendre';

  @override
  String get learnHubSubtitle =>
      'Révisez avec des flashcards et testez vos connaissances avec des quiz.';

  @override
  String get flashcards => 'Flashcards';

  @override
  String cardCount(int count) {
    return '$count cartes';
  }

  @override
  String get quiz => 'Quiz';

  @override
  String get quizGeneral => 'Quiz général de fiqh';

  @override
  String quizQuestionCount(int count) {
    return '$count questions';
  }

  @override
  String get question => 'Question';

  @override
  String get answer => 'Réponse';

  @override
  String get tapToFlip => 'Touchez la carte pour la retourner';

  @override
  String get reviewAgain => 'Revoir';

  @override
  String get knewIt => 'Je sais';

  @override
  String get finish => 'Terminer';

  @override
  String get deckComplete => 'Jeu terminé !';

  @override
  String deckCompleteMessage(int count) {
    return 'Vous avez revu les $count cartes.';
  }

  @override
  String get quizResults => 'Résultats du quiz';

  @override
  String quizScore(int score, int total) {
    return '$score / $total bonnes réponses';
  }

  @override
  String get quizPassed => 'Bravo ! Vous avez obtenu le badge Maître du quiz.';

  @override
  String get quizTryAgain => 'Continuez à étudier — vous pouvez faire mieux !';

  @override
  String get nextQuestion => 'Question suivante';

  @override
  String get share => 'Partager';

  @override
  String get badges => 'Badges';

  @override
  String badgesProgress(int unlocked, int total) {
    return '$unlocked / $total badges débloqués';
  }

  @override
  String get guidedCourses => 'Parcours guidés';

  @override
  String get guidedCoursesDesc =>
      'Des parcours de 7 jours pour apprendre étape par étape.';

  @override
  String courseProgress(int done, int total) {
    return '$done / $total jours complétés';
  }

  @override
  String courseCount(int count) {
    return '$count parcours disponible(s)';
  }

  @override
  String get courseComplete =>
      'Parcours terminé ! Vous avez obtenu le badge Diplômé.';

  @override
  String get tools => 'Outils';

  @override
  String get zakatCalculator => 'Calculateur de Zakat';

  @override
  String get zakatCalculatorShort => 'Estimez votre zakat selon le nisab';

  @override
  String get zakatCalculatorDesc =>
      'Entrez votre richesse pour vérifier le nisab (85g d\'or) et calculer 2,5% de zakat.';

  @override
  String get goldGrams => 'Or (grammes)';

  @override
  String get goldGramsHint => 'ex. 50';

  @override
  String get silverGrams => 'Argent (grammes)';

  @override
  String get silverGramsHint => 'ex. 200';

  @override
  String get cashAmount => 'Espèces et épargne';

  @override
  String get cashAmountHint => 'ex. 5000';

  @override
  String get goldPricePerGram => 'Prix de l\'or au gramme';

  @override
  String get goldPriceHint => 'Monnaie locale';

  @override
  String get calculateZakat => 'Calculer';

  @override
  String zakatDue(String amount) {
    return 'Zakat due : $amount';
  }

  @override
  String get belowNisab => 'Sous le nisab — pas de zakat due';

  @override
  String zakatCalcDetail(
    String gold,
    String silver,
    String cash,
    String nisab,
  ) {
    return 'Or : ${gold}g · Argent : ${silver}g · Cash : $cash · Nisab ≈ $nisab';
  }

  @override
  String get zakatRateNote =>
      'Taux : 2,5% après une année lunaire de possession.';

  @override
  String get learnMoreZakat => 'En savoir plus sur la Zakat';

  @override
  String get zakatTopicHint => 'Ouvrir le sujet Nisab';

  @override
  String get seasonRamadan => 'Saison Ramadan';

  @override
  String get seasonRamadanDesc => 'Sujets du jeûne et de l\'adoration';

  @override
  String get seasonHajj => 'Saison Hajj';

  @override
  String get seasonHajjDesc => 'Sujets du pèlerinage';

  @override
  String get listenQuran => 'Écouter le verset';

  @override
  String get settings => 'Paramètres';

  @override
  String get hijriDate => 'Date hijri';

  @override
  String get languageSetting => 'Langue';

  @override
  String get themeSetting => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get about => 'À propos';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get seasonShaaban => 'Sha\'ban — Préparez le Ramadan';

  @override
  String get seasonShaabanDesc => 'Sujets pour se préparer au mois saint';

  @override
  String get allSchools => 'Toutes les écoles';

  @override
  String get allCategories => 'Toutes les catégories';

  @override
  String get applyFilters => 'Appliquer';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String explorationLevel(int percent) {
    return 'Exploration : $percent %';
  }

  @override
  String coursesCompleted(int done, int total) {
    return '$done parcours sur $total';
  }

  @override
  String get courseProgressTitle => 'Progression des parcours';

  @override
  String get exportLibrary => 'Exporter la bibliothèque';

  @override
  String get onboardingTitle1 => 'Encyclopédie de fiqh hors ligne';

  @override
  String get onboardingDesc1 =>
      'Explorez des centaines de sujets juridiques islamiques, classés par catégorie et école.';

  @override
  String get onboardingTitle2 => 'Apprenez en pratiquant';

  @override
  String get onboardingDesc2 =>
      'Flashcards, quiz, parcours guidés et badges pour ancrer vos connaissances.';

  @override
  String get onboardingTitle3 => 'Votre progression';

  @override
  String get onboardingDesc3 =>
      'Favoris, notes personnelles et tableau de bord pour suivre votre parcours.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get skip => 'Passer';

  @override
  String get myMadhhab => 'Ma madhhab';

  @override
  String get myMadhhabDesc =>
      'Mettre en avant votre école juridique dans les fiches';

  @override
  String get myMadhhabLabel => 'Ma madhhab';

  @override
  String get noSchoolPreference => 'Aucune préférence';

  @override
  String get dailyReminder => 'Rappel du sujet du jour';

  @override
  String get dailyReminderDesc =>
      'Afficher un rappel sur l\'accueil tant que le sujet du jour n\'est pas lu';

  @override
  String get dailyReminderBanner => 'Sujet du jour — à lire aujourd\'hui';

  @override
  String get practicalCases => 'Cas pratiques';

  @override
  String get practicalCasesDesc =>
      'Scénarios « Et si… ? » avec positions des écoles';

  @override
  String get caseCompleted => 'Terminé';

  @override
  String get casePending => 'À résoudre';

  @override
  String get chooseAnswer => 'Choisissez une réponse';

  @override
  String get checkAnswer => 'Vérifier';

  @override
  String get correctAnswer => 'Bonne réponse !';

  @override
  String get wrongAnswer => 'Pas tout à fait — voici l\'explication';

  @override
  String get finishCase => 'Terminer le cas';

  @override
  String get schoolPositions => 'Positions des écoles';

  @override
  String readingStreak(int days) {
    return '$days jours de suite';
  }

  @override
  String get readingStreakDesc => 'Vous lisez régulièrement — continuez !';

  @override
  String get suggestedTopic => 'Sujet suggéré pour vous';

  @override
  String get homeWidget => 'Widget écran d\'accueil';

  @override
  String get homeWidgetDesc =>
      'Ajoutez le widget « Sujet du jour » depuis le menu widgets Android';

  @override
  String get pushNotificationTitle => 'Sujet du jour';

  @override
  String get exportAsText => 'Exporter en texte';

  @override
  String get exportAsPdf => 'Exporter en PDF';

  @override
  String get noneLabel => '(aucun)';

  @override
  String get backupData => 'Sauvegarde des données';

  @override
  String get backupDataDesc =>
      'Favoris, notes, progression, badges et paramètres';

  @override
  String get exportBackup => 'Exporter la sauvegarde';

  @override
  String get importBackup => 'Restaurer une sauvegarde';

  @override
  String get backupRestored => 'Sauvegarde restaurée avec succès';

  @override
  String get backupFailed => 'Échec de la restauration';

  @override
  String get recentSearches => 'Recherches récentes';

  @override
  String get clearRecentSearches => 'Effacer';

  @override
  String get zenMode => 'Mode lecture zen';

  @override
  String get readAloud => 'Lire à voix haute';

  @override
  String get increaseFont => 'Augmenter la police';

  @override
  String get decreaseFont => 'Diminuer la police';

  @override
  String get compareSchools => 'Comparer les écoles';

  @override
  String get compareHubDesc => 'Sujets avec positions de plusieurs madhhabs';

  @override
  String get noComparisonAvailable => 'Aucune comparaison disponible';

  @override
  String get fullComparison => 'Comparaison complète';

  @override
  String get navHome => 'Accueil';

  @override
  String get navLearn => 'Apprendre';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navProfile => 'Profil';

  @override
  String get continueReading => 'Continuer la lecture';

  @override
  String get dailyQuestion => 'Question du jour';

  @override
  String get experienceLevel => 'Niveau d\'expérience';

  @override
  String get experienceLevelDesc => 'Adapter l\'affichage des fiches';

  @override
  String get beginnerMode => 'Mode débutant';

  @override
  String get beginnerModeDesc => 'Résumé et une école à la fois';

  @override
  String get studentMode => 'Mode étudiant';

  @override
  String get studentModeDesc => 'Comparaison complète et sources détaillées';

  @override
  String get beginnerModeActive => 'Mode débutant actif';

  @override
  String get showAllSchools => 'Voir toutes les écoles';

  @override
  String get methodology => 'Méthodologie';

  @override
  String get methodologyShort => 'Sources, limites et conseils';

  @override
  String get methodologyTitle => 'Comment nous travaillons';

  @override
  String get methodologyBody =>
      'Les positions présentées sont tirées de manuels reconnus des cinq madhhabs. Chaque fiche indique les sources (Coran, hadith, ouvrages) avec leur degré d\'authenticité lorsque disponible. L\'application ne remplace pas l\'avis d\'un savant qualifié pour votre situation personnelle.';

  @override
  String get methodologySources => 'Sources et authenticité';

  @override
  String get methodologySourcesBody =>
      'Les hadiths sont classés (sahih, hassan, da\'if, mawdu\') lorsque l\'information est disponible. Les références permettent de vérifier le texte original.';

  @override
  String get askScholar => 'Consulter un savant';

  @override
  String get askScholarDesc =>
      'Pour une fatwa personnelle, consultez une plateforme reconnue :';

  @override
  String get disclaimerGeneral =>
      'Cette application est un outil éducatif. Pour les cas complexes (héritage, divorce, finance), consultez toujours un savant compétent.';

  @override
  String get sensitiveTopicDisclaimer =>
      'Sujet sensible — les règles varient selon les situations. Consultez un savant avant toute décision.';

  @override
  String get sourceReference => 'Référence';

  @override
  String get skillTree => 'Arbre de compétences';

  @override
  String skillProgress(int read, int total) {
    return '$read/$total sujets';
  }

  @override
  String get srsMode => 'Révision espacée (cartes dues)';

  @override
  String get examMode => 'Mode examen';

  @override
  String get examModeDesc => 'Sans correction immédiate — résultats à la fin';

  @override
  String get consensusOnly => 'Consensus uniquement';

  @override
  String get noConsensusFound => 'Aucun consensus identifié entre les écoles';

  @override
  String get scenarioFinder => 'Trouver un scénario';

  @override
  String get scenarioFinderDesc =>
      'Décrivez votre situation pour trouver un cas pratique';

  @override
  String get scenarioFinderHint => 'Ex. : jeûne, voyage, mariage…';

  @override
  String get noScenariosFound => 'Aucun scénario trouvé';

  @override
  String get exportCertificate => 'Exporter le certificat';

  @override
  String get certificateTitle => 'Certificat de parcours';

  @override
  String get certificateDate => 'Date :';

  @override
  String get situationAdvisor => 'Conseiller de situation';

  @override
  String get situationAdvisorDesc =>
      'Décrivez votre cas — sujets et scénarios suggérés';

  @override
  String get situationAdvisorHint =>
      'Ex. : Je voyage en avion pendant le Ramadan et…';

  @override
  String get situationAdvisorEmpty =>
      'Décrivez votre situation pour obtenir des suggestions';

  @override
  String get analyzeSituation => 'Analyser';

  @override
  String get noSituationMatches =>
      'Aucune suggestion — essayez d\'autres mots-clés';

  @override
  String get encyclopediaExam => 'Examen encyclopédique';

  @override
  String get encyclopediaExamDesc => '10 sujets, chronomètre, auto-évaluation';

  @override
  String get examTopicPrompt => 'Connaissez-vous ce sujet ?';

  @override
  String get revealAnswer => 'Révéler le résumé';

  @override
  String get readFullTopic => 'Lire la fiche complète';

  @override
  String get needStudy => 'À réviser';

  @override
  String get examResults => 'Résultats de l\'examen';

  @override
  String examKnownCount(int known, int total) {
    return '$known / $total maîtrisés';
  }

  @override
  String get noExamTopics => 'Pas assez de sujets pour l\'examen';

  @override
  String get exportComparisonPdf => 'Exporter la comparaison en PDF';

  @override
  String get encryptedSync => 'Sync chiffrée';

  @override
  String get encryptedSyncDesc => 'Sauvegarde AES pour iCloud, Drive, etc.';

  @override
  String get exportEncryptedBackup => 'Exporter sauvegarde chiffrée';

  @override
  String get importEncryptedBackup => 'Importer sauvegarde chiffrée';

  @override
  String get enterPassphrase => 'Phrase secrète';

  @override
  String get passphrase => 'Mot de passe (8 car. min.)';

  @override
  String get confirmPassphrase => 'Confirmer';

  @override
  String get encryptedSyncFailed => 'Échec — vérifiez la phrase secrète';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get homeWidgetDescIos =>
      'Widget iOS et Android — ajoutez « Sujet du jour » depuis l\'écran d\'accueil';

  @override
  String get verifiedContent => 'Contenu vérifié';

  @override
  String get isnadChain => 'Chaîne de transmission (isnād)';

  @override
  String get disclaimerHomeBanner =>
      'Outil éducatif — ne remplace pas l\'avis d\'un savant. Voir la méthodologie.';

  @override
  String get liteMode => 'Mode léger';

  @override
  String get liteModeDesc =>
      'Réduit les animations pour appareils lents ou accessibilité';

  @override
  String get globalMadhhabFilter => 'Filtre madhhab global';

  @override
  String get globalMadhhabFilterDesc =>
      'Masquer les sujets sans position de votre école préférée';

  @override
  String get ijmaSection => 'Consensus (ijmāʿ)';

  @override
  String get ijmaSectionDesc =>
      'Les quatre écoles sunnites principales s\'accordent sur ce point.';

  @override
  String get divergenceTimeline => 'Chronologie des divergences';

  @override
  String get contextualShortcuts => 'Raccourcis';

  @override
  String get shortcutZakat => 'Calculateur de zakat';

  @override
  String get inheritanceCalculator => 'Calculateur d\'héritage (Farāʾiḍ)';

  @override
  String get inheritanceCalculatorShort =>
      'Estimation des parts selon la situation familiale';

  @override
  String get inheritanceCalculatorDesc =>
      'Indiquez le patrimoine net (après dettes et frais funéraires), les héritiers présents, et obtenez une répartition approximative selon les règles classiques sunnites.';

  @override
  String get inheritanceDisclaimer =>
      'Outil éducatif uniquement. L\'héritage comporte de nombreuses exceptions (hajb, \'awl, grossesse, etc.). Consultez un savant qualifié avant toute décision.';

  @override
  String get inheritanceSectionEstate => 'Patrimoine';

  @override
  String get inheritanceNetEstate => 'Patrimoine net';

  @override
  String get inheritanceNetEstateHint => 'Montant après dettes';

  @override
  String get inheritanceWasiyyah => 'Legs (wasiyyah)';

  @override
  String get inheritanceWasiyyahHint => 'Max. 1/3 pour non-héritier';

  @override
  String get inheritanceSectionSpouse => 'Conjoint survivant';

  @override
  String get inheritanceNoSpouse => 'Aucun';

  @override
  String get inheritanceWivesCount => 'Nombre d\'épouses';

  @override
  String get inheritanceSectionChildren => 'Enfants du défunt';

  @override
  String get inheritanceSectionParents => 'Parents du défunt';

  @override
  String get inheritanceSectionSiblings => 'Frères et sœurs germains';

  @override
  String get inheritanceCalculate => 'Calculer le partage';

  @override
  String get inheritanceResults => 'Répartition estimée';

  @override
  String inheritanceDistributable(String amount) {
    return 'À partager : $amount';
  }

  @override
  String inheritanceWasiyyahDeducted(String amount) {
    return 'Legs déduit : $amount';
  }

  @override
  String inheritancePerPerson(String amount) {
    return '$amount par personne';
  }

  @override
  String get inheritanceApproximateNote =>
      'Les montants sont indicatifs. Les écoles peuvent diverger sur certains cas.';

  @override
  String get inheritanceNoteAwl =>
      'Réduction proportionnelle (\'awl) appliquée — parts fixes dépassaient le total.';

  @override
  String get inheritanceNoteRadd =>
      'Augmentation (radd) appliquée — surplus redistribué aux héritiers à parts fixes.';

  @override
  String get inheritanceNoteWasiyyahCapped =>
      'Le legs a été plafonné à un tiers du patrimoine.';

  @override
  String get inheritanceNoteNoHeirs =>
      'Aucun héritier reconnu avec ces paramètres — vérifiez la saisie ou consultez un savant.';

  @override
  String get heirHusband => 'Époux';

  @override
  String get heirWife => 'Épouse(s)';

  @override
  String get heirSon => 'Fils';

  @override
  String get heirDaughter => 'Fille(s)';

  @override
  String get heirFather => 'Père';

  @override
  String get heirMother => 'Mère';

  @override
  String get heirFullBrother => 'Frère germain';

  @override
  String get heirFullSister => 'Sœur germaine';
}
