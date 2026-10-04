# Retail Banking Payments & Customer Behaviour Analytics

## Project Overview
This project analyses a synthetic retail banking dataset to understand customer behaviour, account usage, transaction activity, merchant performance, and loan-related patterns.

PostgreSQL was used to explore and analyse the data, while Power BI was used to build an interactive dashboard and present the main findings. The analysis focuses on areas such as account distribution, transaction trends, customer engagement, high-value low-activity customers, and differences between loan and non-loan customer groups.

## Business Questions
- How are accounts distributed across Checking, Savings, and Business account types?
- How many accounts do customers typically hold?
- Which customers have the highest balances and highest transaction activity?
- How does transaction value change over time?
- Which account type generates the highest transaction value and transaction count?
- Are there customers with high balances but relatively low transaction activity?
- How do loan customers compare with non-loan customers?
- Which merchants receive the highest transaction value?
  
## Dataset
The project uses a synthetic banking dataset containing customer, account, card, loan, merchant, branch, and transaction data.

The dataset includes:
- 50,000 customers
- 75,000 accounts
- 100,000 cards
- 30,000 loans
- 5,000 merchants
- 500 branches
- 1,000,000 transactions

The data was sourced from Kaggle and used for learning and portfolio purposes.

## Tools Used
- **PostgreSQL / pgAdmin** – used for data validation, SQL analysis, joins, aggregations, CTEs, and window functions.
- **Power BI** – used to build the data model, create DAX measures, apply slicers, and develop the interactive dashboard.
- **SQL** – used to answer business questions around customer behaviour, account usage, transaction trends, merchant performance, and loan segments.
- **DAX** – used for measures such as customer count, account count, transaction count, transaction value, average transaction value, and customer total balance.
  
## Data Model
The dataset contains several related tables covering customers, accounts, cards, loans, merchants, and transactions.

The main relationships used in Power BI were:

- Customers → Accounts
- Customers → Loans
- Accounts → Cards
- Accounts → Transactions
- Merchants → Transactions

The branches table was kept separate because there was no direct relationship linking it to the other tables.

These relationships allowed customer, account, transaction, merchant, and loan information to be analysed together across the dashboard.

## SQL Analysis

PostgreSQL was used to explore the dataset and answer the main business questions. The analysis covered account distribution, customer account ownership, transaction activity, merchant performance, loan behaviour, and customer engagement.

The SQL work included:
- joins across customer, account, transaction, merchant, and loan tables
- aggregations using `COUNT`, `SUM`, and `AVG`
- CTEs to separate customer balance and transaction calculations
- window functions for month-on-month transaction growth
- customer segmentation using balance and transaction activity thresholds

The full SQL analysis is included in the repository.

## Power BI Dashboard

The Power BI report was built across three pages to keep the analysis clear and organised:

- **Executive Overview** – summarises the main KPIs, monthly transaction value, account type performance, and top merchants by transaction value.
<img width="1045" height="590" alt="Screenshot 2026-09-29 at 12 36 23 AM" src="https://github.com/user-attachments/assets/100a496e-afba-4ba7-9e5c-b50f5cc9b638" />
- **Customer & Account Analysis** – focuses on customer account ownership, customer balances, transaction activity, loan status, and top customers.
<img width="1039" height="579" alt="Screenshot 2026-09-29 at 12 46 53 AM" src="https://github.com/user-attachments/assets/6527a4fc-854a-496f-93a2-4c116e5b61ef" />
- **Transactions & Account Performance** – compares account types, monthly transaction activity, high-value low-engagement customers, and top merchants by transaction count.
<img width="2084" height="1176" alt="image" src="https://github.com/user-attachments/assets/92b1c281-c0a5-4b5b-8d0e-92edd88a59f0" />

Interactive slicers were added for account type and date period so the results can be explored across different segments and time ranges.

## Key Insights
- Account types are almost evenly distributed across the portfolio. Checking accounts represent 33.45% of all accounts, followed by Savings at 33.28% and Business at 33.26%, showing that the three account types are distributed very evenly.
- Most customers hold only a small number of accounts. The largest group is customers with 1 account (16,617), followed by 2 accounts (12,663). Account ownership drops sharply after that, with only 5 customers holding 8 accounts.
- Monthly transaction value is broadly stable over time rather than showing sustained growth. Transaction value fluctuates within a relatively consistent range, while month-on-month growth moves between positive and negative changes.
- Transaction value and transaction frequency do not perfectly align. Business accounts generated the highest total transaction value at about $1.668bn, while Checking accounts recorded the highest transaction count at 333,454. This shows that the account type with the most transactions is not necessarily the one generating the most value.
- A small high-value, low-engagement customer segment was identified. Using an analyst-defined threshold of more than $500K in total balance and fewer than 30 transactions, some customers were identified as holding high balances while making relatively few transactions. The number of customers meeting this condition changes depending on the selected date period.
- Loan status shows almost no difference in average customer balance. Non-loan customers had an average total balance of $193,473.48, compared with $193,445.13 for loan customers, showing very little difference between the two groups.
- Non-loan customers form the larger customer segment. The dataset contains 27,414 non-loan customers compared with 22,586 loan customers, which is roughly a 55% / 45% split.
- Higher transaction activity does not always imply a higher customer balance. Among the most active customers, total balances vary widely, showing that transaction activity and customer balance should be looked at separately.

## Limitations
This project uses a synthetic dataset, so the results are intended for analysis and learning rather than real-world business decision-making.

Some fields that would normally support deeper banking analysis, such as customer income, product tenure, transaction categories, and branch relationships, were not available in the dataset.

The high-value, low-engagement segment was based on an analyst-defined threshold, so it should be treated as an exploratory segment rather than a formal business rule.
