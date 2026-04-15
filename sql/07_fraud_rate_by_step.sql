-- Analysis: Fraud distribution across time steps

-- Finding: Fraud rate varies significantly across time steps (0.01% to 100%).
--          "Quiet periods" with near-zero legitimate activity show 100% fraud rate —
--          suggesting coordinated attacks during off-peak hours.
--          fraud_rate and fraud_amount don't always align: some steps show
--          low fraud_rate but very high fraud_amount (few but large transactions).
--          Both dimensions matter for alert design in real payment systems.


SELECT
    step,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN isfraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(100.0 * SUM(CASE WHEN isfraud = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS fraud_rate,
    ROUND(SUM(CASE WHEN isfraud = 1 THEN amount ELSE 0 END), 2) AS fraud_amount
FROM paysim
GROUP BY step
ORDER BY step;
