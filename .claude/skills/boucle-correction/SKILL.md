---
name: boucle-correction
description: Corrige une erreur en boucle jusqu'à ce que la vérification passe : analyser, modifier, tester, recommencer, 5 tours maximum. À utiliser quand je dis « corrige jusqu'à ce que ça passe », « boucle », « répare le workflow », ou quand je tape /boucle-correction.
---

Objectif : faire passer `bash scripts/check.sh` (ou la vérification que je précise : $ARGUMENTS).

Avant de commencer : `git status`. S'il y a des changements non sauvegardés, fais un commit avant la boucle (message en français).

Chaque tour :
1. Analyser : lis le code et le dernier résultat du test.
2. Modifier : change ce qui doit l'être, et seulement ça.
3. Tester : relance `bash scripts/check.sh`.
4. Corriger : si ça échoue, comprends pourquoi et repars au point 1.

Écris une ligne par tour : « Tour N : ce que j'ai vu, ce que j'ai changé ».

Garde-fous :
- Arrête-toi dès que tout passe, ou après 5 tours.
- Interdit : supprimer des fichiers, modifier `scripts/check.sh` ou `.claude/` pour faire passer le test, désactiver une vérification.
- Un fichier de configuration valide n'est pas un fichier correct : relis ce qu'il fait réellement.

Termine avec le bilan : « Vérifié : … », « Non vérifié : … », puis les tours utilisés.
