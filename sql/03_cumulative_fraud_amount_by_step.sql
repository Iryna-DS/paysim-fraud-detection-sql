SELECT 
    step,
    SUM(amount) AS fraud_amount,
    SUM(SUM(amount)) OVER (ORDER BY step) AS cumulative_fraud
FROM paysim
WHERE isfraud = 1
GROUP BY step
ORDER BY step;
