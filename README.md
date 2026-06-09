# Islamic Law Reference

Encyclopédie fiqh **hors ligne** : plus de 500 sujets, comparaison des madhhabs, parcours d'apprentissage, outils pratiques — en **5 langues** (FR, EN, AR, RU, ZH).

> **Avertissement** : outil éducatif. Ne remplace pas l'avis d'un savant qualifié pour les cas personnels (héritage, divorce, finance, etc.).

## Fonctionnalités

| Domaine | Détails |
|---------|---------|
| **Encyclopédie** | 500+ fiches par catégories, recherche FTS multilingue |
| **Comparaison** | Positions Hanafi, Maliki, Shafi'i, Hanbali, Ja'fari |
| **Apprentissage** | 7 parcours guidés, flashcards SRS, quiz adaptatif, examen encyclopédique |
| **Outils** | Calculateur zakat, calculateur d'héritage (farāʾiḍ), conseiller de situation |
| **Données** | Favoris, notes, badges, export PDF/JSON, sync chiffrée AES |
| **Plateformes** | Android, iOS, Windows, Linux, macOS, Web (SQLite) |

## Stack technique

- **Flutter** 3.11+ · **Provider** · **go_router**
- **SQLite** (sqflite) + FTS5 · DB v22
- Contenu JSON extensible (`assets/content/`) + catalogue Dart (`lib/data/expansion/`)
- CI : `flutter analyze` + `flutter test` (GitHub Actions)

## Démarrage

```bash
flutter pub get
flutter gen-l10n
# Polices arabes (optionnel mais recommandé) :
# powershell -File tool/download_amiri_fonts.ps1
flutter run
```

## Structure

```
lib/
  models/       # Topic, Law, School, Source…
  services/     # DB, export, sync, calculateurs, SRS
  views/        # Écrans
  providers/    # UserProvider
  data/         # Parcours, cas pratiques, expansion fiqh
  l10n/         # Traductions ARB
assets/content/ # Lots JSON encyclopédiques
tool/           # export_topic_batches.dart, download_amiri_fonts.ps1
```

## Contenu

- Seed initial (~110 fiches enrichies) + 11 lots JSON (~485 sujets)
- Lot premium `topics_enriched_premium.json` : enrichissement 5 écoles + sources
- Régénérer les lots : `dart run tool/export_topic_batches.dart`

## Tests

```bash
flutter test
```

## Confidentialité

Voir [PRIVACY.md](PRIVACY.md).

## Licence

Code du projet : voir le dépôt. Contenu éducatif : usage personnel ; les textes religieux cités appartiennent à leur tradition respective.
