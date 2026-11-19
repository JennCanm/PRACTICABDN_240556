USE db_test;

-- ============================================================================
-- CASO DE PRUEBA 3: "COMPRA EXITOSA CON CANCELACIÓN PARCIAL, AJUSTE Y REEMBOLSO PARCIAL"
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PASO 1: Usuario ya registrado crea 1 carrito de 3 productos de la MISMA categoría (1 a 10 uds)
-- ----------------------------------------------------------------------------
SET @c3_user_id = (
    SELECT id FROM tb_users 
    WHERE email <> 'carlos.mendoza.p4@gmail.com' 
    ORDER BY id ASC LIMIT 1 OFFSET 10
);

-- Buscamos una categoría que tenga al menos 3 productos con proveedor asignado y stock >= 20
SET @c3_cat_id = (
    SELECT pc.category_ID
    FROM tbd_products_categories pc
    INNER JOIN tb_products p ON pc.product_ID = p.id
    INNER JOIN tbd_products_users_providers pup ON p.id = pup.product_ID
    WHERE p.current_stock >= 20
    GROUP BY pc.category_ID
    HAVING COUNT(DISTINCT p.id) >= 3
    LIMIT 1
);

INSERT INTO tb_carts (user_ID, status, creation_date)
VALUES (@c3_user_id, b'1', NOW());

SET @c3_cart_id = LAST_INSERT_ID();

INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity, creation_date)
SELECT DISTINCT
    @c3_cart_id,
    pup.user_ID,
    p.id,
    FLOOR(2 + (RAND() * 8)),
    NOW()
FROM tb_products p
INNER JOIN tbd_products_categories pc ON p.id = pc.product_ID
INNER JOIN tbd_products_users_providers pup ON p.id = pup.product_ID
WHERE pc.category_ID = @c3_cat_id
  AND p.current_stock >= 20
LIMIT 3;

-- ----------------------------------------------------------------------------
-- PASO 2: El usuario realiza la orden de compra
-- ----------------------------------------------------------------------------
SELECT SUM(ci.quantity * p.current_price) INTO @c3_subtotal_inicial
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c3_cart_id;

SET @c3_seller_id = (SELECT provider_ID FROM tbd_carts_items WHERE cart_ID = @c3_cart_id LIMIT 1);
SET @c3_shipping = 120.00;
SET @c3_total_inicial = @c3_subtotal_inicial + @c3_shipping;

INSERT INTO tb_buyer_orders (
    seller_ID, subtotal, shipping_cost, fulfillment_status, status, creation_date
) VALUES (
    @c3_seller_id, @c3_subtotal_inicial, @c3_shipping, 'Pending', b'1', NOW()
);

SET @c3_order_id = LAST_INSERT_ID();

INSERT INTO tbd_order_items (
    seller_order_ID, product_ID, provider_ID, product_name, quantity, unit_price, creation_date
)
SELECT 
    @c3_order_id, ci.product_ID, ci.provider_ID, p.name,
    ci.quantity, p.current_price, NOW()
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c3_cart_id;

UPDATE tb_carts SET status = b'0', last_update = NOW() WHERE ID = @c3_cart_id;

-- ----------------------------------------------------------------------------
-- PASO 3: Registro de domicilio para envío distinto a su hogar ("Casa Papas")
-- ----------------------------------------------------------------------------
INSERT INTO tb_user_addresses (
    user_ID, address_label, recipient_name, recipient_phone,
    delivery_instructions, latitude, longitude, is_default, status, creation_date
) VALUES (
    @c3_user_id, 'Casa Papas', 'Roberto Hernández Morales', '7763005566',
    'Casa color beige de dos pisos con jardín al frente, entregar a mis papás',
    20.273100, -97.963500, 0, b'1', NOW()
);

SET @c3_address_id = LAST_INSERT_ID();

INSERT INTO tbd_address_components (address_ID, value, component_type, status, creation_date) VALUES
(@c3_address_id, 'Calle Zaragoza #215', 'Calle y Número', b'1', NOW()),
(@c3_address_id, 'Col. El Tabacal', 'Colonia', b'1', NOW()),
(@c3_address_id, 'Xicotepec de Juárez', 'Municipio', b'1', NOW()),
(@c3_address_id, 'Puebla', 'Estado', b'1', NOW()),
(@c3_address_id, '73080', 'Código Postal', b'1', NOW());

-- ----------------------------------------------------------------------------
-- PASO 4: Registro de método de pago (Tarjeta Digital Spin 16 dígitos + historial)
-- ----------------------------------------------------------------------------
INSERT INTO tbd_user_payment_methods (
    user_ID, payment_method_type_ID, provider, provider_method_ref,
    label, last_four, is_default, status, creation_date
) VALUES (
    @c3_user_id, 3, 'Spin by OXXO Digital', '4772910045823319',
    'Tarjeta Digital Spin', '3319', 1, b'1', NOW()
);

SET @c3_user_pm_id = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods_history (
    payment_method_ID, user_ID, payment_method_type_ID, provider,
    provider_method_ref, label, last_four, is_default, status, action_type, action_date
) VALUES (
    @c3_user_pm_id, @c3_user_id, 3, 'Spin by OXXO Digital',
    '4772910045823319', 'Tarjeta Digital Spin', '3319', 1, b'1', 'INSERT', NOW()
);

-- ----------------------------------------------------------------------------
-- PASO 5 Y 6: Pago único por el costo total y orden marcada como atendida
-- ----------------------------------------------------------------------------
INSERT INTO tb_payment_transaction (
    order_id, user_id, payment_method_id, transaction_reference,
    amount, currency, transaction_status, transaction_date, status
) VALUES (
    @c3_order_id, @c3_user_id, 3, CONCAT('TXN-C3-CASH-SPIN-', UUID_SHORT()),
    @c3_total_inicial, 'MXN', 'AUTHORIZED', NOW(), 1
);

SET @c3_txn_id = LAST_INSERT_ID();

INSERT INTO tb_payments (
    order_id, transaction_id, amount, payment_status, payment_date, status, creation_date
) VALUES (
    @c3_order_id, @c3_txn_id, @c3_total_inicial, 'PAID', NOW(), 1, NOW()
);

SET @c3_payment_id = LAST_INSERT_ID();

UPDATE tb_buyer_orders SET fulfillment_status = 'Accepted', last_update = NOW() WHERE ID = @c3_order_id;

-- Descontamos inventario inicial de los 3 productos
UPDATE tb_products p
INNER JOIN tbd_order_items oi ON p.id = oi.product_ID
SET p.current_stock = p.current_stock - oi.quantity,
    p.last_update = NOW()
WHERE oi.seller_order_ID = @c3_order_id;

-- ----------------------------------------------------------------------------
-- PASO 7: El usuario cancela 1 producto del pedido antes del envío
-- ----------------------------------------------------------------------------
SET @c3_cancel_item_id = (SELECT ID FROM tbd_order_items WHERE seller_order_ID = @c3_order_id ORDER BY ID DESC LIMIT 1);
SET @c3_cancel_prod_id = (SELECT product_ID FROM tbd_order_items WHERE ID = @c3_cancel_item_id);
SET @c3_cancel_qty = (SELECT quantity FROM tbd_order_items WHERE ID = @c3_cancel_item_id);
SET @c3_refund_amount = (SELECT subtotal FROM tbd_order_items WHERE ID = @c3_cancel_item_id);

INSERT INTO tb_order_cancellations (
    order_id, user_id, cancellation_reason, cancellation_status,
    requested_date, processed_date, status
) VALUES (
    @c3_order_id, @c3_user_id,
    'Cancelación parcial de un artículo de la misma categoría antes de despacho',
    'PARTIAL_APPROVED', NOW(), NOW(), 1
);

SET @c3_cancellation_id = LAST_INSERT_ID();

INSERT INTO tbd_cancellation_items (
    cancellation_id, order_item_id, quantity, refund_amount, creation_date
) VALUES (
    @c3_cancellation_id, @c3_cancel_item_id, @c3_cancel_qty, @c3_refund_amount, NOW()
);

-- ----------------------------------------------------------------------------
-- PASO 8: El sistema actualiza la orden de compra y reintegra el stock cancelado
-- ----------------------------------------------------------------------------
UPDATE tb_products
SET current_stock = current_stock + @c3_cancel_qty,
    last_update = NOW()
WHERE id = @c3_cancel_prod_id;

UPDATE tb_buyer_orders
SET subtotal = @c3_subtotal_inicial - @c3_refund_amount,
    fulfillment_status = 'Preparing',
    last_update = NOW()
WHERE ID = @c3_order_id;
-- ----------------------------------------------------------------------------
-- PASO 9: El sistema realiza el reembolso parcial del monto del producto cancelado
-- ----------------------------------------------------------------------------
INSERT INTO tb_refunds (
    order_id, payment_id, return_id, cancellation_id,
    amount, refund_status, refund_date, status, creation_date
) VALUES (
    @c3_order_id, @c3_payment_id, NULL, @c3_cancellation_id,
    @c3_refund_amount, 'REFUNDED_PARTIAL', NOW(), 1, NOW()
);

-- ----------------------------------------------------------------------------
-- PASO 10 Y 11: El sistema realiza el envío y el cliente recibe el pedido en casa
-- ----------------------------------------------------------------------------
UPDATE tb_buyer_orders SET fulfillment_status = 'Sent', last_update = NOW() WHERE ID = @c3_order_id;

INSERT INTO tb_shipments (
    order_id, tracking_number, carrier_name, shipping_status,
    shipped_date, estimated_delivery_date, delivered_date, status, creation_date
) VALUES (
    @c3_order_id, CONCAT('TRK-MX-', @c3_order_id, '-01'), '99Minutos Express', 'DELIVERED',
    NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 1 DAY), 1, NOW()
);

UPDATE tb_buyer_orders SET fulfillment_status = 'Delivered', last_update = NOW() WHERE ID = @c3_order_id;

-- ----------------------------------------------------------------------------
-- VERIFICACIÓN DEL CASO 3
-- ----------------------------------------------------------------------------
SELECT * FROM tb_buyer_orders WHERE ID = @c3_order_id;
SELECT * FROM tbd_order_items WHERE seller_order_ID = @c3_order_id;
SELECT * FROM tb_order_cancellations WHERE id = @c3_cancellation_id;
SELECT * FROM tbd_cancellation_items WHERE cancellation_id = @c3_cancellation_id;
SELECT * FROM tb_refunds WHERE cancellation_id = @c3_cancellation_id;
SELECT * FROM tb_shipments WHERE order_id = @c3_order_id;