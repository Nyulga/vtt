# ADR 001 — Next.js sur Vercel avec Supabase

- Status: accepted
- Date: 2026-11-25
- Scope: framing

## Context
Le VTT doit être une app web où plusieurs joueurs voient la même table en temps réel,
et qu'ils rejoignent par un lien, sans créer de compte.
Contraintes : architecture en trois couches, déploiement depuis GitHub,
première version utilisable le dimanche 29 novembre 2026.

## Decision
- Next.js (TypeScript), déployé sur Vercel depuis GitHub.
- Supabase pour la base PostgreSQL, le temps réel et la connexion anonyme des joueurs.
- Trois couches : présentation (`src/app`, `src/components`),
  service (`src/services`), données (`src/data`, seul endroit qui parle à Supabase).
- MCP Supabase dans `.mcp.json` pour que l'agent consulte et fasse évoluer la base.

## Considered options
- Serveur Node + Socket.io sur le serveur Ubuntu personnel — rejected because
  il faut gérer le serveur, le HTTPS et la base soi-même : trop long pour l'échéance.
- Next.js + Liveblocks — rejected because il faut quand même une base à côté
  pour les fiches : un service de plus à brancher.

## Consequences
- En bien : un seul service (Supabase) couvre la base, le temps réel et l'identité ;
  déploiement automatique à chaque push.
- En mal : dépendance à deux services externes et à leurs limites gratuites ;
  le temps réel passe par Supabase et non par Vercel.
