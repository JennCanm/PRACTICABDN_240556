USE db_test;

-- ============================================================================
-- 00. ACTUALIZACIÓN DE PRIVILEGIOS PARA ROL 'buyer' Y CATÁLOGOS BASE (PRÁCTICA 04)
-- ============================================================================

-- 1. Privilegios del rol 'buyer' (acorde a la estructura de roles del proyecto)
GRANT SELECT ON db_test.tb_users TO 'buyer';
GRANT SELECT ON db_test.tb_people TO 'buyer';
GRANT SELECT ON db_test.tb_products TO 'buyer';
GRANT SELECT ON db_test.tb_categories TO 'buyer';
GRANT SELECT ON db_test.tbd_products_categories TO 'buyer';
GRANT SELECT ON db_test.tbd_products_users_providers TO 'buyer';
GRANT SELECT ON db_test.tbc_payment_methods_types TO 'buyer';
GRANT SELECT ON db_test.tb_payment_methods TO 'buyer';

GRANT SELECT, INSERT, UPDATE ON db_test.tb_carts TO 'buyer';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test.tbd_carts_items TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_buyer_orders TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_order_items TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_user_addresses TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_address_components TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_user_payment_methods TO 'buyer';
GRANT SELECT, INSERT ON db_test.tbd_user_payment_methods_history TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_payments TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_payment_transaction TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_shipments TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_order_cancellations TO 'buyer';
GRANT SELECT, INSERT ON db_test.tbd_cancellation_items TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_returns TO 'buyer';
GRANT SELECT, INSERT ON db_test.tbd_return_items TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_refunds TO 'buyer';

-- Asignar el rol 'buyer' a los usuarios de conexión de aplicación (se activa al pagar)
GRANT 'buyer' TO 'app_web'@'%';
GRANT 'buyer' TO 'app_mobile'@'%';

FLUSH PRIVILEGES;

-- 2. Poblar catálogo de tipos de métodos de pago (tbc_payment_methods_types)
INSERT IGNORE INTO tbc_payment_methods_types (ID, name, description, status, creation_date) VALUES
(1, 'Tarjeta de Débito', 'Pago directo con tarjeta bancaria de débito (16 dígitos)', b'1', NOW()),
(2, 'Tarjeta de Crédito', 'Pago con tarjeta bancaria de crédito a mensualidades o contado', b'1', NOW()),
(3, 'Tarjeta Digital', 'Tarjeta virtual / Spin prepago de 16 dígitos', b'1', NOW()),
(4, 'Transferencia SPEI', 'Transferencia electrónica interbancaria de 16 dígitos', b'1', NOW()),
(5, 'Cupón de Regalo', 'Saldo promocional o tarjeta de regalo canjeable', b'1', NOW());

-- 3. Poblar catálogo de métodos de pago (tb_payment_methods)
INSERT IGNORE INTO tb_payment_methods (id, payment_method_type_id, name, description, status, creation_date) VALUES
(1, 1, 'Débito Bancario Nacional', 'Pasarela Visa/Mastercard Débito', 1, NOW()),
(2, 2, 'Crédito Bancario MSI', 'Pasarela Crédito con soporte de mensualidades', 1, NOW()),
(3, 3, 'Spin Digital Prepago', 'Pasarela de tarjetas digitales Spin', 1, NOW()),
(4, 4, 'SPEI Interbancario', 'Sistema de Pagos Electrónicos Interbancarios', 1, NOW()),
(5, 5, 'Cupón de Regalo Plataforma', 'Canje de cupones de regalo internos', 1, NOW());

-- 4. Poblar relación de productos con proveedores (tbd_products_users_providers)
-- Vinculamos productos disponibles a vendedores reales (Dorian y Gadiel)
INSERT IGNORE INTO tbd_products_users_providers (user_ID, product_ID, type_ownership, status, available_date, creation_date)
SELECT 
    (SELECT id FROM tb_users ORDER BY id ASC LIMIT 1) AS user_ID,
    p.id AS product_ID,
    'Owner',
    b'1',
    NOW(),
    NOW()
FROM tb_products p
WHERE p.current_stock >= 20
LIMIT 300;

INSERT IGNORE INTO tbd_products_users_providers (user_ID, product_ID, type_ownership, status, available_date, creation_date)
SELECT 
    (SELECT id FROM tb_users ORDER BY id ASC LIMIT 1 OFFSET 1) AS user_ID,
    p.id AS product_ID,
    'Distributor',
    b'1',
    NOW(),
    NOW()
FROM tb_products p
WHERE p.current_stock >= 20
  AND p.id NOT IN (SELECT product_ID FROM tbd_products_users_providers)
LIMIT 300;