-- =====================================================
-- PROJET STREAMLY
-- Analyse de données d'une plateforme de streaming
--
-- Objectif :
-- Analyser les utilisateurs, les contenus,
-- l'activité de visionnage et les abonnements.
--
-- Technologies : PostgreSQL / DBeaver
-- Date de référence de l'analyse : 04/10/2026
-- Données : jeu de données synthétique
-- =====================================================


-- =====================================================
-- 1. EXPLORATION ET QUALITE DES DONNEES
-- =====================================================

-- 1.1 Vérification de la connexion

SELECT
    current_database() AS database_name,
    current_schema() AS schema_name;


-- 1.2 Vérification du nombre d'utilisateurs

SELECT COUNT(*) AS total_users
FROM users;


-- 1.3 Vérification du nombre de contenus

SELECT COUNT(*) AS total_contents
FROM contents;


-- 1.4 Vérification du nombre d'abonnements

SELECT COUNT(*) AS total_subscriptions
FROM subscriptions;


-- 1.5 Vérification du nombre d'événements de visionnage

SELECT COUNT(*) AS total_watch_events
FROM watch_events;

-- =====================================================
-- 1.6 CONTROLES DE QUALITE DES DONNEES
-- =====================================================

-- Vérification des doublons dans la table users

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT user_id) AS unique_users
FROM users;


-- Vérification des doublons dans la table watch_events

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT event_id) AS unique_events
FROM watch_events;


-- Vérification des événements associés à un utilisateur inexistant

SELECT COUNT(*) AS invalid_user_events
FROM watch_events w
LEFT JOIN users u
    ON w.user_id = u.user_id
WHERE u.user_id IS NULL;


-- Vérification des événements associés à un contenu inexistant

SELECT COUNT(*) AS invalid_content_events
FROM watch_events w
LEFT JOIN contents c
    ON w.content_id = c.content_id
WHERE c.content_id IS NULL;

-- =====================================================
-- 2. ANALYSE DES UTILISATEURS ET DE L'ACTIVITE
-- =====================================================

-- 2.1 Nombre total d'utilisateurs

SELECT
    COUNT(*) AS total_users
FROM users;


-- 2.2 Nombre d'utilisateurs actifs
-- Un utilisateur est considéré actif s'il a
-- au moins un événement de visionnage.

SELECT
    COUNT(DISTINCT user_id) AS active_users
FROM watch_events;


-- 2.3 Taux d'activité des utilisateurs

SELECT
    ROUND(
        COUNT(DISTINCT w.user_id) * 100.0
        / (SELECT COUNT(*) FROM users),
        2
    ) AS activity_rate
FROM watch_events w;


-- 2.4 Nombre total de visionnages

SELECT
    COUNT(*) AS total_views
FROM watch_events;


-- 2.5 Top 10 des utilisateurs les plus actifs

SELECT
    user_id,
    COUNT(*) AS total_views
FROM watch_events
GROUP BY user_id
ORDER BY total_views DESC
LIMIT 10;

-- =====================================================
-- 3. ANALYSE DES CONTENUS ET DES GENRES
-- =====================================================

-- 3.1 Nombre de visionnages par genre

SELECT
    c.genre,
    COUNT(*) AS total_views
FROM watch_events w
JOIN contents c
    ON w.content_id = c.content_id
GROUP BY c.genre
ORDER BY total_views DESC;


-- 3.2 Temps moyen et total de visionnage par genre

SELECT
    c.genre,
    COUNT(*) AS total_views,
    ROUND(AVG(w.watch_duration_minutes), 2) AS avg_watch_minutes,
    SUM(w.watch_duration_minutes) AS total_watch_minutes
FROM watch_events w
JOIN contents c
    ON w.content_id = c.content_id
GROUP BY c.genre
ORDER BY avg_watch_minutes DESC;


-- 3.3 Taux estimé de visionnage par genre
-- Indicateur proxy : durée regardée / durée totale du contenu
-- Ce n'est pas un véritable taux de complétion du lecteur

SELECT
    c.genre,
    ROUND(
        AVG(
            w.watch_duration_minutes * 100.0
            / c.duration_minutes
        ),
        2
    ) AS estimated_completion_rate
FROM watch_events w
JOIN contents c
    ON w.content_id = c.content_id
GROUP BY c.genre
ORDER BY estimated_completion_rate DESC;


-- =====================================================
-- 4. ANALYSE DE L'ACTIVITE MENSUELLE
-- =====================================================

-- 4.1 Evolution mensuelle des utilisateurs actifs,
-- du nombre de visionnages et du temps de visionnage.

SELECT
    DATE_TRUNC('month', watch_date)::DATE AS month,
    COUNT(DISTINCT user_id) AS monthly_active_users,
    COUNT(*) AS total_views,
    SUM(watch_duration_minutes) AS total_watch_minutes
FROM watch_events
GROUP BY DATE_TRUNC('month', watch_date)
ORDER BY month;

-- =====================================================
-- 5. ANALYSE DE LA RETENTION PAR COHORTES
-- =====================================================

-- 5.1 Identification du mois d'inscription
-- et du mois d'activité de chaque utilisateur.

WITH user_activity AS (
    SELECT DISTINCT
        u.user_id,
        DATE_TRUNC('month', u.registration_date)::DATE AS cohort_month,
        DATE_TRUNC('month', w.watch_date)::DATE AS activity_month
    FROM users u
    JOIN watch_events w
        ON u.user_id = w.user_id
),

-- 5.2 Calcul du nombre de mois écoulés
-- depuis l'inscription.

cohort_activity AS (
    SELECT
        cohort_month,
        activity_month,
        (
            EXTRACT(YEAR FROM activity_month)
            - EXTRACT(YEAR FROM cohort_month)
        ) * 12
        +
        (
            EXTRACT(MONTH FROM activity_month)
            - EXTRACT(MONTH FROM cohort_month)
        ) AS month_number,
        user_id
    FROM user_activity
),

-- 5.3 Calcul de la taille initiale de chaque cohorte.

cohort_size AS (
    SELECT
        DATE_TRUNC('month', registration_date)::DATE AS cohort_month,
        COUNT(*) AS cohort_size
    FROM users
    GROUP BY DATE_TRUNC('month', registration_date)
),

-- 5.4 Calcul des utilisateurs actifs par cohorte et par mois.

retention AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT user_id) AS active_users
    FROM cohort_activity
    GROUP BY cohort_month, month_number
)

-- 5.5 Calcul du taux de rétention.

SELECT
    r.cohort_month,
    r.month_number,
    cs.cohort_size,
    r.active_users,
    ROUND(
        r.active_users * 100.0 / cs.cohort_size,
        2
    ) AS retention_rate
FROM retention r
JOIN cohort_size cs
    ON r.cohort_month = cs.cohort_month
ORDER BY r.cohort_month, r.month_number;


-- =====================================================
-- 6. ANALYSE DES ABONNEMENTS
-- =====================================================

-- 6.1 Répartition des abonnements par formule
-- Données arrêtées au 04/10/2026

SELECT
    plan,
    COUNT(*) AS total_subscriptions,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM subscriptions
WHERE start_date <= DATE '2026-10-04'
GROUP BY plan
ORDER BY total_subscriptions DESC;


-- 6.2 Répartition des abonnements selon leur date de fin

SELECT
    CASE
        WHEN end_date IS NULL THEN 'Sans date de fin'
        ELSE 'Date de fin renseignée'
    END AS subscription_status,
    COUNT(*) AS total_subscriptions
FROM subscriptions
GROUP BY subscription_status
ORDER BY total_subscriptions DESC;


-- 6.3 Répartition des utilisateurs selon leur situation

SELECT
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM subscriptions s
            WHERE s.user_id = u.user_id
              AND s.end_date IS NULL
        ) THEN 'Abonnement en cours'

        WHEN EXISTS (
            SELECT 1
            FROM subscriptions s
            WHERE s.user_id = u.user_id
        ) THEN 'Abonnement terminé'

        ELSE 'Jamais abonné'
    END AS user_status,
    COUNT(*) AS total_users
FROM users u
GROUP BY user_status
ORDER BY total_users DESC;


-- 6.4 Evolution mensuelle des nouvelles souscriptions
-- Date de référence : 04/10/2026

SELECT
    DATE_TRUNC('month', start_date)::DATE AS month,
    COUNT(*) AS new_subscriptions
FROM subscriptions
WHERE start_date <= DATE '2026-10-04'
GROUP BY DATE_TRUNC('month', start_date)
ORDER BY month;


-- 6.5 Nombre total de souscriptions à la date de référence

SELECT
    COUNT(*) AS total_subscriptions_until_reference_date
FROM subscriptions
WHERE start_date <= DATE '2026-10-04';


-- 6.6 Nombre moyen de souscriptions par utilisateur

SELECT
    ROUND(
        COUNT(*) * 1.0 / COUNT(DISTINCT user_id),
        2
    ) AS avg_subscriptions_per_user
FROM subscriptions
WHERE start_date <= DATE '2026-10-04';


-- =====================================================
-- 7. SYNTHESE DES KPI PRINCIPAUX
-- Date de référence : 04/10/2026
-- =====================================================

SELECT
    (SELECT COUNT(*)
     FROM users) AS total_users,

    (SELECT COUNT(DISTINCT user_id)
     FROM watch_events) AS active_users,

    ROUND(
        (SELECT COUNT(DISTINCT user_id) * 100.0
         FROM watch_events)
        / (SELECT COUNT(*) FROM users),
        2
    ) AS activity_rate,

    (SELECT COUNT(*)
     FROM watch_events) AS total_views,

    (SELECT COUNT(*)
     FROM subscriptions
     WHERE start_date <= DATE '2026-10-04')
     AS total_subscriptions;