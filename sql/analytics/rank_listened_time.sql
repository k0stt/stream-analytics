SELECT
    user_id,
    SUM(listen_duration) AS total_listening_time,
    RANK() OVER (
        ORDER BY SUM(listen_duration) DESC
    ) AS user_rank
FROM listening_events
GROUP BY user_id
LIMIT 20;