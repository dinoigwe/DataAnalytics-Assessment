# DataAnalytics-Assessment
<h1>Assessment 1</h1>
<h4>Per-Question Explanations:</h4>

<h4>1. What is the purpose of the query?</h4>
The query is designed to report summary information per user about their involvement in savings and investment plans.
It calculates:

Total number of regular savings accounts.

Total number of investment accounts (referred to as "funds").

Total confirmed deposit amount across these accounts.

2. <h4>Why were certain joins used?</h4>
The JOIN between users_customuser and savings_savingsaccount links each user to their savings accounts.

The JOIN between savings_savingsaccount and plans_plan associates each account with the corresponding plan type, needed to distinguish between savings and investment accounts.

3. <h4>Why include the WHERE clause on plan types?</h4>
To focus the analysis only on users who have either savings or investment accounts (excluding accounts of other plan types that may exist).

4. <h4> What’s the role of GROUP BY?</h4>
GROUP BY ensures aggregation happens per user (identified by owner_id), and also breaks down the totals based on the CASE condition — though this specific part could be optimized.

 <h1>Challenges:</h1>

<h3>Grouping by CASE Expression:</h3>

<h4>Issue:</h4> The query uses a CASE statement in the GROUP BY clause that is not referenced in the SELECT clause. This can lead to unexpected behavior or errors depending on the SQL dialect.

<h4>Resolution:</h4> Removed the CASE from GROUP BY to just group by the user fields (owner_id, first_name, last_name), as that is sufficient for the aggregations required.

<h3>Ambiguity in Plan Classification:</h3>

<h4>Issue:</h4> It was not clear if a single plan could be both a regular savings and an investment fund. If so, this could lead to double-counting.

<h4>Resolution:</h4> Assumed mutual exclusivity of plan types. If that’s not the case, additional clarification or logic would be required.


<h1>Assessment 2</h1>
<h4>Per-Question Explanations:</h4>
1.<h1>Calculating Average Transactions Per Month</h1> 
Approach:
We used COUNT(sav.transaction_date) to get the total number of transactions per customer, and divided it by the number of months since the customer joined using PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM CURDATE()), EXTRACT(YEAR_MONTH FROM cus.date_joined)).

<h1>Reasoning:</h1>
This gives a normalized metric (average per month) for how active each customer is, regardless of when they joined.

2. <h1>Categorizing Customers by Activity Frequency</h1>
<h1>Approach:</h1>
Used a CASE statement to categorize customers based on their average monthly transactions:

≥ 10 → 'High Frequency'

3–9 → 'Medium Frequency'

< 3 → 'Low Frequency'

<h1>Reasoning:</h1>
These thresholds help segment users into intuitive buckets for analysis or targeting.

3. <h1>Counting Customers per Frequency Category</h1>
<h1>Approach:</h1>
Created a second CTE (frequency_counts) to COUNT(*) for each frequency_category from the first CTE.

Reasoning:
This helps in understanding the distribution of customer activity across the different categories.

4. <h1>Joining for Final Output</h1>
Approach:
Joined the two CTEs (customer_activity and frequency_counts) on frequency_category to show:

Customer’s activity category

Their average transactions per month

Total number of customers in that category

Reasoning:
Provides both individual and aggregate views in a single output.

⚠️ Challenges & Resolutions
1. Division by Zero
Challenge:
The customer join duration (in months) could be zero, especially for customers who joined this month.

Resolution:
Used NULLIF(..., 0) to safely handle the denominator in the division, avoiding a division-by-zero error.

2. Aggregation Logic with JOIN
Challenge:
Ensuring that the JOIN between users and savings accounts doesn't multiply rows unexpectedly.

Resolution:
Relied on the GROUP BY clause on cus.id and cus.date_joined to aggregate correctly before further calculations.

3. Reusability of Derived Values
Challenge:
The average transactions per month was used multiple times (in both the SELECT and CASE clause).
