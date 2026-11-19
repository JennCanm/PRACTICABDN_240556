USE db_test;

-- ============================================================================
-- CASO DE PRUEBA 2: "COMPRA CON DETALLES EN EL ÚLTIMO PAGO Y CON RECLAMACIÓN Y REENVÍO"
-- Conexión: app_web | Rol: buyer
-- ============================================================================

SET ROLE 'buyer';

-- ----------------------------------------------------------------------------
-- PASO 1: Usuario ya registrado crea 1 carrito con 10 productos aleatorios (1 a 5 uds)
-- ----------------------------------------------------------------------------
SET @c2_user_id = (
    SELECT id FROM tb_users 
    WHERE email <> 'carlos.mendoza.p4@gmail.com' 
    ORDER BY id ASC LIMIT 1 OFFSET 5
);

INSERT INTO tb_carts (user_ID, status, creation_date)
VALUES (@c2_user_id, b'1', NOW());

SET @c2_cart_id = LAST_INSERT_ID();

-- Insertamos 10 productos disponibles con proveedor válido y cantidad aleatoria entre 1 y 5
INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity, creation_date)
SELECT 
    @c2_cart_id,
    pup.user_ID,
    p.id,
    FLOOR(1 + (RAND() * 5)),
    NOW()
FROM tb_products p
INNER JOIN tbd_products_users_providers pup ON p.id = pup.product_ID
WHERE p.current_stock >= 15
ORDER BY RAND()
LIMIT 10;

-- ----------------------------------------------------------------------------
-- PASO 2: El usuario realiza la orden de compra
-- ----------------------------------------------------------------------------
SELECT SUM(ci.quantity * p.current_price) INTO @c2_subtotal
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c2_cart_id;

SET @c2_seller_id = (SELECT provider_ID FROM tbd_carts_items WHERE cart_ID = @c2_cart_id LIMIT 1);
SET @c2_shipping = 149.00;
SET @c2_total = @c2_subtotal + @c2_shipping;

INSERT INTO tb_buyer_orders (
    seller_ID, subtotal, shipping_cost, fulfillment_status, status, creation_date
) VALUES (
    @c2_seller_id, @c2_subtotal, @c2_shipping, 'Pending', b'1', NOW()
);

SET @c2_order_id = LAST_INSERT_ID();

INSERT INTO tbd_order_items (
    seller_order_ID, product_ID, provider_ID, product_name, quantity, unit_price, creation_date
)
SELECT 
    @c2_order_id, ci.product_ID, ci.provider_ID, p.name,
    ci.quantity, p.current_price, NOW()
FROM tbd_carts_items ci
INNER JOIN tb_products p ON ci.product_ID = p.id
WHERE ci.cart_ID = @c2_cart_id;

UPDATE tb_carts SET status = b'0', last_update = NOW() WHERE ID = @c2_cart_id;

-- ----------------------------------------------------------------------------
-- PASO 3: Registro de domicilio para envío distinto a su hogar ("Oficina / Trabajo")
-- ----------------------------------------------------------------------------
INSERT INTO tb_user_addresses (
    user_ID, address_label, recipient_name, recipient_phone,
    delivery_instructions, latitude, longitude, is_default, status, creation_date
) VALUES (
    @c2_user_id, 'Oficina / Trabajo', 'Recepción Corporativa Piso 3', '7762004455',
    'Entregar en caseta de vigilancia del edificio corporativo, horario 9am a 6pm',
    20.278900, -97.958400, 0, b'1', NOW()
);

SET @c2_address_id = LAST_INSERT_ID();

INSERT INTO tbd_address_components (address_ID, value, component_type, status, creation_date) VALUES
(@c2_address_id, 'Blvd. Benito Juárez #850, Int. 302', 'Calle y Número', b'1', NOW()),
(@c2_address_id, 'Col. La Rivera', 'Colonia', b'1', NOW()),
(@c2_address_id, 'Xicotepec de Juárez', 'Municipio', b'1', NOW()),
(@c2_address_id, 'Puebla', 'Estado', b'1', NOW()),
(@c2_address_id, '73080', 'Código Postal', b'1', NOW());

-- ----------------------------------------------------------------------------
-- PASO 4: Registro de método de pago (Tarjeta de Crédito 16 dígitos + historial)
-- ----------------------------------------------------------------------------
INSERT INTO tbd_user_payment_methods (
    user_ID, payment_method_type_ID, provider, provider_method_ref,
    label, last_four, is_default, status, creation_date
) VALUES (
    @c2_user_id, 2, 'Citibanamex Crédito Oro', '5412750188349910',
    'Tarjeta Crédito Trabajo/Personal', '9910', 1, b'1', NOW()
);

SET @c2_user_pm_id = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods_history (
    payment_method_ID, user_ID, payment_method_type_ID, provider,
    provider_method_ref, label, last_four, is_default, status, action_type, action_date
) VALUES (
    @c2_user_pm_id, @c2_user_id, 2, 'Citibanamex Crédito Oro',
    '5412750188349910', 'Tarjeta Crédito Trabajo/Personal', '9910', 1, b'1', 'INSERT', NOW()
);

-- ----------------------------------------------------------------------------
-- PASO 5 Y 6: 6 pagos mensuales (5 autorizados + 6to rechazado por límite excedido)
-- ----------------------------------------------------------------------------
SET @c2_installment = ROUND(@c2_total / 6, 2);
SET @c2_last_installment = @c2_total - (@c2_installment * 5);

-- Mensualidad 1 (Autorizada)
INSERT INTO tb_payment_transaction (order_id, user_id, payment_method_id, transaction_reference, amount, currency, transaction_status, transaction_date, status)
VALUES (@c2_order_id, @c2_user_id, 2, CONCAT('TXN-C2-M1-', UUID_SHORT()), @c2_installment, 'MXN', 'AUTHORIZED', NOW(), 1);
INSERT INTO tb_payments (order_id, transaction_id, amount, payment_status, payment_date, status, creation_date)
VALUES (@c2_order_id, LAST_INSERT_ID(), @c2_installment, 'PAID', NOW(), 1, NOW());

-- Mensualidad 2 (Autorizada)
INSERT INTO tb_payment_transaction (order_id, user_id, payment_method_id, transaction_reference, amount, currency, transaction_status, transaction_date, status)
VALUES (@c2_order_id, @c2_user_id, 2, CONCAT('TXN-C2-M2-', UUID_SHORT()), @c2_installment, 'MXN', 'AUTHORIZED', DATE_ADD(NOW(), INTERVAL 1 MONTH), 1);
INSERT INTO tb_payments (order_id, transaction_id, amount, payment_status, payment_date, status, creation_date)
VALUES (@c2_order_id, LAST_INSERT_ID(), @c2_installment, 'PAID', DATE_ADD(NOW(), INTERVAL 1 MONTH), 1, NOW());

-- Mensualidad 3 (Autorizada)
INSERT INTO tb_payment_transaction (order_id, user_id, payment_method_id, transaction_reference, amount, currency, transaction_status, transaction_date, status)
VALUES (@c2_order_id, @c2_user_id, 2, CONCAT('TXN-C2-M3-', UUID_SHORT()), @c2_installment, 'MXN', 'AUTHORIZED', DATE_ADD(NOW(), INTERVAL 2 MONTH), 1);
INSERT INTO tb_payments (order_id, transaction_id, amount, payment_status, payment_date, status, creation_date)
VALUES (@c2_order_id, LAST_INSERT_ID(), @c2_installment, 'PAID', DATE_ADD(NOW(), INTERVAL 2 MONTH), 1, NOW());

-- Mensualidad 4 (Autorizada)
INSERT INTO tb_payment_transaction (order_id, user_id, payment_method_id, transaction_reference, amount, currency, transaction_status, transaction_date, status)
VALUES (@c2_order_id, @c2_user_id, 2, CONCAT('TXN-C2-M4-', UUID_SHORT()), @c2_installment, 'MXN', 'AUTHORIZED', DATE_ADD(NOW(), INTERVAL 3 MONTH), 1);
INSERT INTO tb_payments (order_id, transaction_id, amount, payment_status, payment_date, status, creation_date)
VALUES (@c2_order_id, LAST_INSERT_ID(), @c2_installment, 'PAID', DATE_ADD(NOW(), INTERVAL 3 MONTH), 1, NOW());

-- Mensualidad 5 (Autorizada)
INSERT INTO tb_payment_transaction (order_id, user_id, payment_method_id, transaction_reference, amount, currency, transaction_status, transaction_date, status)
VALUES (@c2_order_id, @c2_user_id, 2, CONCAT('TXN-C2-M5-', UUID_SHORT()), @c2_installment, 'MXN', 'AUTHORIZED', DATE_ADD(NOW(), INTERVAL 4 MONTH), 1);
INSERT INTO tb_payments (order_id, transaction_id, amount, payment_status, payment_date, status, creation_date)
VALUES (@c2_order_id, LAST_INSERT_ID(), @c2_installment, 'PAID', DATE_ADD(NOW(), INTERVAL 4 MONTH), 1, NOW());

-- Mensualidad 6 (RECHAZADA por límite excedido de crédito)
INSERT INTO tb_payment_transaction (order_id, user_id, payment_method_id, transaction_reference, amount, currency, transaction_status, transaction_date, status)
VALUES (@c2_order_id, @c2_user_id, 2, CONCAT('TXN-C2-M6-DECLINED-', UUID_SHORT()), @c2_last_installment, 'MXN', 'DECLINED - Limite excedido de credito', DATE_ADD(NOW(), INTERVAL 5 MONTH), 0);
INSERT INTO tb_payments (order_id, transaction_id, amount, payment_status, payment_date, status, creation_date)
VALUES (@c2_order_id, LAST_INSERT_ID(), @c2_last_installment, 'FAILED', DATE_ADD(NOW(), INTERVAL 5 MONTH), 0, NOW());

-- ----------------------------------------------------------------------------
-- PASO 7 Y 8: Procesamiento de orden como atendida, descuento de stock y entrega
-- ----------------------------------------------------------------------------
UPDATE tb_buyer_orders SET fulfillment_status = 'Accepted', last_update = NOW() WHERE ID = @c2_order_id;

UPDATE tb_products p
INNER JOIN tbd_order_items oi ON p.id = oi.product_ID
SET p.current_stock = p.current_stock - oi.quantity,
    p.last_update = NOW()
WHERE oi.seller_order_ID = @c2_order_id;

UPDATE tb_buyer_orders SET fulfillment_status = 'Sent', last_update = NOW() WHERE ID = @c2_order_id;

INSERT INTO tb_shipments (
    order_id, tracking_number, carrier_name, shipping_status,
    shipped_date, estimated_delivery_date, delivered_date, status, creation_date
) VALUES (
    @c2_order_id, CONCAT('TRK-MX-', @c2_order_id, '-01'), 'Estafeta Carga', 'DELIVERED',
    NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), 1, NOW()
);

UPDATE tb_buyer_orders SET fulfillment_status = 'Delivered', last_update = NOW() WHERE ID = @c2_order_id;

-- ----------------------------------------------------------------------------
-- PASO 9: El usuario reclama la devolución de 1 producto que llegó dañado
-- ----------------------------------------------------------------------------
SET @c2_damaged_item_id = (SELECT ID FROM tbd_order_items WHERE seller_order_ID = @c2_order_id LIMIT 1);
SET @c2_damaged_prod_id = (SELECT product_ID FROM tbd_order_items WHERE ID = @c2_damaged_item_id);

INSERT INTO tb_returns (
    order_id, user_id, return_reason, return_status, requested_date, processed_date, status
) VALUES (
    @c2_order_id, @c2_user_id,
    'Producto recibido con empaque roto y daño físico en carcasa; se solicita cambio por unidad nueva',
    'APPROVED_REPLACEMENT', NOW(), NOW(), 1
);

SET @c2_return_id = LAST_INSERT_ID();

INSERT INTO tbd_return_items (
    return_id, order_item_id, quantity, condition_notes, creation_date
) VALUES (
    @c2_return_id, @c2_damaged_item_id, 1, 'Carcasa estrellada al abrir paquete en oficina', NOW()
);

-- ----------------------------------------------------------------------------
-- PASO 10: El sistema realiza el reenvío del producto en buenas condiciones
-- ----------------------------------------------------------------------------
-- Descontamos 1 unidad adicional del inventario por la reposición enviada
UPDATE tb_products
SET current_stock = current_stock - 1,
    last_update = NOW()
WHERE id = @c2_damaged_prod_id;

INSERT INTO tb_shipments (
    order_id, tracking_number, carrier_name, shipping_status,
    shipped_date, estimated_delivery_date, delivered_date, status, creation_date
) VALUES (
    @c2_order_id, CONCAT('TRK-MX-', @c2_order_id, '-REPLACEMENT'), 'Estafeta Express Reposicion', 'DELIVERED',
    DATE_ADD(NOW(), INTERVAL 3 DAY), DATE_ADD(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 4 DAY), 1, NOW()
);

-- ----------------------------------------------------------------------------
-- VERIFICACIÓN DEL CASO 2
-- ----------------------------------------------------------------------------
SELECT * FROM tb_buyer_orders WHERE ID = @c2_order_id;
SELECT * FROM tbd_order_items WHERE seller_order_ID = @c2_order_id;
SELECT id, transaction_reference, amount, transaction_status, status FROM tb_payment_transaction WHERE order_id = @c2_order_id;
SELECT id, transaction_id, amount, payment_status, status FROM tb_payments WHERE order_id = @c2_order_id;
SELECT * FROM tb_returns WHERE id = @c2_return_id;
SELECT * FROM tbd_return_items WHERE return_id = @c2_return_id;
SELECT * FROM tb_shipments WHERE order_id = @c2_order_id;