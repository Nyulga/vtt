---
paths:
  - "src/app/**"
  - "src/components/**"
---

# Règle 01 · Couche présentation

Relire d'abord `00-principes.md`.

## Rôle
Afficher la table de jeu et transmettre les actions des joueurs. C'est la seule couche qui connaît React et Next.js.

## Autorisé
- Appeler les services, obtenus par `src/composition`.
- S'abonner au temps réel (dés, pions) à travers un service.

## Interdit
- Importer `src/data` ou `@supabase/*`.
- Écrire une règle du jeu dans un composant (calcul de dés, validation de fiche) : elle vit dans un service.
- Écrire une couleur en dur : les composants et les couleurs viennent du design system.
- Injecter en HTML brut un texte saisi par un joueur (`dangerouslySetInnerHTML`).

## Comment vérifier
- `git grep -nE "from ['\"](@/data|.*/data/|@supabase)" -- src/app src/components` est vide.
- `git grep -nE "#[0-9a-fA-F]{3,8}\b" -- "src/app/*.tsx" "src/components/*.tsx"` est vide.
- `git grep -n dangerouslySetInnerHTML -- src` est vide.
