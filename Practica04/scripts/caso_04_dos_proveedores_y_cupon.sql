USE db_test;

-- ============================================================================
-- CASO DE PRUEBA 4: "COMPRA EXITOSA DEL MISMO PROVEEDOR CON ENTREGA EN PUNTO DE RECOLECCIÓN"
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PASO 1: Usuario ya registrado (sin carrito previo) arma carrito de 3 productos del MISMO proveedor (1 a 3 uds)
-- ----------------------------------------------------------------------------
SET @c4_user_id = (
    SELECT u.id FROM tb_users u
    WHERE u.email <> 'carlos.mendoza.p4@gmail.com'
      AND u.id NOT IN (SELECT user_ID FROM tb_carts)
    ORDER BY u.id ASC LIMIT 1
);

SET @c4_provider_id = (
    SELECT pup.user_ID
    FROM tbd_products_users_providers pup
    INNER JOIN tb_products p ON pup.product_ID = p.id
    WHERE p.current_stock >= 10
    GROUP BY pup.user_ID
    HAVING COUNT(DISTINCT p.id) >= 3
    LIMIT 1
);

INSERT INTO tb_carts (user_ID, status, creation_date)
VALUES (@c4_user_id, b'1', NOW());

SET @c4_cart_id = LAST_INSERT_ID();

INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity, creation_date)
SELECT 
    @c4_cart_id,
    pup.user_ID,
    p.id,
    FLOOR(1 + (RAND() * 3)),
    NOW()
FROM tb_products p
INNER JOIN tbd_products_users_providers pup ON p.id = pup.product_ID
WHERE pup.user_ID = @c4_provider_id
  AND p.current_stock >= 10
LIMIT 3;

-- ----------------------------------------------------------------------------
-- PASO 2: El usuario realiza la orden de compra
-- ----------------------------------------------------------------------------
SELECT SUM(ci.quantity * p.current_price) INTO @c4_subtotal
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c4_cart_id;

SET @c4_shipping = 110.00;
SET @c4_total = @c4_subtotal + @c4_shipping;

INSERT INTO tb_buyer_orders (
    seller_ID, subtotal, shipping_cost, fulfillment_status, status, creation_date
) VALUES (
    @c4_provider_id, @c4_subtotal, @c4_shipping, 'Pending', b'1', NOW()
);

SET @c4_order_id = LAST_INSERT_ID();

INSERT INTO tbd_order_items (
    seller_order_ID, product_ID, provider_ID, product_name, quantity, unit_price, creation_date
)
SELECT 
    @c4_order_id, ci.product_ID, ci.provider_ID, p.name,
    ci.quantity, p.current_price, NOW()
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c4_cart_id;

UPDATE tb_carts SET status = b'0', last_update = NOW() WHERE ID = @c4_cart_id;

-- ----------------------------------------------------------------------------
-- PASO 3: El usuario registra domicilio para envío en su HOGAR
-- ----------------------------------------------------------------------------
INSERT INTO tb_user_addresses (
    user_ID, address_label, recipient_name, recipient_phone,
    delivery_instructions, latitude, longitude, is_default, status, creation_date
) VALUES (
    @c4_user_id, 'Hogar', 'Fernanda López Silva', '7764007788',
    'Casa color blanco con zaguán negro frente al parque', 20.279500, -97.955200, 1, b'1', NOW()
);

SET @c4_address_id = LAST_INSERT_ID();

INSERT INTO tbd_address_components (address_ID, value, component_type, status, creation_date) VALUES
(@c4_address_id, 'Privada de las Flores #88', 'Calle y Número', b'1', NOW()),
(@c4_address_id, 'Col. Los Pinos', 'Colonia', b'1', NOW()),
(@c4_address_id, 'Xicotepec de Juárez', 'Municipio', b'1', NOW()),
(@c4_address_id, 'Puebla', 'Estado', b'1', NOW()),
(@c4_address_id, '73080', 'Código Postal', b'1', NOW());

-- ----------------------------------------------------------------------------
-- PASO 4: Registro de método de pago: Transferencia SPEI cuenta simulada de 16 dígitos + historial
-- ----------------------------------------------------------------------------
SET @c4_spei_account = CONCAT('012180', LPAD(@c4_user_id, 6, '0'), '2736');

INSERT INTO tbd_user_payment_methods (
    user_ID, payment_method_type_ID, provider, provider_method_ref,
    label, last_four, is_default, status, creation_date
) VALUES (
    @c4_user_id, 4, 'BBVA Transferencia SPEI', @c4_spei_account,
    'Cuenta SPEI 16 Dígitos', '2736', 1, b'1', NOW()
);

SET @c4_user_pm_id = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods_history (
    payment_method_ID, user_ID, payment_method_type_ID, provider,
    provider_method_ref, label, last_four, is_default, status, action_type, action_date
) VALUES (
    @c4_user_pm_id, @c4_user_id, 4, 'BBVA Transferencia SPEI',
    @c4_spei_account, 'Cuenta SPEI 16 Dígitos', '2736', 1, b'1', 'INSERT', NOW()
);

-- ----------------------------------------------------------------------------
-- PASO 5 Y 6: Pago único por el costo total y orden marcada como atendida
-- ----------------------------------------------------------------------------
INSERT INTO tb_payment_transaction (
    order_id, user_id, payment_method_id, transaction_reference,
    amount, currency, transaction_status, transaction_date, status
) VALUES (
    @c4_order_id, @c4_user_id, 4, CONCAT('TXN-C4-SPEI-CASH-', UUID_SHORT()),
    @c4_total, 'MXN', 'AUTHORIZED', NOW(), 1
);

INSERT INTO tb_payments (
    order_id, transaction_id, amount, payment_status, payment_date, status, creation_date
) VALUES (
    @c4_order_id, LAST_INSERT_ID(), @c4_total, 'PAID', NOW(), 1, NOW()
);

UPDATE tb_buyer_orders SET fulfillment_status = 'Accepted', last_update = NOW() WHERE ID = @c4_order_id;

UPDATE tb_products p
INNER JOIN tbd_order_items oi ON p.id = oi.product_ID
SET p.current_stock = p.current_stock - oi.quantity,
    p.last_update = NOW()
WHERE oi.seller_order_ID = @c4_order_id;

-- ----------------------------------------------------------------------------
-- PASO 7 Y 8: Envío fallido en domicilio (nadie recibió) y recolección en punto de entrega
-- ----------------------------------------------------------------------------
UPDATE tb_buyer_orders SET fulfillment_status = 'Sent', last_update = NOW() WHERE ID = @c4_order_id;

INSERT INTO tb_shipments (
    order_id, tracking_number, carrier_name, shipping_status,
    shipped_date, estimated_delivery_date, delivered_date, status, creation_date
) VALUES (
    @c4_order_id, CONCAT('TRK-MX-', @c4_order_id, '-PICKUP'),
    'DHL Express - Punto de Recolección Sucursal Centro', 'DELIVERED',
    NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), 1, NOW()
);

UPDATE tb_buyer_orders SET fulfillment_status = 'Delivered', last_update = NOW() WHERE ID = @c4_order_id;

-- ----------------------------------------------------------------------------
-- VERIFICACIÓN DEL CASO 4
-- ----------------------------------------------------------------------------
SELECT * FROM tb_buyer_orders WHERE ID = @c4_order_id;
SELECT ID, seller_order_ID, product_ID, provider_ID, product_name, quantity, subtotal FROM tbd_order_items WHERE seller_order_ID = @c4_order_id;
SELECT * FROM tb_shipments WHERE order_id = @c4_order_id;