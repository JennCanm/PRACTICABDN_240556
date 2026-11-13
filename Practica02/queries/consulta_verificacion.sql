USE db_test;

-- ============================================================================
-- PUNTO 1 Y 2: ESTRUCTURA GENERAL (25 TABLAS, 72 TRIGGERS, 25 VISTAS)
-- ============================================================================

-- 1.1 Verificar el total de tablas base en db_test (debe devolver 25)
SELECT COUNT(*) AS total_tablas 
FROM information_schema.tables 
WHERE table_schema = 'db_test' AND table_type = 'BASE TABLE';

-- 1.2 Verificar los 72 triggers de auditoría (3 por cada una de las 24 tablas)
SELECT COUNT(*) AS total_triggers 
FROM information_schema.triggers 
WHERE trigger_schema = 'db_test';

-- 1.3 Desglose de triggers por tabla y evento (INSERT, UPDATE, DELETE)
SELECT event_object_table AS tabla, action_timing, event_manipulation, trigger_name
FROM information_schema.triggers
WHERE trigger_schema = 'db_test'
ORDER BY event_object_table, event_manipulation;

-- 1.4 Verificar las 25 vistas (24 de trazabilidad + 1 vista consolidada de productos)
SELECT COUNT(*) AS total_vistas 
FROM information_schema.views 
WHERE table_schema = 'db_test';

SELECT table_name AS nombre_vista 
FROM information_schema.views 
WHERE table_schema = 'db_test'
ORDER BY table_name;


-- ============================================================================
-- PUNTO 3 Y 4: PROCEDIMIENTOS ALMACENADOS, EVENTOS Y SIMULACIÓN DE 7,500 USUARIOS
-- ============================================================================

-- 3.1 Listar todos los procedimientos almacenados (inserción masiva, limpieza, reportes)
SHOW PROCEDURE STATUS WHERE Db = 'db_test';

-- 3.2 Listar los eventos programados (automatización / mantenimiento)
SHOW EVENTS FROM db_test;

-- 3.3 Verificar la población de los 7,500 usuarios distribuidos en los 3 escenarios
SELECT COUNT(*) AS total_usuarios FROM usuarios;
SELECT COUNT(*) AS total_clientes FROM clientes;

-- 3.4 Verificar distribución de usuarios por rol/perfil o estado
SELECT estatus, COUNT(*) AS cantidad 
FROM usuarios 
GROUP BY estatus;


-- ============================================================================
-- PUNTO 5 Y 6: REGLAS DE NEGOCIO DE CATEGORIZACIÓN Y TRAZABILIDAD DE PRODUCTOS
-- ============================================================================

-- 5.1 Verificar que existan al menos 100 categorías activas con más de 5 productos cada una
SELECT 
    c.id_categoria, 
    c.nombre AS categoria, 
    COUNT(p.id_producto) AS total_productos
FROM categorias c
INNER JOIN productos p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nombre
HAVING COUNT(p.id_producto) > 5
ORDER BY total_productos ASC;

-- 5.2 Conteo total de categorías que cumplen la regla (>= 100 categorías con > 5 productos)
SELECT COUNT(*) AS categorias_validas
FROM (
    SELECT id_categoria
    FROM productos
    GROUP BY id_categoria
    HAVING COUNT(*) > 5
) AS sub;

-- 5.3 Verificar la trazabilidad de categorización (historial de cambios de categoría/estatus)
SELECT * FROM bitacora_auditoria 
WHERE tabla_afectada IN ('categorias', 'productos') 
ORDER BY fecha_hora DESC 
LIMIT 20;

-- 5.4 Consultar la vista consolidada de catálogo y categorización de productos
SELECT * FROM vw_catalogo_productos LIMIT 15;


-- ============================================================================
-- PUNTO 7 Y 8: VERIFICACIÓN DE LOS 7,000+ PRODUCTOS DE GADI Y DORIAN Y ROLES
-- ============================================================================

-- 7.1 Verificar que existan los usuarios/colaboradores Gadi y Dorian (o roles superadmin/seller)
SELECT User, Host FROM mysql.user WHERE User IN ('superadmin', 'seller', 'gadi', 'dorian');

-- 7.2 Verificar el total global de productos registrados (debe superar los 7,000)
SELECT COUNT(*) AS total_productos_registrados FROM productos;

-- 7.3 Verificar la autoría y trazabilidad de los ~7,000 productos agregados por Gadi y Dorian
SELECT 
    usuario,
    accion,
    COUNT(*) AS total_productos_procesados,
    MIN(fecha_hora) AS inicio_carga,
    MAX(fecha_hora) AS fin_carga
FROM bitacora_auditoria
WHERE tabla_afectada = 'productos' 
  AND accion = 'INSERT'
GROUP BY usuario, accion
ORDER BY total_productos_procesados DESC;

-- 7.4 Verificar que no existan productos o categorías huérfanas tras las cargas masivas
SELECT COUNT(*) AS productos_sin_categoria
FROM productos p
LEFT JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE c.id_categoria IS NULL;


-- ============================================================================
-- PUNTO 9 Y 10: AUDITORÍA GLOBAL POR TABLA, PEDIDOS E INTEGRIDAD TRANSACCIONAL
-- ============================================================================

-- 9.1 Resumen general de auditoría capturada por los 72 triggers en todas las tablas
SELECT 
    tabla_afectada, 
    accion, 
    COUNT(*) AS total_movimientos
FROM bitacora_auditoria
GROUP BY tabla_afectada, accion
ORDER BY tabla_afectada, accion;

-- 9.2 Verificar pedidos, detalles y movimientos transaccionales generados
SELECT 
    (SELECT COUNT(*) FROM pedidos) AS total_pedidos,
    (SELECT COUNT(*) FROM detalle_pedidos) AS total_detalles_pedido,
    (SELECT COUNT(*) FROM pagos) AS total_pagos,
    (SELECT COUNT(*) FROM envios) AS total_envios;

-- 9.3 Verificar normalidad en los estados de pedidos y productos (sin nulos ni cadenas vacías)
SELECT estatus, COUNT(*) AS cantidad FROM pedidos GROUP BY estatus;
SELECT estatus, COUNT(*) AS cantidad FROM productos GROUP BY estatus;