SELECT
    e.group_name,
    le.listen_duration,
    le.completed
FROM experiments e
JOIN listening_events le
    ON e.user_id = le.user_id
