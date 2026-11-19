USE db_test;

-- ============================================================================
-- 1. VERIFICACIÓN DE ESTRUCTURA GENERAL (25 TABLAS, 72 TRIGGERS, 25 VISTAS)
-- ============================================================================

-- 1.1 Verificar el total de tablas en db_test
SELECT COUNT(*) AS total_tablas 
FROM information_schema.tables 
WHERE table_schema = 'db_test' AND table_type = 'BASE TABLE';

-- 1.2 Verificar los 72 triggers de auditoría (3 por cada una de las 24 tablas operativas)
SELECT COUNT(*) AS total_triggers 
FROM information_schema.triggers 
WHERE trigger_schema = 'db_test';

-- 1.3 Desglose de triggers por tabla y evento (INSERT, UPDATE, DELETE)
SELECT event_object_table AS tabla, action_timing, event_manipulation, trigger_name
FROM information_schema.triggers
WHERE trigger_schema = 'db_test'
ORDER BY event_object_table, event_manipulation;

-- 1.4 Verificar las 25 vistas (24 de auditoría + 1 vista consolidada de productos)
SELECT COUNT(*) AS total_vistas 
FROM information_schema.views 
WHERE table_schema = 'db_test';

SELECT table_name AS nombre_vista 
FROM information_schema.views 
WHERE table_schema = 'db_test'
ORDER BY table_name;


-- ============================================================================
-- 2. VERIFICACIÓN DE PROCEDIMIENTOS ALMACENADOS Y EVENTOS PROGRAMADOS
-- ============================================================================

-- 2.1 Listar todos los procedimientos almacenados (inserción masiva, limpieza, reportes)
SHOW PROCEDURE STATUS WHERE Db = 'db_test';

-- 2.2 Listar todos los eventos programados
SHOW EVENTS FROM db_test;


-- ============================================================================
-- 3. VERIFICACIÓN DE POBLACIÓN DE USUARIOS Y PERSONAS (tb_users / tb_people)
-- ============================================================================

-- 3.1 Conteo exacto de personas y cuentas de usuario registradas
SELECT 
    (SELECT COUNT(*) FROM tb_people) AS total_personas,
    (SELECT COUNT(*) FROM tb_users) AS total_usuarios;

-- 3.2 Verificar distribución de usuarios por estado/estatus (revisa el nombre exacto de tu columna de estado si cambia)
SELECT * FROM tb_users LIMIT 5;


-- ============================================================================
-- 4. REGLAS DE CATEGORIZACIÓN Y TRAZABILIDAD (tb_categories / tbd_products_categories)
-- ============================================================================

-- 4.1 Verificar el total de categorías (debe dar 100) y total de productos (~11,951)
SELECT 
    (SELECT COUNT(*) FROM tb_categories) AS total_categorias,
    (SELECT COUNT(*) FROM tb_products) AS total_productos,
    (SELECT COUNT(*) FROM tbd_products_categories) AS total_relaciones_producto_categoria;

-- 4.2 Verificar que existan al menos 100 categorías con más de 5 productos asociados cada una
SELECT 
    c.id AS id_categoria,
    COUNT(pc.product_id) AS productos_asociados
FROM tb_categories c
INNER JOIN tbd_products_categories pc ON c.id = pc.category_id
GROUP BY c.id
HAVING COUNT(pc.product_id) > 5
ORDER BY productos_asociados ASC;

-- 4.3 Verificar trazabilidad en tb_logs sobre categorías, productos y su tabla puente
SELECT * FROM tb_logs 
ORDER BY id DESC 
LIMIT 20;


-- ============================================================================
-- 5. VERIFICACIÓN DE LOS 7,000+ PRODUCTOS DE GADI Y DORIAN Y AUDITORÍA EN tb_logs
-- ============================================================================

-- 5.1 Verificar los usuarios/roles creados en el servidor MySQL (superadmin, seller, gadi, dorian)
SELECT User, Host FROM mysql.user WHERE User IN ('superadmin', 'seller', 'gadi', 'dorian');

-- 5.2 Verificar el total de registros de auditoría capturados por los 72 triggers (~75,912 logs)
SELECT COUNT(*) AS total_registros_auditoria FROM tb_logs;

-- 5.3 Ver distribución de movimientos en tb_logs (inserciones masivas de usuarios, productos y categorías)
SELECT * FROM tb_logs LIMIT 10;


-- ============================================================================
-- 6. VERIFICACIÓN DE INTEGRIDAD REFERENCIAL (SIN REGISTROS HUÉRFANOS)
-- ============================================================================

-- 6.1 Comprobar que ningún registro de tbd_products_categories apunte a un producto o categoría inexistente (debe dar 0)
SELECT COUNT(*) AS relaciones_huerfanas
FROM tbd_products_categories pc
LEFT JOIN tb_products p ON pc.product_id = p.id
LEFT JOIN tb_categories c ON pc.category_id = c.id
WHERE p.id IS NULL OR c.id IS NULL;

-- 6.2 Comprobar que todo usuario en tb_users tenga un registro válido en tb_people (debe dar 0)
SELECT COUNT(*) AS usuarios_sin_persona
FROM tb_users u
LEFT JOIN tb_people p ON u.person_id = p.id
WHERE p.id IS NULL;