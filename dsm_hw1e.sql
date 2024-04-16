SELECT n AS name, d AS purchase_date
FROM purchases
WHERE DATE_PART('day', d) >= 22
  AND DATE_PART('day', d) <= DATE_PART('day', DATE_TRUNC('month', d) + INTERVAL '1 month' - INTERVAL '1 day')
  AND DATE_PART('dow', d) = 5
ORDER BY d;
