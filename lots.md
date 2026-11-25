# Lots · VTT

Un lot = une chose que l'utilisateur fait de bout en bout, de l'écran à la base. Il se livre en une PR, avec le skill `lot` (`/lot N`). Le lot 1 est le plus petit.

Avant le lot 1 : le design system est posé. On ne code aucun écran sans lui.

## Lot 1 · Créer une table et obtenir son lien

**Parcours** : le meneur de jeu ouvre l'app, donne un nom à sa table et la crée. Il obtient un lien d'invitation à copier.

**Dépend de** : aucun.

**Critères d'acceptation**
- [ ] Étant donné un visiteur, quand il crée une table nommée « La crypte », alors la table existe et il en est le meneur.
- [ ] Étant donné une table créée, quand le meneur l'ouvre, alors il voit un lien d'invitation unique et peut le copier.
- [ ] Étant donné un nom vide ou de plus de 60 caractères, quand on valide, alors la table n'est pas créée et un message dit pourquoi.

**Statut** : à faire

## Lot 2 · Rejoindre une table par le lien, avec un pseudo

**Parcours** : un joueur ouvre le lien reçu, choisit un pseudo et arrive à la table. Les autres le voient arriver.

**Dépend de** : lot 1.

**Critères d'acceptation**
- [ ] Étant donné un lien valide, quand un joueur saisit le pseudo « Arya », alors il rejoint la table comme joueur.
- [ ] Étant donné un lien inconnu, quand on l'ouvre, alors un message dit que la table n'existe pas.
- [ ] Étant donné deux joueurs à la table, quand un troisième arrive, alors les deux premiers le voient dans la liste sans recharger la page.

**Statut** : à faire

## Lot 3 · Créer et modifier sa fiche de personnage

**Parcours** : à la table, un joueur crée la fiche de son personnage (nom, classe, niveau, points de vie, six caractéristiques) et la modifie en cours de partie.

**Dépend de** : lot 2. Peut avancer en parallèle du lot 4.

**Critères d'acceptation**
- [ ] Étant donné un joueur à la table, quand il remplit une fiche complète, alors elle est enregistrée et retrouvée après rechargement.
- [ ] Étant donné une caractéristique hors de 1 à 30, ou des points de vie négatifs, quand il valide, alors la fiche est refusée avec un message.
- [ ] Étant donné la fiche d'un autre joueur, quand il essaie de la modifier, alors c'est refusé ; seul le meneur peut toutes les voir.

**Statut** : à faire

## Lot 4 · Lancer des dés visibles par toute la table

**Parcours** : un joueur tape une formule (« 1d20+3 », « 2d6 ») ou clique un dé ; le résultat s'affiche pour tous dans le journal de la table.

**Dépend de** : lot 2. Peut avancer en parallèle du lot 3.

**Critères d'acceptation**
- [ ] Étant donné la formule « 2d6+3 » et un hasard prévisible qui donne 4 puis 5, quand on lance, alors le total est 12 et le détail montre 4 et 5.
- [ ] Étant donné une formule invalide (« 0d6 », « d0 », « 2d6+ »), quand on lance, alors rien n'est enregistré et un message explique l'erreur.
- [ ] Étant donné deux joueurs à la table, quand l'un lance, alors l'autre voit le résultat dans le journal sans recharger la page.

**Statut** : à faire

## Lot 5 · Carte et pions déplaçables (bonus)

**Parcours** : le meneur affiche une carte en grille ; chaque joueur déplace son pion, et tout le monde voit le déplacement.

**Dépend de** : lots 2 et 3.

**Critères d'acceptation**
- [ ] Étant donné une table, quand le meneur ouvre la carte, alors une grille s'affiche avec un pion par personnage.
- [ ] Étant donné son pion, quand un joueur le déplace sur une case, alors les autres voient le pion à la nouvelle place sans recharger.
- [ ] Étant donné le pion d'un autre joueur, quand il essaie de le déplacer, alors c'est refusé ; le meneur peut déplacer tous les pions.

**Statut** : à faire
