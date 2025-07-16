-- 1
DELIMITER $$

CREATE PROCEDURE nombre(
  IN product_id,
  IN customer_id,
  IN rating
)
BEGIN
  INSERT INTO rates () VALUES (product_id, customer_id, rating);
  SELECT AVG(qp.rating)
  FROM products AS p 
  INNER JOIN quality_products AS qp ON p.id = qp.product_id;
END $$

DELIMITER ;

CALL nombre();

-- 2

-- 3

-- 4

-- 5

-- 6

-- 7

-- 8