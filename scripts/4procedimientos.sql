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

-- 3
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

-- 4
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

-- 5
DELIMITER $$
CREATE PROCEDURE beneficios_activos()
BEGIN
  SELECT 
  FROM membership_benefits AS mb 
  INNER JOIN  membership_periods AS mp ON 
  WHERE 
END $$
DELIMITER ;

-- Llamar procedimiento
CALL beneficios_activos(valor1, 'valor2');

-- 6

-- 7

-- 8

-- 9

-- 10

-- 11

-- 12

-- 13

-- 14

-- 15

-- 16

-- 17

-- 18

-- 19

-- 20