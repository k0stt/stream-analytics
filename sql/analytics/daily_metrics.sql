--CREATE MATERIALIZED VIEW daily_metrics AS
SELECT
    DATE(listened_at) AS event_date,
    COUNT(DISTINCT user_id) AS dau,
    COUNT(*) AS total_streams,
    AVG(listen_duration) AS avg_listen_duration
FROM listening_events
GROUP BY DATE(listened_at);