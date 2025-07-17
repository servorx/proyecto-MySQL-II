-- 1
DELIMITER $$
CREATE TRIGGER before_update_products
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  SET NEW.updated_at = NOW();
END $$
DELIMITER ;

-- 2
DELIMITER $$
CREATE TRIGGER after_insert_rates
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  INSERT INTO log_acciones (accion, customer_id, company_id, poll_id, fecha)
  VALUES ('Insertó una calificación', NEW.customer_id, NEW.company_id, NEW.poll_id, NOW());
END $$
DELIMITER ;

-- 3
DELIMITER $$
CREATE TRIGGER prevent_company_product
BEFORE INSERT ON company_products
FOR EACH ROW
BEGIN
  IF NEW.unitmeasure_id IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede asociar un producto a una empresa sin unidad de medida';
  END IF;
END $$
DELIMITER ;
INSERT INTO company_products (company_id, product_id, price, unitmeasure_id) VALUES (1, 1, 9.99, NULL);
INSERT INTO company_products (company_id, product_id, price, unitmeasure_id) VALUES (1, 1, 9.99, 2);

-- 4
DELIMITER $$
CREATE TRIGGER validate_rating_limit
BEFORE INSERT ON rates
FOR EACH ROW
BEGIN
  IF NEW.rating > 5 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'la calificación no puede ser mayor a 5.';
  END IF;
END $$
DELIMITER ;

-- 5
DELIMITER $$
CREATE TRIGGER update_membership_status
BEFORE UPDATE ON membership_periods
FOR EACH ROW
BEGIN
  DECLARE fecha_fin DATE;

  SELECT end_date INTO fecha_fin
  FROM periods
  WHERE id = NEW.period_id;

  IF fecha_fin < CURDATE() THEN
    SET NEW.status = 'INACTIVA';
  END IF;
END $$
DELIMITER ;

-- 6
DELIMITER $$
CREATE TRIGGER evitar_duplicate_product_name
BEFORE INSERT ON company_products
FOR EACH ROW
BEGIN
  DECLARE existing_count INT;

  SELECT COUNT(*)
  INTO existing_count
  FROM company_products AS cp
  INNER JOIN products AS p ON cp.product_id = p.id
  INNER JOIN products AS p_new ON NEW.product_id = p_new.id
  WHERE cp.company_id = NEW.company_id
    AND p.name = p_new.name;

  IF existing_count > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'ya existe un producto con ese nombre para esta empresa.';
  END IF;
END $$
DELIMITER ;

-- 7
DELIMITER $$
CREATE TRIGGER after_add_favorite_notify
AFTER INSERT ON detail_favorites
FOR EACH ROW
BEGIN
  DECLARE v_customer_id INT;

  SELECT customer_id INTO v_customer_id
  FROM favorites
  WHERE id = NEW.favorite_id;

  INSERT INTO notificaciones (client_id, message)
  VALUES (
    v_customer_id,
    CONCAT('Se añadió el producto ID ', NEW.product_id, ' a favoritos.')
  );
END $$
DELIMITER ;
INSERT INTO details_favorites (client_id, product_id)
VALUES (1, 101);

-- 8
DELIMITER $$

CREATE TRIGGER insertar_quality_product
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  DECLARE v_product_id INT;

  -- Obtener el product_id desde la tabla polls
  SELECT product_id INTO v_product_id
  FROM polls
  WHERE id = NEW.poll_id;

  -- Insertar en quality_products
  INSERT INTO quality_products (
    product_id,
    customer_id,
    poll_id,
    company_id,
    daterating,
    rating
  )
  VALUES (
    v_product_id,
    NEW.customer_id,
    NEW.poll_id,
    NEW.company_id,
    NEW.daterating,
    NEW.rating
  );
END$$

DELIMITER ;

-- 9
DELIMITER $$
CREATE TRIGGER delete_fav_delete_product
AFTER DELETE ON products
FOR EACH ROW
BEGIN
  DELETE FROM detail_favorites
  WHERE product_id = OLD.id;
END $$
DELIMITER ;

-- 10
DELIMITER $$
CREATE TRIGGER bloquear_modificacion_audiencias_activas
BEFORE UPDATE ON audiences
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM companies WHERE audience_id = OLD.id
    UNION
    SELECT 1 FROM customers WHERE audience_id = OLD.id
    UNION
    SELECT 1 FROM membership_benefits WHERE audience_id = OLD.id
    UNION
    SELECT 1 FROM audience_benefits WHERE audience_id = OLD.id
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede modificar una audiencia que ya está en uso.';
  END IF;
END $$
DELIMITER ;

-- 11
DROP TRIGGER IF EXISTS recalcular_promedio_calidad;
DELIMITER $$
CREATE TRIGGER recalcular_promedio_calidad
AFTER INSERT ON rates
FOR EACH ROW
BEGIN
  DECLARE prod_id INT;

  SELECT product_id INTO prod_id
  FROM polls
  WHERE id = NEW.poll_id;

  UPDATE products
  SET average_rating = (
    SELECT AVG(r.rating)
    FROM rates r
    INNER JOIN polls p ON r.poll_id = p.id
    WHERE p.product_id = prod_id
  )
  WHERE id = prod_id;
END $$
DELIMITER ;

