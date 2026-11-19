USE db_test;

-- ============================================================================
-- CASO DE PRUEBA 5: "COMPRA FALLIDA POR FALTA DE INVENTARIO Y REASIGNACIÓN DE CUPÓN"
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PASO 1: Usuario ya registrado (sin carrito previo) crea carrito de 1 producto (1 a 5 uds)
-- ----------------------------------------------------------------------------
SET @c5_user_id = (
    SELECT u.id FROM tb_users u
    WHERE u.email <> 'carlos.mendoza.p4@gmail.com'
      AND u.id NOT IN (SELECT user_ID FROM tb_carts)
    ORDER BY u.id ASC LIMIT 1 OFFSET 5
);

SELECT p.id, pup.user_ID, p.current_stock
INTO @c5_product_id, @c5_provider_id, @c5_stock_original
FROM tb_products p
INNER JOIN tbd_products_users_providers pup ON p.id = pup.product_ID
WHERE p.current_price <= 3000.00
ORDER BY p.id DESC
LIMIT 1;

SET @c5_qty_solicitada = 4;

INSERT INTO tb_carts (user_ID, status, creation_date)
VALUES (@c5_user_id, b'1', NOW());

SET @c5_cart_id = LAST_INSERT_ID();

INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity, creation_date)
VALUES (@c5_cart_id, @c5_provider_id, @c5_product_id, @c5_qty_solicitada, NOW());

-- ----------------------------------------------------------------------------
-- PASO 2: El usuario realiza la orden de compra
-- ----------------------------------------------------------------------------
SELECT (@c5_qty_solicitada * current_price) INTO @c5_subtotal
FROM tb_products WHERE id = @c5_product_id;

SET @c5_shipping = 0.00;
SET @c5_total = @c5_subtotal + @c5_shipping;

INSERT INTO tb_buyer_orders (
    seller_ID, subtotal, shipping_cost, fulfillment_status, status, creation_date
) VALUES (
    @c5_provider_id, @c5_subtotal, @c5_shipping, 'Pending', b'1', NOW()
);

SET @c5_order_id = LAST_INSERT_ID();

INSERT INTO tbd_order_items (
    seller_order_ID, product_ID, provider_ID, product_name, quantity, unit_price, creation_date
)
SELECT 
    @c5_order_id, @c5_product_id, @c5_provider_id, name,
    @c5_qty_solicitada, current_price, NOW()
FROM tb_products WHERE id = @c5_product_id;

UPDATE tb_carts SET status = b'0', last_update = NOW() WHERE ID = @c5_cart_id;

-- ----------------------------------------------------------------------------
-- PASO 3: El usuario registra domicilio para envío en su HOGAR
-- ----------------------------------------------------------------------------
INSERT INTO tb_user_addresses (
    user_ID, address_label, recipient_name, recipient_phone,
    delivery_instructions, latitude, longitude, is_default, status, creation_date
) VALUES (
    @c5_user_id, 'Hogar', 'Alejandro Torres Vega', '7765008899',
    'Frente a la farmacia, portón café', 20.274200, -97.962100, 1, b'1', NOW()
);

SET @c5_address_id = LAST_INSERT_ID();

INSERT INTO tbd_address_components (address_ID, value, component_type, status, creation_date) VALUES
(@c5_address_id, 'Calle Hidalgo #54', 'Calle y Número', b'1', NOW()),
(@c5_address_id, 'Col. Centro', 'Colonia', b'1', NOW()),
(@c5_address_id, 'Xicotepec de Juárez', 'Municipio', b'1', NOW()),
(@c5_address_id, 'Puebla', 'Estado', b'1', NOW()),
(@c5_address_id, '73080', 'Código Postal', b'1', NOW());

-- ----------------------------------------------------------------------------
-- PASO 4: Registro de método de pago: Cupón de Regalo
-- ----------------------------------------------------------------------------
SET @c5_coupon_code = CONCAT('GIFT-2026-', LPAD(@c5_user_id, 6, '0'));

INSERT INTO tbd_user_payment_methods (
    user_ID, payment_method_type_ID, provider, provider_method_ref,
    label, last_four, is_default, status, creation_date
) VALUES (
    @c5_user_id, 5, 'Cupón de Regalo Plataforma', @c5_coupon_code,
    'Cupón de Regalo Tienda', RIGHT(@c5_coupon_code, 4), 1, b'1', NOW()
);

SET @c5_user_pm_id = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods_history (
    payment_method_ID, user_ID, payment_method_type_ID, provider,
    provider_method_ref, label, last_four, is_default, status, action_type, action_date
) VALUES (
    @c5_user_pm_id, @c5_user_id, 5, 'Cupón de Regalo Plataforma',
    @c5_coupon_code, 'Cupón de Regalo Tienda', RIGHT(@c5_coupon_code, 4), 1, b'1', 'INSERT', NOW()
);

INSERT INTO tb_payment_transaction (
    order_id, user_id, payment_method_id, transaction_reference,
    amount, currency, transaction_status, transaction_date, status
) VALUES (
    @c5_order_id, @c5_user_id, 5, CONCAT('TXN-C5-GIFTCARD-', UUID_SHORT()),
    @c5_total, 'MXN', 'AUTHORIZED', NOW(), 1
);

SET @c5_txn_id = LAST_INSERT_ID();

INSERT INTO tb_payments (
    order_id, transaction_id, amount, payment_status, payment_date, status, creation_date
) VALUES (
    @c5_order_id, @c5_txn_id, @c5_total, 'PAID', NOW(), 1, NOW()
);

SET @c5_payment_id = LAST_INSERT_ID();

-- Cupón marcado como consumido temporalmente
UPDATE tbd_user_payment_methods SET status = b'0', last_update = NOW() WHERE ID = @c5_user_pm_id;

-- ----------------------------------------------------------------------------
-- PASO 5: El sistema detecta falta de inventario y marca la orden como NO ATENDIDA
-- ----------------------------------------------------------------------------
UPDATE tb_products SET current_stock = 1, last_update = NOW() WHERE id = @c5_product_id;

UPDATE tb_buyer_orders 
SET fulfillment_status = 'Pending', 
    last_update = NOW() 
WHERE ID = @c5_order_id;

-- ----------------------------------------------------------------------------
-- PASO 6: El sistema cancela la orden y REASIGNA el cupón utilizado al usuario
-- ----------------------------------------------------------------------------
INSERT INTO tb_order_cancellations (
    order_id, user_id, cancellation_reason, cancellation_status,
    requested_date, processed_date, status
) VALUES (
    @c5_order_id, @c5_user_id,
    'Orden no atendida y cancelada automáticamente por falta de inventario disponible; se reasigna cupón de regalo',
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

INSERT INTO tb_refunds (
    order_id, payment_id, return_id, cancellation_id,
    amount, refund_status, refund_date, status, creation_date
) VALUES (
    @c5_order_id, @c5_payment_id, NULL, @c5_cancellation_id,
    @c5_total, 'REFUNDED_FULL', NOW(), 1, NOW()
);

-- Reasignamos el cupón al usuario (status = b'1')
UPDATE tbd_user_payment_methods 
SET status = b'1', 
    label = 'Cupón de Regalo Reasignado por Falta de Stock',
    last_update = NOW() 
WHERE ID = @c5_user_pm_id;

-- Cancelamos la orden
UPDATE tb_buyer_orders 
SET fulfillment_status = 'Canceled', 
    status = b'0',
    last_update = NOW() 
WHERE ID = @c5_order_id;

-- ----------------------------------------------------------------------------
-- VERIFICACIÓN DEL CASO 5
-- ----------------------------------------------------------------------------
SELECT * FROM tb_buyer_orders WHERE ID = @c5_order_id;
SELECT ID, user_ID, provider_method_ref, label, HEX(status) AS cupon_activo FROM tbd_user_payment_methods WHERE ID = @c5_user_pm_id;
SELECT * FROM tb_order_cancellations WHERE id = @c5_cancellation_id;
SELECT * FROM tb_refunds WHERE cancellation_id = @c5_cancellation_id;