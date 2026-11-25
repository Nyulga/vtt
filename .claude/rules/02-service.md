---
paths:
  - "src/services/**"
---

# Règle 02 · Couche service

Relire d'abord `00-principes.md`.

## Rôle
Porter les règles du jeu et la validation (tables, invitations, fiches, dés, pions). C'est la seule couche qui décide de ce qui est permis.

## Autorisé
- Définir les contrats (interfaces) dont elle a besoin, par exemple `DepotFiches` : la couche données les implémente.
- Recevoir ses dépendances en paramètre, assemblées dans `src/composition`.

## Interdit
- Importer `src/data`, `@supabase/*`, React ou Next.js.
- Lire le hasard ou l'horloge directement (`Math.random(`, `Date.now(`, `new Date(`) : ils arrivent en paramètre, pour des tests prévisibles.
- Laisser passer une entrée non validée (pseudo, formule de dés, fiche, position de pion) vers la couche données.

## Tests
- Chaque règle métier a son test dans `_test_/unitaires/services/`, écrit d'abord (TDD), avec des fakes en mémoire des contrats, sans base ni réseau.

## Comment vérifier
- `git grep -nE "from ['\"](@/data|.*/data/|@supabase|react|next)" -- src/services` est vide.
- `git grep -nE "Math\.random\(|Date\.now\(|new Date\(" -- src/services` est vide.
- Chaque service modifié a un fichier de test modifié ou créé dans `_test_/unitaires/services/`.
- Casse exprès une règle métier : au moins un test devient rouge.
