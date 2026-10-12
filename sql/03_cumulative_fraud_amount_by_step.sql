-- Analysis: Cumulative fraud amount over time

-- Finding: Cumulative fraud grows with visible spikes at certain time steps,
--          suggesting periods of coordinated fraudulent activity.
--          In a real system, these spikes would trigger alert escalation.

SELECT 
    step,
    SUM(amount) AS fraud_amount,
    SUM(SUM(amount)) OVER (ORDER BY step) AS cumulative_fraud
FROM paysim
WHERE isfraud = 1
GROUP BY step
ORDER BY step;
