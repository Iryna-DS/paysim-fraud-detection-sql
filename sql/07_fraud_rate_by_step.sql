-- Analysis: Fraud concentration by time step



SELECT
    step,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN isfraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(100.0 * SUM(CASE WHEN isfraud = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS fraud_rate,
    ROUND(SUM(CASE WHEN isfraud = 1 THEN amount ELSE 0 END), 2) AS fraud_amount
FROM paysim
GROUP BY step
ORDER BY step;
