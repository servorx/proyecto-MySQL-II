CREATE FUNCTION nombre_funcion(
    parametro1 tipo_dato,
    parametro2 tipo_dato,
) RETURNS tipo_dato
DETERMINISTIC || NO DETERMINISTIC
READS SQL DATA (opcional)
BEGIN
    -- funcion como tal
    RETURN valor;
END ;