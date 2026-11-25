#!/usr/bin/env bash
# Hook PostToolUse (matcher « Edit|Write ») : lance ESLint sur le fichier que l'agent vient de
# modifier. En cas d'erreur, il l'écrit sur stderr et sort avec le code 2 : la modification
# reste, mais l'agent lit l'erreur et la corrige tout de suite.

entree="$(cat)"

# Chemin du fichier modifié, lu dans le JSON reçu sur l'entrée standard. On n'utilise pas jq,
# absent de beaucoup de postes : sed suffit, puis on dédouble les « \\ » des chemins Windows.
fichier="$(printf '%s' "$entree" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1 | sed 's/\\\\/\\/g')"
[ -n "$fichier" ] || exit 0

# Seuls les fichiers que le lint sait lire sont contrôlés.
case "$fichier" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs) ;;
  *) exit 0 ;;
esac

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 1

# Tant que les dépendances ne sont pas installées, il n'y a pas de lint à lancer.
[ -e node_modules/.bin/eslint ] || exit 0

if ! sortie="$(pnpm exec eslint "$fichier" 2>&1)"; then
  echo "Lint en échec sur $fichier :" >&2
  echo "$sortie" >&2
  exit 2
fi
exit 0
