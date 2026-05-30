SELECT
    e.group_name,
    AVG(le.listen_duration)
        AS avg_listen_duration
FROM experiments e
JOIN listening_events le
    ON e.user_id = le.user_id
GROUP BY e.group_name