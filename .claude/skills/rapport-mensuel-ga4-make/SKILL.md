---
name: rapport-mensuel-ga4-make
description: Mettre en place, tester et dépanner le rapport mensuel Google Analytics 4 envoyé par e-mail avec Make (scénario GA4, module de texte, Gmail), pour 3vmovie.fr puis encorpsdame.fr. À utiliser quand je parle du rapport mensuel GA4, du scénario Make, de « no rows found », d'un e-mail de rapport vide, d'une connexion GA4 ou Gmail dans Make, ou de la balise Google Analytics de Site Kit.
---

# Rapport mensuel GA4 par e-mail avec Make

Frédéric n'est pas développeur : une étape à la fois, un clic décrit à la fois, demander une capture d'écran après chaque étape. Jamais de tirets longs.

## Objectif

Recevoir chaque mois, le 1er à 8h (Europe/Paris), un e-mail avec les chiffres Google Analytics 4 de 3vmovie.fr. Ensuite, dupliquer le scénario pour encorpsdame.fr et fredjgaia.fr.

## Architecture retenue

- Make se planifie seul : Paramètres de planification, jours du mois, le 1, 08:00, fuseau Europe/Paris. Aucun webhook, aucun GitHub.
- Scénario « Rapport mensuel GA4 3vmovie », 3 modules : GA4 Report (n°2, avec l'horloge) puis Combine Report (n°3, agrégateur de texte) puis Gmail, Send an email (n°5). Les numéros sautent (1 et 4 supprimés), c'est normal.
- Le workflow `.github/workflows/monthly-ga4-report.yml` appelle un webhook Make mort (« Webhook is no longer active »). Il devient inutile : le supprimer APRÈS un test réussi, avec l'accord de Frédéric. L'ancienne URL reste dans l'historique Git mais est morte, donc sans risque.
- Ne pas réintroduire de secret `MAKE_WEBHOOK_URL` : variante abandonnée.

## Identifiants (non secrets)

| Site | Compte GA | Propriété (Property ID) | ID de mesure |
|---|---|---|---|
| 3V MOVIE (3vmovie.fr) | 321808841 | 450329326 | G-MYP1SXDEQD |
| En Corps d'Âme (encorpsdame.fr) | 378041300 | 549980471 | à relever |
| fredjgaia.fr | pas encore de GA4 | à créer | à créer |

## Réglages du scénario

**GA4 Report**
- Connection : une connexion PAR propriété. Le Property ID se saisit dans la connexion, pas dans le module. Nom conseillé : `GA4 3vmovie`. Saisir le numéro à 9 chiffres, jamais le nom du site.
- Dimensions : Page path, Session default channel group.
- Metrics : Sessions, Total users, Engagement rate, Views.
- Date Ranges : Last 30 days (la liste propose aussi Last 28 days, Quarter to date, Custom, pas de 90 jours).
- Limit : 20. Filter mode : choose, filtres vides. Keep Empty Rows : No.
- Google refuse plus de 9 dimensions et 10 métriques : décocher tout, puis chercher et cocher avec la loupe de la liste.

**Combine Report** : à vérifier au premier test avec des données. Source Module = GA4 Report. Le champ Text contient le modèle d'une ligne (champs GA4 mappés). Séparateur de lignes adapté au HTML (par exemple `<br>`).

**Gmail** : Connection par « Sign in with Google ». Body type : Raw HTML. To : l'adresse saisie par Frédéric. Subject : `Rapport mensuel GA4 3vmovie`. Content : cliquer dans le champ et choisir la pastille Text de Combine Report. Ne JAMAIS taper le texte à la main : l'e-mail contiendrait ces mots.

## Pièges rencontrés (symptôme, cause, remède)

| Symptôme | Cause | Remède |
|---|---|---|
| « Webhook is no longer active » | Le scénario n'avait plus de module Webhook | Abandonner le webhook, planifier dans Make |
| Pastille rouge/orange sur un module | Connexion ou champ requis vide | Cliquer le module, lire le message |
| Roue « Créer un lien… » qui tourne | Chrome et ses extensions bloquent la fenêtre Google | Faire la connexion dans Safari |
| Les modules ajoutés disparaissent | Rechargement sans sauvegarde | Cliquer Save (disquette) à chaque étape |
| « Messages » refuse Save | Module de test vide resté sur le schéma | Clic droit, Delete, jamais « Save anyway » |
| « Requests are limited to 9 dimensions » | Toutes les dimensions cochées | Garder 2 dimensions |
| « no rows were found », e-mail `{"text":""}` | GA4 n'a reçu aucune visite | Voir « Balise du site » |
| Planification « Every 15 minutes » | Réglage par défaut | La changer AVANT d'activer, sinon un e-mail toutes les 15 minutes |
| Bandeau « reautorize before 21 avril 2027 » | Jeton Google valable 6 mois | Réautoriser la connexion Gmail (rappel agenda le 12 avril 2027) |

## Balise du site (cause réelle du « no rows »)

Site Kit était connecté à la bonne propriété mais « Code Snippet : Snippet is not inserted ». Remède : Site Kit, Réglages, Google Analytics, Edit, activer « Place Google Analytics code », Save. Ensuite :
- vider le cache WP Fastest Cache ;
- tester en navigation privée, accepter le bandeau Complianz, puis Google Analytics, Rapports, Temps réel (1 utilisateur en France constaté le 23 octobre 2026) ;
- les rapports sur 30 jours se remplissent après 24 à 48 h ;
- les visiteurs connectés à WordPress sont exclus (réglage voulu) ;
- les refus de cookies ne sont pas comptés : chiffres inférieurs à la réalité, c'est légal et normal, ne pas désactiver le bandeau ;
- ne pas cliquer « Enable » d'Advanced data breakdowns ni « Disconnect ».

## Règles de sécurité

- Jamais d'identifiant, mot de passe ou URL de webhook dans la conversation.
- « Run once » envoie un VRAI e-mail : prévenir avant.
- Ne jamais activer l'interrupteur avant un Run once réussi avec des chiffres lisibles.
- Autorisations Claude in Chrome : bloquer banque, PayPal, Amazon, impôts. Laisser 3vmovie.fr, analytics.google.com, eu1.make.com, accounts.google.com, mail.google.com.
- Avant toute action dans l'interface (clic de sauvegarde, activation, suppression), demander l'accord de Frédéric.

## État au 23 octobre 2026

- [x] Workflow GitHub réparé et fusionné (PR n°1).
- [x] Connexions GA4 3vmovie et Gmail créées dans Make.
- [x] Balise GA4 posée sur 3vmovie.fr, Temps réel OK.
- [x] Module 6 (doublon GA4) supprimé, scénario à 3 modules.
- [x] Rappel agenda de réautorisation Gmail : 12 avril 2027, 9h.
- [ ] Vérifier que la planification affiche bien « mensuel, jour 1, 08:00 » et non « Every 15 minutes » (sauvegarde finale non vue).
- [ ] Interrupteur : reste sur Inactive.
- [ ] Rappel agenda « Run once » vers le 26 octobre : non créé (attend « oui rappel »).

## Reste à faire, dans l'ordre

1. Vers le 26 octobre : Run once. Ouvrir la bulle de GA4 Report (Output doit contenir des lignes) et lire l'e-mail. S'il reste vide ou illisible, corriger le modèle de Combine Report.
2. Test réussi : interrupteur sur ON (prochain envoi le 1er novembre à 8h).
3. Supprimer le workflow GitHub devenu inutile (avec accord).
4. Cloner le scénario pour encorpsdame.fr (propriété 549980471, nouvelle connexion) puis pour fredjgaia.fr quand son GA4 existera.
