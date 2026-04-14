SELECT 
    nameorig,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN isfraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(100.0 * SUM(CASE WHEN isfraud = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS fraud_rate,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(SUM(CASE WHEN isfraud = 1 THEN amount ELSE 0 END), 2) AS fraud_amount
FROM paysim
WHERE type IN ('TRANSFER', 'CASH_OUT')
GROUP BY nameorig
HAVING COUNT(*) > 1
   AND SUM(CASE WHEN isfraud = 1 THEN 1 ELSE 0 END) > 0
ORDER BY fraud_amount DESC
LIMIT 10;
