-- CTE to calculate average transactions per month and categorize frequency
WITH customer_activity AS (
    SELECT
        cus.id AS customer_id,
        
        -- Calculate average number of transactions per month per customer
        ROUND(
            COUNT(sav.transaction_date) /
            NULLIF(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM CURDATE()), EXTRACT(YEAR_MONTH FROM cus.date_joined)), 0), 
            2
        ) AS avg_transactions_per_month,

        -- Classify customers based on their transaction frequency
        CASE
            WHEN COUNT(sav.transaction_date) /
                 NULLIF(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM CURDATE()), EXTRACT(YEAR_MONTH FROM cus.date_joined)), 0) >= 10 
                 THEN 'High Frequency'
            WHEN COUNT(sav.transaction_date) /
                 NULLIF(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM CURDATE()), EXTRACT(YEAR_MONTH FROM cus.date_joined)), 0) BETWEEN 3 AND 9 
                 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        adashi_staging.users_customuser AS cus
    JOIN
        adashi_staging.savings_savingsaccount AS sav 
        ON cus.id = sav.owner_id
    GROUP BY
        cus.id, cus.date_joined
),

-- CTE to count number of customers in each frequency category
frequency_counts AS (
    SELECT
        frequency_category,
        COUNT(*) AS customer_count
    FROM customer_activity
    GROUP BY frequency_category
)

-- Final selection joining both CTEs to show per-customer average with overall category count
SELECT
    ca.frequency_category,
    fc.customer_count,
    ca.avg_transactions_per_month
FROM 
    customer_activity ca
JOIN 
    frequency_counts fc 
    ON ca.frequency_category = fc.frequency_category;
