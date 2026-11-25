---
paths:
  - "src/composition/**"
---

# Règle 04 · Assemblage (composition)

Relire d'abord `00-principes.md`.

## Rôle
Brancher les services sur les implémentations de la couche données, et leur fournir le hasard et l'horloge. C'est le seul endroit qui connaît à la fois `src/services` et `src/data` (ADR 002) : les dépendances sont assemblées à un seul endroit (règle 00, principe D).

## Autorisé
- Importer `src/services` et `src/data`, et créer le client Supabase.

## Interdit
- Porter une règle du jeu, une validation ou un affichage : l'assemblage branche, il ne décide pas.
- Utiliser la clé `service_role` (règle 03).

## Comment vérifier
- Aucune condition métier dans `src/composition` : chaque fonction se contente de construire et de relier des objets.
- `git grep -n service_role -- src/composition` est vide.
