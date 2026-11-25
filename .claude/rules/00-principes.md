# Règle 00 · Principes communs (toujours applicable)

Cette règle s'applique à **tout** le code du projet, à chaque tâche. Elle complète `INTENT.md`, qui reste la source de vérité. Les règles de chaque couche (`.claude/rules/01-…` et suivantes) précisent ce qu'elle impose.

## 1. Avant de coder

1. Relire `INTENT.md`, puis le lot en cours.
2. Relire cette règle et la règle de **chaque couche** que la tâche va toucher.
3. Vérifier que la branche courante est `dev`.
4. Avant d'utiliser l'API d'une librairie (Next.js, React, Supabase, Vitest…), consulter sa documentation à jour avec le MCP Context7 (`resolve-library-id` puis `query-docs`) plutôt que de se fier à sa mémoire : les API changent d'une version à l'autre.
5. Si une demande contredit une règle, **s'arrêter et le signaler**. Ne jamais contourner une règle en silence.

## 2. SOLID : l'esprit, pas une architecture

SOLID ne dicte pas la forme du projet (3 couches, modules, hexagonal…) : l'architecture est choisie projet par projet et décrite dans les règles de couche et les ADR. SOLID dit **comment** découper, quelle que soit cette forme.

| Principe | Ce que ça veut dire ici |
|---|---|
| **S** · Responsabilité unique | Un fichier, une classe, une fonction ou un composant fait **une** chose. Un élément qui fait « et aussi… » se découpe. |
| **O** · Ouvert/fermé | On étend en **ajoutant** (un nouveau cas dans une table, une nouvelle implémentation), pas en empilant des `if` dans du code existant. |
| **L** · Substitution | Deux implémentations d'une même interface sont interchangeables : elles passent les mêmes tests. |
| **I** · Ségrégation des interfaces | Des interfaces petites et ciblées, définies selon le besoin de celui qui les utilise. Pas d'objet « fourre-tout ». |
| **D** · Inversion des dépendances | Le cœur métier dépend d'interfaces, jamais de la base, du réseau ou du framework. Les dépendances arrivent de l'extérieur, et sont assemblées à **un seul** endroit. |

## 3. Zéro God file, zéro code spaghetti : limites chiffrées

Ces limites sont des plafonds, pas des objectifs. Elles sont vérifiées par un outil : `pnpm verifier`.

| Mesure | Limite du projet |
|---|---|
| Lignes par fichier | ≤ 250 |
| Lignes par fonction (composant compris) | ≤ 60 |
| Complexité cyclomatique par fonction | ≤ 8 |
| Paramètres par fonction | ≤ 3 (un composant reçoit un seul objet de propriétés) |
| Profondeur d'imbrication | ≤ 3 |
| Code dupliqué | ≤ 2 % |
| Imports circulaires | interdits |

En plus :
- **Pas de valeur magique** : une constante métier a un nom (`DELAI_RELANCE_JOURS = 7`).
- **Retour anticipé** plutôt qu'une pile de `if` imbriqués.
- **Pas de code mort, pas de code commenté**, pas de `TODO` sans issue associée.
- **Pas de fichier `utils`, `helpers`, `common` ou `misc`** : un code transverse porte un nom qui dit ce qu'il fait (`format_montant`, `horloge`).
- **Désactiver une règle est interdit** (`noqa`, `type: ignore`, `eslint-disable`, `@ts-expect-error`…). Si c'est vraiment inévitable : s'arrêter, demander l'accord, et écrire la justification sur la même ligne.

### Anti-patterns interdits
- Singleton et état global modifiable ;
- God object, God service, God file ;
- logique métier dans l'interface, les routes ou l'accès aux données ;
- pattern ajouté « au cas où », sans besoin réel dans le lot en cours.

### Sobriété : le code le plus simple qui respecte les règles
- **Chercher avant d'écrire** : réutiliser ce qui existe déjà dans le projet.
- **Pas de dépendance pour quelques lignes** ; une nouvelle dépendance se justifie (besoin réel, maintenance active, licence, aucune vulnérabilité connue).
- **Supprimer vaut mieux qu'ajouter** : le code devenu inutile part dans la même étape, avec ses tests.
- **Corriger la cause, pas le symptôme**, une seule fois, à l'endroit partagé.
- **Rien « pour plus tard »** : une idée hors du lot devient une issue.

## 4. Nommage

- Le langage métier est celui d'`INTENT.md` (français), partout dans le code.
- Les identifiants n'ont pas d'accents. Les termes techniques des patterns restent en anglais (`Repository`, `Adapter`).
- Un nom dit **ce que fait** la chose, jamais comment elle est faite.

## 5. Commentaires : en français, utiles et bien écrits

- Chaque fichier commence par une courte description de son rôle.
- Chaque classe ou composant public, et chaque règle métier, explique sa responsabilité et sa **raison d'être**.
- Chaque choix non évident est justifié, avec un renvoi vers l'ADR ou la section d'`INTENT.md` concernée.
- Interdit : paraphraser le code, le style télégraphique, le franglais inutile, les commentaires périmés.

## 6. TDD

Pour toute règle métier : **rouge → vert → refactorisation**. Le test est écrit d'abord et vu en échec **pour la bonne raison** (une assertion, pas une erreur d'import ou de syntaxe).

**Rangement** : tous les tests vivent dans `_test_/` à la racine, jamais à côté du code : `_test_/integration/` pour les tests d'intégration, `_test_/unitaires/<couche>/` pour les tests unitaires (`donnees`, `services`, `presentation`).

**Tests d'intégration d'abord** : avant de coder un lot, chaque critère d'acceptation devient un test d'intégration qui traverse les couches (service et vraie couche données), dans `_test_/integration/`. Ces tests sont écrits et vus rouges **avant** le moindre code du lot, puis doivent tous être verts à la fin. On ne modifie pas un test d'intégration pour le faire passer : si le critère change, on le dit et on demande l'accord.

**Non-régression** :
- Tout bug corrigé commence par un test qui le **reproduit**, vu rouge avant la correction. Ce test reste dans la suite.
- On ne supprime, ne saute (`skip`, `only`) et n'affaiblit jamais un test existant pour faire passer un changement. Si un test est devenu faux, on le dit et on demande l'accord.
- Avant chaque commit, c'est la suite **complète** qui doit passer, pas seulement les tests du lot.

## 7. Fin de tâche

- Relecture du code produit contre cette règle et contre la règle de chaque couche touchée.
- Lint, typage, tests et contrôles de structure sont tous verts en local.

## Comment vérifier

- `pnpm verifier` passe : elle contrôle les tailles, la complexité, la duplication, les imports circulaires et les désactivations de règles.
- `git grep -nE "noqa|type: ignore|eslint-disable|ts-expect-error"` ne renvoie que des lignes accordées par l'utilisateur.
- Aucun fichier nommé `utils`, `helpers`, `common` ou `misc` : `git ls-files | grep -Ei "utils|helpers|common|misc"` est vide.
- Les points de lecture (SOLID, commentaires, sobriété) sont contrôlés par l'agent `revue` à chaque lot.
- La non-régression (suite complète, tests supprimés ou désactivés, test de reproduction de chaque `fix`) est contrôlée par l'agent `non-regression` à chaque lot.
