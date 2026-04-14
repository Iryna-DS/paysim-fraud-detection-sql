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
