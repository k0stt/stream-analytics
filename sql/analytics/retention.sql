WITH first_activity AS (
    SELECT
        user_id,
        MIN(DATE(listened_at)) AS first_date
    FROM listening_events
    GROUP BY user_id
),
user_activity AS (
    SELECT
        le.user_id,
        DATE(le.listened_at) AS activity_date,
        fa.first_date,
        DATE(le.listened_at) - fa.first_date
            AS days_since_signup
    FROM listening_events le
    JOIN first_activity fa
    ON le.user_id = fa.user_id
)
SELECT
    first_date,
    days_since_signup,
    COUNT(DISTINCT user_id) AS retained_users
FROM user_activity
GROUP BY
    first_date,
    days_since_signup
ORDER BY
    first_date,
    days_since_signup;