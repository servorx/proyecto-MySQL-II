-- 1
SELECT p.name AS producto,
c.name AS empresa,
cm.name AS ciudad,
MIN(cp.price) AS precio_minimo
FROM products AS p
INNER JOIN company_products AS cp ON p.id = cp.product_id
INNER JOIN companies AS c ON cp.company_id = c.id
INNER JOIN cities_or_municipalities AS cm ON c.city_id = cm.code
GROUP BY p.id, c.id, cm.code;

-- 2
SELECT c.id,
c.name,
COUNT(qp.rating) AS total_calificaciones
FROM customers AS c 
INNER JOIN quality_products AS qp ON c.id = qp.customer_id
WHERE qp.daterating >= NOW() - INTERVAL 6 MONTH
GROUP BY c.id, c.name
ORDER BY SUM(qp.rating) DESC 
LIMIT 5;

-- 3
SELECT c.id AS category_id,
c.description,
uom.description AS unidad_medida
FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.id
INNER JOIN company_products AS cp ON p.id = cp.product_id
INNER JOIN unit_of_measure AS uom ON cp.unitmeasure_id = uom.id
GROUP BY c.id, c.description, uom.description
;

-- 4
-- no encontré forma de hacerlo sin subconsulta
SELECT qp.product_id,
p.name,
qp.rating
FROM quality_products AS qp 
INNER JOIN products AS p ON qp.product_id = p.id
WHERE qp.rating > (
	SELECT AVG(rating) 
	FROM quality_products)
; 

-- 5
SELECT c.id AS company_id,
c.name,
r.rating
FROM companies AS c 
INNER JOIN rates AS r ON c.id = r.company_id
WHERE r.company_id IS NULL;
;

-- 6
SELECT df.product_id,
p.name,
COUNT(DISTINCT f.customer_id) AS total_clientes
FROM detail_favorites AS df
INNER JOIN favorites AS f ON df.favorite_id = f.id
INNER JOIN products AS p ON df.product_id = p.id
GROUP BY df.product_id, p.name
HAVING COUNT(DISTINCT f.customer_id) > 10;

-- 7 
SELECT 
com.code AS city_id,
com.name AS city_name,
ca.description AS category,
COUNT(co.id) AS total_empresas
FROM companies AS co 
INNER JOIN cities_or_municipalities AS com ON co.city_id = com.code 
INNER JOIN categories AS ca ON co.category_id = ca.id
WHERE co.isactive = TRUE
GROUP BY com.code, com.name, ca.description;

-- 8 
SELECT p.id product_id, 
p.name AS name_product,
COUNT(df.id) AS cantidad_calificaciones,
com.name AS ciudad_nombre,
c.city_id AS city_id
FROM products AS p 
INNER JOIN detail_favorites AS df ON p.id = df.product_id
INNER JOIN company_products AS cp ON p.id = cp.product_id
INNER JOIN companies AS c ON cp.company_id = c.id
INNER JOIN cities_or_municipalities AS com ON c.city_id = com.code
GROUP BY p.id, p.name, com.name, c.city_id
ORDER BY COUNT(df.id) DESC
LIMIT 10
;

-- 9
SELECT p.id AS product_id,
p.name,
uom.id
FROM products AS p 
INNER JOIN company_products AS cp ON p.id = cp.product_id
INNER JOIN unit_of_measure AS uom ON cp.unitmeasure_id = uom.id
WHERE uom.id IS NULL
; 

-- 10 
SELECT m.id AS membership_id,
m.name
FROM memberships AS m
LEFT JOIN membership_benefits AS mb ON m.id = mb.membership_id
WHERE mb.benefit_id IS NULL
;

-- 11
SELECT p.id AS product_id,
p.name,
AVG(qp.rating) AS promedio_valoracion,
c.description 
FROM products AS p 
INNER JOIN quality_products AS qp ON p.id = qp.product_id
INNER JOIN categories AS c ON p.category_id = c.id
WHERE c.id = 1
GROUP BY p.id, p.name, c.description
;

-- 12
SELECT qp.customer_id, 
c.name
FROM quality_products AS qp  
INNER JOIN customers AS c ON qp.customer_id = c.id
INNER JOIN companies AS co ON qp.company_id = co.id
GROUP BY qp.customer_id, c.name
HAVING COUNT(DISTINCT qp.company_id) > 1
;

-- 13
SELECT com.code,
com.name,
COUNT(c.id) AS total_clientes 
FROM customers AS c 
INNER JOIN cities_or_municipalities AS com ON c.city_id = com.code
GROUP BY com.code, com.name
ORDER BY COUNT(c.id) ASC
;

-- 14
SELECT 
  cp.company_id,
  p.id AS product_id,
  p.name AS product_name,
  AVG(qp.rating) AS promedio_rating
FROM products AS p
INNER JOIN quality_products AS qp ON p.id = qp.product_id
INNER JOIN company_products AS cp ON p.id = cp.product_id
GROUP BY cp.company_id, p.id, p.name
ORDER BY promedio_rating DESC
;

-- 15
SELECT c.name,
COUNT(DISTINCT cp.product_id) AS total_productos 
FROM companies AS c 
INNER JOIN company_products AS cp ON c.id = cp.company_id
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT cp.product_id) > 5
ORDER BY total_productos DESC
LIMIT 5;

-- 16
SELECT p.id AS product_id,
p.name 
FROM detail_favorites AS df
INNER JOIN products AS p ON df.product_id = p.id
INNER JOIN favorites AS f ON df.favorite_id = f.id
LEFT JOIN quality_products AS qp ON qp.product_id = p.id 
LEFT JOIN quality_products AS qp2 ON qp2.customer_id = f.customer_id 
LEFT JOIN quality_products AS qp3 ON qp3.company_id = f.company_id
WHERE qp.rating IS NULL
;

-- 17
SELECT a.id AS audience_id,
a.description AS audience_description,
b.id AS benefit_id,
b.description AS benefit_description,
b.detail AS benefit_detail
FROM audience_benefits AS ab 
INNER JOIN benefits AS b ON ab.benefit_id = b.id
INNER JOIN audiences AS a ON ab.audience_id = a.id
ORDER BY a.id, b.id
;

-- 18
SELECT c.id AS company_id,
c.name AS company_name,
com.name AS city_name,
com.code AS city_id
FROM companies AS c 
INNER JOIN cities_or_municipalities AS com ON c.city_id = com.code
LEFT JOIN company_products AS cp ON c.id = cp.company_id
WHERE cp.company_id IS NULL 
;

-- 19
SELECT DISTINCT cp.company_id,
p1.id AS product_id,
p1.name AS product_name
FROM products AS p1
-- el <> se usa para especificar diferencia
JOIN products AS p2 ON p1.name = p2.name AND p1.id <> p2.id
JOIN company_products AS cp ON p1.id = cp.product_id
ORDER BY cp.company_id, p1.name;

-- 20
SELECT 
c.id AS customer_id,
c.name AS customer_name,
p.id AS product_id,
p.name AS product_name,
AVG(qp.rating) AS promedio_calificacion
FROM customers AS c
INNER JOIN favorites AS f ON c.id = f.customer_id
INNER JOIN detail_favorites AS df ON f.id = df.favorite_id
INNER JOIN products AS p ON df.product_id = p.id
LEFT JOIN quality_products AS qp ON p.id = qp.product_id
GROUP BY c.id, c.name, p.id, p.name
ORDER BY c.id, p.name;