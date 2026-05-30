WITH last_activity AS (
    SELECT
        user_id,
        MAX(DATE(listened_at)) AS last_listen_date
    FROM listening_events
    GROUP BY user_id
)

SELECT
    COUNT(*) AS churned_users
FROM last_activity
WHERE last_listen_date
    < CURRENT_DATE - INTERVAL '30 days';