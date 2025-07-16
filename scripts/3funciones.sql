-- 1
SELECT p.id,
p.name,
AVG(qp.rating)
FROM products AS p
INNER JOIN quality_products AS qp ON p.id = qp.product_id
GROUP BY p.id, p.name
;

-- 2
SELECT c.id AS customer_id,
c.name customer_name, 
COUNT(*) AS productos_calificados 
FROM customers AS c 
INNER JOIN quality_products AS qp ON c.id = qp.customer_id
GROUP BY c.id
;

-- 3
SELECT ab.audience_id,
COUNT(ab.benefit_id) AS beneficios_audiencia
FROM audience_benefits AS ab
GROUP BY ab.audience_id;

-- 4
SELECT AVG(cp.product_id) AS productos_compañia,
c.name AS company_name 
FROM company_products AS cp 
INNER JOIN companies AS c ON cp.company_id = c.id
GROUP BY cp.company_id
;

-- 5
SELECT SUM(c.id) AS total_empresas,
c.city_id,
com.name
FROM companies AS c
INNER JOIN cities_or_municipalities AS com ON c.city_id = com.code
GROUP BY c.city_id
ORDER BY total_empresas ASC
;

-- 6
SELECT AVG(p.price) AS promedio_precio,
uom.description
FROM products AS p
INNER JOIN company_products AS cp ON p.id = cp.product_id   
INNER JOIN unit_of_measure AS uom ON cp.unitmeasure_id = uom.id
GROUP BY uom.id
;

-- 7
SELECT COUNT(*) AS clientes_por_ciudad
a.city_id
FROM customers AS c 
INNER JOIN addresses AS a ON c.address_id = a.id 
GROUP BY a.city_id
;