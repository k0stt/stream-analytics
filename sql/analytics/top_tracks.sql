SELECT
    t.track_name,
    a.artist_name,
    COUNT(*) AS total_plays
FROM listening_events le
JOIN tracks t
ON le.track_id = t.track_id
JOIN artists a
ON t.artist_id = a.artist_id
GROUP BY
    t.track_name,
    a.artist_name
ORDER BY total_plays DESC
LIMIT 20;