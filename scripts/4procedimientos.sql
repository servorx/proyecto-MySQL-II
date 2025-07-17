-- este comando no es necesario, lo tengo como base para poder borrar los procedimientos ya creados
SELECT 
  CONCAT('DROP PROCEDURE IF EXISTS `', ROUTINE_NAME, '`;') AS drop_command
FROM information_schema.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
  AND ROUTINE_SCHEMA = 'proyecto';


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

CALL resumen_mensual();

-- 5
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

CALL beneficios_activos();

-- 6
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


CALL eliminar_producto_huerfano();

-- 7
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

CALL categoria_actualizar_precio(1, 1.10);

-- 8
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

-- 9
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

-- 10
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

-- 11
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

-- 12
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

-- 13
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

-- 14
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

-- 15
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

-- 16
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

-- 17
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


-- 18
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

-- 19
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

-- 20
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