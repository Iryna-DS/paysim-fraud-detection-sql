SELECT 
    nameorig,
    COUNT(*) AS transactions,
    SUM(amount) AS total_sent
FROM paysim
GROUP BY nameorig
HAVING COUNT(*) > 1
ORDER BY total_sent DESC
LIMIT 10;
