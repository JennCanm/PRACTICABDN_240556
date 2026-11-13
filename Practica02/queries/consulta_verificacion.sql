-- Seleccionar base de datos
USE db_test;

-- 1. Estructura general de la base de datos
SHOW TABLES;
SHOW TRIGGERS FROM db_test;

-- 2. Conteo global de logs
SELECT COUNT(*) AS total_registros 
FROM tb_logs;


-- 3. jenn Consultar todas las operaciones realizadas en la base de datos
SELECT * 
FROM tb_logs;

-- 4. Verificar que los usuarios remotos hayan sido creados
SELECT user, host 
FROM mysql.user 
WHERE host = '%' 
  AND account_locked = 'N';

-- 5. Verificar los roles que fueron creados
SELECT user, host 
FROM mysql.user 
WHERE host = '%' 
  AND account_locked = 'Y';

-- 6. Verificar qué usuarios tienen asignados qué roles
SELECT 
    to_user AS usuario, 
    to_host AS host, 
    from_user AS rol, 
    from_host AS rol_host 
FROM mysql.role_edges 
ORDER BY rol, usuario, from_user;

-- 7. Identificar exactamente quién creó a cada usuario en el sistema y cuándo lo hizo
SELECT 
    u.nick,
    u.email,
    b.db_user AS inserted_by,
    b.table_description,
    b.operation_date
FROM tb_users u
JOIN tb_logs b 
    ON b.table_description LIKE CONCAT('%ID=', u.id, ',%')
WHERE b.table_operation = 'Create'
  AND b.table_name = 'tb_users'
GROUP BY 
    u.nick,
    u.email,
    b.db_user,
    b.table_description,
    b.operation_date
ORDER BY b.operation_date ASC;

-- 8. Verificar el total de procedimientos almacenados en la base de datos db_test_7b
SHOW PROCEDURE STATUS 
WHERE Db = 'db_test_7b';

-- 9. Contabilizar los productos
SELECT COUNT(*) AS total_productos 
FROM tb_products;

-- 10. Visualizar todos los productos
SELECT * 
FROM tb_products;

-- 11. Consulta para saber la trazabilidad de los productos
SELECT * 
FROM vw_trazabilidad_productos 
LIMIT 10;