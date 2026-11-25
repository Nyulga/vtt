# VTT

> Lis d'abord `intent.md` : il fixe le but du projet et ses contraintes. En cas de doute, il fait référence.

Une table de jeu virtuelle (VTT) : une app web pour jouer à des jeux de rôle en ligne, avec cartes, pions et dés partagés.
Pour un meneur de jeu et ses joueurs, chacun depuis son navigateur.

## Commandes

- Tests : `pnpm test`
- Lint : `pnpm lint`
- Build : `pnpm build`
- Vérification complète (lint, types, tests) : `pnpm verifier`. Elle existera dès l'installation de Next.js.

## Outils MCP

- `supabase` et `playwright` sont déclarés dans `.mcp.json` : ils arrivent avec le dépôt.
- `context7` (documentation à jour des librairies, règle 00 §1) s'installe une fois par développeur, hors du dépôt, pour que chacun garde sa propre clé :
  `claude mcp add --scope user --transport http context7 https://mcp.context7.com/mcp`
  Une clé personnelle (gratuite, sur context7.com) relève la limite d'usage ; elle ne va jamais dans un fichier suivi par Git.

## Architecture

- Trois couches : présentation, service, données (ADR 002). Les règles de chaque couche sont dans `.claude/rules/`, avec `00-principes.md` qui s'applique partout.
- Les décisions d'architecture sont dans `docs/decisions/`. Lis-les avant de proposer un choix d'architecture.
- Tous les tests vivent dans `_test_/` : `_test_/integration/` et `_test_/unitaires/<couche>/`.

## Façon de travailler

- On ne code aucun écran sans le design system.
- Le travail est découpé en lots dans `lots.md`. Un lot se traite avec le skill `lot` (`/lot N`) : tests d'intégration écrits et vus rouges d'abord, puis le code.
- Travail en parallèle : un worktree par lot indépendant, créé par l'agent `worktree-manager` dans `.claude/worktrees/`.
- Idées, bugs et constats hors lot : une issue GitHub, via le skill ou l'agent `backlog`.
- Messages de commit au format du skill `git-conventional`.
- Ne commite et ne pousse jamais sans que je le demande.
