-- este comando no es necesario, lo tengo como base para poder borrar los procedimientos ya creados

-- 1
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

-- 2
DELIMITER $$
CREATE PROCEDURE insert_company(
  IN ic_type_id INT,
  IN ic_name VARCHAR(80),
  IN ic_category_id INT,
  IN ic_city_id VARCHAR(10),
  IN ic_audience_id INT,
  IN ic_phone_id INT 
)
BEGIN
  -- cuerpo del procedimiento
  INSERT INTO tabla (col1, col2) VALUES (param1, param2);
END $$
DELIMITER ;

-- Llamar procedimiento
CALL insert_company(valor1, 'valor2');
-- 3

-- 4

-- 5

-- 6

-- 7

-- 8