# Resolución General del Proyecto

### Las soluciones específicas se encuentran en la carpeta `scripts`, donde se pueden encontrar los 20 ejercicios de cada apartado en su respectivo archivo.

A su vez, todos los inserts se encuentran en el archivo `dml.sql` y la creacion de las tablas en el archivo `ddl.sql`. Simplemente se copia y se pega todo el archivo dml para crear la base de datos y sus tablas para luego copiar y pegar todo el archivo de ddl y agregar las insersiones, ya en cada apartado de ejercicios se puede encontrar su respectivo archivo y solucion en este mismo readme o en la carpeta scripts

# Historias de Usuario

## 🔹 **1. Consultas SQL Especializadas**

1. Como analista, quiero listar todos los productos con su empresa asociada y el precio más bajo por ciudad.
```sql
SELECT p.name AS producto,
c.name AS empresa,
cm.name AS ciudad,
MIN(cp.price) AS precio_minimo
FROM products AS p
INNER JOIN company_products AS cp ON p.id = cp.product_id
INNER JOIN companies AS c ON cp.company_id = c.id
INNER JOIN cities_or_municipalities AS cm ON c.city_id = cm.code
GROUP BY p.id, c.id, cm.code;
```
2. Como administrador, deseo obtener el top 5 de clientes que más productos han calificado en los últimos 6 meses.
```sql
SELECT c.id,
c.name,
COUNT(qp.rating) AS total_calificaciones
FROM customers AS c 
INNER JOIN quality_products AS qp ON c.id = qp.customer_id
WHERE qp.daterating >= NOW() - INTERVAL 6 MONTH
GROUP BY c.id, c.name
ORDER BY SUM(qp.rating) DESC 
LIMIT 5;
```
3. Como gerente de ventas, quiero ver la distribución de productos por categoría y unidad de medida.
```sql
SELECT c.id AS category_id,
c.description,
uom.description AS unidad_medida
FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.id
INNER JOIN company_products AS cp ON p.id = cp.product_id
INNER JOIN unit_of_measure AS uom ON cp.unitmeasure_id = uom.id
GROUP BY c.id, c.description, uom.description
;
```
4. Como cliente, quiero saber qué productos tienen calificaciones superiores al promedio general.
```sql
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
```
5. Como auditor, quiero conocer todas las empresas que no han recibido ninguna calificación.
```sql
SELECT c.id AS company_id,
c.name,
r.rating
FROM companies AS c 
INNER JOIN rates AS r ON c.id = r.company_id
WHERE r.company_id IS NULL;
;
```
6. Como operador, deseo obtener los productos que han sido añadidos como favoritos por más de 10 clientes distintos.
```sql
SELECT df.product_id,
p.name,
COUNT(DISTINCT f.customer_id) AS total_clientes
FROM detail_favorites AS df
INNER JOIN favorites AS f ON df.favorite_id = f.id
INNER JOIN products AS p ON df.product_id = p.id
GROUP BY df.product_id, p.name
HAVING COUNT(DISTINCT f.customer_id) > 10;
```
7. Como gerente regional, quiero obtener todas las empresas activas por ciudad y categoría.
```sql
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
```
8. Como especialista en marketing, deseo obtener los 10 productos más calificados en cada ciudad.
```sql
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
```
9. Como técnico, quiero identificar productos sin unidad de medida asignada.
```sql
SELECT p.id AS product_id,
p.name,
uom.id
FROM products AS p 
INNER JOIN company_products AS cp ON p.id = cp.product_id
INNER JOIN unit_of_measure AS uom ON cp.unitmeasure_id = uom.id
WHERE uom.id = NULL
; 
```
10. Como gestor de beneficios, deseo ver los planes de membresía sin beneficios registrados.
```sql
SELECT m.id AS membership_id,
m.name,
m.description,
mb.benefit_id
FROM memberships AS m 
INNER JOIN membership_benefits AS mb ON m.id = mb.membership_id  
WHERE mb.benefit_id = NULL
; 
```
11. Como supervisor, quiero obtener los productos de una categoría específica con su promedio de calificación.
```sql
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
```
12. Como asesor, deseo obtener los clientes que han comprado productos de más de una empresa.
```sql
SELECT qp.customer_id, 
c.name
FROM quality_products AS qp  
INNER JOIN customers AS c ON qp.customer_id = c.id
INNER JOIN companies AS co ON qp.company_id = co.id
GROUP BY qp.customer_id, c.name
HAVING COUNT(DISTINCT qp.company_id) > 1
;
```
13. Como director, quiero identificar las ciudades con más clientes activos.
```sql
SELECT com.code,
com.name,
COUNT(c.id) AS total_clientes 
FROM customers AS c 
INNER JOIN cities_or_municipalities AS com ON c.city_id = com.code
GROUP BY com.code, com.name
ORDER BY COUNT(c.id) ASC
;
```
14. Como analista de calidad, deseo obtener el ranking de productos por empresa basado en la media de `quality_products`.
```sql
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
```
15. Como administrador, quiero listar empresas que ofrecen más de cinco productos distintos.
```sql
SELECT c.name,
COUNT(DISTINCT cp.product_id) AS total_productos 
FROM companies AS c 
INNER JOIN company_products AS cp ON c.id = cp.company_id
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT cp.product_id) > 5
ORDER BY total_productos DESC
LIMIT 5;
```
16. Como cliente, deseo visualizar los productos favoritos que aún no han sido calificados.
```sql
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
```
17. Como desarrollador, deseo consultar los beneficios asignados a cada audiencia junto con su descripción.
```sql
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
```
18. Como operador logístico, quiero saber en qué ciudades hay empresas sin productos asociados.
```sql
SELECT c.id AS company_id,
c.name AS company_name,
com.name AS city_name,
com.code AS city_id
FROM companies AS c 
INNER JOIN cities_or_municipalities AS com ON c.city_id = com.code
LEFT JOIN company_products AS cp ON c.id = cp.company_id
WHERE cp.company_id IS NULL 
;
```
19. Como técnico, deseo obtener todas las empresas con productos duplicados por nombre.
```sql
SELECT DISTINCT cp.company_id,
p1.id AS product_id,
p1.name AS product_name
FROM products AS p1
-- el <> se usa para especificar diferencia
JOIN products AS p2 ON p1.name = p2.name AND p1.id <> p2.id
JOIN company_products AS cp ON p1.id = cp.product_id
ORDER BY cp.company_id, p1.name;
```
20. Como analista, quiero una vista resumen de clientes, productos favoritos y promedio de calificación recibido.
```sql
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
```

------

## 🔹 **2. Subconsultas**

1. Como gerente, quiero ver los productos cuyo precio esté por encima del promedio de su categoría.
```sql
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
```
2. Como administrador, deseo listar las empresas que tienen más productos que la media de empresas.
```sql
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
```
3. Como cliente, quiero ver mis productos favoritos que han sido calificados por otros clientes.
```sql
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
```
4. Como supervisor, deseo obtener los productos con el mayor número de veces añadidos como favoritos.
```sql
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
```
5. Como técnico, quiero listar los clientes cuyo correo no aparece en la tabla `rates` ni en `quality_products`.
```sql
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
```
6. Como gestor de calidad, quiero obtener los productos con una calificación inferior al mínimo de su categoría.
```sql
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
```
7. Como desarrollador, deseo listar las ciudades que no tienen clientes registrados.
```sql
SELECT com.code AS city_id,
com.name AS city_name
FROM cities_or_municipalities AS com 
WHERE com.code NOT IN (
  SELECT DISTINCT c.city_id
  FROM customers AS c
  WHERE c.city_id IS NOT NULL 
)
; 
```
8. Como administrador, quiero ver los productos que no han sido evaluados en ninguna encuesta.
```sql
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
```
9. Como auditor, quiero listar los beneficios que no están asignados a ninguna audiencia.
```sql
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
```
10. Como cliente, deseo obtener mis productos favoritos que no están disponibles actualmente en ninguna empresa.
```sql
SELECT p.id,
p.name
FROM products AS p 
INNER JOIN detail_favorites AS df ON p.id = df.product_id
WHERE p.id NOT IN (
  SELECT cp.product_id
  FROM company_products AS cp
)
;
```
11. Como director, deseo consultar los productos vendidos en empresas cuya ciudad tenga menos de tres empresas registradas.
```sql
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
```
12. Como analista, quiero ver los productos con calidad superior al promedio de todos los productos.
```sql
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
```
13. Como gestor, quiero ver empresas que sólo venden productos de una única categoría.
```sql
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
```
14. Como gerente comercial, quiero consultar los productos con el mayor precio entre todas las empresas.
```sql
SELECT p.id,
p.name,
p.price
FROM products AS p 
WHERE p.price IN (
  SELECT MAX(price)
  FROM products
)
;
```
15. Como cliente, quiero saber si algún producto de mis favoritos ha sido calificado por otro cliente con más de 4 estrellas.
```sql
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
```
16. Como operador, quiero saber qué productos no tienen imagen asignada pero sí han sido calificados.
```sql
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
```
17. Como auditor, quiero ver los planes de membresía sin periodo vigente.
```sql
SELECT m.id,
m.name
FROM memberships AS m
WHERE m.id NOT IN (
  SELECT DISTINCT membership_id
  FROM membership_periods 
)
;
```
18. Como especialista, quiero identificar los beneficios compartidos por más de una audiencia.
```sql
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
```
19. Como técnico, quiero encontrar empresas cuyos productos no tengan unidad de medida definida.
```sql
-- todos tienen medids definidas
SELECT c.id AS company_id,
c.name
FROM companies AS c
WHERE c.id IN (
  SELECT cp.company_id
  FROM company_products AS cp
  WHERE cp.unitmeasure_id IS NULL
);

```
20. Como gestor de campañas, deseo obtener los clientes con membresía activa y sin productos favoritos.
```sql
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
```

------

## 🔹 **3. Funciones Agregadas**

### **1. Obtener el promedio de calificación por producto**

   > *"Como analista, quiero obtener el promedio de calificación por producto."*

   🔍 **Explicación para dummies:**
    La persona encargada de revisar el rendimiento quiere saber **qué tan bien calificado está cada producto**. Con `AVG(rating)` agrupado por `product_id`, puede verlo de forma resumida.
```sql
SELECT p.id,
p.name,
AVG(qp.rating)
FROM products AS p
INNER JOIN quality_products AS qp ON p.id = qp.product_id
GROUP BY p.id, p.name
;
```

   ------

   ### **2. Contar cuántos productos ha calificado cada cliente**

   > *"Como gerente, desea contar cuántos productos ha calificado cada cliente."*

   🔍 **Explicación:**
    Aquí se quiere saber **quiénes están activos opinando**. Se usa `COUNT(*)` sobre `rates`, agrupando por `customer_id`.
```sql
SELECT c.id AS customer_id,
c.name customer_name, 
COUNT(*) AS productos_calificados 
FROM customers AS c 
INNER JOIN quality_products AS qp ON c.id = qp.customer_id
GROUP BY c.id
;
```

   ------

   ### **3. Sumar el total de beneficios asignados por audiencia**

   > *"Como auditor, quiere sumar el total de beneficios asignados por audiencia."*

   🔍 **Explicación:**
    El auditor busca **cuántos beneficios tiene cada tipo de usuario**. Con `COUNT(*)` agrupado por `audience_id` en `audiencebenefits`, lo obtiene.
```sql
SELECT ab.audience_id,
COUNT(ab.benefit_id) AS beneficios_audiencia
FROM audience_benefits AS ab
GROUP BY ab.audience_id;
```
   ------

   ### **4. Calcular la media de productos por empresa**

   > *"Como administrador, desea conocer la media de productos por empresa."*

   🔍 **Explicación:**
    El administrador quiere saber si **las empresas están ofreciendo pocos o muchos productos**. Cuenta los productos por empresa y saca el promedio con `AVG(cantidad)`.
```sql
SELECT AVG(cp.product_id) AS productos_compañia,
c.name AS company_name 
FROM company_products AS cp 
INNER JOIN companies AS c ON cp.company_id = c.id
GROUP BY cp.company_id
;
```
   ------

   ### **5. Contar el total de empresas por ciudad**

   > *"Como supervisor, quiere ver el total de empresas por ciudad."*

   🔍 **Explicación:**
    La idea es ver **en qué ciudades hay más movimiento empresarial**. Se usa `COUNT(*)` en `companies`, agrupando por `city_id`.
```sql
SELECT SUM(c.id) AS total_empresas,
c.city_id,
com.name
FROM companies AS c
INNER JOIN cities_or_municipalities AS com ON c.city_id = com.code
GROUP BY c.city_id
ORDER BY total_empresas ASC
;
```
   ------

   ### **6. Calcular el promedio de precios por unidad de medida**

   > *"Como técnico, desea obtener el promedio de precios de productos por unidad de medida."*

   🔍 **Explicación:**
    Se necesita saber si **los precios son coherentes según el tipo de medida**. Con `AVG(price)` agrupado por `unit_id`, se compara cuánto cuesta el litro, kilo, unidad, etc.
```sql
SELECT AVG(p.price) AS promedio_precio,
uom.description
FROM products AS p
INNER JOIN company_products AS cp ON p.id = cp.product_id   
INNER JOIN unit_of_measure AS uom ON cp.unitmeasure_id = uom.id
GROUP BY uom.id
;
```
   ------

   ### **7. Contar cuántos clientes hay por ciudad**

   > *"Como gerente, quiere ver el número de clientes registrados por cada ciudad."*

   🔍 **Explicación:**
    Con `COUNT(*)` agrupado por `city_id` en la tabla `customers`, se obtiene **la cantidad de clientes que hay en cada zona**.
```sql
SELECT 
  a.city_id,
  COUNT(*) AS clientes_por_ciudad
FROM customers AS c 
INNER JOIN addresses AS a ON c.address_id = a.id 
GROUP BY a.city_id;
```
   ------

   ### **8. Calcular planes de membresía por periodo**

   > *"Como operador, desea contar cuántos planes de membresía existen por periodo."*

   🔍 **Explicación:**
    Sirve para ver **qué tantos planes están vigentes cada mes o trimestre**. Se agrupa por periodo (`start_date`, `end_date`) y se cuenta cuántos registros hay.
```sql
SELECT COUNT(mp.membership_id) as cantidad_planes_membresia
FROM membership_periods AS mp  
GROUP BY mp.period_id
;
```
   ------

   ### **9. Ver el promedio de calificaciones dadas por un cliente a sus favoritos**

   > *"Como cliente, quiere ver el promedio de calificaciones que ha otorgado a sus productos favoritos."*

   🔍 **Explicación:**
    El cliente quiere saber **cómo ha calificado lo que más le gusta**. Se hace un `JOIN` entre favoritos y calificaciones, y se saca `AVG(rating)`.
```sql
SELECT c.id,
c.name,
AVG(rating) promedio_rating
FROM customers AS c 
INNER JOIN quality_products AS qp ON c.id = qp.customer_id
GROUP BY c.id
; 
```
   ------

   ### **10. Consultar la fecha más reciente en que se calificó un producto**

   > *"Como auditor, desea obtener la fecha más reciente en la que se calificó un producto."*

   🔍 **Explicación:**
    Busca el `MAX(created_at)` agrupado por producto. Así sabe **cuál fue la última vez que se evaluó cada uno**.
```sql
SELECT MAX(qp.daterating) AS fecha_mas_reciente 
FROM quality_products AS qp 
;
```
   ------

   ### **11. Obtener la desviación estándar de precios por categoría**

   > *"Como desarrollador, quiere conocer la variación de precios por categoría de producto."*

   🔍 **Explicación:**
    Usando `STDDEV(price)` en `companyproducts` agrupado por `category_id`, se puede ver **si hay mucha diferencia de precios dentro de una categoría**.
```sql
SELECT 
p.category_id,
STDDEV(cp.price) AS variacion
FROM company_products AS cp 
INNER JOIN products AS p ON cp.product_id = p.id
GROUP BY p.category_id;
```
   ------

   ### **12. Contar cuántas veces un producto fue favorito**

   > *"Como técnico, desea contar cuántas veces un producto fue marcado como favorito."*

   🔍 **Explicación:**
    Con `COUNT(*)` en `details_favorites`, agrupado por `product_id`, se obtiene **cuáles productos son los más populares entre los clientes**.
```sql
SELECT COUNT(*) AS cantidad_veces_marcado,
product_id
FROM detail_favorites 
GROUP BY product_id
;
```
   ------

   ### **13. Calcular el porcentaje de productos evaluados**

   > *"Como director, quiere saber qué porcentaje de productos han sido calificados al menos una vez."*

   🔍 **Explicación:**
    Cuenta cuántos productos hay en total y cuántos han sido evaluados (`rates`). Luego calcula `(evaluados / total) * 100`.
```sql
SELECT ROUND(
    (SELECT COUNT(DISTINCT product_id) FROM quality_products) * 100.0 /
    (SELECT COUNT(*) FROM products), 2
) AS porcentaje_calificados
;
```
   ------

   ### **14. Ver el promedio de rating por encuesta**

   > *"Como analista, desea conocer el promedio de rating por encuesta."*

   🔍 **Explicación:**
    Agrupa por `poll_id` en `rates`, y calcula el `AVG(rating)` para ver **cómo se comportó cada encuesta**.
```sql
SELECT 
AVG(rating) AS promedio_rating
FROM rates
GROUP BY poll_id
;
```
   ------

   ### **15. Calcular el promedio y total de beneficios por plan**

   > *"Como gestor, quiere obtener el promedio y el total de beneficios asignados a cada plan de membresía."*

   🔍 **Explicación:**
    Agrupa por `membership_id` en `membershipbenefits`, y usa `COUNT(*)` y `AVG(beneficio)` si aplica (si hay ponderación).
```sql
SELECT 
membership_id,
COUNT(*) AS total_beneficios,
AVG(benefit_id) AS promedio_id_beneficio
FROM membership_benefits
GROUP BY membership_id
;
```
   ------

   ### **16. Obtener media y varianza de precios por empresa**

   > *"Como gerente, desea obtener la media y la varianza del precio de productos por empresa."*

   🔍 **Explicación:**
    Se agrupa por `company_id` y se usa `AVG(price)` y `VARIANCE(price)` para saber **qué tan consistentes son los precios por empresa**.
```sql
SELECT 
company_id,
AVG(price) AS promedio_precio,
VARIANCE(price) AS varianza_precio
FROM company_products
GROUP BY company_id
;
```
   ------

   ### **17. Ver total de productos disponibles en la ciudad del cliente**

   > *"Como cliente, quiere ver cuántos productos están disponibles en su ciudad."*

   🔍 **Explicación:**
    Hace un `JOIN` entre `companies`, `companyproducts` y `citiesormunicipalities`, filtrando por la ciudad del cliente. Luego se cuenta.
```sql
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
```
   ------

   ### **18. Contar productos únicos por tipo de empresa**

   > *"Como administrador, desea contar los productos únicos por tipo de empresa."*

   🔍 **Explicación:**
    Agrupa por `company_type_id` y cuenta cuántos productos diferentes tiene cada tipo de empresa.
```sql
SELECT 
c.type_id,
ti.description AS tipo,
COUNT(DISTINCT cp.product_id) AS productos_unicos
FROM companies AS c
INNER JOIN company_products AS cp ON c.id = cp.company_id
INNER JOIN types_identifications AS ti ON c.type_id = ti.id 
GROUP BY c.type_id, ti.id
;
```
   ------

   ### **19. Ver total de clientes sin correo electrónico registrado**

   > *"Como operador, quiere saber cuántos clientes no han registrado su correo."*

   🔍 **Explicación:**
    Filtra `customers WHERE email IS NULL` y hace un `COUNT(*)`. Esto ayuda a mejorar la base de datos para campañas.
```sql
SELECT 
  COUNT(*) AS clientes_sin_email
FROM customers
WHERE email_id IS NULL;
```
   ------

   ### **20. Empresa con más productos calificados**

   > *"Como especialista, desea obtener la empresa con el mayor número de productos calificados."*

   🔍 **Explicación:**
    Hace un `JOIN` entre `companies`, `companyproducts`, y `rates`, agrupa por empresa y usa `COUNT(DISTINCT product_id)`, ordenando en orden descendente y tomando solo el primero.
```sql
SELECT c.id,
c.name,
COUNT(DISTINCT product_id) AS total_calificados
FROM companies AS c 
INNER JOIN company_products AS cp ON c.id = cp.company_id
INNER JOIN rates AS r ON c.id = r.company_id
GROUP BY c.id
ORDER BY total_calificados DESC
LIMIT 1;
```
------

## 🔹 **4. Procedimientos Almacenados**

### **1. Registrar una nueva calificación y actualizar el promedio**

   > *"Como desarrollador, quiero un procedimiento que registre una calificación y actualice el promedio del producto."*

   🧠 **Explicación:**
    Este procedimiento recibe `product_id`, `customer_id` y `rating`, inserta la nueva fila en `rates`, y recalcula automáticamente el promedio en la tabla `products` (campo `average_rating`).
```sql
-- decidi hacerlo en quality_products porque recibe mejor los parametros y no tengo que hacer tantos join
DELIMITER $$

CREATE PROCEDURE update_average(
  IN ua_product_id INT,
  IN ua_customer_id INT,
  IN ua_company_id INT,
  IN ua_poll_id INT,
  IN ua_rating DECIMAL(5,2)
)
BEGIN
  INSERT INTO quality_products (
    product_id, customer_id, company_id, poll_id, daterating, rating
  ) 
  VALUES (
    ua_product_id, ua_customer_id, ua_company_id, ua_poll_id, NOW(), ua_rating
  );

  -- Mostrar promedio del producto actualizado
  SELECT 
    p.id AS product_id,
    p.name,
    AVG(qp.rating) AS promedio_rating
  FROM products AS p
  INNER JOIN quality_products AS qp ON p.id = qp.product_id
  WHERE p.id = ua_product_id
  GROUP BY p.id, p.name;
END $$

DELIMITER ;

CALL update_average(1, 2, 3, 1, 4.5);
```
   ------

   ### **2. Insertar empresa y asociar productos por defecto**

   > *"Como administrador, deseo un procedimiento para insertar una empresa y asociar productos por defecto."*

   🧠 **Explicación:**
    Este procedimiento inserta una empresa en `companies`, y luego vincula automáticamente productos predeterminados en `companyproducts`.
```sql
DELIMITER $$
CREATE PROCEDURE insert_company(
  IN ic_type_id INT,
  IN ic_name VARCHAR(80),
  IN ic_category_id INT,
  IN ic_city_id VARCHAR(10),
  IN ic_audience_id INT,
  IN ic_phone_id INT ,
  IN ic_email_id INT
)
BEGIN
  DECLARE new_company_id INT;

  INSERT INTO companies (
    type_id, name, category_id, city_id, audience_id, phone_id, email_id, isactive
  )
  VALUES (
    ic_type_id, ic_name, ic_category_id, ic_city_id, ic_audience_id, ic_phone_id, ic_email_id, TRUE
  );

  SET new_company_id = LAST_INSERT_ID();

  INSERT INTO company_products (company_id, product_id, price, unitmeasure_id)
  VALUES 
    (new_company_id, 1, 10000.00, 1),
    (new_company_id, 2, 15000.00, 1),
    (new_company_id, 3, 20000.00, 1);
END $$
DELIMITER ;

-- Llamar procedimiento
CALL insert_company(1,'Empresa Demo', 2,'57-1-BOG', 1, 3, 4);
```
   ------

   ### **3. Añadir producto favorito validando duplicados**

   > *"Como cliente, quiero un procedimiento que añada un producto favorito y verifique duplicados."*

   🧠 **Explicación:**
    Verifica si el producto ya está en favoritos (`details_favorites`). Si no lo está, lo inserta. Evita duplicaciones silenciosamente.
```sql
DELIMITER $$
CREATE PROCEDURE add_product_to_favorites(
  IN ap_favorite_id INT,
  IN ap_product_id INT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM detail_favorites 
    WHERE product_id = ap_product_id AND favorite_id = ap_favorite_id
  ) THEN
    INSERT INTO detail_favorites (favorite_id, product_id) 
    VALUES (ap_favorite_id, ap_product_id);
  END IF;
END $$
DELIMITER ;
-- Llamar procedimiento
CALL add_product_to_favorites(4, 5); 
```
   ------

   ### **4. Generar resumen mensual de calificaciones por empresa**

   > *"Como gestor, deseo un procedimiento que genere un resumen mensual de calificaciones por empresa."*

   🧠 **Explicación:**
    Hace una consulta agregada con `AVG(rating)`  por empresa, y guarda los resultados en una tabla de resumen tipo `resumen_calificaciones`.
```sql
DELIMITER $$
CREATE PROCEDURE resumen_mensual()
BEGIN
  SELECT 
  qp.company_id,
  c.name AS company_name,
  DATE_FORMAT(qp.daterating, '%Y-%m-01') AS mes_resumen,
  AVG(qp.rating) AS promedio_rating,
  COUNT(*) AS total_calificaciones
  FROM quality_products AS qp
  INNER JOIN companies AS c ON qp.company_id = c.id
  GROUP BY qp.company_id, mes_resumen
  ORDER BY mes_resumen DESC, company_id;
END $$
DELIMITER ;

-- Llamar procedimiento
CALL resumen_mensual();
```
   ------

   ### **5. Calcular beneficios activos por membresía**

   > *"Como supervisor, quiero un procedimiento que calcule beneficios activos por membresía."*

   🧠 **Explicación:**
    Consulta `membershipbenefits` junto con `membershipperiods`, y devuelve una lista de beneficios vigentes según la fecha actual.
```sql
DELIMITER $$
CREATE PROCEDURE beneficios_activos()
BEGIN
  SELECT mb.benefit_id
  FROM membership_benefits AS mb
  INNER JOIN membership_periods AS mp ON mb.membership_id = mp.membership_id
  INNER JOIN periods AS p ON mp.period_id = p.id
  WHERE CURRENT_DATE BETWEEN p.start_date AND p.end_date;
END $$
DELIMITER ;

-- Llamar procedimiento
CALL beneficios_activos();
```
   ------

   ### **6. Eliminar productos huérfanos**

   > *"Como técnico, deseo un procedimiento que elimine productos sin calificación ni empresa asociada."*

   🧠 **Explicación:**
    Elimina productos de la tabla `products` que no tienen relación ni en `rates` ni en `companyproducts`.
```sql
DELIMITER $$
CREATE PROCEDURE eliminar_producto_huerfano()
BEGIN
  DELETE FROM products AS p
  WHERE NOT EXISTS (
    SELECT 1
    FROM quality_products AS qp
    WHERE qp.product_id = p.id
  )
  AND NOT EXISTS (
    SELECT 1
    FROM company_products AS cp
    WHERE cp.product_id = p.id
  );
END $$
DELIMITER ;

-- Llamar procedimiento
CALL eliminar_producto_huerfano();
```
   ------

   ### **7. Actualizar precios de productos por categoría**

   > *"Como operador, quiero un procedimiento que actualice precios de productos por categoría."*

   🧠 **Explicación:**
    Recibe un `categoria_id` y un `factor` (por ejemplo 1.05), y multiplica todos los precios por ese factor en la tabla `companyproducts`.
```sql
DELIMITER $$
CREATE PROCEDURE categoria_actualizar_precio(
  IN cap_categoria_id INT,
  IN factor DECIMAL(4,3)
)
BEGIN
  UPDATE company_products AS cp
  INNER JOIN products AS p ON cp.product_id = p.id
  SET cp.price = cp.price * factor
  WHERE p.category_id = cap_categoria_id;
END $$
DELIMITER ;

-- Llamar procedimiento
CALL categoria_actualizar_precio(1, 1.10);
```
   ------

   ### **8. Validar inconsistencia entre `rates` y `quality_products`**

   > *"Como auditor, deseo un procedimiento que liste inconsistencias entre `rates` y `quality_products`."*

   🧠 **Explicación:**
    Busca calificaciones (`rates`) que no tengan entrada correspondiente en `quality_products`. Inserta el error en una tabla `errores_log`.
```sql
DELIMITER $$
CREATE PROCEDURE listar_inconsistencias_rates()
BEGIN
  SELECT r.*
  FROM rates AS r
  LEFT JOIN quality_products AS qp 
    ON r.customer_id = qp.customer_id 
    AND r.company_id = qp.company_id 
    AND r.poll_id = qp.poll_id
  WHERE qp.customer_id IS NULL;
END $$
DELIMITER ;

CALL listar_inconsistencias_rates();
```
   ------

   ### **9. Asignar beneficios a nuevas audiencias**

   > *"Como desarrollador, quiero un procedimiento que asigne beneficios a nuevas audiencias."*

   🧠 **Explicación:**
    Recibe un `benefit_id` y `audience_id`, verifica si ya existe el registro, y si no, lo inserta en `audiencebenefits`.
```sql
DELIMITER $$
CREATE PROCEDURE asignar_beneficio_audiencia(
  IN ab_benefit_id INT,
  IN ab_audience_id INT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1 
    FROM audience_benefits 
    WHERE benefit_id = ab_benefit_id 
      AND audience_id = ab_audience_id
  ) THEN
    INSERT INTO audience_benefits (benefit_id, audience_id)
    VALUES (ab_benefit_id, ab_audience_id);
  END IF;
END $$
DELIMITER ;

CALL asignar_beneficio_audiencia(1, 3);
```
   ------

   ### **10. Activar planes de membresía vencidos con pago confirmado**

   > *"Como administrador, deseo un procedimiento que active planes de membresía vencidos si el pago fue confirmado."*

   🧠 **Explicación:**
    Actualiza el campo `status` a `'ACTIVA'` en `membershipperiods` donde la fecha haya vencido pero el campo `pago_confirmado` sea `TRUE`.
```sql
DELIMITER $$
CREATE PROCEDURE activar_planes_vencidos()
BEGIN
  UPDATE membership_periods AS mp
  INNER JOIN periods AS p ON mp.period_id = p.id
  SET mp.status = 'ACTIVA'
  WHERE p.end_date < CURDATE()
    AND mp.pago_confirmado = TRUE
    AND mp.status != 'ACTIVA';
END $$
DELIMITER ;

CALL activar_planes_vencidos();
```
   ------

   ### **11. Listar productos favoritos del cliente con su calificación**

   > *"Como cliente, deseo un procedimiento que me devuelva todos mis productos favoritos con su promedio de rating."*

   🧠 **Explicación:**
    Consulta todos los productos favoritos del cliente y muestra el promedio de calificación de cada uno, uniendo `favorites`, `rates` y `products`.
```sql
DELIMITER $$
CREATE PROCEDURE listar_favoritos(
  IN lf_id INT
)
BEGIN
  SELECT p.id,
  p.name,
  AVG(qp.rating) AS promedio_rating
  FROM detail_favorites AS df
  INNER JOIN favorites AS f ON df.favorite_id = f.id
  INNER JOIN products AS p ON df.product_id = p.id
  LEFT JOIN quality_products AS qp ON qp.product_id = p.id
  WHERE f.customer_id = lf_id
  GROUP BY p.id, p.name
  ;
END $$
DELIMITER ;

CALL listar_favoritos(1);
```
   ------

   ### **12. Registrar encuesta y sus preguntas asociadas**

   > *"Como gestor, quiero un procedimiento que registre una encuesta y sus preguntas asociadas."*

   🧠 **Explicación:**
    Inserta la encuesta principal en `polls` y luego cada una de sus preguntas en otra tabla relacionada como `poll_questions`.
```sql
DELIMITER $$
CREATE PROCEDURE registrar_encuesta(
  IN p_name VARCHAR(80),
  IN p_description TEXT,
  IN p_isactive BOOLEAN,
  IN p_categorypoll_id INT
)
BEGIN
  INSERT INTO polls (name, description, isactive, categorypoll_id)
  VALUES (p_name, p_description, p_isactive, p_categorypoll_id);
END $$
DELIMITER ;

CALL registrar_encuesta('Encuesta de Satisfacción','Mide la satisfacción de los clientes con los servicios ofrecidos',TRUE,1);
```
   ------

   ### **13. Eliminar favoritos antiguos sin calificaciones**

   > *"Como técnico, deseo un procedimiento que borre favoritos antiguos no calificados en más de un año."*

   🧠 **Explicación:**
    Filtra productos favoritos que no tienen calificaciones recientes y fueron añadidos hace más de 12 meses, y los elimina de `details_favorites`.
```sql
DELIMITER $$
CREATE PROCEDURE eliminar_favoritos_antiguos()
BEGIN
  DELETE df.*
  FROM detail_favorites AS df
  INNER JOIN favorites AS f ON df.favorite_id = f.id
  LEFT JOIN quality_products AS qp ON qp.product_id = df.product_id AND qp.customer_id = f.customer_id
  WHERE qp.daterating IS NULL OR qp.daterating < DATE_SUB(NOW(), INTERVAL 12 MONTH);
END $$
DELIMITER ;

CALL eliminar_favoritos_antiguos();
```
   ------

   ### **14. Asociar beneficios automáticamente por audiencia**

   > *"Como operador, quiero un procedimiento que asocie automáticamente beneficios por audiencia."*

   🧠 **Explicación:**
    Inserta en `audiencebenefits` todos los beneficios que apliquen según una lógica predeterminada (por ejemplo, por tipo de usuario).
```sql
DELIMITER $$
CREATE PROCEDURE asociar_beneficios_por_audiencia()
BEGIN
-- insert ignore para evitar duplicados
  INSERT IGNORE INTO audience_benefits (audience_id, benefit_id)

  SELECT a.id, 
  b.id
  FROM audiences AS a
  INNER JOIN benefits AS b ON b.description LIKE CONCAT('%', a.description, '%');
END $$
DELIMITER ;

CALL asociar_beneficios_por_audiencia();
```
   ------

   ### **15. Historial de cambios de precio**

   > *"Como administrador, deseo un procedimiento para generar un historial de cambios de precio."*

   🧠 **Explicación:**
    Cada vez que se cambia un precio, el procedimiento compara el anterior con el nuevo y guarda un registro en una tabla `historial_precios`.
```sql
-- primero crear una tabla temporal de historial_precios 
CREATE TEMPORARY TABLE company_products_backup AS
SELECT * FROM company_products;

DELIMITER $$
CREATE PROCEDURE simular_historial_precios()
BEGIN
  SELECT cp.product_id,
    cp.company_id,
    cpb.price AS precio_anterior,
    cp.price AS precio_actual,
    (cp.price - cpb.price) AS diferencia,
    ((cp.price - cpb.price) / cpb.price) * 100 AS porcentaje_cambio
  FROM company_products_backup AS cpb
  INNER JOIN company_products AS cp ON cp.product_id = cpb.product_id AND cp.company_id = cpb.company_id
  WHERE cp.price <> cpb.price;
END $$
DELIMITER ;

CALL simular_historial_precios();
```
   ------

   ### **16. Registrar encuesta activa automáticamente**

   > *"Como desarrollador, quiero un procedimiento que registre automáticamente una nueva encuesta activa."*

   🧠 **Explicación:**
    Inserta una encuesta en `polls` con el campo `isactive = 'TRUE'` y una fecha de inicio en `NOW()`.
```sql
DELIMITER $$
CREATE PROCEDURE registrar_encuesta_activa(
  IN p_name VARCHAR(80),
  IN p_description TEXT,
  IN p_categorypoll_id INT
)
BEGIN
  INSERT INTO polls (name, description, isactive, categorypoll_id)
  VALUES (
    p_name,
    p_description,
    TRUE,
    p_categorypoll_id
  );
END $$
DELIMITER ;

CALL registrar_encuesta_activa('Encuesta de satisfacción julio','Recoge opiniones de clientes sobre el servicio en julio.',1);
```
   ------

   ### **17. Actualizar unidad de medida de productos sin afectar ventas**

   > *"Como técnico, deseo un procedimiento que actualice la unidad de medida de productos sin afectar si hay ventas."*

   🧠 **Explicación:**
    Verifica si el producto no ha sido vendido, y si es así, permite actualizar su `unitmeasure_id`.
```sql
DELIMITER $$
CREATE PROCEDURE actualizar_unidad_medida(
  IN p_company_id INT,
  IN p_product_id INT,
  IN p_new_unitmeasure_id INT
)
BEGIN
  DECLARE vendido INT;

  SELECT COUNT(*) INTO vendido
  FROM quality_products
  WHERE product_id = p_product_id;

  IF vendido = 0 THEN
    UPDATE company_products
    SET unitmeasure_id = p_new_unitmeasure_id
    WHERE company_id = p_company_id AND product_id = p_product_id;
    SELECT 'unidad de medida actualizada correctamente.' AS mensaje;
  ELSE
    SELECT 'no se puede actualizar la unidad de medida porque el producto ya fue vendido.' AS mensaje;
  END IF;
END $$
DELIMITER ;

CALL actualizar_unidad_medida(1, 42, 5);
```
   ------

   ### **18. Recalcular promedios de calidad semanalmente**

   > *"Como supervisor, quiero un procedimiento que recalcule todos los promedios de calidad cada semana."*

   🧠 **Explicación:**
    Hace un `AVG(rating)` agrupado por producto y lo actualiza en `products`.
```sql
DELIMITER $$
CREATE PROCEDURE recalcular_promedio_calidad()
BEGIN
  SELECT 
    p.id AS producto_id,
    p.name AS nombre_producto,
    AVG(qp.rating) AS promedio_calidad
  FROM products AS p
  JOIN quality_products AS qp ON p.id = qp.product_id
  GROUP BY p.id, p.name;
END $$
DELIMITER ;

CALL recalcular_promedio_calidad();
```
   ------

   ### **19. Validar claves foráneas entre calificaciones y encuestas**

   > *"Como auditor, deseo un procedimiento que valide claves foráneas cruzadas entre calificaciones y encuestas."*

   🧠 **Explicación:**
    Busca registros en `rates` con `poll_id` que no existen en `polls`, y los reporta.
```sql
DELIMITER $$
CREATE PROCEDURE validate_poll_rates()
BEGIN
  SELECT 
    r.customer_id,
    r.company_id,
    r.poll_id,
    r.daterating,
    r.rating
  FROM rates AS r
  LEFT JOIN polls AS p ON r.poll_id = p.id
  WHERE p.id IS NULL;
END $$
DELIMITER ;

CALL validate_poll_rates();
```
   ------

   ### **20. Generar el top 10 de productos más calificados por ciudad**

   > *"Como gerente, quiero un procedimiento que genere el top 10 de productos más calificados por ciudad."*

   🧠 **Explicación:**
    Agrupa las calificaciones por ciudad (a través de la empresa que lo vende) y selecciona los 10 productos con más evaluaciones.
```sql
DELIMITER $$
CREATE PROCEDURE top_productos_por_ciudad()
BEGIN
  SELECT
    c.city_id,
    ci.name AS city_name,
    p.id,
    p.name AS product_name,
    COUNT(*) AS total_ratings,
    AVG(r.rating) AS avg_rating
  FROM rates AS r
  INNER JOIN company_products AS cp ON r.company_id = cp.company_id
  INNER JOIN companies AS c ON r.company_id = c.id
  INNER JOIN cities_or_municipalities AS ci ON c.city_id = ci.id
  INNER JOIN products AS p ON qp.product_id = p.id
  GROUP BY c.city_id, ci.name, qp.product_id, p.name
  ORDER BY c.city_id, total_ratings DESC
  LIMIT 10;
END $$
DELIMITER ;

CALL top_productos_por_ciudad();
```
------

## 🔹 **5. Triggers**

### 🔎 **1. Actualizar la fecha de modificación de un producto**

   > "Como desarrollador, deseo un trigger que actualice la fecha de modificación cuando se actualice un producto."

   🧠 **Explicación:**
    Cada vez que se actualiza un producto, queremos que el campo `updated_at` se actualice automáticamente con la fecha actual (`NOW()`), sin tener que hacerlo manualmente desde la app.

   🔁 Se usa un `BEFORE UPDATE`.
```sql

```
   ------

   ### 🔎 **2. Registrar log cuando un cliente califica un producto**

   > "Como administrador, quiero un trigger que registre en log cuando un cliente califica un producto."

   🧠 **Explicación:**
    Cuando alguien inserta una fila en `rates`, el trigger crea automáticamente un registro en `log_acciones` con la información del cliente y producto calificado.

   🔁 Se usa un `AFTER INSERT` sobre `rates`.
```sql

```
   ------

   ### 🔎 **3. Impedir insertar productos sin unidad de medida**

   > "Como técnico, deseo un trigger que impida insertar productos sin unidad de medida."

   🧠 **Explicación:**
    Antes de guardar un nuevo producto, el trigger revisa si `unit_id` es `NULL`. Si lo es, lanza un error con `SIGNAL`.

   🔁 Se usa un `BEFORE INSERT`.
```sql

```
   ------

   ### 🔎 **4. Validar calificaciones no mayores a 5**

   > "Como auditor, quiero un trigger que verifique que las calificaciones no superen el valor máximo permitido."

   🧠 **Explicación:**
    Si alguien intenta insertar una calificación de 6 o más, se bloquea automáticamente. Esto evita errores o trampa.

   🔁 Se usa un `BEFORE INSERT`.
```sql

```
   ------

   ### 🔎 **5. Actualizar estado de membresía cuando vence**

   > "Como supervisor, deseo un trigger que actualice automáticamente el estado de membresía al vencer el periodo."

   🧠 **Explicación:**
    Cuando se actualiza un periodo de membresía (`membershipperiods`), si `end_date` ya pasó, se puede cambiar el campo `status` a 'INACTIVA'.

   🔁 `AFTER UPDATE` o `BEFORE UPDATE` dependiendo de la lógica.
```sql

```
   ------

   ### 🔎 **6. Evitar duplicados de productos por empresa**

   > "Como operador, quiero un trigger que evite duplicar productos por nombre dentro de una misma empresa."

   🧠 **Explicación:**
    Antes de insertar un nuevo producto en `companyproducts`, el trigger puede consultar si ya existe uno con el mismo `product_id` y `company_id`.

   🔁 `BEFORE INSERT`.
```sql

```
   ------

   ### 🔎 **7. Enviar notificación al añadir un favorito**

   > "Como cliente, deseo un trigger que envíe notificación cuando añado un producto como favorito."

   🧠 **Explicación:**
    Después de un `INSERT` en `details_favorites`, el trigger agrega un mensaje a una tabla `notificaciones`.

   🔁 `AFTER INSERT`.
```sql

```
   ------

   ### 🔎 **8. Insertar fila en `quality_products` tras calificación**

   > "Como técnico, quiero un trigger que inserte una fila en `quality_products` cuando se registra una calificación."

   🧠 **Explicación:**
    Al insertar una nueva calificación en `rates`, se crea automáticamente un registro en `quality_products` para mantener métricas de calidad.

   🔁 `AFTER INSERT`.
```sql

```
   ------

   ### 🔎 **9. Eliminar favoritos si se elimina el producto**

   > "Como desarrollador, deseo un trigger que elimine los favoritos si se elimina el producto."

   🧠 **Explicación:**
    Cuando se borra un producto, el trigger elimina las filas en `details_favorites` donde estaba ese producto.

   🔁 `AFTER DELETE` en `products`.
```sql

```
   ------

   ### 🔎 **10. Bloquear modificación de audiencias activas**

   > "Como administrador, quiero un trigger que bloquee la modificación de audiencias activas."

   🧠 **Explicación:**
    Si un usuario intenta modificar una audiencia que está en uso, el trigger lanza un error con `SIGNAL`.

   🔁 `BEFORE UPDATE`.
```sql

```
   ------

   ### 🔎 **11. Recalcular promedio de calidad del producto tras nueva evaluación**

   > "Como gestor, deseo un trigger que actualice el promedio de calidad del producto tras una nueva evaluación."

   🧠 **Explicación:**
    Después de insertar en `rates`, el trigger actualiza el campo `average_rating` del producto usando `AVG()`.

   🔁 `AFTER INSERT`.
```sql

```
   ------

   ### 🔎 **12. Registrar asignación de nuevo beneficio**

   > "Como auditor, quiero un trigger que registre cada vez que se asigna un nuevo beneficio."

   🧠 **Explicación:**
    Cuando se hace `INSERT` en `membershipbenefits` o `audiencebenefits`, se agrega un log en `bitacora`.
```sql

```
   ------

   ### 🔎 **13. Impedir doble calificación por parte del cliente**

   > "Como cliente, deseo un trigger que me impida calificar el mismo producto dos veces seguidas."

   🧠 **Explicación:**
    Antes de insertar en `rates`, el trigger verifica si ya existe una calificación de ese `customer_id` y `product_id`.
```sql

```
   ------

   ### 🔎 **14. Validar correos duplicados en clientes**

   > "Como técnico, quiero un trigger que valide que el email del cliente no se repita."

   🧠 **Explicación:**
    Verifica, antes del `INSERT`, si el correo ya existe en la tabla `customers`. Si sí, lanza un error.
```sql

```
   ------

   ### 🔎 **15. Eliminar detalles de favoritos huérfanos**

   > "Como operador, deseo un trigger que elimine registros huérfanos de `details_favorites`."

   🧠 **Explicación:**
    Si se elimina un registro de `favorites`, se borran automáticamente sus detalles asociados.
```sql

```
   ------

   ### 🔎 **16. Actualizar campo `updated_at` en `companies`**

   > "Como administrador, quiero un trigger que actualice el campo `updated_at` en `companies`."

   🧠 **Explicación:**
    Como en productos, actualiza automáticamente la fecha de última modificación cada vez que se cambia algún dato.
```sql

```
   ------

   ### 🔎 **17. Impedir borrar ciudad si hay empresas activas**

   > "Como desarrollador, deseo un trigger que impida borrar una ciudad si hay empresas activas en ella."

   🧠 **Explicación:**
    Antes de hacer `DELETE` en `citiesormunicipalities`, el trigger revisa si hay empresas registradas en esa ciudad.
```sql

```
   ------

   ### 🔎 **18. Registrar cambios de estado en encuestas**

   > "Como auditor, quiero un trigger que registre cambios de estado de encuestas."

   🧠 **Explicación:**
    Cada vez que se actualiza el campo `status` en `polls`, el trigger guarda la fecha, nuevo estado y usuario en un log.
```sql

```
   ------

   ### 🔎 **19. Sincronizar `rates` y `quality_products`**

   > "Como supervisor, deseo un trigger que sincronice `rates` con `quality_products` al calificar."

   🧠 **Explicación:**
    Inserta o actualiza la calidad del producto en `quality_products` cada vez que se inserta una nueva calificación.
```sql

```
   ------

   ### 🔎 **20. Eliminar productos sin relación a empresas**

   > "Como operador, quiero un trigger que elimine automáticamente productos sin relación a empresas."

   🧠 **Explicación:**
    Después de borrar la última relación entre un producto y una empresa (`companyproducts`), el trigger puede eliminar ese producto.
```sql

```
------

## 🔹 **6. Events (Eventos Programados..Usar procedimientos o funciones para cada evento)**

### 🔹 **1. Borrar productos sin actividad cada 6 meses**

   > **Historia:** Como administrador, quiero un evento que borre productos sin actividad cada 6 meses.

   🧠 **Explicación:**
    Algunos productos pueden haber sido creados pero nunca calificados, marcados como favoritos ni asociados a una empresa. Este evento eliminaría esos productos cada 6 meses.

   🛠️ **Se usaría un `DELETE`** sobre `products` donde no existan registros en `rates`, `favorites` ni `companyproducts`.

   📅 **Frecuencia del evento:** `EVERY 6 MONTH`
```sql

```
   ------

   ### 🔹 **2. Recalcular el promedio de calificaciones semanalmente**

   > **Historia:** Como supervisor, deseo un evento semanal que recalcula el promedio de calificaciones.

   🧠 **Explicación:**
    Se puede tener una tabla `product_metrics` que almacena promedios pre-calculados para rapidez. El evento actualizaría esa tabla con nuevos promedios.

   🛠️ **Usa `UPDATE` con `AVG(rating)` agrupado por producto.**

   📅 Frecuencia: `EVERY 1 WEEK`
```sql

```
   ------

   ### 🔹 **3. Actualizar precios según inflación mensual**

   > **Historia:** Como operador, quiero un evento mensual que actualice los precios de productos por inflación.

   🧠 **Explicación:**
    Aplicar un porcentaje de aumento (por ejemplo, 3%) a los precios de todos los productos.

   🛠️ `UPDATE companyproducts SET price = price * 1.03;`

   📅 Frecuencia: `EVERY 1 MONTH`
```sql

```
   ------

   ### 🔹 **4. Crear backups lógicos diariamente**

   > **Historia:** Como auditor, deseo un evento que genere un backup lógico cada medianoche.

   🧠 **Explicación:**
    Este evento no ejecuta comandos del sistema, pero puede volcar datos clave a una tabla temporal o de respaldo (`products_backup`, `rates_backup`, etc.).

   📅 `EVERY 1 DAY STARTS '00:00:00'`
```sql

```
   ------

   ### 🔹 **5. Notificar sobre productos favoritos sin calificar**

   > **Historia:** Como cliente, quiero un evento que me recuerde los productos que tengo en favoritos y no he calificado.

   🧠 **Explicación:**
    Genera una lista (`user_reminders`) de `product_id` donde el cliente tiene el producto en favoritos pero no hay `rate`.

   🛠️ Requiere `INSERT INTO recordatorios` usando un `LEFT JOIN` y `WHERE rate IS NULL`.
```sql

```
   ------

   ### 🔹 **6. Revisar inconsistencias entre empresa y productos**

   > **Historia:** Como técnico, deseo un evento que revise inconsistencias entre empresas y productos cada domingo.

   🧠 **Explicación:**
    Detecta productos sin empresa, o empresas sin productos, y los registra en una tabla de anomalías.

   🛠️ Puede usar `NOT EXISTS` y `JOIN` para llenar una tabla `errores_log`.

   📅 `EVERY 1 WEEK ON SUNDAY`
```sql

```
   ------

   ### 🔹 **7. Archivar membresías vencidas diariamente**

   > **Historia:** Como administrador, quiero un evento que archive membresías vencidas.

   🧠 **Explicación:**
    Cambia el estado de la membresía cuando su `end_date` ya pasó.

   🛠️ `UPDATE membershipperiods SET status = 'INACTIVA' WHERE end_date < CURDATE();`
```sql

```
   ------

   ### 🔹 **8. Notificar beneficios nuevos a usuarios semanalmente**

   > **Historia:** Como supervisor, deseo un evento que notifique por correo sobre beneficios nuevos.

   🧠 **Explicación:**
    Detecta registros nuevos en la tabla `benefits` desde la última semana y los inserta en `notificaciones`.

   🛠️ `INSERT INTO notificaciones SELECT ... WHERE created_at >= NOW() - INTERVAL 7 DAY`
```sql

```
   ------

   ### 🔹 **9. Calcular cantidad de favoritos por cliente mensualmente**

   > **Historia:** Como operador, quiero un evento que calcule el total de favoritos por cliente y lo guarde.

   🧠 **Explicación:**
    Cuenta los productos favoritos por cliente y guarda el resultado en una tabla de resumen mensual (`favoritos_resumen`).

   🛠️ `INSERT INTO favoritos_resumen SELECT customer_id, COUNT(*) ... GROUP BY customer_id`
```sql

```
   ------

   ### 🔹 **10. Validar claves foráneas semanalmente**

   > **Historia:** Como auditor, deseo un evento que valide claves foráneas semanalmente y reporte errores.

   🧠 **Explicación:**
    Comprueba que cada `product_id`, `customer_id`, etc., tengan correspondencia en sus tablas. Si no, se registra en una tabla `inconsistencias_fk`.
```sql

```
   ------

   ### 🔹 **11. Eliminar calificaciones inválidas antiguas**

   > **Historia:** Como técnico, quiero un evento que elimine calificaciones con errores antiguos.

   🧠 **Explicación:**
    Borra `rates` donde el valor de `rating` es NULL o <0 y que hayan sido creadas hace más de 3 meses.

   🛠️ `DELETE FROM rates WHERE rating IS NULL AND created_at < NOW() - INTERVAL 3 MONTH`
```sql

```
   ------

   ### 🔹 **12. Cambiar estado de encuestas inactivas automáticamente**

   > **Historia:** Como desarrollador, deseo un evento que actualice encuestas que no se han usado en mucho tiempo.

   🧠 **Explicación:**
    Cambia el campo `status = 'inactiva'` si una encuesta no tiene nuevas respuestas en más de 6 meses.
```sql

```
   ------

   ### 🔹 **13. Registrar auditorías de forma periódica**

   > **Historia:** Como administrador, quiero un evento que inserte datos de auditoría periódicamente.

   🧠 **Explicación:**
    Cada día, se puede registrar el conteo de productos, usuarios, etc. en una tabla tipo `auditorias_diarias`.
```sql

```
   ------

   ### 🔹 **14. Notificar métricas de calidad a empresas**

   > **Historia:** Como gestor, deseo un evento que notifique a las empresas sus métricas de calidad cada lunes.

   🧠 **Explicación:**
    Genera una tabla o archivo con `AVG(rating)` por producto y empresa y se registra en `notificaciones_empresa`.
```sql

```
   ------

   ### 🔹 **15. Recordar renovación de membresías**

   > **Historia:** Como cliente, quiero un evento que me recuerde renovar la membresía próxima a vencer.

   🧠 **Explicación:**
    Busca `membershipperiods` donde `end_date` esté entre hoy y 7 días adelante, e inserta recordatorios.
```sql

```
   ------

   ### 🔹 **16. Reordenar estadísticas generales cada semana**

   > **Historia:** Como operador, deseo un evento que reordene estadísticas generales.

   🧠 **Explicación:**
    Calcula y actualiza métricas como total de productos activos, clientes registrados, etc., en una tabla `estadisticas`.
```sql

```
   ------

   ### 🔹 **17. Crear resúmenes temporales de uso por categoría**

   > **Historia:** Como técnico, quiero un evento que cree resúmenes temporales por categoría.

   🧠 **Explicación:**
    Cuenta cuántos productos se han calificado en cada categoría y guarda los resultados para dashboards.
```sql

```
   ------

   ### 🔹 **18. Actualizar beneficios caducados**

   > **Historia:** Como gerente, deseo un evento que desactive beneficios que ya expiraron.

   🧠 **Explicación:**
    Revisa si un beneficio tiene una fecha de expiración (campo `expires_at`) y lo marca como inactivo.
```sql

```
   ------

   ### 🔹 **19. Alertar productos sin evaluación anual**

   > **Historia:** Como auditor, quiero un evento que genere alertas sobre productos sin evaluación anual.

   🧠 **Explicación:**
    Busca productos sin `rate` en los últimos 365 días y genera alertas o registros en `alertas_productos`.
```sql

```
   ------

   ### 🔹 **20. Actualizar precios con índice externo**

   > **Historia:** Como administrador, deseo un evento que actualice precios según un índice referenciado.

   🧠 **Explicación:**
    Se podría tener una tabla `inflacion_indice` y aplicar ese valor multiplicador a los precios de productos activos.
```sql

```
   ------

## 🔹 **7. Historias de Usuario con JOINs**

### 🔹 **1. Ver productos con la empresa que los vende**

   > **Historia:** Como analista, quiero consultar todas las empresas junto con los productos que ofrecen, mostrando el nombre del producto y el precio.

   🧠 **Explicación para dummies:**
    Imagina que tienes dos tablas: una con empresas (`companies`) y otra con productos (`products`). Hay una tabla intermedia llamada `companyproducts` que dice qué empresa vende qué producto y a qué precio.
    Con un `JOIN`, unes estas tablas para ver “Empresa A vende Producto X a $10”.

   🔍 Se usa un `INNER JOIN`.
```sql

```
   ------

   ### 🔹 **2. Mostrar productos favoritos con su empresa y categoría**

   > **Historia:** Como cliente, deseo ver mis productos favoritos junto con la categoría y el nombre de la empresa que los ofrece.

   🧠 **Explicación:**
    Tú como cliente guardaste algunos productos en favoritos. Quieres ver no solo el nombre, sino también quién lo vende y a qué categoría pertenece.

   🔍 Aquí se usan varios `JOIN` para traer todo en una sola consulta bonita y completa.
```sql

```
   ------

   ### 🔹 **3. Ver empresas aunque no tengan productos**

   > **Historia:** Como supervisor, quiero ver todas las empresas aunque no tengan productos asociados.

   🧠 **Explicación:**
    No todas las empresas suben productos de inmediato. Queremos verlas igualmente.
    Un `LEFT JOIN` te permite mostrar la empresa, aunque no tenga productos en la otra tabla.

   🔍 Se une `companies LEFT JOIN`.
```sql

```
   ------

   ### 🔹 **4. Ver productos que fueron calificados (o no)**

   > **Historia:** Como técnico, deseo obtener todas las calificaciones de productos incluyendo aquellos productos que aún no han sido calificados.

   🧠 **Explicación:**
    Queremos ver todos los productos. Si hay calificación, que la muestre; si no, que aparezca como NULL.
    Esto se hace con un `RIGHT JOIN` desde `rates` hacia `products`.

   🔍 Así sabrás qué productos no tienen aún calificaciones.
```sql

```
   ------

   ### 🔹 **5. Ver productos con promedio de calificación y empresa**

   > **Historia:** Como gestor, quiero ver productos con su promedio de calificación y nombre de la empresa.

   🧠 **Explicación:**
    El producto vive en la tabla `products`, el precio y empresa están en `companyproducts`, y las calificaciones en `rates`.
    Un `JOIN` permite unir todo y usar `AVG(rates.valor)` para calcular el promedio.

   🔍 Combinas `products JOIN companyproducts JOIN companies JOIN rates`.
```sql

```
   ------

   ### 🔹 **6. Ver clientes y sus calificaciones (si las tienen)**

   > **Historia:** Como operador, deseo obtener todos los clientes y sus calificaciones si existen.

   🧠 **Explicación:**
    A algunos clientes no les gusta calificar, pero igual deben aparecer.
    Se hace un `LEFT JOIN` desde `customers` hacia `rates`.

   🔍 Devuelve calificaciones o `NULL` si el cliente nunca calificó.
```sql

```
   ------

   ### 🔹 **7. Ver favoritos con la última calificación del cliente**

   > **Historia:** Como cliente, quiero consultar todos mis favoritos junto con la última calificación que he dado.

   🧠 **Explicación:**
    Esto requiere unir tus productos favoritos (`favorites` + `details_favorites`) con las calificaciones (`rates`), filtradas por la fecha más reciente.

   🔍 Requiere `JOIN` y subconsulta con `MAX(created_at)` o `ORDER BY` + `LIMIT 1`.
```sql

```
   ------

   ### 🔹 **8. Ver beneficios incluidos en cada plan de membresía**

   > **Historia:** Como administrador, quiero unir `membershipbenefits`, `benefits` y `memberships`.

   🧠 **Explicación:**
    Tienes planes (`memberships`), beneficios (`benefits`) y una tabla que los relaciona (`membershipbenefits`).
    Un `JOIN` muestra qué beneficios tiene cada plan.
```sql

```
   ------

   ### 🔹 **9. Ver clientes con membresía activa y sus beneficios**

   > **Historia:** Como gerente, deseo ver todos los clientes con membresía activa y sus beneficios actuales.

   🧠 **Explicación:** La intención es **mostrar una lista de clientes** que:

   1. Tienen **una membresía activa** (vigente hoy).
   2. Y a esa membresía le corresponden **uno o más beneficios**.

   🔍 Mucho `JOIN`, pero muestra todo lo que un cliente recibe por su membresía.
```sql

```
   ------

   ### 🔹 **10. Ver ciudades con cantidad de empresas**

   > **Historia:** Como operador, quiero obtener todas las ciudades junto con la cantidad de empresas registradas.

   🧠 **Explicación:**
    Unes `citiesormunicipalities` con `companies` y cuentas cuántas empresas hay por ciudad (`COUNT(*) GROUP BY ciudad`).
```sql

```
   ------

   ### 🔹 **11. Ver encuestas con calificaciones**

   > **Historia:** Como analista, deseo unir `polls` y `rates`.

   🧠 **Explicación:**
    Cada encuesta (`polls`) puede estar relacionada con una calificación (`rates`).
    El `JOIN` permite ver qué encuesta usó el cliente para calificar.
```sql

```
   ------

   ### 🔹 **12. Ver productos evaluados con datos del cliente**

   > **Historia:** Como técnico, quiero consultar todos los productos evaluados con su fecha y cliente.

   🧠 **Explicación:**
    Unes `rates`, `products` y `customers` para saber qué cliente evaluó qué producto y cuándo.
```sql

```
   ------

   ### 🔹 **13. Ver productos con audiencia de la empresa**

   > **Historia:** Como supervisor, deseo obtener todos los productos con la audiencia objetivo de la empresa.

   🧠 **Explicación:**
    Unes `products`, `companyproducts`, `companies` y `audiences` para saber si ese producto está dirigido a niños, adultos, etc.
```sql

```
   ------

   ### 🔹 **14. Ver clientes con sus productos favoritos**

   > **Historia:** Como auditor, quiero unir `customers` y `favorites`.

   🧠 **Explicación:**
    Para ver qué productos ha marcado como favorito cada cliente.
    Unes `customers` → `favorites` → `details_favorites` → `products`.
```sql

```
   ------

   ### 🔹 **15. Ver planes, periodos, precios y beneficios**

   > **Historia:** Como gestor, deseo obtener la relación de planes de membresía, periodos, precios y beneficios.

   🧠 **Explicación:**
    Unes `memberships`, `membershipperiods`, `membershipbenefits`, y `benefits`.

   🔍 Sirve para hacer un catálogo completo de lo que incluye cada plan.
```sql

```
   ------

   ### 🔹 **16. Ver combinaciones empresa-producto-cliente calificados**

   > **Historia:** Como desarrollador, quiero consultar todas las combinaciones empresa-producto-cliente que hayan sido calificadas.

   🧠 **Explicación:**
    Une `rates` con `products`, `companyproducts`, `companies`, y `customers`.

   🔍 Así sabes: quién calificó, qué producto, de qué empresa.
```sql

```
   ------

   ### 🔹 **17. Comparar favoritos con productos calificados**

   > **Historia:** Como cliente, quiero ver productos que he calificado y también tengo en favoritos.

   🧠 **Explicación:**
    Une `details_favorites` y `rates` por `product_id`, filtrando por tu `customer_id`.
```sql

```
   ------

   ### 🔹 **18. Ver productos ordenados por categoría**

   > **Historia:** Como operador, quiero unir `categories` y `products`.

   🧠 **Explicación:**
    Cada producto tiene una categoría.
    El `JOIN` permite ver el nombre de la categoría junto al nombre del producto.
```sql

```
   ------

   ### 🔹 **19. Ver beneficios por audiencia, incluso vacíos**

   > **Historia:** Como especialista, quiero listar beneficios por audiencia, incluso si no tienen asignados.

   🧠 **Explicación:**
    Un `LEFT JOIN` desde `audiences` hacia `audiencebenefits` y luego `benefits`.

   🔍 Audiencias sin beneficios mostrarán `NULL`.
```sql

```
   ------

   ### 🔹 **20. Ver datos cruzados entre calificaciones, encuestas, productos y clientes**

   > **Historia:** Como auditor, deseo una consulta que relacione `rates`, `polls`, `products` y `customers`.

   🧠 **Explicación:**
    Es una auditoría cruzada. Se une todo lo relacionado con una calificación:

   - ¿Quién calificó? (`customers`)
   - ¿Qué calificó? (`products`)
   - ¿En qué encuesta? (`polls`)
   - ¿Qué valor dio? (`rates`)
```sql

```
------

## 🔹 **8. Historias de Usuario con Funciones Definidas por el Usuario (UDF)**

1. Como analista, quiero una función que calcule el **promedio ponderado de calidad** de un producto basado en sus calificaciones y fecha de evaluación.

   > **Explicación:** Se desea una función `calcular_promedio_ponderado(product_id)` que combine el valor de `rate` y la antigüedad de cada calificación para dar más peso a calificaciones recientes.
```sql

```
2. Como auditor, deseo una función que determine si un producto ha sido **calificado recientemente** (últimos 30 días).

   > **Explicación:** Se busca una función booleana `es_calificacion_reciente(fecha)` que devuelva `TRUE` si la calificación se hizo en los últimos 30 días.
```sql

```
3. Como desarrollador, quiero una función que reciba un `product_id` y devuelva el **nombre completo de la empresa** que lo vende.

   > **Explicación:** La función `obtener_empresa_producto(product_id)` haría un `JOIN` entre `companyproducts` y `companies` y devolvería el nombre de la empresa.
```sql

```
4. Como operador, deseo una función que, dado un `customer_id`, me indique si el cliente tiene una **membresía activa**.

   > **Explicación:** `tiene_membresia_activa(customer_id)` consultaría la tabla `membershipperiods` para ese cliente y verificaría si la fecha actual está dentro del rango.
```sql

```
5. Como administrador, quiero una función que valide si una ciudad tiene **más de X empresas registradas**, recibiendo la ciudad y el número como 

   parámetros.

   > **Explicación:** `ciudad_supera_empresas(city_id, limite)` devolvería `TRUE` si el conteo de empresas en esa ciudad excede `limite`.
```sql

```
6. Como gerente, deseo una función que, dado un `rate_id`, me devuelva una **descripción textual de la calificación** (por ejemplo, “Muy bueno”, “Regular”).

   > **Explicación:** `descripcion_calificacion(valor)` devolvería “Excelente” si `valor = 5`, “Bueno” si `valor = 4`, etc.
```sql

```
7. Como técnico, quiero una función que devuelva el **estado de un producto** en función de su evaluación (ej. “Aceptable”, “Crítico”).

   > **Explicación:** `estado_producto(product_id)` clasificaría un producto como “Crítico”, “Aceptable” o “Óptimo” según su promedio de calificaciones.
```sql

```
8. Como cliente, deseo una función que indique si un producto está **entre mis favoritos**, recibiendo el `product_id` y mi `customer_id`.

   > **Explicación:** `es_favorito(customer_id, product_id)` devolvería `TRUE` si hay un registro en `details_favorites`.
```sql

```
9. Como gestor de beneficios, quiero una función que determine si un beneficio está **asignado a una audiencia específica**, retornando verdadero o falso.

   > **Explicación:** `beneficio_asignado_audiencia(benefit_id, audience_id)` buscaría en `audiencebenefits` y retornaría `TRUE` si hay coincidencia.
```sql

```
10. Como auditor, deseo una función que reciba una fecha y determine si se encuentra dentro de un **rango de membresía activa**.

    > **Explicación:** `fecha_en_membresia(fecha, customer_id)` compararía `fecha` con los rangos de `membershipperiods` activos del cliente.
```sql

```
11. Como desarrollador, quiero una función que calcule el **porcentaje de calificaciones positivas** de un producto respecto al total.

    > **Explicación:** `porcentaje_positivas(product_id)` devolvería la relación entre calificaciones mayores o iguales a 4 y el total de calificaciones.
```sql

```
12. Como supervisor, deseo una función que calcule la **edad de una calificación**, en días, desde la fecha actual.

    > Un **supervisor** quiere saber cuántos **días han pasado** desde que se registró una calificación de un producto. Este cálculo debe hacerse dinámicamente comparando la **fecha actual del sistema (`CURRENT_DATE`)** con la **fecha en que se hizo la calificación** (que suponemos está almacenada en un campo como `created_at` o `rate_date` en la tabla `rates`).
```sql

```
13. Como operador, quiero una función que, dado un `company_id`, devuelva la **cantidad de productos únicos** asociados a esa empresa.

    > **Explicación:** `productos_por_empresa(company_id)` haría un `COUNT(DISTINCT product_id)` en `companyproducts`.
```sql

```
14. Como gerente, deseo una función que retorne el **nivel de actividad** de un cliente (frecuente, esporádico, inactivo), según su número de calificaciones.
```sql

```
15. Como administrador, quiero una función que calcule el **precio promedio ponderado** de un producto, tomando en cuenta su uso en favoritos.
```sql

```
16. Como técnico, deseo una función que me indique si un `benefit_id` está asignado a más de una audiencia o membresía (valor booleano).
```sql

```
17. Como cliente, quiero una función que, dada mi ciudad, retorne un **índice de variedad** basado en número de empresas y productos.
```sql

```
18. Como gestor de calidad, deseo una función que evalúe si un producto debe ser **desactivado** por tener baja calificación histórica.
```sql

```
19. Como desarrollador, quiero una función que calcule el **índice de popularidad** de un producto (combinando favoritos y ratings).
```sql

```
20. Como auditor, deseo una función que genere un código único basado en el nombre del producto y su fecha de creación.
```sql

```