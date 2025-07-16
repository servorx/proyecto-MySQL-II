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
SELECT c.id,
c.name,
COUNT(cp.product_id) AS cantidad_productos
FROM companies AS c 
INNER JOIN company_products AS cp ON c.id = cp.company_id
GROUP BY c.id, c.name
HAVING COUNT(cp.product_id) > (
  SELECT AVG(cantidad)
  FROM (
    SELECT COUNT(cp2.product_id) AS cantidad
    FROM company_products cp2
    GROUP BY cp2.company_id
  ) AS sub
);

-- 3 
SELECT p.id AS product_id,
p.name AS product_name,
df.favorite_id
FROM products AS p
INNER JOIN detail_favorites AS df ON p.id = df.product_id
INNER JOIN favorites AS f ON df.favorite_id = f.id
WHERE p.id IN (
  SELECT qp.product_id
  FROM quality_products AS qp 
  WHERE qp.customer_id != f.customer_id
)
;

-- 4
SELECT p.id,
p.name,
COUNT(df.id) AS veces_favorito
FROM products AS p 
INNER JOIN detail_favorites AS df ON p.id = df.product_id
GROUP BY p.id, p.name
HAVING COUNT(df.id) = (
  SELECT MAX(veces)
  FROM (
    SELECT COUNT(*) AS veces
    FROM detail_favorites
    GROUP BY product_id
  ) AS sub
);

-- 5
SELECT c.id,
c.name AS customer_name,
e.email_name,
e.email_type,
c.email_id
FROM customers AS c 
INNER JOIN emails AS e ON c.email_id = e.id
WHERE c.email_id NOT IN (
  SELECT c2.email_id
  FROM rates AS r 
  INNER JOIN customers AS c2 ON r.customer_id = c2.id
  WHERE c2.email_id IS NOT NULL 
) AND c.email_id NOT IN (
  SELECT c3.email_id
  FROM quality_products AS qp 
  INNER JOIN customers AS c3 ON qp.customer_id = c3.id
  WHERE c3.email_id IS NOT NULL
)
;

-- 6
SELECT p.id,
p.name,
p.category_id,
qp.rating AS product_rating
FROM products AS p
INNER JOIN quality_products AS qp ON p.id = qp.product_id
WHERE qp.rating < (
  SELECT MIN(qp2.rating)
  FROM quality_products qp2
  INNER JOIN products p2 ON qp2.product_id = p2.id
  WHERE p2.category_id = p.category_id
)
;

-- 7 
SELECT com.code AS city_id,
com.name AS city_name
FROM cities_or_municipalities AS com 
WHERE com.code NOT IN (
  SELECT DISTINCT c.city_id
  FROM customers AS c
  WHERE c.city_id IS NOT NULL 
)
; 

-- 8 
SELECT p.id AS product_id,
p.name AS product_name
FROM products AS p 
WHERE p.id NOT IN (
  SELECT DISTINCT qp.product_id
  FROM quality_products AS qp 
  WHERE qp.product_id IS NOT NULL 
)
ORDER BY p.id
;

-- 9 
SELECT b.id,
b.description,
b.detail
FROM benefits AS b 
WHERE b.id NOT IN  (
  SELECT ab.benefit_id
  FROM audience_benefits AS ab 
  WHERE ab.benefit_id IS NOT NULL
)
;

-- 10
-- to dos los productos favoritos estan disponibles en las empresas 
SELECT p.id,
p.name
FROM products AS p 
INNER JOIN detail_favorites AS df ON p.id = df.product_id
WHERE p.id NOT IN (
  SELECT cp.product_id
  FROM company_products AS cp
)
;

-- 11
SELECT p.id,
p.name
FROM products AS p 
INNER JOIN company_products AS cp ON p.id = cp.product_id
INNER JOIN companies AS c ON cp.company_id = c.id
WHERE c.city_id IN (
  SELECT city_id
  FROM companies  
  GROUP BY city_id
  HAVING COUNT(*) < 3
)
ORDER BY p.id ASC 
;

-- 12
SELECT p.id,
p.name AS product_name,
qp.rating 
FROM products AS p 
INNER JOIN quality_products AS qp ON p.id = qp.product_id
WHERE qp.rating > (
  SELECT AVG(rating)
  FROM quality_products
)
;

-- 13
SELECT c.id AS company_id,
c.name,
ca.description AS category
FROM companies AS c 
INNER JOIN categories AS ca ON c.category_id = ca.id
WHERE c.id IN (
  SELECT cp.company_id
  FROM company_products AS cp 
  INNER JOIN products AS p ON cp.product_id = p.id
  GROUP BY cp.company_id
  HAVING COUNT(DISTINCT category_id) = 1
)
ORDER BY c.id
;

-- 14
SELECT p.id,
p.name,
cp.price
FROM products AS p 
INNER JOIN company_products AS cp ON p.id = cp.product_id
WHERE cp.price = (
  SELECT MAX(price)
  FROM company_products
)
;

-- 15
SELECT p.id AS product_id,
p.name AS product_name,
qp.rating
FROM products AS p
INNER JOIN quality_products AS qp ON p.id = qp.product_id
WHERE qp.customer_id != ALL (
  SELECT f.customer_id
  FROM favorites AS f
  INNER JOIN detail_favorites AS df ON f.id = df.favorite_id
  WHERE df.product_id = p.id
)
AND qp.rating > 4;

-- 16 
SELECT p.id AS product_id,
p.name,
qp.rating 
FROM products AS p 
INNER JOIN quality_products AS qp ON p.id = qp.product_id
WHERE p.image IS NULL AND qp.rating IN (
  SELECT rating
  FROM quality_products 
  WHERE rating IS NOT NULL 
)
;

-- 17
SELECT m.id,
m.name
FROM memberships AS m
WHERE m.id NOT IN (
  SELECT DISTINCT membership_id
  FROM membership_periods 
)
;

-- 18
SELECT b.id AS benefit_id,
b.description
FROM benefits AS b
WHERE b.id IN (
  SELECT ab.benefit_id
  FROM audience_benefits AS ab
  GROUP BY ab.benefit_id
  HAVING COUNT(DISTINCT ab.audience_id) > 1
)
;

-- 19
SELECT c.id AS company_id,
c.name
FROM companies AS c
WHERE c.id IN (
  SELECT cp.company_id
  FROM company_products AS cp
  WHERE cp.unitmeasure_id IS NULL
);

-- 20
SELECT cu.id,
cu.name
FROM customers AS cu
WHERE cu.audience_id IN (
  SELECT mb.audience_id
  FROM membership_benefits AS mb
) AND cu.id NOT IN (
  SELECT f.customer_id
  FROM favorites AS f
);
