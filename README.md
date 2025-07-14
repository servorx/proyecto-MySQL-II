# Resolución General del Proyecto

### Las soluciones específicas se encuentran en la carpeta `scripts`, donde se pueden encontrar los 20 ejercicios de cada apartado en su respectivo archivo.

#### A su vez, todos los inserts se encuentran en el archivo `dml.sql` y la creacion de las tablas en el archivo `ddl.sql`.

# Historias de Usuario

## 🔹 **1. Consultas SQL Especializadas**

1. Como analista, quiero listar todos los productos con su empresa asociada y el precio más bajo por ciudad.
```sql

```
2. Como administrador, deseo obtener el top 5 de clientes que más productos han calificado en los últimos 6 meses.
```sql

```
3. Como gerente de ventas, quiero ver la distribución de productos por categoría y unidad de medida.
```sql

```
4. Como cliente, quiero saber qué productos tienen calificaciones superiores al promedio general.
```sql

```
5. Como auditor, quiero conocer todas las empresas que no han recibido ninguna calificación.
```sql

```
6. Como operador, deseo obtener los productos que han sido añadidos como favoritos por más de 10 clientes distintos.
```sql

```
7. Como gerente regional, quiero obtener todas las empresas activas por ciudad y categoría.
```sql

```
8. Como especialista en marketing, deseo obtener los 10 productos más calificados en cada ciudad.
```sql

```
9. Como técnico, quiero identificar productos sin unidad de medida asignada.
```sql

```
10. Como gestor de beneficios, deseo ver los planes de membresía sin beneficios registrados.
```sql

```
11. Como supervisor, quiero obtener los productos de una categoría específica con su promedio de calificación.
```sql

```
12. Como asesor, deseo obtener los clientes que han comprado productos de más de una empresa.
```sql

```
13. Como director, quiero identificar las ciudades con más clientes activos.
```sql

```
14. Como analista de calidad, deseo obtener el ranking de productos por empresa basado en la media de `quality_products`.
```sql

```
15. Como administrador, quiero listar empresas que ofrecen más de cinco productos distintos.
```sql

```
16. Como cliente, deseo visualizar los productos favoritos que aún no han sido calificados.
```sql

```
17. Como desarrollador, deseo consultar los beneficios asignados a cada audiencia junto con su descripción.
```sql

```
18. Como operador logístico, quiero saber en qué ciudades hay empresas sin productos asociados.
```sql

```
19. Como técnico, deseo obtener todas las empresas con productos duplicados por nombre.
```sql

```
20. Como analista, quiero una vista resumen de clientes, productos favoritos y promedio de calificación recibido.
```sql

```

------

## 🔹 **2. Subconsultas**

1. Como gerente, quiero ver los productos cuyo precio esté por encima del promedio de su categoría.
```sql

```
2. Como administrador, deseo listar las empresas que tienen más productos que la media de empresas.
```sql

```
3. Como cliente, quiero ver mis productos favoritos que han sido calificados por otros clientes.
```sql

```
4. Como supervisor, deseo obtener los productos con el mayor número de veces añadidos como favoritos.
```sql

```
5. Como técnico, quiero listar los clientes cuyo correo no aparece en la tabla `rates` ni en `quality_products`.
```sql

```
6. Como gestor de calidad, quiero obtener los productos con una calificación inferior al mínimo de su categoría.
```sql

```
7. Como desarrollador, deseo listar las ciudades que no tienen clientes registrados.
```sql

```
8. Como administrador, quiero ver los productos que no han sido evaluados en ninguna encuesta.
```sql

```
9. Como auditor, quiero listar los beneficios que no están asignados a ninguna audiencia.
```sql

```
10. Como cliente, deseo obtener mis productos favoritos que no están disponibles actualmente en ninguna empresa.
```sql

```
11. Como director, deseo consultar los productos vendidos en empresas cuya ciudad tenga menos de tres empresas registradas.
```sql

```
12. Como analista, quiero ver los productos con calidad superior al promedio de todos los productos.
```sql

```
13. Como gestor, quiero ver empresas que sólo venden productos de una única categoría.
```sql

```
14. Como gerente comercial, quiero consultar los productos con el mayor precio entre todas las empresas.
```sql

```
15. Como cliente, quiero saber si algún producto de mis favoritos ha sido calificado por otro cliente con más de 4 estrellas.
```sql

```
16. Como operador, quiero saber qué productos no tienen imagen asignada pero sí han sido calificados.
```sql

```
17. Como auditor, quiero ver los planes de membresía sin periodo vigente.
```sql

```
18. Como especialista, quiero identificar los beneficios compartidos por más de una audiencia.
```sql

```
19. Como técnico, quiero encontrar empresas cuyos productos no tengan unidad de medida definida.
```sql

```
20. Como gestor de campañas, deseo obtener los clientes con membresía activa y sin productos favoritos.
```sql

```

------

## 🔹 **3. Funciones Agregadas**

### **1. Obtener el promedio de calificación por producto**

   > *"Como analista, quiero obtener el promedio de calificación por producto."*

   🔍 **Explicación para dummies:**
    La persona encargada de revisar el rendimiento quiere saber **qué tan bien calificado está cada producto**. Con `AVG(rating)` agrupado por `product_id`, puede verlo de forma resumida.
```sql

```

   ------

   ### **2. Contar cuántos productos ha calificado cada cliente**

   > *"Como gerente, desea contar cuántos productos ha calificado cada cliente."*

   🔍 **Explicación:**
    Aquí se quiere saber **quiénes están activos opinando**. Se usa `COUNT(*)` sobre `rates`, agrupando por `customer_id`.
```sql

```

   ------

   ### **3. Sumar el total de beneficios asignados por audiencia**

   > *"Como auditor, quiere sumar el total de beneficios asignados por audiencia."*

   🔍 **Explicación:**
    El auditor busca **cuántos beneficios tiene cada tipo de usuario**. Con `COUNT(*)` agrupado por `audience_id` en `audiencebenefits`, lo obtiene.
```sql

```
   ------

   ### **4. Calcular la media de productos por empresa**

   > *"Como administrador, desea conocer la media de productos por empresa."*

   🔍 **Explicación:**
    El administrador quiere saber si **las empresas están ofreciendo pocos o muchos productos**. Cuenta los productos por empresa y saca el promedio con `AVG(cantidad)`.
```sql

```
   ------

   ### **5. Contar el total de empresas por ciudad**

   > *"Como supervisor, quiere ver el total de empresas por ciudad."*

   🔍 **Explicación:**
    La idea es ver **en qué ciudades hay más movimiento empresarial**. Se usa `COUNT(*)` en `companies`, agrupando por `city_id`.
```sql

```
   ------

   ### **6. Calcular el promedio de precios por unidad de medida**

   > *"Como técnico, desea obtener el promedio de precios de productos por unidad de medida."*

   🔍 **Explicación:**
    Se necesita saber si **los precios son coherentes según el tipo de medida**. Con `AVG(price)` agrupado por `unit_id`, se compara cuánto cuesta el litro, kilo, unidad, etc.
```sql

```
   ------

   ### **7. Contar cuántos clientes hay por ciudad**

   > *"Como gerente, quiere ver el número de clientes registrados por cada ciudad."*

   🔍 **Explicación:**
    Con `COUNT(*)` agrupado por `city_id` en la tabla `customers`, se obtiene **la cantidad de clientes que hay en cada zona**.
```sql

```
   ------

   ### **8. Calcular planes de membresía por periodo**

   > *"Como operador, desea contar cuántos planes de membresía existen por periodo."*

   🔍 **Explicación:**
    Sirve para ver **qué tantos planes están vigentes cada mes o trimestre**. Se agrupa por periodo (`start_date`, `end_date`) y se cuenta cuántos registros hay.
```sql

```
   ------

   ### **9. Ver el promedio de calificaciones dadas por un cliente a sus favoritos**

   > *"Como cliente, quiere ver el promedio de calificaciones que ha otorgado a sus productos favoritos."*

   🔍 **Explicación:**
    El cliente quiere saber **cómo ha calificado lo que más le gusta**. Se hace un `JOIN` entre favoritos y calificaciones, y se saca `AVG(rating)`.
```sql

```
   ------

   ### **10. Consultar la fecha más reciente en que se calificó un producto**

   > *"Como auditor, desea obtener la fecha más reciente en la que se calificó un producto."*

   🔍 **Explicación:**
    Busca el `MAX(created_at)` agrupado por producto. Así sabe **cuál fue la última vez que se evaluó cada uno**.
```sql

```
   ------

   ### **11. Obtener la desviación estándar de precios por categoría**

   > *"Como desarrollador, quiere conocer la variación de precios por categoría de producto."*

   🔍 **Explicación:**
    Usando `STDDEV(price)` en `companyproducts` agrupado por `category_id`, se puede ver **si hay mucha diferencia de precios dentro de una categoría**.
```sql

```
   ------

   ### **12. Contar cuántas veces un producto fue favorito**

   > *"Como técnico, desea contar cuántas veces un producto fue marcado como favorito."*

   🔍 **Explicación:**
    Con `COUNT(*)` en `details_favorites`, agrupado por `product_id`, se obtiene **cuáles productos son los más populares entre los clientes**.
```sql

```
   ------

   ### **13. Calcular el porcentaje de productos evaluados**

   > *"Como director, quiere saber qué porcentaje de productos han sido calificados al menos una vez."*

   🔍 **Explicación:**
    Cuenta cuántos productos hay en total y cuántos han sido evaluados (`rates`). Luego calcula `(evaluados / total) * 100`.
```sql

```
   ------

   ### **14. Ver el promedio de rating por encuesta**

   > *"Como analista, desea conocer el promedio de rating por encuesta."*

   🔍 **Explicación:**
    Agrupa por `poll_id` en `rates`, y calcula el `AVG(rating)` para ver **cómo se comportó cada encuesta**.
```sql

```
   ------

   ### **15. Calcular el promedio y total de beneficios por plan**

   > *"Como gestor, quiere obtener el promedio y el total de beneficios asignados a cada plan de membresía."*

   🔍 **Explicación:**
    Agrupa por `membership_id` en `membershipbenefits`, y usa `COUNT(*)` y `AVG(beneficio)` si aplica (si hay ponderación).
```sql

```
   ------

   ### **16. Obtener media y varianza de precios por empresa**

   > *"Como gerente, desea obtener la media y la varianza del precio de productos por empresa."*

   🔍 **Explicación:**
    Se agrupa por `company_id` y se usa `AVG(price)` y `VARIANCE(price)` para saber **qué tan consistentes son los precios por empresa**.
```sql

```
   ------

   ### **17. Ver total de productos disponibles en la ciudad del cliente**

   > *"Como cliente, quiere ver cuántos productos están disponibles en su ciudad."*

   🔍 **Explicación:**
    Hace un `JOIN` entre `companies`, `companyproducts` y `citiesormunicipalities`, filtrando por la ciudad del cliente. Luego se cuenta.
```sql

```
   ------

   ### **18. Contar productos únicos por tipo de empresa**

   > *"Como administrador, desea contar los productos únicos por tipo de empresa."*

   🔍 **Explicación:**
    Agrupa por `company_type_id` y cuenta cuántos productos diferentes tiene cada tipo de empresa.
```sql

```
   ------

   ### **19. Ver total de clientes sin correo electrónico registrado**

   > *"Como operador, quiere saber cuántos clientes no han registrado su correo."*

   🔍 **Explicación:**
    Filtra `customers WHERE email IS NULL` y hace un `COUNT(*)`. Esto ayuda a mejorar la base de datos para campañas.
```sql

```
   ------

   ### **20. Empresa con más productos calificados**

   > *"Como especialista, desea obtener la empresa con el mayor número de productos calificados."*

   🔍 **Explicación:**
    Hace un `JOIN` entre `companies`, `companyproducts`, y `rates`, agrupa por empresa y usa `COUNT(DISTINCT product_id)`, ordenando en orden descendente y tomando solo el primero.
```sql

```
------

## 🔹 **4. Procedimientos Almacenados**

### **1. Registrar una nueva calificación y actualizar el promedio**

   > *"Como desarrollador, quiero un procedimiento que registre una calificación y actualice el promedio del producto."*

   🧠 **Explicación:**
    Este procedimiento recibe `product_id`, `customer_id` y `rating`, inserta la nueva fila en `rates`, y recalcula automáticamente el promedio en la tabla `products` (campo `average_rating`).
```sql

```
   ------

   ### **2. Insertar empresa y asociar productos por defecto**

   > *"Como administrador, deseo un procedimiento para insertar una empresa y asociar productos por defecto."*

   🧠 **Explicación:**
    Este procedimiento inserta una empresa en `companies`, y luego vincula automáticamente productos predeterminados en `companyproducts`.
```sql

```
   ------

   ### **3. Añadir producto favorito validando duplicados**

   > *"Como cliente, quiero un procedimiento que añada un producto favorito y verifique duplicados."*

   🧠 **Explicación:**
    Verifica si el producto ya está en favoritos (`details_favorites`). Si no lo está, lo inserta. Evita duplicaciones silenciosamente.
```sql

```
   ------

   ### **4. Generar resumen mensual de calificaciones por empresa**

   > *"Como gestor, deseo un procedimiento que genere un resumen mensual de calificaciones por empresa."*

   🧠 **Explicación:**
    Hace una consulta agregada con `AVG(rating)` por empresa, y guarda los resultados en una tabla de resumen tipo `resumen_calificaciones`.
```sql

```
   ------

   ### **5. Calcular beneficios activos por membresía**

   > *"Como supervisor, quiero un procedimiento que calcule beneficios activos por membresía."*

   🧠 **Explicación:**
    Consulta `membershipbenefits` junto con `membershipperiods`, y devuelve una lista de beneficios vigentes según la fecha actual.
```sql

```
   ------

   ### **6. Eliminar productos huérfanos**

   > *"Como técnico, deseo un procedimiento que elimine productos sin calificación ni empresa asociada."*

   🧠 **Explicación:**
    Elimina productos de la tabla `products` que no tienen relación ni en `rates` ni en `companyproducts`.
```sql

```
   ------

   ### **7. Actualizar precios de productos por categoría**

   > *"Como operador, quiero un procedimiento que actualice precios de productos por categoría."*

   🧠 **Explicación:**
    Recibe un `categoria_id` y un `factor` (por ejemplo 1.05), y multiplica todos los precios por ese factor en la tabla `companyproducts`.
```sql

```
   ------

   ### **8. Validar inconsistencia entre `rates` y `quality_products`**

   > *"Como auditor, deseo un procedimiento que liste inconsistencias entre `rates` y `quality_products`."*

   🧠 **Explicación:**
    Busca calificaciones (`rates`) que no tengan entrada correspondiente en `quality_products`. Inserta el error en una tabla `errores_log`.
```sql

```
   ------

   ### **9. Asignar beneficios a nuevas audiencias**

   > *"Como desarrollador, quiero un procedimiento que asigne beneficios a nuevas audiencias."*

   🧠 **Explicación:**
    Recibe un `benefit_id` y `audience_id`, verifica si ya existe el registro, y si no, lo inserta en `audiencebenefits`.
```sql

```
   ------

   ### **10. Activar planes de membresía vencidos con pago confirmado**

   > *"Como administrador, deseo un procedimiento que active planes de membresía vencidos si el pago fue confirmado."*

   🧠 **Explicación:**
    Actualiza el campo `status` a `'ACTIVA'` en `membershipperiods` donde la fecha haya vencido pero el campo `pago_confirmado` sea `TRUE`.
```sql

```
   ------

   ### **11. Listar productos favoritos del cliente con su calificación**

   > *"Como cliente, deseo un procedimiento que me devuelva todos mis productos favoritos con su promedio de rating."*

   🧠 **Explicación:**
    Consulta todos los productos favoritos del cliente y muestra el promedio de calificación de cada uno, uniendo `favorites`, `rates` y `products`.
```sql

```
   ------

   ### **12. Registrar encuesta y sus preguntas asociadas**

   > *"Como gestor, quiero un procedimiento que registre una encuesta y sus preguntas asociadas."*

   🧠 **Explicación:**
    Inserta la encuesta principal en `polls` y luego cada una de sus preguntas en otra tabla relacionada como `poll_questions`.
```sql

```
   ------

   ### **13. Eliminar favoritos antiguos sin calificaciones**

   > *"Como técnico, deseo un procedimiento que borre favoritos antiguos no calificados en más de un año."*

   🧠 **Explicación:**
    Filtra productos favoritos que no tienen calificaciones recientes y fueron añadidos hace más de 12 meses, y los elimina de `details_favorites`.
```sql

```
   ------

   ### **14. Asociar beneficios automáticamente por audiencia**

   > *"Como operador, quiero un procedimiento que asocie automáticamente beneficios por audiencia."*

   🧠 **Explicación:**
    Inserta en `audiencebenefits` todos los beneficios que apliquen según una lógica predeterminada (por ejemplo, por tipo de usuario).
```sql

```
   ------

   ### **15. Historial de cambios de precio**

   > *"Como administrador, deseo un procedimiento para generar un historial de cambios de precio."*

   🧠 **Explicación:**
    Cada vez que se cambia un precio, el procedimiento compara el anterior con el nuevo y guarda un registro en una tabla `historial_precios`.
```sql

```
   ------

   ### **16. Registrar encuesta activa automáticamente**

   > *"Como desarrollador, quiero un procedimiento que registre automáticamente una nueva encuesta activa."*

   🧠 **Explicación:**
    Inserta una encuesta en `polls` con el campo `status = 'activa'` y una fecha de inicio en `NOW()`.
```sql

```
   ------

   ### **17. Actualizar unidad de medida de productos sin afectar ventas**

   > *"Como técnico, deseo un procedimiento que actualice la unidad de medida de productos sin afectar si hay ventas."*

   🧠 **Explicación:**
    Verifica si el producto no ha sido vendido, y si es así, permite actualizar su `unit_id`.
```sql

```
   ------

   ### **18. Recalcular promedios de calidad semanalmente**

   > *"Como supervisor, quiero un procedimiento que recalcule todos los promedios de calidad cada semana."*

   🧠 **Explicación:**
    Hace un `AVG(rating)` agrupado por producto y lo actualiza en `products`.
```sql

```
   ------

   ### **19. Validar claves foráneas entre calificaciones y encuestas**

   > *"Como auditor, deseo un procedimiento que valide claves foráneas cruzadas entre calificaciones y encuestas."*

   🧠 **Explicación:**
    Busca registros en `rates` con `poll_id` que no existen en `polls`, y los reporta.
```sql

```
   ------

   ### **20. Generar el top 10 de productos más calificados por ciudad**

   > *"Como gerente, quiero un procedimiento que genere el top 10 de productos más calificados por ciudad."*

   🧠 **Explicación:**
    Agrupa las calificaciones por ciudad (a través de la empresa que lo vende) y selecciona los 10 productos con más evaluaciones.
```sql

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