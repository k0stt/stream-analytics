SELECT
    u.subscription_type,
    AVG(le.listen_duration)
        AS avg_duration,
    COUNT(*) AS total_streams
FROM users u
JOIN listening_events le
    ON u.user_id = le.user_id
GROUP BY u.subscription_type