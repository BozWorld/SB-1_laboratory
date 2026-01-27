# S.B.E-Laboratory

Un projet de jeu Godot 4.4.

## Table des matières
- [À propos](#à-propos)
- [Comment réaliser un fork de ce projet](#comment-réaliser-un-fork-de-ce-projet)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Développement](#développement)
- [Structure du projet](#structure-du-projet)

## À propos

S.B.E-Laboratory est un projet de jeu développé avec le moteur Godot 4.4 utilisant la méthode de rendu Forward Plus.

## Comment réaliser un fork de ce projet

Forker ce projet vous permet de créer votre propre copie du dépôt où vous pouvez apporter des modifications sans affecter le projet original.

### Étape 1 : Forker le dépôt sur GitHub

1. Accédez à la page du dépôt : https://github.com/BozWorld/SB-1_laboratory
2. Cliquez sur le bouton **Fork** en haut à droite de la page
3. Sélectionnez où vous souhaitez forker le dépôt (votre compte personnel ou une organisation)
4. Attendez que GitHub crée votre fork

### Étape 2 : Cloner votre fork

Après avoir forké, clonez votre dépôt forké sur votre machine locale :

```bash
# Remplacez VOTRE_NOM_UTILISATEUR par votre nom d'utilisateur GitHub
git clone https://github.com/VOTRE_NOM_UTILISATEUR/SB-1_laboratory.git
cd SB-1_laboratory
```

### Étape 3 : Configurer le remote upstream (Optionnel mais recommandé)

Pour garder votre fork synchronisé avec le dépôt original :

```bash
# Ajoutez le dépôt original comme "upstream"
git remote add upstream https://github.com/BozWorld/SB-1_laboratory.git

# Vérifiez que le remote a été ajouté
git remote -v
```

### Étape 4 : Synchroniser votre fork avec upstream

Pour obtenir les dernières modifications du dépôt original :

```bash
# Récupérez les dernières modifications d'upstream
git fetch upstream

# Basculez sur votre branche principale
git checkout main

# Fusionnez les modifications d'upstream
git merge upstream/main
```

## Prérequis

- **Godot Engine 4.4** ou version ultérieure
- Connaissances de base en GDScript (le langage de script de Godot)

## Installation

1. Téléchargez et installez [Godot Engine 4.4](https://godotengine.org/download)
2. Ouvrez Godot Engine
3. Cliquez sur **Importer** et naviguez vers le dossier du dépôt cloné
4. Sélectionnez le fichier `project.godot`
5. Cliquez sur **Importer & Éditer**

## Développement

### Exécuter le projet

1. Ouvrez le projet dans Godot Engine
2. Appuyez sur **F5** ou cliquez sur le bouton **Lecture** pour exécuter le projet
3. La scène principale démarrera automatiquement

### Configuration du projet

- **Taille de la fenêtre** : 1920x1080
- **Version Godot** : 4.4
- **Méthode de rendu** : Forward Plus

## Structure du projet

```
SB-1_laboratory/
├── Scene/              # Scènes du jeu (fichiers .tscn)
├── Script/             # Fichiers GDScript
│   ├── basic_math/
│   ├── basics_actor/
│   └── debug_hud/
├── visual/             # Ressources visuelles
├── project.godot       # Configuration principale du projet
└── NAMING_CONVENTION_SOURCE.tscn
```

## Contribuer

1. Forkez le projet (voir [Comment réaliser un fork de ce projet](#comment-réaliser-un-fork-de-ce-projet))
2. Créez une branche de fonctionnalité (`git checkout -b feature/fonctionnalite-incroyable`)
3. Commitez vos modifications (`git commit -m 'Ajout d'une fonctionnalité incroyable'`)
4. Poussez vers la branche (`git push origin feature/fonctionnalite-incroyable`)
5. Ouvrez une Pull Request

## Licence

Veuillez vérifier auprès des mainteneurs du projet pour les informations de licence.

---

*For English documentation, see [README.md](README.md)*
