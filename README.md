# STREAMLY — Product & Data Analytics

**Analyse de données d'une plateforme fictive de streaming avec SQL, PostgreSQL et Power BI.**

![Streamly Dashboard](screenshots/streamly_dashboard.png)

## Présentation du projet

Streamly est un projet personnel de Data Analytics réalisé autour d'une plateforme fictive de streaming.

L'objectif est d'exploiter des données utilisateurs, contenus, visionnages et abonnements afin d'analyser l'activité de la plateforme, comprendre les comportements des utilisateurs et construire des indicateurs utiles au pilotage produit.

Ce projet couvre l'ensemble d'une démarche d'analyse : exploration des données, contrôle qualité, requêtes SQL, analyse métier et visualisation dans Power BI.

## Objectifs métier

- Mesurer l'activité et l'engagement des utilisateurs.
- Identifier les genres et contenus les plus consultés.
- Analyser l'évolution mensuelle des visionnages.
- Étudier les comportements de consommation.
- Comprendre la répartition des formules d'abonnement.
- Construire des KPI pour suivre la performance de la plateforme.

## Technologies utilisées

| Technologie | Utilisation |
|---|---|
| PostgreSQL | Stockage et interrogation des données |
| SQL | Exploration, nettoyage logique et analyses |
| DBeaver | Gestion de la base de données |
| Power BI | Création du tableau de bord interactif |
| GitHub | Versionnement et documentation du projet |

## Données exploitées

Le projet repose sur quatre tables contenant des données synthétiques :

| Table | Volume | Description |
|---|---:|---|
| `users` | 1 000 | Informations sur les utilisateurs |
| `contents` | 200 | Catalogue des contenus |
| `watch_events` | 20 000 | Événements de visionnage |
| `subscriptions` | 1 225 | Historique des abonnements |

Les données sont fictives et utilisées exclusivement à des fins pédagogiques et de démonstration.

## Analyses réalisées

### 1. Exploration et qualité des données
- Vérification des volumes et de la structure des tables.
- Contrôle des doublons et des relations entre tables.
- Vérification de la cohérence des données.

### 2. Analyse des utilisateurs
- Nombre total d'utilisateurs.
- Nombre et taux d'utilisateurs actifs.
- Identification des utilisateurs les plus engagés.

### 3. Analyse des contenus
- Nombre de visionnages par genre.
- Durée moyenne et totale de visionnage.
- Identification des contenus les plus populaires.
- Estimation du ratio de visionnage par rapport à la durée des contenus.

### 4. Analyse de l'activité
- Évolution mensuelle des visionnages.
- Évolution du nombre d'utilisateurs actifs.
- Analyse des minutes consommées.
- Analyse de la rétention par cohortes.

### 5. Analyse des abonnements
- Répartition des formules d'abonnement.
- Évolution mensuelle des souscriptions.
- Analyse des abonnements avec et sans date de fin renseignée.

## Principaux indicateurs

| KPI | Résultat |
|---|---:|
| Utilisateurs | 1 000 |
| Utilisateurs actifs | 997 |
| Taux d'activité | 99,70 % |
| Événements de visionnage | 20 000 |
| Abonnements démarrés au 04/10/2026 | 1 165 |
| Nombre moyen de souscriptions par utilisateur | 1,17 |

## Tableau de bord Power BI

Le tableau de bord permet de visualiser les principaux indicateurs de performance de Streamly à travers :
- Des cartes KPI.
- Une analyse des visionnages par genre.
- Des graphiques d'évolution mensuelle.
- Une répartition des abonnements.
- Un classement des contenus les plus consultés.

## Méthodologie et limites

Les analyses de visionnage exploitent l'ensemble des événements disponibles dans le jeu de données.

Les analyses d'abonnements utilisent, selon les indicateurs, une date de référence au 4 octobre 2026 ou l'historique complet. Les périodes d'observation peuvent donc différer d'un indicateur à l'autre.

Quelques précautions d'interprétation :
- Les données sont synthétiques et ne représentent pas une activité réelle.
- Une date de fin non renseignée ne prouve pas à elle seule qu'un abonnement est actif.
- Le ratio de visionnage est un indicateur estimatif basé sur la durée visionnée et la durée totale du contenu. Il ne constitue pas une mesure exacte de complétion.

## Structure du dépôt

```text
streamly-product-analytics/
├── README.md
├── LICENSE
├── sql/
│   └── streamly_analysis.sql
├── powerbi/
│   └── streamly_dashboard.pbix
├── screenshots/
│   └── streamly_dashboard.png
└── data/
    └── README.md
```

## Compétences mobilisées

**SQL · PostgreSQL · Data Analytics · Analyse produit · KPI · Modélisation relationnelle · Power BI · Data Visualization · GitHub**


## Méthodologie et limites

Les analyses de visionnage exploitent l'ensemble des événements disponibles dans le jeu de données.

Les analyses d'abonnements utilisent, selon les indicateurs, une date de référence au 4 octobre 2026 ou l'historique complet. Les périodes d'observation peuvent donc différer d'un indicateur à l'autre.

Quelques précautions d'interprétation :
- Les données sont synthétiques et ne représentent pas une activité réelle.
- Une date de fin non renseignée ne prouve pas à elle seule qu'un abonnement est actif.
- Le ratio de visionnage est un indicateur estimatif basé sur la durée visionnée et la durée totale du contenu. Il ne constitue pas une mesure exacte de complétion.

---

*Projet personnel réalisé dans le cadre du développement de compétences en Data Analytics et Product Analytics.*
