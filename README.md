# PaySim Fraud Analysis — SQL Portfolio Project
 
Exploratory analysis of a synthetic financial transactions dataset using SQL.  
The goal was to identify fraud patterns, profile suspicious accounts, and investigate data quality

**Tools:** PostgreSQL / DBeaver  
**Dataset:** [PaySim — Synthetic Financial Dataset](https://www.kaggle.com/datasets/ealaxi/paysim1) (6.3M transactions)

---
 
## Business Questions
 
1. Which transaction types are most vulnerable to fraud?
2. How do fraudulent transactions differ in size from legitimate ones?
3. How does fraud volume accumulate over time?
4. Are there peak periods when fraud is most likely to occur?
5. Do fraudsters drain victim accounts completely or partially?
6. Which accounts are involved in repeated fraudulent activity?
7. Which destination accounts receive the most fraud money?
8. How effective is the built-in fraud detection flag?
9. Do balance inconsistencies signal fraud?
 
---
 
## Key Findings
 
### 1. Fraud is concentrated in two transaction types
`TRANSFER` and `CASH_OUT` account for **100% of all fraud cases**.  
Other types — PAYMENT, DEBIT, CASH_IN — show zero fraud activity, suggesting fraudsters deliberately exploit these two channels.
 
→ See: `sql/01_dataset_overview.sql`
 
---
 
### 2. Fraudulent transactions involve significantly higher amounts
Fraud transactions have a much higher average amount compared to legitimate ones, consistent with account takeover scenarios where the goal is to drain the full balance in a single operation.
 
→ See: `sql/02_fraud_vs_nonfraud_summary.sql`
 
---
 
### 3. Cumulative fraud grows with visible spikes
Fraud accumulates steadily over time but with notable spikes at certain steps — periods of accelerated fraudulent activity. In a real payment system, these spikes would trigger alert escalation protocols.
 
→ See: `sql/03_cumulative_fraud_amount_by_step.sql`
 
---
 
### 4. Fraud rate and fraud amount tell different stories
Fraud rate varies significantly across time steps (0.01% to 100%). "Quiet periods" with near-zero legitimate activity show 100% fraud rate — suggesting coordinated attacks during off-peak hours. Importantly, fraud_rate and fraud_amount don't always align: some steps show low fraud_rate but very high fraud_amount (few but very large transactions). Both dimensions matter for alert design in real payment systems.
 
→ See: `sql/07_fraud_rate_by_step.sql`
 
---
 
### 5. Fraudsters almost always drain accounts completely
 
| Drain category | Transactions | % of fraud | Avg amount | Total fraud amount |
|---|---|---|---|---|
| Full drain (100%) | 8,022 | 97.67% | 1,318,691 | 10,578,543,500 |
| Partial drain (50–89%) | 83 | 1.01% | 9,891,499 | 820,994,453 |
| Small fraction (<50%) | 53 | 0.65% | 9,572,498 | 507,342,403 |
| Already empty | 41 | 0.50% | 232,562 | 9,535,070 |
| Near-full drain (90–99%) | 14 | 0.17% | 10,000,000 | 140,000,000 |
 
97.67% of fraud transactions fully empty the victim's balance — confirming account takeover as the dominant fraud pattern. Two paradoxes emerge: partial drains show a much higher average amount (9.9M vs 1.3M for full drains), suggesting larger accounts are drained partially to avoid detection thresholds. Near-full drain transactions all hit exactly the 10M system limit — fraudsters took the maximum allowed without fully emptying the account, a deliberate strategy to avoid "full drain" alert triggers.
 
→ See: `sql/08_account_drain_analysis.sql`
 
---
 
### 6. Repeat senders involved in fraud — potential money mules
A subset of accounts appear repeatedly as senders in fraud cases, consistent with money mule behaviour or compromised accounts being reused across multiple fraudulent operations.
 
→ See: `sql/04_suspicious_accounts.sql`
 
---
 
### 7. Drop accounts follow a "use and abandon" pattern
All top fraud recipient accounts appear exactly twice — a strong signal of deliberate drop account strategy. Most are active for very short periods (16–133 steps) before disappearing. Exception: one account (C668046170) was active for 417 steps and hit the 10M system limit twice — possibly a more sophisticated long-running money mule operation.
 
→ See: `sql/09_drop_account_profiling.sql`
 
---
 
### 8. Built-in fraud detection misses the vast majority of fraud
`isFlaggedFraud` catches only a small fraction of actual fraud cases, revealing a high false negative rate. In a production payment system, this would represent significant undetected financial losses.
 
→ See: `sql/06_fraud_detection_effectiveness.sql`
 
---
 
### 9. Hypothesis tested: balance inconsistencies do not signal fraud
 
**Hypothesis:** Transactions where `oldbalanceOrig - amount ≠ newbalanceOrig` would correlate with fraudulent activity.
 
| Actual | Balance status | Transactions | % within group |
|---|---|---|---|
| Legitimate | Consistent | 254,520 | 9.21% |
| Legitimate | Inconsistent | 2,507,676 | 90.79% |
| Fraud | Consistent | 8,168 | 99.45% |
| Fraud | Inconsistent | 45 | 0.55% |
 
Hypothesis not confirmed. 99.45% of fraud transactions show consistent balances, while 90.79% of legitimate transactions are inconsistent. Balance mismatches in PaySim reflect simulation noise in legitimate transactions (fees, rounding, intermediate states) — not fraud signals. This is a critical caveat when engineering features for ML fraud detection on this dataset.
 
→ See: `sql/05_balance_inconsistency.sql`

---
 
## Dataset Notes
 
PaySim is a synthetic dataset generated to mimic real mobile money transactions.  
It is intentionally imbalanced: fraud accounts for ~0.13% of all transactions — realistic for production payment systems.  
Balance inconsistencies in the dataset reflect simulation noise and should not be used as fraud features in ML models without further investigation.
