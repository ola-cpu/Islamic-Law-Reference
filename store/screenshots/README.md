# Captures Play Store

Générez les PNG avec un émulateur Android ou un appareil connecté :

```powershell
.\tool\capture_store_screenshots.ps1
```

Fichiers attendus (1080×1920 recommandé) :

| Fichier | Écran |
|---------|--------|
| `01_home.png` | Accueil |
| `02_learn_hub.png` | Hub apprentissage |
| `03_zakat_calculator.png` | Calculateur zakat |
| `04_inheritance_calculator.png` | Calculateur héritage |
| `05_search.png` | Recherche |
| `06_compare.png` | Comparaison madhhabs |
| `07_settings.png` | Paramètres |
| `08_topic_detail.png` | Fiche encyclopédique |

Les fichiers sont copiés depuis `build/` après `flutter test integration_test/store_screenshots_test.dart`.
