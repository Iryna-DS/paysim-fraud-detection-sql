-- Analysis: Fraud rate by transaction type

-- Finding: TRANSFER and CASH_OUT account for 100% of all fraud cases.
--          Other types (PAYMENT, DEBIT, CASH_IN) show zero fraud activity,
--          suggesting fraudsters deliberately exploit these two channels.

SELECT 
    type,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN isfraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(
        100.0 * SUM(CASE WHEN isfraud = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS fraud_rate
FROM paysim
GROUP BY type
ORDER BY fraud_rate DESC;
