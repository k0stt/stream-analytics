SELECT
    ROUND(
        AVG(
            CASE
                WHEN completed = TRUE
                THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS completion_rate_percent
FROM listening_events;