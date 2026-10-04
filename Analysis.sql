--Analysis Question 1: Which account type has the highest average balance?
SELECT
    account_type,
    round(AVG(balance_usd),2) AS avg_balance
FROM accounts
GROUP BY account_type
ORDER BY avg_balance DESC;
-- Finding: Average balances are very similar across all three account types,
--with Savings accounts showing only a slightly higher average balance.


-- Analysis Question 2: Which account type has the most accounts, 
--and what percentage of all accounts does each type represent?
SELECT
    account_type,
    COUNT(account_id) AS account_count
FROM accounts
GROUP BY account_type
ORDER BY account_count DESC;
-- Account type distribution and percentage share
SELECT
    account_type,
    COUNT(*) AS account_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_share
FROM accounts
GROUP BY account_type
ORDER BY account_count DESC;
-- Finding: The account portfolio is distributed very evenly across Checking, 
--Savings, and Business accounts, with Checking representing a slightly larger share.


--Analysis Question 3: How many accounts does each customer have, and what is the distribution of account ownership?
--(How many customers have 1, 2, 3, etc. accounts?)
SELECT
    customer_id,
    COUNT(*) AS account_count
FROM accounts
GROUP BY customer_id
ORDER BY account_count DESC;

WITH customer_account_counts AS (
    SELECT
        customer_id,
        COUNT(*) AS account_count
    FROM accounts
    GROUP BY customer_id
)
SELECT
    account_count AS number_of_accounts,
    COUNT(*) AS number_of_customers
FROM customer_account_counts
GROUP BY account_count
ORDER BY number_of_accounts ASC;
-- Finding: Most customers hold only a small number of accounts.
-- Single-account customers form the largest group (16,617), and the number
-- of customers decreases as account ownership increases.


--Analysis Question 4: Which customers have the highest total account balance?
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(a.balance_usd) AS total_balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_balance DESC
LIMIT 10;
-- Finding: Joseph Martinez has the highest combined account balance at approximately $1.02M,
-- followed by several other customers with similarly high total balances.


--Analysis Question 5:Which customers are the most active by number of transactions?
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(t.transaction_id) AS transaction_count
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY transaction_count DESC
LIMIT 10;
-- Finding: Joseph Martinez records the highest transaction activity with 131 transactions,
-- followed by other customers with slightly lower transaction counts.


--Analysis Question 6: Among the most active customers, what are their total account balances?
WITH customer_balances AS (
    SELECT
        customer_id,
        SUM(balance_usd) AS total_balance
    FROM accounts
    GROUP BY customer_id
),

customer_transactions AS (
    SELECT
        a.customer_id,
        COUNT(t.transaction_id) AS transaction_count
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY a.customer_id
)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    cb.total_balance,
    ct.transaction_count
FROM customers c
JOIN customer_balances cb
    ON c.customer_id = cb.customer_id
JOIN customer_transactions ct
    ON c.customer_id = ct.customer_id
ORDER BY ct.transaction_count DESC
LIMIT 20;
-- Finding: The most active customers have a wide range of total balances,
-- showing that higher transaction activity does not necessarily mean a higher account balance.


--Analysis Question 7:Which merchants receive the highest total transaction value?
SELECT
    m.merchant_id,
    m.merchant_name,
    SUM(t.amount_usd) AS total_transaction_value
FROM merchants m
JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name
ORDER BY total_transaction_value DESC
LIMIT 10;
-- Finding: Lopez PLC has the highest total transaction value at approximately $1.35M,
-- while the other top merchants record broadly similar total values.


--Analysis Question 8:How does total transaction value change over time by month?
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount_usd) AS total_transaction_value
FROM transactions
GROUP BY month
ORDER BY month;
-- Finding: Monthly transaction value remains fairly stable over time,
-- with regular fluctuations but no clear sustained upward or downward trend.


--Analysis Question 9: Month-on-month transaction growth.
WITH monthly_transactions AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount_usd) AS total_transaction_value
    FROM transactions
    GROUP BY month
)

SELECT
    month,
    total_transaction_value,
    LAG(total_transaction_value) OVER (ORDER BY month) AS previous_month_value
FROM monthly_transactions
ORDER BY month;

WITH monthly_transactions AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(amount_usd) AS total_transaction_value
    FROM transactions
    GROUP BY month
)

SELECT
    month,
    total_transaction_value,
    LAG(total_transaction_value) OVER (ORDER BY month) AS previous_month_value,
    ROUND(
        (
            total_transaction_value
            - LAG(total_transaction_value) OVER (ORDER BY month)
        )
        * 100.0
        / LAG(total_transaction_value) OVER (ORDER BY month),
        2
    ) AS mom_growth_percent
FROM monthly_transactions
ORDER BY month;
-- Finding: Month-on-month transaction value moves between positive and negative changes,
-- with no clear pattern of consistent growth over time.


--Analysis Question 10:Which customers have high account balances but relatively low transaction activity?
WITH customer_balances AS (
    SELECT
        customer_id,
        SUM(balance_usd) AS total_balance
    FROM accounts
    GROUP BY customer_id
),

customer_transactions AS (
    SELECT
        a.customer_id,
        COUNT(t.transaction_id) AS transaction_count
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY a.customer_id
)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    cb.total_balance,
    ct.transaction_count
FROM customers c
JOIN customer_balances cb
    ON c.customer_id = cb.customer_id
JOIN customer_transactions ct
    ON c.customer_id = ct.customer_id
WHERE cb.total_balance > 500000
  AND ct.transaction_count < 30
ORDER BY cb.total_balance DESC;
-- Finding: A small group of customers hold high total balances while making relatively few transactions,
-- showing that a high account balance does not always mean high transaction activity.


--Analysis Question 11: Which account type generates the highest total transaction value and the most transactions?
SELECT
    a.account_type,
    SUM(t.amount_usd) AS total_transaction_value,
    COUNT(t.transaction_id) AS transaction_count
FROM accounts a
JOIN transactions t
    ON t.account_id = a.account_id
GROUP BY a.account_type
ORDER BY total_transaction_value DESC;
-- Finding: Business accounts generate the highest total transaction value,
-- while Checking accounts have the highest transaction count, showing that
-- the account type with the most transactions is not necessarily the one generating the most value.


--Analysis Question 12: How do loan customers differ from non-loan customers in average balance or transaction activity?
WITH customer_balance AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(a.balance_usd) AS total_balance
    FROM customers c
    JOIN accounts a
        ON c.customer_id = a.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),

customer_loan AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(l.loan_id) AS loan_count
    FROM customers c
    LEFT JOIN loans l
        ON c.customer_id = l.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
)

SELECT
    CASE
        WHEN cl.loan_count > 0 THEN 'Loan Customer'
        ELSE 'Non-Loan Customer'
    END AS customer_type,
    ROUND(AVG(cb.total_balance), 2) AS avg_total_balance
FROM customer_balance cb
JOIN customer_loan cl
    ON cb.customer_id = cl.customer_id
GROUP BY customer_type
ORDER BY avg_total_balance DESC;
-- Finding: Loan and non-loan customers have almost the same average total balance,
-- showing very little difference between the two groups in this dataset.


--Analysis Question 13:How many customers have at least one loan, and how many have no loans?
WITH customer_loans AS (
    SELECT
        c.customer_id,
        COUNT(l.loan_id) AS total_loans
    FROM customers c
    LEFT JOIN loans l
        ON l.customer_id = c.customer_id
    GROUP BY c.customer_id
)
SELECT
    CASE
        WHEN total_loans > 0 THEN 'Loan Customer'
        ELSE 'Non-Loan Customer'
    END AS customer_type,
    COUNT(*) AS number_of_customers
FROM customer_loans
GROUP BY customer_type
ORDER BY customer_type;
-- Finding: Non-loan customers form the larger group, with 27,414 customers
-- compared with 22,586 loan customers.
