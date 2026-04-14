# PaySim Fraud Analysis — SQL Portfolio Project
 
Exploratory analysis of a synthetic financial transactions dataset using SQL.  
The goal was to identify fraud patterns, profile suspicious accounts, and investigate data quality — tasks typical for a data analyst in fintech.
 
**Tools:** PostgreSQL / DBeaver  
**Dataset:** [PaySim — Synthetic Financial Dataset](https://www.kaggle.com/datasets/ealaxi/paysim1) (6.3M transactions)

---
 
## Business Questions
 
1. Which transaction types have the highest fraud rate?
2. How do fraudulent transactions differ from legitimate ones in terms of amount?
3. How does fraud volume accumulate over time?
4. Which accounts are involved in repeated fraudulent activity?
5. Do balance inconsistencies signal fraud?
 
---
## Key Findings
 
### 1. Fraud is concentrated in two transaction types
`TRANSFER` and `CASH_OUT` account for **100% of all fraud cases**.  
Other types (PAYMENT, DEBIT, CASH_IN) have zero fraud — suggesting fraudsters specifically exploit these two channels.

---
 
### 2. Fraudulent transactions involve significantly higher amounts
Fraud transactions have a higher average amount compared to legitimate ones — consistent with account takeover scenarios where the full balance is drained.

---
 
### 3. Fraud accumulates steadily — with visible spikes
Using a cumulative window function over time steps reveals that fraud is not random — there are periods of accelerated activity, which in a real system would trigger alert escalation.

---
 
### 4. Repeat senders involved in fraud — potential money mules
Accounts with multiple transactions where at least one is fraudulent, ranked by total fraud amount. This pattern is consistent with money mule behaviour or compromised accounts used repeatedly.

---
 
### 5. Hypothesis tested: do balance inconsistencies indicate fraud?
 
**Hypothesis:** Transactions where `oldbalanceOrig - amount ≠ newbalanceOrig` would correlate with fraudulent activity.

| isfraud | balance_status | transactions | % within group |
|---------|---------------|-------------|----------------|
| 0 | Consistent | 254,520 | 9.21% |
| 0 | Inconsistent | 2,507,676 | 90.79% |
| 1 | Consistent | 8,168 | 99.45% |
| 1 | Inconsistent | 45 | 0.55% |
 
**Finding:** Hypothesis not confirmed. 99.45% of fraud transactions show *consistent* balances, while 90.79% of legitimate transactions are *inconsistent*.
 
**Interpretation:** Balance mismatches in PaySim reflect simulation noise in legitimate transactions (fees, rounding, intermediate states) — not fraud signals. This is an important caveat when using balance delta as a feature in ML fraud detection models.


 
---
 
## Dataset Notes
 
PaySim is a synthetic dataset generated to mimic real mobile money transactions.  
It is intentionally imbalanced: fraud accounts for ~0.13% of all transactions — realistic for production payment systems.
 
