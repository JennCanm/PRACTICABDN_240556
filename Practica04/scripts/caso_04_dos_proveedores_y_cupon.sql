USE db_test;

-- ============================================================================
-- CASO DE PRUEBA 4: "COMPRA MULTIPROVEEDOR, CAMBIO DE DOMICILIO Y CUPÓN DE REGALO"
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PASO 1: Usuario registrado arma carrito con 4 productos de 2 proveedores distintos
-- ----------------------------------------------------------------------------
SET @c4_user_id = (
    SELECT id FROM tb_users 
    WHERE email <> 'carlos.mendoza.p4@gmail.com' 
    ORDER BY id ASC LIMIT 1 OFFSET 15
);

SET @c4_prov_a = (SELECT DISTINCT user_ID FROM tbd_products_users_providers ORDER BY user_ID ASC LIMIT 1 OFFSET 0);
SET @c4_prov_b = (SELECT DISTINCT user_ID FROM tbd_products_users_providers ORDER BY user_ID ASC LIMIT 1 OFFSET 1);

INSERT INTO tb_carts (user_ID, status, creation_date)
VALUES (@c4_user_id, b'1', NOW());

SET @c4_cart_id = LAST_INSERT_ID();

-- 2 productos del Proveedor A
INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity, creation_date)
SELECT @c4_cart_id, pup.user_ID, p.id, 2, NOW()
FROM tb_products p
INNER JOIN tbd_products_users_providers pup ON p.id = pup.product_ID
WHERE pup.user_ID = @c4_prov_a AND p.current_stock >= 15
LIMIT 2;

-- 2 productos del Proveedor B
INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity, creation_date)
SELECT @c4_cart_id, pup.user_ID, p.id, 1, NOW()
FROM tb_products p
INNER JOIN tbd_products_users_providers pup ON p.id = pup.product_ID
WHERE pup.user_ID = @c4_prov_b AND p.current_stock >= 15
LIMIT 2;

-- ----------------------------------------------------------------------------
-- PASO 2: Generación de la orden de compra y cierre de carrito
-- ----------------------------------------------------------------------------
SELECT SUM(ci.quantity * p.current_price) INTO @c4_subtotal
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c4_cart_id;

SET @c4_shipping = 180.00;
SET @c4_coupon_discount = 500.00;
SET @c4_total_pagar = GREATEST((@c4_subtotal + @c4_shipping) - @c4_coupon_discount, 50.00);

INSERT INTO tb_buyer_orders (
    seller_ID, subtotal, shipping_cost, fulfillment_status, status, creation_date
) VALUES (
    @c4_prov_a, @c4_subtotal, @c4_shipping, 'Pending', b'1', NOW()
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
-- PASO 3: Registro de domicilio inicial y actualización/cambio antes del envío
-- ----------------------------------------------------------------------------
INSERT INTO tb_user_addresses (
    user_ID, address_label, recipient_name, recipient_phone,
    delivery_instructions, latitude, longitude, is_default, status, creation_date
) VALUES (
    @c4_user_id, 'Departamento Anterior', 'Fernanda López Silva', '7764007788',
    'Edificio B Depto 4', 20.271000, -97.960100, 0, b'0', NOW()
);

INSERT INTO tb_user_addresses (
    user_ID, address_label, recipient_name, recipient_phone,
    delivery_instructions, latitude, longitude, is_default, status, creation_date
) VALUES (
    @c4_user_id, 'Casa Nueva Actualizada', 'Fernanda López Silva', '7764007788',
    'Casa esquina con reja blanca, dejar en recepción si no estoy', 20.279500, -97.955200, 1, b'1', NOW()
);

SET @c4_address_id = LAST_INSERT_ID();

INSERT INTO tbd_address_components (address_ID, value, component_type, status, creation_date) VALUES
(@c4_address_id, 'Privada de las Flores #88', 'Calle y Número', b'1', NOW()),
(@c4_address_id, 'Col. Los Pinos', 'Colonia', b'1', NOW()),
(@c4_address_id, 'Xicotepec de Juárez', 'Municipio', b'1', NOW()),
(@c4_address_id, 'Puebla', 'Estado', b'1', NOW()),
(@c4_address_id, '73080', 'Código Postal', b'1', NOW());

-- ----------------------------------------------------------------------------
-- PASO 4: Registro de métodos de pago (Cupón de Regalo + Transferencia SPEI)
-- ----------------------------------------------------------------------------
INSERT INTO tbd_user_payment_methods (
    user_ID, payment_method_type_ID, provider, provider_method_ref,
    label, last_four, is_default, status, creation_date
) VALUES (
    @c4_user_id, 5, 'Cupón Promocional VIP', 'GIFT2026PROMO500',
    'Cupón Regalo $500 MXN', 'O500', 0, b'1', NOW()
);

SET @c4_pm_coupon_id = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods_history (
    payment_method_ID, user_ID, payment_method_type_ID, provider,
    provider_method_ref, label, last_four, is_default, status, action_type, action_date
) VALUES (
    @c4_pm_coupon_id, @c4_user_id, 5, 'Cupón Promocional VIP',
    'GIFT2026PROMO500', 'Cupón Regalo $500 MXN', 'O500', 0, b'1', 'INSERT', NOW()
);

INSERT INTO tbd_user_payment_methods (
    user_ID, payment_method_type_ID, provider, provider_method_ref,
    label, last_four, is_default, status, creation_date
) VALUES (
    @c4_user_id, 4, 'BBVA SPEI CLABE', '0121800019482736',
    'Cuenta SPEI Principal', '2736', 1, b'1', NOW()
);

SET @c4_pm_spei_id = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods_history (
    payment_method_ID, user_ID, payment_method_type_ID, provider,
    provider_method_ref, label, last_four, is_default, status, action_type, action_date
) VALUES (
    @c4_pm_spei_id, @c4_user_id, 4, 'BBVA SPEI CLABE',
    '0121800019482736', 'Cuenta SPEI Principal', '2736', 1, b'1', 'INSERT', NOW()
);

-- ----------------------------------------------------------------------------
-- PASO 5: Pago mixto autorizado (Cupón $500 + SPEI por el remanente)
-- ----------------------------------------------------------------------------
INSERT INTO tb_payment_transaction (
    order_id, user_id, payment_method_id, transaction_reference,
    amount, currency, transaction_status, transaction_date, status
) VALUES (
    @c4_order_id, @c4_user_id, 5, CONCAT('TXN-C4-COUPON-', UUID_SHORT()),
    @c4_coupon_discount, 'MXN', 'AUTHORIZED', NOW(), 1
);
INSERT INTO tb_payments (order_id, transaction_id, amount, payment_status, payment_date, status, creation_date)
VALUES (@c4_order_id, LAST_INSERT_ID(), @c4_coupon_discount, 'PAID', NOW(), 1, NOW());

INSERT INTO tb_payment_transaction (
    order_id, user_id, payment_method_id, transaction_reference,
    amount, currency, transaction_status, transaction_date, status
) VALUES (
    @c4_order_id, @c4_user_id, 4, CONCAT('TXN-C4-SPEI-', UUID_SHORT()),
    @c4_total_pagar, 'MXN', 'AUTHORIZED', NOW(), 1
);
INSERT INTO tb_payments (order_id, transaction_id, amount, payment_status, payment_date, status, creation_date)
VALUES (@c4_order_id, LAST_INSERT_ID(), @c4_total_pagar, 'PAID', NOW(), 1, NOW());

-- ----------------------------------------------------------------------------
-- PASO 6: Procesamiento de orden, descuento de stock y 2 envíos (uno por proveedor)
-- ----------------------------------------------------------------------------
UPDATE tb_buyer_orders SET fulfillment_status = 'Accepted', last_update = NOW() WHERE ID = @c4_order_id;

UPDATE tb_products p
INNER JOIN tbd_order_items oi ON p.id = oi.product_ID
SET p.current_stock = p.current_stock - oi.quantity,
    p.last_update = NOW()
WHERE oi.seller_order_ID = @c4_order_id;

UPDATE tb_buyer_orders SET fulfillment_status = 'Sent', last_update = NOW() WHERE ID = @c4_order_id;

INSERT INTO tb_shipments (
    order_id, tracking_number, carrier_name, shipping_status,
    shipped_date, estimated_delivery_date, delivered_date, status, creation_date
) VALUES (
    @c4_order_id, CONCAT('TRK-MX-', @c4_order_id, '-PROVA'), 'FedEx Nacional', 'DELIVERED',
    NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 1 DAY), 1, NOW()
);

INSERT INTO tb_shipments (
    order_id, tracking_number, carrier_name, shipping_status,
    shipped_date, estimated_delivery_date, delivered_date, status, creation_date
) VALUES (
    @c4_order_id, CONCAT('TRK-MX-', @c4_order_id, '-PROVB'), 'Redpack Express', 'DELIVERED',
    NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), 1, NOW()
);

UPDATE tb_buyer_orders SET fulfillment_status = 'Delivered', last_update = NOW() WHERE ID = @c4_order_id;

-- ----------------------------------------------------------------------------
-- VERIFICACIÓN DEL CASO 4
-- ----------------------------------------------------------------------------
SELECT * FROM tb_buyer_orders WHERE ID = @c4_order_id;
SELECT ID, seller_order_ID, product_ID, provider_ID, product_name, quantity, subtotal FROM tbd_order_items WHERE seller_order_ID = @c4_order_id;
SELECT id, transaction_reference, amount, transaction_status FROM tb_payment_transaction WHERE order_id = @c4_order_id;
SELECT * FROM tb_shipments WHERE order_id = @c4_order_id;