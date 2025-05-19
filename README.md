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



<h1>Assessment 2</h1>
<h4>Per-Question Explanations:</h4>
1.  <h4>Calculating Average Transactions Per Month</h4> 
<h4>Approach:</h4>
I used COUNT(sav.transaction_date) to get the total number of transactions per customer, and divided it by the number of months since the customer joined using PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM CURDATE()), EXTRACT(YEAR_MONTH FROM cus.date_joined)).

2. <h4>Categorizing Customers by Activity Frequency</h4>
<h4>Approach:</h4>
I used a CASE statement to categorize customers based on their average monthly transactions:

≥ 10 → 'High Frequency'

3–9 → 'Medium Frequency'

< 3 → 'Low Frequency'


3. <h4>Counting Customers per Frequency Category</h4>
<h4>Approach:</h4>
I created a second CTE (frequency_counts) to COUNT(*) for each frequency_category from the first CTE.

<h4>Reasoning:</h4>
This helps in understanding the distribution of customer activity across the different categories.

4. <h4>Joining for Final Output</h4>
<h4>Approach:</h4>
I joined the two CTEs (customer_activity and frequency_counts) on frequency_category to show:

Customer’s activity category

Their average transactions per month

Total number of customers in that category

<h4>Reasoning:</h4>
Provides both individual and aggregate views in a single output.

<h1> Challenges & Resolutions</h1>

1.<h4> Aggregation Logic with JOIN</h4>
<h4>Challenge:</h4>
Ensuring that the JOIN between users and savings accounts doesn't multiply rows unexpectedly.

<h4>Resolution:</h4>
Relied on the GROUP BY clause on cus.id and cus.date_joined to aggregate correctly before further calculations.



<h1>Assessment 3</h1>
<h4>Per-Question Explanations:</h4>

1.<h4>What information is being retrieved?</h4>
The query retrieves the plan ID, owner ID, plan type, the most recent transaction date, and the number of days since the last transaction from the savings system.

2.<h4>How are plans categorized?</h4>
Using a CASE expression:

If is_regular_savings = '1', the plan is labeled as "savings".

If is_a_fund = '1', the plan is labeled as "investment".

3.<h4>How is inactivity determined?</h4>

The MAX(save.transaction_date) identifies the last activity.

DATEDIFF(CURRENT_DATE, MAX(...)) computes how many days have passed since that last activity.

Only plans inactive for 365 days or more are selected via the HAVING clause.

4.<h4>What filters are applied?</h4>

The WHERE clause ensures only records where the plan is either a regular savings plan or a fund are considered.

<h1>Challenges</h1>
1.<h4>Ambiguity in plan classification</h4>

<h4>Challenge: </h4>Both is_regular_savings and is_a_fund could potentially be '1'. It’s unclear which label should take precedence.

<h4>Resolution:</h4> Using an ER Diagram to confirm the relationship of field between tables used.


<h1>Assessment 4</h1>
<h4>Per-Question Explanations:</h4>

1. <h4>Selecting customer_id and name:</h4>

<h4>Approach:</h4> Retrieve each customer’s unique identifier and full name using CONCAT(first_name, ' ', last_name).

<h4>Purpose:</h4> Ensures that the results are human-readable and clearly identify each customer.

2. <h4>Calculating tenure_months:</h4>

<h4>Approach:</h4> Use TIMESTAMPDIFF(MONTH, cus.date_joined, CURDATE()) to calculate the number of months since the customer joined.

<h4>Purpose:</h4> Tenure is essential to measure how long the customer has been active, which directly affects the CLV calculation.

3. <h4>Counting total_transactions:</h4>

<h4>Approach:</h4> Use COUNT(sav.transaction_date) to get the total number of transactions for each customer.

<h4>Purpose:</h4> Total transaction count reflects customer engagement and is a key variable in estimating lifetime value.


4. <h4>Joining Tables:</h4>

<h4>Approach:</h4> Perform an inner join between the users_customuser and savings_savingsaccount tables on id and owner_id.

<h4>Purpose:</h4> To link each customer with their transaction data.




