# ADR 002 — Architecture en trois couches

- Status: accepted
- Date: 2026-11-25
- Scope: framing

## Context
`intent.md` impose au minimum trois couches. L'app est petite (tables, invitations, fiches, dés, pions),
doit être livrée en quatre jours, et plusieurs agents vont coder en parallèle : les frontières
entre couches doivent être simples à respecter et à vérifier.

## Decision
- Présentation : `src/app` et `src/components` (Next.js, React). N'appelle que des services.
- Service : `src/services`. Règles du jeu et validation. Définit les contrats (interfaces)
  dont il a besoin ; ne connaît ni Supabase, ni React.
- Données : `src/data`. Seule couche qui importe Supabase (base et temps réel) ;
  implémente les contrats du service.
- Assemblage : `src/composition`, seul endroit qui branche les services sur la couche données.
- Le hasard (dés) et l'horloge sont injectés dans les services, pour des tests prévisibles.
- Chaque table Supabase a sa politique RLS, refus par défaut.

## Considered options
- Architecture hexagonale (ports et adaptateurs) — rejected because elle ajoute dossiers et cérémonie
  pour un gain nul à cette taille ; on n'en garde que l'inversion des dépendances (contrats dans le service).
- Trois couches sans contrats (le service appelle Supabase) — rejected because les règles du jeu
  ne se testeraient plus sans base, et la frontière avec la couche données deviendrait floue.

## Consequences
- En bien : règles du jeu testées sans réseau ; frontières vérifiables par un simple `git grep` ;
  une couche par agent codeur.
- En mal : un contrat et un fake à écrire pour chaque accès aux données ; le temps réel demande
  un contrat d'abonnement côté service.
