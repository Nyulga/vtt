#!/usr/bin/env bash
# Hook PreToolUse (matcher « Bash ») : bloque, avant leur exécution, les commandes qui ne se
# rattrapent pas ou qui exposent des secrets. Il double les règles « deny » de settings.json :
# une règle compare le texte exact de la commande et se contourne (« bash -c … », chemin
# complet) ; ce hook cherche le motif dans toute la commande.
# Sortie 2 : la commande est refusée et l'agent lit la raison sur stderr.

entree="$(cat)"

refuser() {
  echo "Commande bloquée par le garde-fou du projet : $1" >&2
  echo "Si c'est vraiment voulu, demande à l'utilisateur de la lancer lui-même." >&2
  exit 2
}

# Pousser sur main : le seul chemin vers main est une PR fusionnée par l'utilisateur.
printf '%s' "$entree" | grep -Eq 'git[^"]*push[^"]*[[:space:]:]main([[:space:]"]|$)' \
  && refuser "pousser sur main."

# Push forcé : il réécrit l'historique partagé.
printf '%s' "$entree" | grep -Eq 'git[^"]*push[^"]*(--force|[[:space:]]-f([[:space:]"]|$))' \
  && refuser "push forcé."

# Suppression récursive et forcée.
printf '%s' "$entree" | grep -Eq '(^|[^[:alnum:]])rm[[:space:]]+-[[:alpha:]]*r[[:alpha:]]*f|rm[[:space:]]+-[[:alpha:]]*f[[:alpha:]]*r' \
  && refuser "suppression récursive forcée (rm -rf)."

# Lecture des fichiers de secrets par une commande (cat, type, less, grep, source…).
printf '%s' "$entree" | grep -Eq '(cat|type|less|more|head|tail|grep|source|Get-Content)[^"]*\.env(\.[[:alnum:]]+)?([[:space:]"]|$)' \
  && ! printf '%s' "$entree" | grep -q '\.env\.example' \
  && refuser "lecture d'un fichier de secrets (.env)."

# Fusion d'une PR : elle appartient à l'utilisateur.
printf '%s' "$entree" | grep -Eq 'gh[^"]*pr[^"]*merge' \
  && refuser "fusion d'une PR."

exit 0
