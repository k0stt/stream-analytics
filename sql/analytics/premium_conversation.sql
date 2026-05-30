SELECT
    ROUND(
        COUNT(*) FILTER (
            WHERE subscription_type = 'premium'
        ) * 100.0
        /
        COUNT(*),
        2
    ) AS premium_conversion_rate
FROM users;