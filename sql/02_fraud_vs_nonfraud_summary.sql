-- Analysis: Amount comparison — fraud vs legitimate transactions

-- Finding: Fraud transactions have a significantly higher average amount,
--          consistent with account takeover scenarios where the full
--          balance is drained in a single operation.

SELECT 
    CASE 
        WHEN isfraud = 1 THEN 'Fraud'
        ELSE 'Non-Fraud'
    END AS transaction_type,
    COUNT(*) AS transactions,
    ROUND(AVG(amount),2) AS avg_amount,
    Round(MAX(amount),2) AS max_amount
FROM paysim
GROUP BY transaction_type;
