USE db_test;

-- ============================================================================
-- CONSULTAS DE VERIFICACIÓN - PRÁCTICA 04 (CASOS DE PRUEBA 1 AL 5)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- VISTA GENERAL: RESUMEN DE TODAS LAS ÓRDENES GENERADAS EN LA PRÁCTICA
-- ----------------------------------------------------------------------------
SELECT 
    bo.ID AS order_id,
    bo.seller_ID AS proveedor_id,
    bo.subtotal,
    bo.shipping_cost,
    (bo.subtotal + bo.shipping_cost) AS total_orden,
    bo.fulfillment_status AS estado_orden,
    HEX(bo.status) AS activo,
    bo.creation_date
FROM tb_buyer_orders bo
ORDER BY bo.ID ASC;

-- ============================================================================
-- CASO DE PRUEBA 1: "Compra Exitosa, sin modificaciones"
-- (Usuario nuevo, 5 productos, débito 16 dígitos, pago único, entrega en hogar)
-- ============================================================================
SELECT 
    u.id AS user_id,
    u.email,
    u.nick,
    p.given_names,
    p.family_names,
    upm.provider,
    upm.provider_method_ref AS tarjeta_16_digitos,
    ua.address_label AS domicilio_entrega
FROM tb_users u
INNER JOIN tb_people p ON u.id = p.user_ID
INNER JOIN tbd_user_payment_methods upm ON u.id = upm.user_ID
INNER JOIN tb_user_addresses ua ON u.id = ua.user_ID
WHERE upm.payment_method_type_ID = 1
ORDER BY u.id DESC
LIMIT 1;

SELECT 
    oi.seller_order_ID AS order_id,
    oi.product_ID,
    oi.product_name,
    oi.quantity,
    oi.unit_price,
    oi.subtotal
FROM tbd_order_items oi
WHERE oi.seller_order_ID = (
    SELECT pt.order_id 
    FROM tb_payment_transaction pt
    INNER JOIN tbd_user_payment_methods upm ON pt.user_id = upm.user_ID
    WHERE upm.payment_method_type_ID = 1
    ORDER BY pt.id ASC
    LIMIT 1
);

-- ============================================================================
-- CASO DE PRUEBA 2: "Detalles en el último pago, reclamación y reenvío"
-- (10 productos aleatorios, 6 pagos con 1 rechazado, reclamación y 2 envíos)
-- ============================================================================
SELECT 
    pt.id AS txn_id,
    pt.order_id,
    pt.transaction_reference,
    pt.amount,
    pt.transaction_status,
    py.payment_status
FROM tb_payment_transaction pt
INNER JOIN tb_payments py ON pt.id = py.transaction_id
WHERE pt.order_id = 3
ORDER BY pt.id ASC;

SELECT 
    r.id AS reclamacion_id,
    r.order_id,
    r.return_status,
    r.return_reason,
    ri.order_item_id,
    oi.product_name AS producto_danado,
    ri.quantity AS cantidad_reclamada,
    ri.condition_notes
FROM tb_returns r
INNER JOIN tbd_return_items ri ON r.id = ri.return_id
INNER JOIN tbd_order_items oi ON ri.order_item_id = oi.ID
WHERE r.order_id = 3;

SELECT 
    id AS envio_id,
    order_id,
    tracking_number,
    carrier_name,
    shipping_status,
    shipped_date,
    delivered_date
FROM tb_shipments
WHERE order_id = 3
ORDER BY id ASC;

-- ============================================================================
-- CASO DE PRUEBA 3: "Cancelación parcial, ajuste y reembolso parcial"
-- (3 productos misma categoría, "Casa Papas", Spin 16 dígitos, reembolso parcial)
-- ============================================================================
SELECT 
    bo.ID AS order_id,
    bo.subtotal,
    bo.shipping_cost,
    bo.fulfillment_status,
    ua.address_label AS domicilio_entrega,
    upm.label AS metodo_pago,
    upm.provider_method_ref AS tarjeta_spin
FROM tb_buyer_orders bo
INNER JOIN tb_payment_transaction pt ON bo.ID = pt.order_id
INNER JOIN tb_user_addresses ua ON pt.user_id = ua.user_ID AND ua.address_label = 'Casa Papas'
INNER JOIN tbd_user_payment_methods upm ON pt.user_id = upm.user_ID
WHERE bo.ID = 4
LIMIT 1;

SELECT 
    oc.id AS cancelacion_id,
    oc.order_id,
    oc.cancellation_status,
    ci.order_item_id,
    oi.product_name AS producto_cancelado,
    ci.quantity AS cantidad_cancelada,
    rf.amount AS monto_reembolsado,
    rf.refund_status
FROM tb_order_cancellations oc
INNER JOIN tbd_cancellation_items ci ON oc.id = ci.cancellation_id
INNER JOIN tbd_order_items oi ON ci.order_item_id = oi.ID
INNER JOIN tb_refunds rf ON oc.id = rf.cancellation_id
WHERE oc.order_id = 4;

-- ============================================================================
-- CASO DE PRUEBA 4: "Compra exitosa mismo proveedor en punto de recolección"
-- (3 productos del mismo proveedor, domicilio Hogar, SPEI 16 dígitos, Pickup)
-- ============================================================================
SELECT 
    oi.seller_order_ID AS order_id,
    oi.provider_ID AS mismo_proveedor_id,
    oi.product_ID,
    oi.product_name,
    oi.quantity,
    oi.subtotal
FROM tbd_order_items oi
WHERE oi.seller_order_ID = 7;

SELECT 
    bo.ID AS order_id,
    bo.fulfillment_status,
    upm.provider AS metodo_pago,
    upm.provider_method_ref AS cuenta_spei_16_digitos,
    s.tracking_number,
    s.carrier_name AS punto_entrega,
    s.shipping_status
FROM tb_buyer_orders bo
INNER JOIN tb_payment_transaction pt ON bo.ID = pt.order_id
INNER JOIN tbd_user_payment_methods upm ON pt.user_id = upm.user_ID
INNER JOIN tb_shipments s ON bo.ID = s.order_id
WHERE bo.ID = 7;

-- ============================================================================
-- CASO DE PRUEBA 5: "Compra fallida por falta de inventario y reasignación de cupón"
-- (1 producto, orden cancelada por stock insuficiente y cupón reactivado)
-- ============================================================================
SELECT 
    bo.ID AS order_id,
    bo.subtotal,
    bo.fulfillment_status AS estado_orden,
    HEX(bo.status) AS orden_activa,
    oc.cancellation_status,
    oc.cancellation_reason,
    rf.amount AS monto_reembolsado,
    rf.refund_status
FROM tb_buyer_orders bo
INNER JOIN tb_order_cancellations oc ON bo.ID = oc.order_id
INNER JOIN tb_refunds rf ON oc.id = rf.cancellation_id
WHERE bo.ID = 8;

SELECT 
    upm.ID AS cupon_id,
    upm.user_ID,
    upm.provider_method_ref AS codigo_cupon,
    upm.label AS estado_reasignacion,
    HEX(upm.status) AS cupon_activo_nuevamente
FROM tbd_user_payment_methods upm
INNER JOIN tb_payment_transaction pt ON upm.user_ID = pt.user_id
WHERE pt.order_id = 8;

-- ============================================================================
-- AUDITORÍA: ÚLTIMOS MOVIMIENTOS REGISTRADOS POR LOS TRIGGERS EN BITÁCORA
-- ============================================================================
SELECT 
    ID,
    table_operation,
    db_user,
    operation_date,
    table_name,
    table_description
FROM tb_logs
ORDER BY ID DESC
LIMIT 15;