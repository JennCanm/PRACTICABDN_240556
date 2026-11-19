USE db_test;

-- ============================================================================
-- CASO DE PRUEBA 1: "COMPRA EXITOSA, SIN MODIFICACIONES" (PASOS 1 AL 11)
-- Conexión requerida: app_web | Transición de rol: user_not_registered -> buyer
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PASO 1: Registro de usuario nuevo (Rol: user_not_registered)
-- ----------------------------------------------------------------------------
SET ROLE 'user_not_registered';

INSERT INTO tb_users (email, nick, password, creation_date, status)
VALUES ('carlos.mendoza.p4@gmail.com', 'carlos_mendoza_p4', SHA2('PassSeguro2026!', 256), NOW(), b'1');

SET @c1_user_id = LAST_INSERT_ID();

INSERT INTO tb_people (
    user_ID, courtesy_title, given_names, family_names, birth_date,
    gender, country_code, phone, status, creation_date
) VALUES (
    @c1_user_id, 'Sr.', 'Carlos Alberto', 'Mendoza Ruiz', '1996-05-14',
    'Hombre', '+52', '7761002233', b'1', NOW()
);

-- Activamos el rol 'buyer' para operar la sesión de compra del usuario registrado
SET ROLE 'buyer';

-- ----------------------------------------------------------------------------
-- PASO 2: Selección de 5 productos disponibles (verificar estatus y stock)
-- ----------------------------------------------------------------------------
SELECT p.id, p.SKU, p.name, p.current_price, p.current_stock, p.status, pup.user_ID AS provider_id
FROM tb_products p
INNER JOIN tbd_products_users_providers pup ON p.id = pup.product_ID
WHERE p.current_stock >= 10
LIMIT 5;

SET @c1_prod1 = (SELECT product_ID FROM tbd_products_users_providers LIMIT 1 OFFSET 0);
SET @c1_prov1 = (SELECT user_ID FROM tbd_products_users_providers WHERE product_ID = @c1_prod1 LIMIT 1);

SET @c1_prod2 = (SELECT product_ID FROM tbd_products_users_providers LIMIT 1 OFFSET 1);
SET @c1_prov2 = (SELECT user_ID FROM tbd_products_users_providers WHERE product_ID = @c1_prod2 LIMIT 1);

SET @c1_prod3 = (SELECT product_ID FROM tbd_products_users_providers LIMIT 1 OFFSET 2);
SET @c1_prov3 = (SELECT user_ID FROM tbd_products_users_providers WHERE product_ID = @c1_prod3 LIMIT 1);

SET @c1_prod4 = (SELECT product_ID FROM tbd_products_users_providers LIMIT 1 OFFSET 3);
SET @c1_prov4 = (SELECT user_ID FROM tbd_products_users_providers WHERE product_ID = @c1_prod4 LIMIT 1);

SET @c1_prod5 = (SELECT product_ID FROM tbd_products_users_providers LIMIT 1 OFFSET 4);
SET @c1_prov5 = (SELECT user_ID FROM tbd_products_users_providers WHERE product_ID = @c1_prod5 LIMIT 1);

-- ----------------------------------------------------------------------------
-- PASO 3: El usuario crea 1 carrito de compra
-- ----------------------------------------------------------------------------
INSERT INTO tb_carts (user_ID, status, creation_date)
VALUES (@c1_user_id, b'1', NOW());

SET @c1_cart_id = LAST_INSERT_ID();

-- ----------------------------------------------------------------------------
-- PASO 4: El usuario agrega 5 productos con diferentes cantidades al carrito
-- ----------------------------------------------------------------------------
INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity, creation_date) VALUES
(@c1_cart_id, @c1_prov1, @c1_prod1, 1, NOW()),
(@c1_cart_id, @c1_prov2, @c1_prod2, 2, NOW()),
(@c1_cart_id, @c1_prov3, @c1_prod3, 3, NOW()),
(@c1_cart_id, @c1_prov4, @c1_prod4, 1, NOW()),
(@c1_cart_id, @c1_prov5, @c1_prod5, 4, NOW());

-- ----------------------------------------------------------------------------
-- PASO 5: El usuario realiza la orden de compra
-- ----------------------------------------------------------------------------
SELECT SUM(ci.quantity * p.current_price) INTO @c1_subtotal
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c1_cart_id;

SET @c1_shipping = 99.00;
SET @c1_total = @c1_subtotal + @c1_shipping;

INSERT INTO tb_buyer_orders (
    seller_ID, subtotal, shipping_cost, fulfillment_status, status, creation_date
) VALUES (
    @c1_prov1, @c1_subtotal, @c1_shipping, 'Pending', b'1', NOW()
);

SET @c1_order_id = LAST_INSERT_ID();

-- Sin incluir 'subtotal' porque es columna generada automáticamente
INSERT INTO tbd_order_items (
    seller_order_ID, product_ID, provider_ID, product_name, quantity, unit_price, creation_date
)
SELECT 
    @c1_order_id, ci.product_ID, ci.provider_ID, p.name,
    ci.quantity, p.current_price, NOW()
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c1_cart_id;

UPDATE tb_carts SET status = b'0', last_update = NOW() WHERE ID = @c1_cart_id;

-- ----------------------------------------------------------------------------
-- PASO 6: El usuario registra su domicilio para envío
-- ----------------------------------------------------------------------------
INSERT INTO tb_user_addresses (
    user_ID, address_label, recipient_name, recipient_phone,
    delivery_instructions, latitude, longitude, is_default, status, creation_date
) VALUES (
    @c1_user_id, 'Casa', 'Carlos Alberto Mendoza Ruiz', '7761002233',
    'Portón negro frente al parque central, tocar timbre', 20.275600, -97.961200, 1, b'1', NOW()
);

SET @c1_address_id = LAST_INSERT_ID();

INSERT INTO tbd_address_components (address_ID, value, component_type, status, creation_date) VALUES
(@c1_address_id, 'Av. Juárez #142', 'Calle y Número', b'1', NOW()),
(@c1_address_id, 'Col. Centro', 'Colonia', b'1', NOW()),
(@c1_address_id, 'Xicotepec de Juárez', 'Municipio', b'1', NOW()),
(@c1_address_id, 'Puebla', 'Estado', b'1', NOW()),
(@c1_address_id, '73080', 'Código Postal', b'1', NOW());

-- ----------------------------------------------------------------------------
-- PASO 7: Registro de método de pago (Tarjeta de Débito 16 dígitos + historial)
-- ----------------------------------------------------------------------------
INSERT INTO tbd_user_payment_methods (
    user_ID, payment_method_type_ID, provider, provider_method_ref,
    label, last_four, is_default, status, creation_date
) VALUES (
    @c1_user_id, 1, 'BBVA Débito', '4152313890127845',
    'Tarjeta Débito Principal', '7845', 1, b'1', NOW()
);

SET @c1_user_pm_id = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods_history (
    payment_method_ID, user_ID, payment_method_type_ID, provider,
    provider_method_ref, label, last_four, is_default, status, action_type, action_date
) VALUES (
    @c1_user_pm_id, @c1_user_id, 1, 'BBVA Débito',
    '4152313890127845', 'Tarjeta Débito Principal', '7845', 1, b'1', 'INSERT', NOW()
);

-- ----------------------------------------------------------------------------
-- PASO 8 Y 9: Pago único (rol 'buyer' activo) y autorización bancaria
-- ----------------------------------------------------------------------------
SET ROLE 'buyer';

INSERT INTO tb_payment_transaction (
    order_id, user_id, payment_method_id, transaction_reference,
    amount, currency, transaction_status, transaction_date, status
) VALUES (
    @c1_order_id, @c1_user_id, 1, CONCAT('TXN-C1-', UUID_SHORT()),
    @c1_total, 'MXN', 'AUTHORIZED', NOW(), 1
);

SET @c1_txn_id = LAST_INSERT_ID();

INSERT INTO tb_payments (
    order_id, transaction_id, amount, payment_status, payment_date, status, creation_date
) VALUES (
    @c1_order_id, @c1_txn_id, @c1_total, 'PAID', NOW(), 1, NOW()
);

-- ----------------------------------------------------------------------------
-- PASO 10: El sistema procesa la orden como atendida y descuenta inventario
-- ----------------------------------------------------------------------------
UPDATE tb_buyer_orders 
SET fulfillment_status = 'Accepted', last_update = NOW() 
WHERE ID = @c1_order_id;

UPDATE tb_products p
INNER JOIN tbd_order_items oi ON p.id = oi.product_ID
SET p.current_stock = p.current_stock - oi.quantity,
    p.last_update = NOW()
WHERE oi.seller_order_ID = @c1_order_id;

-- ----------------------------------------------------------------------------
-- PASO 11: Envío y entrega del producto en casa del usuario
-- ----------------------------------------------------------------------------
UPDATE tb_buyer_orders 
SET fulfillment_status = 'Sent', last_update = NOW() 
WHERE ID = @c1_order_id;

INSERT INTO tb_shipments (
    order_id, tracking_number, carrier_name, shipping_status,
    shipped_date, estimated_delivery_date, delivered_date, status, creation_date
) VALUES (
    @c1_order_id, CONCAT('TRK-MX-', @c1_order_id, '-01'), 'DHL Express México', 'DELIVERED',
    NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 1 DAY), 1, NOW()
);

UPDATE tb_buyer_orders 
SET fulfillment_status = 'Delivered', last_update = NOW() 
WHERE ID = @c1_order_id;

-- ----------------------------------------------------------------------------
-- CONSULTAS DE VERIFICACIÓN DEL CASO 1
-- ----------------------------------------------------------------------------
SELECT CURRENT_ROLE() AS rol_activo;
SELECT * FROM tb_buyer_orders WHERE ID = @c1_order_id;
SELECT * FROM tbd_order_items WHERE seller_order_ID = @c1_order_id;
SELECT * FROM tb_payment_transaction WHERE order_id = @c1_order_id;
SELECT * FROM tb_payments WHERE order_id = @c1_order_id;
SELECT * FROM tb_shipments WHERE order_id = @c1_order_id;