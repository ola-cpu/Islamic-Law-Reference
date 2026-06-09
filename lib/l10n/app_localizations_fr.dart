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
}
