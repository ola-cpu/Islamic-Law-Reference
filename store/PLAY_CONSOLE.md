# Guide Play Console — Islamic Law Reference

*Sprint 4 · Publication Android*

## Prérequis

| Élément | Emplacement |
|---------|-------------|
| Icône 512×512 | Générée via `store/icon/app_icon.png` + `dart run flutter_launcher_icons` |
| Feature graphic 1024×500 | `store/feature_graphic.png` |
| Captures téléphone | `store/screenshots/` (script ci-dessous) |
| Politique confidentialité | https://ola-cpu.github.io/Islamic-Law-Reference/privacy.html |
| Descriptions | `store/LISTING.md` |
| AAB release | `build/app/outputs/bundle/release/app-release.aab` |

---

## 1. Activer GitHub Pages (une fois)

1. GitHub → **Settings** → **Pages**
2. Source : **GitHub Actions** (le workflow `pages.yml` déploie `docs/`)
3. Vérifier l’URL : https://ola-cpu.github.io/Islamic-Law-Reference/privacy.html

---

## 2. Keystore de signature

```powershell
cd android
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
copy key.properties.example key.properties
# Éditez key.properties avec vos mots de passe
```

`key.properties` et `*.jks` sont **gitignorés** — ne jamais les committer.

---

## 3. Générer les icônes

```powershell
flutter pub get
dart run flutter_launcher_icons
```

---

## 4. Captures d’écran

```powershell
# Émulateur Android démarré
.\tool\capture_store_screenshots.ps1
```

Captures produites : accueil, hub apprentissage, zakat, héritage, recherche, comparaison, paramètres, fiche détail.

---

## 5. Build AAB release

```powershell
flutter build appbundle --release
```

Sans `key.properties`, le build utilise la clé debug (tests uniquement). Pour la Play Store, configurez le keystore release.

---

## 6. Créer l’application (Play Console)

1. [Google Play Console](https://play.google.com/console) → **Créer une application**
2. **Nom** : Islamic Law Reference
3. **Langue par défaut** : Français
4. **Type** : Application · **Gratuit**
5. Déclarations : politique de confidentialité, classification contenu, public cible

### Fiche Play Store

| Champ | Valeur |
|-------|--------|
| Titre | Islamic Law Reference |
| Description courte | Voir `LISTING.md` (≤ 80 car.) |
| Description complète | Copier section FR de `LISTING.md` |
| Icône | `store/icon/app_icon.png` (512 px export) |
| Feature graphic | `store/feature_graphic.png` |
| Captures | 6–8 PNG 1080×1920 depuis `store/screenshots/` |
| Catégorie | Éducation |
| URL confidentialité | https://ola-cpu.github.io/Islamic-Law-Reference/privacy.html |

### Classification du contenu

- **Public** : Tous publics (contenu éducatif religieux, sans violence)
- **Pas de publicité** (sauf si vous en ajoutez plus tard)
- **Collecte de données** : Non — données locales uniquement (voir PRIVACY.md)

### Sécurité des données (formulaire)

| Question | Réponse |
|----------|---------|
| Collecte de données ? | Non (ou minimale : préférences locales non transmises) |
| Chiffrement en transit | N/A (hors ligne) |
| Suppression des données | Désinstallation de l’app |

---

## 7. Téléverser l’AAB

1. **Production** → **Créer une version**
2. Téléverser `app-release.aab`
3. Notes de version : section « Notes 1.0.0 » de `LISTING.md`
4. **Examiner** → **Déployer** (test interne d’abord recommandé)

---

## 8. Piste de test interne (recommandé)

1. **Tests** → **Test interne** → créer une liste de testeurs (e-mails)
2. Publier la même version en test interne
3. Valider installation, onboarding, calculateurs, recherche hors ligne
4. Promouvoir vers production

---

## Checklist finale

- [ ] `flutter test` et `flutter analyze` OK
- [ ] Pages GitHub déployées (privacy URL accessible)
- [ ] Keystore release configuré
- [ ] Icônes générées sur appareil réel
- [ ] 6+ captures FR
- [ ] AAB signé release téléversé
- [ ] Formulaire données + classification complétés
