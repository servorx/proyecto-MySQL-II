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

-- 8
SELECT COUNT(mp.membership_id) as cantidad_planes_membresia
FROM membership_periods AS mp  
GROUP BY mp.period_id
;

-- 9
SELECT c.id,
c.name,
AVG(rating) promedio_rating
FROM customers AS c 
INNER JOIN quality_products AS qp ON c.id = qp.customer_id
GROUP BY c.id
; 

-- 10
SELECT MAX(qp.daterating) AS fecha_mas_reciente 
FROM quality_products AS qp 
;

-- 11
SELECT 
p.category_id,
STDDEV(cp.price) AS variacion
FROM company_products AS cp 
INNER JOIN products AS p ON cp.product_id = p.id
GROUP BY p.category_id;

-- 12 
SELECT COUNT(*) AS cantidad_veces_marcado,
product_id
FROM detail_favorites 
GROUP BY product_id
;

-- 13
SELECT ROUND(
    (SELECT COUNT(DISTINCT product_id) FROM quality_products) * 100.0 /
    (SELECT COUNT(*) FROM products), 2
) AS porcentaje_calificados
;

-- 14
SELECT 
AVG(rating) AS promedio_rating
FROM rates
GROUP BY poll_id
;

-- 15
SELECT 
membership_id,
COUNT(*) AS total_beneficios,
AVG(benefit_id) AS promedio_id_beneficio
FROM membership_benefits
GROUP BY membership_id
;

-- 16
SELECT 
company_id,
AVG(price) AS promedio_precio,
VARIANCE(price) AS varianza_precio
FROM company_products
GROUP BY company_id
;

-- 17
SELECT 
c.id AS customer_id,
c.name AS customer_name,
com.name AS customer_city,
COUNT(DISTINCT cp.product_id) AS total_available_products
FROM customers AS cu
INNER JOIN addresses AS a ON cu.address_id = a.id 
INNER JOIN cities_or_municipalities AS com ON a.city_id = com.code
INNER JOIN companies AS c ON c.city_id = com.code
INNER JOIN company_products AS cp ON c.id = cp.company_id
GROUP BY c.id, c.name, com.name
;

-- 18
SELECT 
c.type_id,
ti.description AS tipo,
COUNT(DISTINCT cp.product_id) AS productos_unicos
FROM companies AS c
INNER JOIN company_products AS cp ON c.id = cp.company_id
INNER JOIN types_identifications AS ti ON c.type_id = ti.id 
GROUP BY c.type_id, ti.id
;

-- 19
SELECT 
  COUNT(*) AS clientes_sin_email
FROM customers
WHERE email_id IS NULL;

-- 20 
SELECT c.id,
c.name,
COUNT(DISTINCT product_id) AS total_calificados
FROM companies AS c 
INNER JOIN company_products AS cp ON c.id = cp.company_id
INNER JOIN rates AS r ON c.id = r.company_id
GROUP BY c.id
ORDER BY total_calificados DESC
LIMIT 1;