-- Analysis: Effectiveness of the built-in fraud detection flag

-- Finding: isFlaggedFraud catches only a fraction of actual fraud,
--          revealing a high false negative rate. In production systems
--          this would represent significant financial losses from
--          undetected fraudulent transactions.

SELECT
    isfraud,
    isflaggedfraud,
    COUNT(*) AS transactions,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY isfraud), 2) AS pct
FROM paysim
GROUP BY isfraud, isflaggedfraud
ORDER BY isfraud, isflaggedfraud;
