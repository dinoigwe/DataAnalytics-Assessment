-- Select relevant customer data and compute metrics
SELECT 
    cus.id AS customer_id,  -- Unique identifier for the customer
    CONCAT(first_name, ' ', last_name) AS name,  -- Full name of the customer

    -- Calculate customer tenure in months since joining
    TIMESTAMPDIFF(MONTH, cus.date_joined, CURDATE()) AS tenure_months,

    -- Count the total number of transactions made by the customer
    COUNT(sav.transaction_date) AS total_transactions,

    -- Estimate Customer Lifetime Value (CLV):
    -- (transactions per month) * 12 months * 0.001 (assumed average transaction value)
    ((COUNT(sav.transaction_date) / TIMESTAMPDIFF(MONTH, cus.date_joined, CURDATE())) * 12 * 0.001) AS estimated_clv

FROM
    adashi_staging.users_customuser AS cus  -- Customer information table

    JOIN
    adashi_staging.savings_savingsaccount AS sav  -- Savings account table containing transactions
    ON cus.id = sav.owner_id  -- Join on customer ID and account owner ID

-- Group results by customer to aggregate transaction data
GROUP BY cus.id

-- Order the final result by estimated customer lifetime value in descending order
ORDER BY estimated_clv DESC;
