---
name: verifie-avant-de-livrer
description: Vérifie un travail avant de le déclarer terminé. À utiliser à la fin de chaque étape, avant tout commit, ou quand je demande « c'est bon ? », « tu as vérifié ? », « on peut livrer ? ».
---

Avant de dire qu'une tâche est terminée :

1. Relis la demande de départ et la définition de « terminé » du CLAUDE.md.
2. Lance `./scripts/check.sh` et lis le résultat en entier.
3. Contrôle un cas normal et un cas limite (fichier vide, indentation décalée, clé manquante).
4. Corrige ce qui ne va pas, puis recommence au point 2 (5 tours maximum).

Réponds ensuite avec ce format :
- Vérifié : ce que tu as réellement testé, et le résultat.
- Non vérifié : ce que tu n'as pas pu tester, et pourquoi.
- À tester par moi : 2 ou 3 gestes précis, en moins de 2 minutes.

Interdit : écrire « ça devrait marcher ». Dis ce que tu as vu.
