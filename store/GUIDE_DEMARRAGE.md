# Guide de démarrage — Pages + test interne Play

*À suivre dans l’ordre · ~30 min la première fois*

---

## Partie A — Activer GitHub Pages (politique de confidentialité)

**État actuel** : le workflow `Deploy GitHub Pages` a été poussé, mais l’URL  
https://ola-cpu.github.io/Islamic-Law-Reference/privacy.html  
renvoie **404** tant que Pages n’est pas activé dans les paramètres du dépôt.

### Étapes (une seule fois)

1. Ouvrez : https://github.com/ola-cpu/Islamic-Law-Reference/settings/pages  
2. Sous **Build and deployment** → **Source** : choisissez **GitHub Actions** (pas « Deploy from a branch »).  
3. Enregistrez si un bouton **Save** apparaît.  
4. Allez dans **Actions** : https://github.com/ola-cpu/Islamic-Law-Reference/actions/workflows/pages.yml  
5. Cliquez **Run workflow** → branche `main` → **Run workflow**.  
6. Attendez ~1 min (coche verte).  
7. Vérifiez dans le navigateur :  
   https://ola-cpu.github.io/Islamic-Law-Reference/privacy.html  

Si la page s’affiche → copiez cette URL pour la Play Console (champ « Politique de confidentialité »).

### Dépannage

| Problème | Solution |
|----------|----------|
| Workflow rouge | Ouvrez le run → lisez l’erreur ; souvent Pages pas encore en mode « GitHub Actions ». |
| 404 après succès | Attendre 2–5 min ; vider le cache du navigateur. |
| Pas d’accès Settings | Vous devez être **propriétaire** du dépôt `ola-cpu/Islamic-Law-Reference`. |

---

## Partie B — Compte développeur Google Play

1. Créez un compte sur https://play.google.com/console (frais unique ~25 USD).  
2. Complétez le profil développeur (identité, coordonnées).  

---

## Partie C — Keystore et build AAB

Dans PowerShell, à la racine du projet :

```powershell
.\tool\prepare_play_release.ps1
```

Ou manuellement :

```powershell
cd android
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
copy key.properties.example key.properties
# Éditez key.properties avec vos mots de passe
cd ..
flutter build appbundle --release
```

Fichier produit : `build\app\outputs\bundle\release\app-release.aab`

---

## Partie D — Créer l’app + test interne

### 1. Nouvelle application

1. Play Console → **Créer une application**  
2. **Nom** : `Islamic Law Reference`  
3. **Langue** : Français  
4. **Application** · **Gratuit**  

### 2. Fiche Play Store (minimum pour test interne)

| Champ | Valeur |
|-------|--------|
| Titre | Islamic Law Reference |
| Description courte | `Encyclopédie fiqh hors ligne — 500+ sujets, 5 madhhabs, 5 langues.` |
| Description complète | Copier section FR de `store/LISTING.md` |
| Icône 512 px | `store/icon/app_icon.png` |
| Feature graphic | `store/feature_graphic.png` |
| Captures téléphone | Au moins 2 PNG (idéal : 6+ via `.\tool\capture_store_screenshots.ps1`) |
| **URL confidentialité** | `https://ola-cpu.github.io/Islamic-Law-Reference/privacy.html` |

### 3. Classification et données

- **Politique** → **Contenu de l’application** : questionnaire (éducation, pas de violence).  
- **Politique** → **Sécurité des données** :  
  - Collecte : **Non** (données locales uniquement)  
  - Voir `PRIVACY.md` pour répondre cohéremment  

### 4. Téléverser en test interne

1. Menu **Tests** → **Tests internes** → **Créer une version**  
2. **Téléverser** → sélectionnez `app-release.aab`  
3. **Nom de la version** : `1.0.0 (1)`  
4. **Notes de version** : copier « Notes 1.0.0 » depuis `store/LISTING.md`  
5. **Enregistrer** → **Examiner la version** → **Déployer vers les tests internes**  

### 5. Ajouter des testeurs

1. **Tests internes** → onglet **Testeurs**  
2. **Créer une liste** (ex. `equipe-beta`)  
3. Ajoutez vos adresses Gmail  
4. Copiez le **lien d’adhésion** et ouvrez-le sur le téléphone du testeur  

### 6. Valider sur appareil

- [ ] Installation depuis le lien Play  
- [ ] Onboarding + navigation 5 onglets  
- [ ] Recherche hors ligne  
- [ ] Calculateur zakat / héritage  
- [ ] Fiche détail + comparaison madhhabs  
- [ ] Export / paramètres sans crash  

---

## Partie E — Captures d’écran (optionnel mais recommandé)

Aucun émulateur Android n’est détecté sur cette machine pour l’instant.

```powershell
flutter emulators
flutter emulators --launch <id_emulateur>
.\tool\capture_store_screenshots.ps1
```

Les PNG seront dans `store/screenshots/`.

---

## Liens utiles

| Ressource | URL |
|-----------|-----|
| Actions CI | https://github.com/ola-cpu/Islamic-Law-Reference/actions |
| Workflow Pages | https://github.com/ola-cpu/Islamic-Law-Reference/actions/workflows/pages.yml |
| Paramètres Pages | https://github.com/ola-cpu/Islamic-Law-Reference/settings/pages |
| Guide détaillé Play | [PLAY_CONSOLE.md](PLAY_CONSOLE.md) |
| Fiche Store | [LISTING.md](LISTING.md) |
