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

