# Islamic Law Reference

Islamic Law Reference est une application mobile visant à regrouper, organiser et rendre accessible l’ensemble des lois qui régissent la vie en islam, issues du Coran, de la Sunnah, et des grands ouvrages de jurisprudence islamique (fiqh).

## Architecture Technique

- **Framework** : [Flutter](https://flutter.dev/) (pour le développement mobile multiplateforme).
- **Stockage Local** : [SQLite](https://www.sqlite.org/) (via `sqflite`) pour une gestion structurée et performante des données hors ligne.
- **Gestion d'état** : [Provider](https://pub.dev/packages/provider) pour une gestion simple et efficace de l'état de l'application (favoris, notes).
- **Internationalisation** : `flutter_localizations` et `intl` pour le support multilingue (Arabe, Français, Anglais).

## Structure du Projet

- `lib/models/` : Définition des objets de données (Loi, Catégorie, Source, etc.).
- `lib/views/` : Écrans et composants de l'interface utilisateur.
- `lib/services/` : Services pour la base de données et autres fonctionnalités externes.
- `lib/providers/` : Gestion de l'état global de l'application.
- `lib/l10n/` : Fichiers de traduction.

## Fonctionnalités Principales

- Navigation par catégories thématiques.
- Moteur de recherche avancé avec filtres par école juridique et source.
- Fiches détaillées avec références textuelles et commentaires d'érudits.
- Support multilingue complet.
- Système de favoris et de notes personnelles.
- Mode hors ligne intégral.
