-- Analysis: Drop account profiling — fraud recipient analysis


-- Finding: All top fraud recipients appear exactly twice — a strong
--          signal of deliberate "use and abandon" drop account strategy.
--          Most are active for very short periods (16–133 steps) before
--          disappearing, consistent with temporary accounts created
--          specifically to receive and quickly move funds.
--          Exception: C668046170 active for 417 steps and hit the 10M
--          system limit.


SELECT
    namedest,
    COUNT(*) AS fraud_transactions,
    ROUND(SUM(amount), 2) AS total_received,
    ROUND(AVG(amount), 2) AS avg_per_transaction,
    ROUND(MAX(amount), 2) AS largest_transfer,
    MIN(step) AS first_seen_step,
    MAX(step) AS last_seen_step,
    MAX(step) - MIN(step) AS active_for_steps
FROM paysim
WHERE isfraud = 1
GROUP BY namedest
HAVING COUNT(*) > 1
ORDER BY total_received DESC
LIMIT 10;
