SELECT
    DATE_TRUNC('month', listened_at) AS month,
    COUNT(DISTINCT user_id) AS monthly_active_users
FROM listening_events
GROUP BY month
ORDER BY month;