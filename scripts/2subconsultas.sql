-- 2
SELECT p.id AS product_id, 
p.name AS product_name,
p.price AS product_price,
c.description AS category_name
FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.id
WHERE p.price > (
  SELECT AVG(p2.price)
  FROM products AS p2
  WHERE p2.category_id = p.category_id
)
;

-- 2