SELECT
    DATE(listened_at) AS event_date,
    COUNT(DISTINCT user_id) AS daily_active_users
FROM
    listening_events
GROUP BY
    DATE(listened_at)
ORDER BY
    event_date;