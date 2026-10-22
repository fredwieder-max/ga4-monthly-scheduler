#!/usr/bin/env bash
# Hook « Stop » : empêche Claude de s'arrêter tant que scripts/check.sh échoue.
# Garde-fou : 5 tours maximum, puis Claude doit s'arrêter et faire un bilan.
MAX_TOURS=5
cd "$(dirname "$0")/../.." || exit 0

SESSION=$(jq -r '.session_id // "default"' 2>/dev/null)
COMPTEUR="${TMPDIR:-/tmp}/claude-boucle-${SESSION}"

SORTIE=$(./scripts/check.sh 2>&1)
if [ $? -eq 0 ]; then
  rm -f "$COMPTEUR"
  exit 0
fi

TOURS=$(( $(cat "$COMPTEUR" 2>/dev/null || echo 0) + 1 ))
echo "$TOURS" > "$COMPTEUR"

if [ "$TOURS" -gt "$MAX_TOURS" ]; then
  rm -f "$COMPTEUR"
  echo "Boucle arrêtée après $MAX_TOURS tours : erreur toujours présente. Fais le bilan à l'utilisateur (ce que tu as essayé, ce qui bloque)." >&2
  echo "$SORTIE" >&2
  exit 0
fi

{
  echo "Vérification en échec (tour $TOURS sur $MAX_TOURS). Corrige sans modifier scripts/check.sh pour le faire passer, puis relance ./scripts/check.sh."
  echo "$SORTIE"
} >&2
exit 2
