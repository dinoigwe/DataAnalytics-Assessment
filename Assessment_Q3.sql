-- Select the plan ID and owner ID from the savings account table
SELECT 
    save.plan_id,
    save.owner_id,

    -- Determine the type of plan: either 'savings' or 'investment'
    CASE
        WHEN plan.is_regular_savings = '1' THEN 'savings'
        WHEN plan.is_a_fund = '1' THEN 'investment'
    END AS type,

    -- Get the most recent transaction date for the plan
    MAX(save.transaction_date) AS last_transaction_date,

    -- Calculate the number of days since the last transaction
    DATEDIFF(CURRENT_DATE, MAX(save.transaction_date)) AS inactivity_days

FROM
    -- Join the plans and savings accounts tables
    adashi_staging.plans_plan AS plan
    JOIN adashi_staging.savings_savingsaccount AS save 
        ON plan.id = save.plan_id

-- Filter to include only plans that are either regular savings or funds
WHERE
    plan.is_regular_savings = '1'
    OR plan.is_a_fund = '1'

-- Group by plan and owner, and the derived 'type' field
GROUP BY 
    save.plan_id, 
    save.owner_id, 
    CASE
        WHEN plan.is_regular_savings = '1' THEN 'savings'
        WHEN plan.is_a_fund = '1' THEN 'investment'
    END

-- Only include results where the plan has been inactive for at least 365 days
HAVING 
    DATEDIFF(CURRENT_DATE, MAX(save.transaction_date)) >= 365;
