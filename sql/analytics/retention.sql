WITH first_activity AS (
    SELECT
        user_id,
        MIN(DATE(listened_at)) AS cohort_date
    FROM listening_events
    GROUP BY user_id
),

retention_data AS (
    SELECT
        fa.cohort_date,
        DATE(le.listened_at) AS activity_date,
        DATE(le.listened_at) - fa.cohort_date
            AS retention_day,
        le.user_id
    FROM listening_events le
    JOIN first_activity fa
        ON le.user_id = fa.user_id
)

SELECT
    cohort_date,
    retention_day,
    COUNT(DISTINCT user_id) AS retained_users
FROM retention_data
GROUP BY
    cohort_date,
    retention_day
ORDER BY
    cohort_date,
    retention_day