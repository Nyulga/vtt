---
name: lot
description: Traiter un lot de `lots.md` selon le process du projet VTT : plan validé, TDD, vérification par les sous-agents, puis proposition de PR. Utiliser quand l'utilisateur tape « /lot N » ou demande de traiter un lot.
argument-hint: "<numéro du lot>"
disable-model-invocation: true
---

# lot · notre façon de développer un lot

Ce skill définit le process du projet. Il s'applique à chaque lot, sans qu'on ait besoin de le redire.
Argument : le numéro du lot (`$ARGUMENTS`).

## Le process : la session code ou délègue, les agents vérifient

La session principale peut coder elle-même, ou déléguer une couche à son agent codeur (`dev-donnees`, `dev-service`, `dev-presentation`) en annonçant le modèle et l'effort. Les agents codeurs ne commitent jamais : seule la session commite et pousse, sur `dev`.
Deux lots indépendants (sans fichier commun) peuvent avancer en parallèle, chacun dans son worktree créé par `worktree-manager`.

### 1. Préparer
- `git checkout dev && git pull origin dev`. Si `main` a reçu des changements : `git merge origin/main`.
- Lis le lot $ARGUMENTS dans `lots.md`, puis `intent.md`, `00-principes.md` et la rule de chaque couche touchée.
- Retrouve l'issue du lot : `gh issue list --label lot --search "Lot $ARGUMENTS"`.

### 2. Planifier, puis attendre la validation
- Les tâches, couche par couche, dans l'ordre : données (`src/data`) → service (`src/services`) → présentation (`src/app`, `src/components`).
- Pour chaque critère d'acceptation : son test d'intégration (écrit en premier), puis les tests unitaires par couche.
- Les critères flous ou impossibles à tester, et les questions ouvertes.
- **STOP : attendre la validation explicite du plan.**

### 3. Exécuter en TDD
- **D'abord les tests d'intégration** : un par critère d'acceptation, dans `_test_/integration/lot-$ARGUMENTS.test.ts`. Lance-les : ils échouent tous **pour la bonne raison**. Garde cette sortie rouge et montre-la avant d'écrire du code.
- Puis, couche par couche, les tests unitaires d'abord, le code ensuite, jusqu'au vert.
- **Fin du lot** : les tests d'intégration du lot passent tous, sans avoir été modifiés depuis la sortie rouge (`git diff <commit des tests>..HEAD -- _test_/integration/lot-$ARGUMENTS.test.ts` est vide, sauf accord de l'utilisateur). Puis `pnpm verifier` en entier.
- Si le lot touche la configuration, le câblage ou une route : le test de fumée passe, et il parcourt au moins un aller-retour écriture puis lecture du lot.
- Un commit : `feat(lot-$ARGUMENTS): <titre du lot>`, avec `Refs #<issue>`. Pousse sur `dev`.

### 4. Vérifier
- Lance **en parallèle** les sous-agents `revue`, `securite` et `non-regression` sur la plage `<commit de départ>..HEAD`.
- Constats `bloquant` ou `important` : corrige, commit `fix(lot-$ARGUMENTS): <quoi>`, relance le vérificateur concerné.
- Constats `mineur` et hors lot : des issues, via l'agent `backlog` (label `relecture` ou `securite`).

### 5. Proposer la PR
- Si le projet a une CI : suis `gh run watch` sur le dernier push ; elle doit être verte.
- Coche les critères dans `lots.md`. Fais le bilan : chaque critère et son test, la sortie rouge puis verte, les verdicts des vérificateurs.
- **Propose** la PR `dev` → `main`, sans l'ouvrir. Ne l'ouvre (`gh pr create --base main --head dev`) que si l'utilisateur dit oui. Corps : critères cochés avec leurs tests, sorties rouge et verte, `Closes #<issue>`.

## Après la fusion : fermer l'issue
- **Jamais de toi-même** : seulement quand l'utilisateur dit que la PR est fusionnée.
- Vérifie d'abord : `gh pr view <N> --json state`. Si ce n'est pas `MERGED`, ne touche rien et dis-le.
- Piège : la branche par défaut du dépôt est `dev` et la PR fusionne dans `main` ; dans ce cas, `Closes #N` **ne ferme pas** l'issue. Ferme-la à la main, avec la preuve :
  1. coche `- [x]` chaque critère dans le corps de l'issue, **seulement** si son test est passé ;
  2. ajoute un commentaire de preuve : le commit de fusion, la sortie verte, le rappel de la sortie rouge vue ;
  3. `gh issue close <N>`.

## Règles
- Ne jamais démarrer un lot sans la demande de l'utilisateur.
- Ne pas sortir du lot : une idée hors lot est signalée, puis devient une issue.
- Ne jamais toucher à `main`, ne jamais fusionner : la fusion appartient à l'utilisateur.
- En cas de contradiction entre ce skill et `intent.md`, `intent.md` l'emporte : le signaler.
- Commits : skill `git-conventional`.
