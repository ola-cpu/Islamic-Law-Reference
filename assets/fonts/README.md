# Polices Amiri

L'application utilise la police [Amiri](https://github.com/aliftype/amiri) (OFL) pour l'arabe et les PDF.

Exécutez depuis la racine du projet :

```powershell
.\tool\download_amiri_fonts.ps1
```

Fichiers attendus :

- `Amiri-Regular.ttf`
- `Amiri-Bold.ttf`

Sans ces fichiers, l'UI arabe utilise une police système et les exports PDF basculent sur Helvetica.
