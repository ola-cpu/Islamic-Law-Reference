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
}
