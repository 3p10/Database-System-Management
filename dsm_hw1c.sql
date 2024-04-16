SELECT n as name, d as purchase_date
FROM purchases
WHERE EXTRACT(MONTH FROM d) IN (2,3)  -- February and March
  AND EXTRACT(YEAR FROM d) % 4 = 0  -- Leap year check
ORDER BY name, d;