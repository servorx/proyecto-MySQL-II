-- Actualizar cities_or_municipalities con los códigos DANE de municipios
-- Esto se hace mapeando el nombre de la ciudad y el ID de estado/región
-- Se asume que los nombres de las ciudades en tu tabla cities_or_municipalities
-- coinciden con los nombres en dane_municipalities (aunque mayúsculas/minúsculas pueden variar,
-- se recomienda estandarizar o usar LOWER/UPPER para la comparación si es necesario).
UPDATE cities_or_municipalities AS c
INNER JOIN state_or_regions AS sr ON c.statereg_id = sr.code
INNER JOIN dane_municipalities AS dm ON UPPER(c.name) = UPPER(dm.name) AND sr.dane_department_code = dm.dane_department_code
SET
    c.dane_department_code = dm.dane_department_code,
    c.dane_municipality_code = dm.dane_municipality_code
WHERE
    c.statereg_id IS NOT NULL; -- Excluir las entradas de "Mobile Phones" que tienen statereg_id NULL

-- Consideraciones adicionales para las entradas de "Mobile Phones - Comcel", etc.
-- Estas entradas en cities_or_municipalities tienen statereg_id NULL y no representan
-- ciudades/municipios geográficos DANE. Por lo tanto, sus campos dane_department_code
-- y dane_municipality_code permanecerán NULL, lo cual es correcto.