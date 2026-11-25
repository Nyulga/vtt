---
paths:
  - "src/data/**"
  - "supabase/**"
---

# Règle 03 · Couche données

Relire d'abord `00-principes.md`.

## Rôle
Lire et écrire dans Supabase (base, temps réel) en implémentant les contrats de la couche service. C'est la seule couche qui parle à Supabase.

## Autorisé
- Importer `@supabase/*` et les contrats de `src/services`.

## Interdit
- Porter une règle du jeu : la couche données stocke, elle ne décide pas.
- Créer une table sans sa politique RLS (Row Level Security : les règles d'accès dans la base) dans la même migration. Le refus est la règle par défaut.
- Confier une autorisation (« qui peut lire ou modifier quoi ») au seul service. Le code du service peut tourner dans le navigateur et être contourné : chaque autorisation d'un critère d'acceptation (fiche d'un autre joueur, pion d'un autre joueur) est aussi écrite dans une politique RLS.
- Modifier une migration déjà fusionnée : on en écrit une nouvelle.
- Utiliser la clé `service_role` dans l'app, ou la commiter.

## Tests
- Chaque politique RLS a un test d'intégration dans `_test_/integration/` qui vérifie le **refus** directement contre la base, sans passer par le service (par exemple : un joueur qui écrit dans la fiche d'un autre est refusé).

## Comment vérifier
- `git grep -ln "@supabase" -- src` ne liste que des fichiers de `src/data` et `src/composition`.
- Chaque `create table` des migrations a un `enable row level security` et au moins une `create policy` dans le même fichier.
- `git diff --name-only <départ>..HEAD -- supabase/migrations` ne montre que des fichiers ajoutés, aucun fichier modifié.
- `git grep -n service_role -- src` est vide.
- Chaque `create policy` des migrations a un test de refus dans `_test_/integration/`.
