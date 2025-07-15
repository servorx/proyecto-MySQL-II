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
SUM(qp.rating) AS calificaciones
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
WHERE r.rating = NULL
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
WHERE uom.id = NULL
; 

-- 10 
SELECT m.id AS membership_id,
m.name,
m.description,
mb.benefit_id
FROM memberships AS m 
INNER JOIN membership_benefits AS mb ON m.id = mb.membership_id  
WHERE mb.benefit_id = NULL
; 

-- 11
SELECT p.id AS product_id,
p.name,
AVG(p.)
FROM products AS p 
INNER JOIN 
GROUP BY 
WHERE 