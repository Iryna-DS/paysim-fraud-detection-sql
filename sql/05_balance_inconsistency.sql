-- Analysis: Balance consistency check — data quality investigation
--
-- Finding: Hypothesis not confirmed. 99.45% of fraud transactions show
--          CONSISTENT balances, while 90.79% of legitimate transactions
--          are INCONSISTENT. Balance mismatches reflect simulation noise
--          in legitimate transactions (fees, rounding, intermediate states),
--          not fraud signals. This is a critical caveat when engineering
--          features for ML fraud detection on this dataset.

SELECT 
    isfraud,
    CASE
        WHEN oldbalanceorg - amount = newbalanceorig THEN 'Consistent'
        ELSE 'Inconsistent'
    END AS balance_status,
    COUNT(*) AS transactions,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY isfraud), 2) AS pct
FROM paysim
WHERE type IN ('TRANSFER', 'CASH_OUT')
GROUP BY isfraud, balance_status
ORDER BY isfraud, balance_status;
