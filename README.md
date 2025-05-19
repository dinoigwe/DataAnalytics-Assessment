# DataAnalytics-Assessment
Assessment 1
 Per-Question Explanations:

What is the purpose of the query?

The query is designed to report summary information per user about their involvement in savings and investment plans. It calculates:

Total number of regular savings accounts.

Total number of investment accounts (referred to as "funds").

Total confirmed deposit amount across these accounts.

Why were certain joins used?

The JOIN between users_customuser and savings_savingsaccount links each user to their savings accounts.

The JOIN between savings_savingsaccount and plans_plan associates each account with the corresponding plan type, needed to distinguish between savings and investment accounts.

Why use SUM(CASE ...) instead of COUNT?

We use SUM with a CASE condition because we want to count only the records that match specific criteria (e.g., is_regular_savings = 1), and ignore others by summing 1s and 0s.

Why include the WHERE clause on plan types?

To focus the analysis only on users who have either savings or investment accounts (excluding accounts of other plan types that may exist).

What’s the role of GROUP BY?

GROUP BY ensures aggregation happens per user (identified by owner_id), and also breaks down the totals based on the CASE condition — though this specific part could be optimized.

📌 Challenges:

Grouping by CASE Expression:

Issue: The query uses a CASE statement in the GROUP BY clause that is not referenced in the SELECT clause. This can lead to unexpected behavior or errors depending on the SQL dialect.

Resolution: Removed the CASE from GROUP BY to just group by the user fields (owner_id, first_name, last_name), as that is sufficient for the aggregations required.

Ambiguity in Plan Classification:

Issue: It was not clear if a single plan could be both a regular savings and an investment fund. If so, this could lead to double-counting.

Resolution: Assumed mutual exclusivity of plan types. If that’s not the case, additional clarification or logic would be required.

Optimization Concern:

Issue: Multiple joins and aggregations could affect performance on large datasets.

Resolution: Indexing on plan_id, owner_id, and confirmed_amount fields would help. Additionally, a CTE or subquery could simplify or improve readability and modularity.

Let me know if you'd like a revised version of the SQL with these improvements or written as a report.
