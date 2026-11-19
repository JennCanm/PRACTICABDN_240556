USE db_test;

-- ============================================================================
-- CASO DE PRUEBA 5: "CANCELACIÓN TOTAL ANTES DEL ENVÍO Y REEMBOLSO ÍNTEGRO"
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PASO 1: Usuario registrado crea carrito con 3 productos
-- ----------------------------------------------------------------------------
SET @c5_user_id = (
    SELECT id FROM tb_users 
    WHERE email <> 'carlos.mendoza.p4@gmail.com' 
    ORDER BY id ASC LIMIT 1 OFFSET 20
);

INSERT INTO tb_carts (user_ID, status, creation_date)
VALUES (@c5_user_id, b'1', NOW());

SET @c5_cart_id = LAST_INSERT_ID();

INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity, creation_date)
SELECT @c5_cart_id, pup.user_ID, p.id, 2, NOW()
FROM tb_products p
INNER JOIN tbd_products_users_providers pup ON p.id = pup.product_ID
WHERE p.current_stock >= 15
LIMIT 3;

-- ----------------------------------------------------------------------------
-- PASO 2: Generación de la orden de compra y cierre del carrito
-- ----------------------------------------------------------------------------
SELECT SUM(ci.quantity * p.current_price) INTO @c5_subtotal
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c5_cart_id;

SET @c5_seller_id = (SELECT provider_ID FROM tbd_carts_items WHERE cart_ID = @c5_cart_id LIMIT 1);
SET @c5_shipping = 99.00;
SET @c5_total = @c5_subtotal + @c5_shipping;

INSERT INTO tb_buyer_orders (
    seller_ID, subtotal, shipping_cost, fulfillment_status, status, creation_date
) VALUES (
    @c5_seller_id, @c5_subtotal, @c5_shipping, 'Pending', b'1', NOW()
);

SET @c5_order_id = LAST_INSERT_ID();

INSERT INTO tbd_order_items (
    seller_order_ID, product_ID, provider_ID, product_name, quantity, unit_price, creation_date
)
SELECT 
    @c5_order_id, ci.product_ID, ci.provider_ID, p.name,
    ci.quantity, p.current_price, NOW()
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c5_cart_id;

UPDATE tb_carts SET status = b'0', last_update = NOW() WHERE ID = @c5_cart_id;

-- ----------------------------------------------------------------------------
-- PASO 3: Domicilio y método de pago (Tarjeta de Débito)
-- ----------------------------------------------------------------------------
INSERT INTO tb_user_addresses (
    user_ID, address_label, recipient_name, recipient_phone,
    delivery_instructions, latitude, longitude, is_default, status, creation_date
) VALUES (
    @c5_user_id, 'Casa Principal', 'Alejandro Torres Vega', '7765008899',
    'Frente a la farmacia, portón café', 20.274200, -97.962100, 1, b'1', NOW()
);

SET @c5_address_id = LAST_INSERT_ID();

INSERT INTO tbd_address_components (address_ID, value, component_type, status, creation_date) VALUES
(@c5_address_id, 'Calle Hidalgo #54', 'Calle y Número', b'1', NOW()),
(@c5_address_id, 'Col. Centro', 'Colonia', b'1', NOW()),
(@c5_address_id, 'Xicotepec de Juárez', 'Municipio', b'1', NOW()),
(@c5_address_id, 'Puebla', 'Estado', b'1', NOW()),
(@c5_address_id, '73080', 'Código Postal', b'1', NOW());

INSERT INTO tbd_user_payment_methods (
    user_ID, payment_method_type_ID, provider, provider_method_ref,
    label, last_four, is_default, status, creation_date
) VALUES (
    @c5_user_id, 1, 'Santander Débito', '4915660123458821',
    'Débito Santander', '8821', 1, b'1', NOW()
);

SET @c5_user_pm_id = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods_history (
    payment_method_ID, user_ID, payment_method_type_ID, provider,
    provider_method_ref, label, last_four, is_default, status, action_type, action_date
) VALUES (
    @c5_user_pm_id, @c5_user_id, 1, 'Santander Débito',
    '4915660123458821', 'Débito Santander', '8821', 1, b'1', 'INSERT', NOW()
);

-- ----------------------------------------------------------------------------
-- PASO 4: Pago autorizado y orden aceptada con descuento de inventario
-- ----------------------------------------------------------------------------
INSERT INTO tb_payment_transaction (
    order_id, user_id, payment_method_id, transaction_reference,
    amount, currency, transaction_status, transaction_date, status
) VALUES (
    @c5_order_id, @c5_user_id, 1, CONCAT('TXN-C5-FULL-', UUID_SHORT()),
    @c5_total, 'MXN', 'AUTHORIZED', NOW(), 1
);

SET @c5_txn_id = LAST_INSERT_ID();

INSERT INTO tb_payments (
    order_id, transaction_id, amount, payment_status, payment_date, status, creation_date
) VALUES (
    @c5_order_id, @c5_txn_id, @c5_total, 'PAID', NOW(), 1, NOW()
);

SET @c5_payment_id = LAST_INSERT_ID();

UPDATE tb_buyer_orders SET fulfillment_status = 'Accepted', last_update = NOW() WHERE ID = @c5_order_id;

UPDATE tb_products p
INNER JOIN tbd_order_items oi ON p.id = oi.product_ID
SET p.current_stock = p.current_stock - oi.quantity,
    p.last_update = NOW()
WHERE oi.seller_order_ID = @c5_order_id;

-- ----------------------------------------------------------------------------
-- PASO 5: El cliente solicita la cancelación TOTAL antes del envío
-- ----------------------------------------------------------------------------
INSERT INTO tb_order_cancellations (
    order_id, user_id, cancellation_reason, cancellation_status,
    requested_date, processed_date, status
) VALUES (
    @c5_order_id, @c5_user_id,
    'Cancelación total solicitada por el cliente antes de generar guía de envío',
    'FULL_APPROVED', NOW(), NOW(), 1
);

SET @c5_cancellation_id = LAST_INSERT_ID();

INSERT INTO tbd_cancellation_items (
    cancellation_id, order_item_id, quantity, refund_amount, creation_date
)
SELECT 
    @c5_cancellation_id, ID, quantity, subtotal, NOW()
FROM tbd_order_items
WHERE seller_order_ID = @c5_order_id;

-- ----------------------------------------------------------------------------
-- PASO 6: Reintegro completo de inventario, reembolso total y cierre de orden
-- ----------------------------------------------------------------------------
UPDATE tb_products p
INNER JOIN tbd_order_items oi ON p.id = oi.product_ID
SET p.current_stock = p.current_stock + oi.quantity,
    p.last_update = NOW()
WHERE oi.seller_order_ID = @c5_order_id;

INSERT INTO tb_refunds (
    order_id, payment_id, return_id, cancellation_id,
    amount, refund_status, refund_date, status, creation_date
) VALUES (
    @c5_order_id, @c5_payment_id, NULL, @c5_cancellation_id,
    @c5_total, 'REFUNDED_FULL', NOW(), 1, NOW()
);

UPDATE tb_buyer_orders 
SET fulfillment_status = 'Canceled', 
    status = b'0',
    last_update = NOW() 
WHERE ID = @c5_order_id;

-- ----------------------------------------------------------------------------
-- VERIFICACIÓN DEL CASO 5
-- ----------------------------------------------------------------------------
SELECT * FROM tb_buyer_orders WHERE ID = @c5_order_id;
SELECT * FROM tb_order_cancellations WHERE id = @c5_cancellation_id;
SELECT * FROM tbd_cancellation_items WHERE cancellation_id = @c5_cancellation_id;
SELECT * FROM tb_refunds WHERE cancellation_id = @c5_cancellation_id;