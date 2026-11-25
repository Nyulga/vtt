---
name: worktree
description: Crée, liste et range les worktrees Git de VTT dans .claude/worktrees/, pour isoler une grosse tâche ou faire travailler plusieurs agents en parallèle sans collision. Utiliser quand l'utilisateur tape « /worktree », veut « travailler à part » sur une fonctionnalité ou une correction, voir ses worktrees, ou en ranger un.
argument-hint: "creer <type>/<nom> | lister | ranger <nom>"
---

# worktree · travailler en parallèle sans collision

Un worktree est un second dossier de travail du même dépôt, avec ses fichiers et sa branche : un agent par worktree, et aucun n'écrase le travail d'un autre. On les range **uniquement** dans `.claude/worktrees/`. Ce skill est lancé par la session principale : c'est elle qui crée et range les worktrees, et les agents codeurs y travaillent.
Argument : `$ARGUMENTS`.

## Créer `<type>/<nom>`
1. **Le `.gitignore`** : vérifie que `.claude/worktrees/` est ignoré (`git check-ignore -q .claude/worktrees/x`). Sinon, ajoute la ligne et dis-le.
2. **Le point de départ** : `git fetch origin`, puis pars de la branche **locale** `dev` (elle porte le travail pas encore poussé). Si la branche distante est en avance, signale-le et demande avant de continuer. Dis toujours de quelle branche tu pars.
3. **La création** : `git worktree add .claude/worktrees/<nom> -b <type>/<nom> dev`. Un nom ou une branche qui existe déjà : demande s'il faut le reprendre ou en choisir un autre.
4. **Les fichiers locaux** : un worktree neuf n'a aucun fichier ignoré par Git (`.env*`). Copie ceux que liste `.worktreeinclude` (à la racine, syntaxe du `.gitignore`), en recréant leurs dossiers. Donne **les noms** des fichiers copiés, jamais leur contenu, et préviens : ces copies visent la même base et le même port que le dossier principal.
5. **Les dépendances**, dans le worktree : `pnpm install`.
6. **Les tests de départ** : `pnpm test`. S'ils échouent, donne les échecs, demande s'il faut continuer, et ne supprime rien.
7. **Le compte rendu** : chemin, branche et point de départ, fichiers copiés, dépendances, résultat des tests.

## Lister
`git worktree list` : pour chacun, le chemin, la branche et le commit abrégé.

## Ranger `<nom>`
- `git worktree remove .claude/worktrees/<nom>`, puis `git branch -d <type>/<nom>`.
- **Jamais `rm -rf`** sur un worktree (le garde-fou le bloque de toute façon).
- Des modifications non commitées, ou une branche non fusionnée dans `dev` : dis-le, et demande l'accord de l'utilisateur avant `--force` ou `-D`.

## Types de branche
`feature` (fonctionnalité), `fix` (correction), `refactor` (restructuration sans changement de comportement), `chore` (maintenance, outillage). Pour un autre besoin, propose le plus proche et demande.

## Règles
- Deux tâches qui touchent les mêmes fichiers restent l'une après l'autre : signale-le au lieu de créer deux worktrees.
- Le travail d'un worktree revient sur `dev` par une fusion de sa branche, faite par la session principale ; rien ne va directement sur `main`.
- Une installation qui échoue : signale-la, puis lance quand même les tests.
