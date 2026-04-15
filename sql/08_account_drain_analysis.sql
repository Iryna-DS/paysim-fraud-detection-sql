-- Analysis: Account drain rate in fraud transactions

-- Finding: 97.67% of fraud transactions are full drains (100% of balance),
--          confirming account takeover as the dominant fraud pattern.
--          However, two paradoxes emerge:
--          1. Partial drains show avg amount of 9.9M vs 1.3M for full drains —
--             larger accounts are drained partially, possibly to avoid
--             detection thresholds.
--          2. Near-full drain (90-99%): only 14 transactions but all hit
--             exactly the 10M system limit — fraudsters took the maximum
--             allowed without fully emptying the account, a deliberate
--             strategy to avoid "full drain" alert triggers.

SELECT
    CASE
        WHEN oldbalanceorg = 0 THEN 'Already empty'
        WHEN ROUND(amount / oldbalanceorg, 2) >= 1.00 THEN 'Full drain (100%)'
        WHEN ROUND(amount / oldbalanceorg, 2) >= 0.90 THEN 'Near-full drain (90–99%)'
        WHEN ROUND(amount / oldbalanceorg, 2) >= 0.50 THEN 'Partial drain (50–89%)'
        ELSE 'Small fraction (<50%)'
    END AS drain_category,
    COUNT(*) AS fraud_transactions,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_fraud,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(SUM(amount), 2) AS total_fraud_amount
FROM paysim
WHERE isfraud = 1
GROUP BY drain_category
ORDER BY pct_of_fraud DESC;
