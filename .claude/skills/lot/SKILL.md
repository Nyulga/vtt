---
name: lot
description: Traiter un lot de `lots.md` selon le process du projet VTT : plan validé, tests d'intégration vus rouges d'abord, étapes déléguées aux agents codeurs, vérification par quatre sous-agents, puis proposition de PR. Utiliser quand l'utilisateur tape « /lot N » ou demande de traiter un lot.
argument-hint: "<numéro du lot>"
disable-model-invocation: true
---

# lot · notre façon de développer un lot

Ce skill définit le process du projet. Il s'applique à chaque lot, sans qu'on ait besoin de le redire.
Argument : le numéro du lot (`$ARGUMENTS`).

## Accord de commit
Taper `/lot N` vaut accord pour **commiter et pousser sur `dev` à chaque étape**, et **uniquement sur `dev`**. `main` ne reçoit jamais de commit direct : seule une PR `dev` → `main`, vérifiée, ouverte avec l'accord de l'utilisateur et fusionnée par lui seul.

## Rôles
- **Coordinateur = la session principale**, en Opus, effort élevé au minimum. Sur un autre modèle : s'arrêter et demander `/model`. Le coordinateur n'est jamais un sous-agent (un sous-agent ne relance pas proprement d'autres sous-agents).
- Le coordinateur **ne code pas les couches** : il écrit les tests d'intégration, planifie, délègue, contrôle, commite et rend compte. Il écrit aussi l'assemblage (`src/composition`, quelques lignes de branchement, règle 04) et peut corriger seul une faute de frappe ou un import oublié.
- **Seul le coordinateur commite et pousse**, sur `dev`. Les sous-agents ne font ni commit, ni push, ni checkout, ni reset.

| Agent | Couche ou rôle | Modèle | Effort |
|---|---|---|---|
| `dev-service` | service (`src/services`) : règles du jeu, validation, contrats | Sonnet | élevé |
| `dev-donnees` | données (`src/data`, `supabase/`) : migrations, RLS, temps réel | Sonnet | élevé |
| `dev-presentation` | présentation (`src/app`, `src/components`) avec le design system | Sonnet | moyen |
| `revue` | critères, correction, tests | Opus | élevé |
| `conformite` | rules, design system, commentaires | Sonnet | élevé |
| `securite` | sécurité, secrets, données personnelles | Opus | élevé |
| `non-regression` | suite complète, tests supprimés ou désactivés, test de chaque `fix` | Sonnet | moyen |
| `backlog` | issues GitHub | Sonnet | faible |

Le coordinateur passe le modèle et l'effort dans les paramètres de l'outil Agent, et les annonce. Un lot délicat (autorisations, temps réel, brouillard de guerre) peut monter un agent d'un cran : l'écrire dans le plan.

## 1. Préparer
1. `git checkout dev && git pull origin dev` (et `git merge origin/main` si `main` a reçu des changements).
2. Lire `INTENT.md`, le lot $ARGUMENTS dans `lots.md`, les ADR de `docs/decisions/`, `00-principes.md` et la rule de chaque couche touchée.
3. Vérifier que les lots dont il dépend sont terminés. Sinon, s'arrêter.
4. Vérifier les outils nécessaires (Node, pnpm, base de test Supabase, MCP Context7). S'il en manque un, s'arrêter et le dire.
5. Retrouver l'issue du lot (`gh issue list --label lot --search "Lot $ARGUMENTS"`) ; noter le commit de départ (`git rev-parse HEAD`).
6. Créer le journal `docs/plan/journal/lot-$ARGUMENTS.md` à partir de [journal-modele.md](journal-modele.md).

## 2. Planifier, puis attendre la validation
- Les étapes dans l'ordre de construction : **service** (règles et contrats, testés avec des fakes) → **données** (implémente ces contrats) → **assemblage** (`src/composition`) → **présentation**. Le service passe en premier parce que c'est lui qui définit les contrats (ADR 002).
- Pour chaque étape : l'agent, son modèle et son effort, les fichiers prévus, la rule qui s'applique.
- Pour chaque critère d'acceptation : son test d'intégration, puis les tests unitaires par couche qui le soutiennent.
- Pour chaque autorisation du lot (qui peut lire ou modifier quoi) : sa politique RLS et son test de refus (règle 03).
- Les critères flous ou impossibles à tester, et les questions ouvertes.

**STOP : attendre la validation explicite du plan avant d'écrire le moindre test ou de lancer le moindre agent.**

## 3. Tests d'intégration d'abord
1. Écrire `_test_/integration/lot-$ARGUMENTS.test.ts` : un test par critère d'acceptation, qui traverse le service et la vraie couche données (base de test, jamais la base réelle), plus un test de refus par politique RLS prévue.
2. Les lancer : ils échouent tous **pour la bonne raison** (une assertion ou une fonction absente, pas une erreur de syntaxe ou d'import). Garder cette sortie rouge, la montrer et la noter dans le journal.
3. Commiter : `test(lot-$ARGUMENTS): tests d'intégration du lot`, puis `Refs #<issue>`. Pousser. Ce commit est la référence : ces tests ne changent plus sans l'accord de l'utilisateur.

## 4. Exécuter, étape par étape, en TDD
Pour chaque étape :
1. **Lancer l'agent codeur** avec : le lot et l'étape, les critères et les tests attendus, les fichiers concernés, ce que les étapes précédentes ont livré (contrats, signatures, schémas). Il écrit ses tests unitaires, les voit échouer, écrit le code, les voit passer, et rend la sortie rouge et la sortie verte.
2. **Contrôler** : lancer `pnpm verifier` ; vérifier que la sortie rouge échouait pour la bonne raison ; sinon, renvoyer au même agent avec l'erreur.
3. **Commiter** : `feat(lot-$ARGUMENTS): <étape>`, puis `Refs #<issue>`. Pousser.
4. **Compléter le journal** : étape, agent, tests, extraits rouge et vert, commit.

Les étapes s'enchaînent une par une. On ne parallélise que des étapes indépendantes et sans fichier commun, chacune dans son worktree (`isolation: "worktree"` dans l'outil Agent, ou skill `/worktree`) ; le coordinateur intègre ensuite leurs changements sur `dev`.

**Fin des étapes** :
- les tests d'intégration du lot passent tous, sans avoir changé depuis le commit de référence (`git diff <commit des tests>..HEAD -- _test_/integration/lot-$ARGUMENTS.test.ts` est vide, sauf accord de l'utilisateur) ;
- `pnpm verifier` passe en entier ;
- si le lot touche la configuration, le câblage ou une route : le test de fumée passe, et il parcourt au moins un aller-retour écriture puis lecture du lot.

## 5. Vérifier
1. Lancer **en parallèle** `revue`, `conformite`, `securite` et `non-regression` sur `<commit de départ>..HEAD`.
2. Constats `bloquant` ou `important` : correction par l'agent de la couche, commit `fix(lot-$ARGUMENTS): <quoi>` (avec son test de reproduction, règle 00 §6), relance du seul vérificateur concerné.
3. Après **deux allers-retours** sans résolution : s'arrêter et soumettre le problème à l'utilisateur.
4. Constats `mineur` et hors lot : des issues, via `backlog` (label `relecture` ou `securite`).
5. CI : suivre `gh run watch` sur le dernier push ; elle doit être verte.
6. Noter les verdicts dans le tableau du journal.

## 6. Clore et proposer la PR
1. Vérifier la définition de « terminé » du lot, point par point. Cocher les critères dans `lots.md`. Mettre `CLAUDE.md` et `README.md` à jour si une commande a changé. Commit `docs(lot-$ARGUMENTS): clôture du lot`.
2. Bilan : chaque critère et son test, les sorties rouge et verte, les verdicts des vérificateurs, le lien de la CI, les issues créées.
3. **Proposer** la PR `dev` → `main`, sans l'ouvrir. Ne l'ouvrir (`gh pr create --base main --head dev`) que si l'utilisateur dit oui. Corps : critères cochés avec leurs tests, sorties rouge et verte tirées du journal, `Closes #<issue>`.

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
- En cas de contradiction entre ce skill et `INTENT.md`, `INTENT.md` l'emporte : le signaler.
- Commits : skill `git-conventional`.
