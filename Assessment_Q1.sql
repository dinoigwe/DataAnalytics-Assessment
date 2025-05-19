-- Select user ID and full name along with some aggregated savings and investment details
SELECT 
    sav.owner_id,  -- The ID of the user who owns the savings account
    CONCAT(cus.first_name, ' ', cus.last_name) AS name,  -- Combine first and last name for full name

    -- Count how many savings accounts are regular savings
    SUM(CASE
        WHEN plan.is_regular_savings = 1 THEN 1
        ELSE 0
    END) AS savings_count,

    -- Count how many savings accounts are categorized as a fund (investment)
    SUM(CASE
        WHEN plan.is_a_fund = 1 THEN 1
        ELSE 0
    END) AS investment_count,

    -- Sum the total confirmed deposit amounts across all accounts
    SUM(sav.confirmed_amount) AS total_deposits

FROM
    adashi_staging.users_customuser AS cus  -- User table

    -- Join with savings account table on user ID
    JOIN adashi_staging.savings_savingsaccount AS sav 
        ON cus.id = sav.owner_id

    -- Join with plans table on plan ID to get plan details
    JOIN adashi_staging.plans_plan AS plan 
        ON plan.id = sav.plan_id

-- Filter to include only records that are either regular savings or a fund
WHERE
    plan.is_regular_savings = 1
    OR plan.is_a_fund = 1

-- Group by user and plan type to support aggregation
GROUP BY 
    sav.owner_id, 
    cus.first_name, 
    cus.last_name, 
    CASE
        WHEN plan.is_regular_savings = 1 THEN 'savings'
        WHEN plan.is_a_fund = 1 THEN 'investment'
    END;
