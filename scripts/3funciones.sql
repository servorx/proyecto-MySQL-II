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
SELECT 
FROM 
WHERE 
