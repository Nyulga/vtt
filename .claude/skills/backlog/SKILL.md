---
name: backlog
description: Gérer le backlog de VTT dans GitHub Issues avec gh. Utiliser quand l'utilisateur dit « crée une issue », « ajoute au backlog », « envoie les lots sur GitHub », ou quand un bug, un constat de vérification ou une idée hors lot apparaît pendant le travail.
---

# backlog · le backlog vit dans GitHub

Principe : **un sujet = une issue**, créée tout de suite avec `gh issue create`.
Dépôt : `Nyulga/vtt` (public). Jamais de secret, de donnée personnelle ni de donnée réelle dans une issue.

## Avant de commencer
- `gh auth status` doit indiquer une connexion active.

## Labels
Crée-les s'ils manquent. N'en invente pas d'autres.

| Label | Couleur | Usage |
|---|---|---|
| `lot` | `1F2124` | Un lot de `lots.md` |
| `bug` | `B42318` | Un comportement incorrect, avec les étapes pour le reproduire |
| `relecture` | `F2A900` | Un constat de `revue`, à traiter hors du lot en cours |
| `securite` | `855600` | Un constat de `securite` (mineur ou info) |

Création : `gh label create <nom> --color <couleur> --description "<usage>" 2>/dev/null || true`

## Titre
- Un lot : `Lot N · <titre avec un verbe>`.
- Les autres issues : le problème, en français, factuel. On décrit le problème, pas la solution.

## Corps
- **Lot** : le parcours, les critères d'acceptation en cases `- [ ]`, `Dépend de #N` pour chaque lot requis.
- **Bug** : ce qui est observé, ce qui était attendu, les étapes pour le reproduire, avec `fichier:ligne` si on le connaît.
- **Constat** : l'emplacement, le constat, le scénario et la piste, tels que les a rendus l'agent. Pour la sécurité : sans recette d'exploitation.
- Liens : `Bloqué par #N`, `Découvert pendant #N`.

## Commits et PR
- Les commits d'un lot contiennent `Refs #N`.
- La PR qui clôt une issue contient `Closes #N`.

## Règles
1. Cherche les doublons avant de créer : `gh issue list --state all --search "<mots-clés>"`.
2. Ne ferme jamais une issue sans preuve (une PR fusionnée) ou sans demande explicite.
3. Une issue traite un seul sujet.
4. Donne à l'utilisateur le numéro et le lien de chaque issue créée.
