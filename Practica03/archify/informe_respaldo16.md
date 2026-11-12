# Informe técnico — db_test (respaldo16)

## Fuente y alcance

Fuente única: `respaldo16.sql`, dump MySQL 8.0.36. Este informe describe definiciones incluidas en el volcado; no valida la ejecución en un servidor.

## Resumen del esquema

- Tablas: **26**
- Columnas: **214**
- Relaciones de clave foránea: **41**
- Filas incluidas en los INSERT del dump: **140,570**
- Rutinas extraídas: **75** (72 triggers, 3 procedimientos, 0 funciones, 0 eventos).

## Tablas y relaciones

- **tb_buyer_orders** (8 columnas; PK: ID; 1 FK)
- **tb_carts** (5 columnas; PK: ID; 1 FK)
- **tb_categories** (7 columnas; PK: id; 2 FK)
- **tb_logs** (9 columnas; PK: ID; 1 FK)
- **tb_order_cancellations** (8 columnas; PK: id; 2 FK)
- **tb_payment_methods** (7 columnas; PK: id; 1 FK)
- **tb_payment_transaction** (10 columnas; PK: id; 2 FK)
- **tb_payments** (9 columnas; PK: id; 2 FK)
- **tb_people** (12 columnas; PK: person_ID; 1 FK)
- **tb_products** (9 columnas; PK: id; 0 FK)
- **tb_refunds** (11 columnas; PK: id; 4 FK)
- **tb_returns** (8 columnas; PK: id; 2 FK)
- **tb_shipments** (11 columnas; PK: id; 1 FK)
- **tb_user_addresses** (12 columnas; PK: ID; 1 FK)
- **tb_users** (8 columnas; PK: id; 0 FK)
- **tbc_payment_methods_types** (6 columnas; PK: ID; 0 FK)
- **tbd_address_components** (8 columnas; PK: ID; 2 FK)
- **tbd_cancellation_items** (6 columnas; PK: id; 2 FK)
- **tbd_carts_items** (5 columnas; PK: cart_ID, provider_ID, product_ID; 3 FK)
- **tbd_order_items** (9 columnas; PK: ID; 3 FK)
- **tbd_products_categories** (5 columnas; PK: product_ID, category_ID; 2 FK)
- **tbd_products_users_providers** (7 columnas; PK: user_ID, product_ID; 2 FK)
- **tbd_return_items** (6 columnas; PK: id; 2 FK)
- **tbd_user_payment_methods** (11 columnas; PK: ID; 2 FK)
- **tbd_user_payment_methods_history** (12 columnas; PK: history_ID; 0 FK)
- **tbd_users_wishlist_products** (5 columnas; PK: user_ID, product_ID; 2 FK)

### Integridad referencial

Relaciones extraídas de las cláusulas FOREIGN KEY:

- `tb_buyer_orders.seller_ID` → `tb_users.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_carts.user_ID` → `tb_users.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_categories.sup_id_category` → `tb_categories.id`; ON DELETE SET NULL, ON UPDATE CASCADE.
- `tb_categories.sup_id_category` → `tb_categories.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_logs.app_user_id` → `tb_users.id`; ON DELETE SET NULL, ON UPDATE CASCADE.
- `tb_order_cancellations.order_id` → `tb_buyer_orders.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_order_cancellations.user_id` → `tb_users.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_payment_methods.payment_method_type_id` → `tbc_payment_methods_types.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_payment_transaction.order_id` → `tb_buyer_orders.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_payment_transaction.user_id` → `tb_users.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_payments.order_id` → `tb_buyer_orders.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_payments.transaction_id` → `tb_payment_transaction.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_people.user_ID` → `tb_users.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_refunds.cancellation_id` → `tb_order_cancellations.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_refunds.order_id` → `tb_buyer_orders.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_refunds.payment_id` → `tb_payments.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_refunds.return_id` → `tb_returns.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_returns.order_id` → `tb_buyer_orders.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_returns.user_id` → `tb_users.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_shipments.order_id` → `tb_buyer_orders.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tb_user_addresses.user_ID` → `tb_users.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_address_components.address_ID` → `tb_user_addresses.ID`; ON DELETE RESTRICT, ON UPDATE NO ACTION.
- `tbd_address_components.address_ID, address_sup_ID` → `tbd_address_components.address_ID, ID`; ON DELETE RESTRICT, ON UPDATE NO ACTION.
- `tbd_cancellation_items.cancellation_id` → `tb_order_cancellations.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_cancellation_items.order_item_id` → `tbd_order_items.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_carts_items.cart_ID` → `tb_carts.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_carts_items.provider_ID` → `tbd_products_users_providers.user_ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_carts_items.product_ID` → `tbd_products_users_providers.product_ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_order_items.seller_order_ID` → `tb_buyer_orders.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_order_items.product_ID` → `tbd_products_users_providers.product_ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_order_items.provider_ID` → `tbd_products_users_providers.user_ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_products_categories.category_ID` → `tb_categories.id`; ON DELETE CASCADE ON, ON UPDATE CASCADE.
- `tbd_products_categories.product_ID` → `tb_products.id`; ON DELETE CASCADE ON, ON UPDATE CASCADE.
- `tbd_products_users_providers.product_ID` → `tb_products.id`; ON DELETE CASCADE ON, ON UPDATE CASCADE.
- `tbd_products_users_providers.user_ID` → `tb_users.id`; ON DELETE CASCADE ON, ON UPDATE CASCADE.
- `tbd_return_items.order_item_id` → `tbd_order_items.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_return_items.return_id` → `tb_returns.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_user_payment_methods.user_ID` → `tb_users.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_user_payment_methods.payment_method_type_ID` → `tbc_payment_methods_types.ID`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_users_wishlist_products.product_ID` → `tb_products.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.
- `tbd_users_wishlist_products.user_ID` → `tb_users.id`; ON DELETE NO ACTION, ON UPDATE NO ACTION.

El volcado desactiva temporalmente la comprobación de FK durante la carga. Se observan referencias a tablas que aparecen definidas después en el archivo, lo que depende de ese orden de carga y de la reactivación final de `FOREIGN_KEY_CHECKS`.

## Anexo técnico: rutinas

### PROCEDURE `sp_generate_test_users`

- DEFINER: `root@localhost`
- Parámetros: IN p_scenario VARCHAR(20), IN p_password VARCHAR(255)
- Tablas referenciadas por análisis estático: `tb_people`, `tb_users`
- Control transaccional explícito: sí
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### PROCEDURE `sp_restore_product`

- DEFINER: `root@localhost`
- Parámetros: IN p_product_id INT UNSIGNED
- Tablas referenciadas por análisis estático: `tb_products`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### PROCEDURE `sp_soft_delete_product`

- DEFINER: `root@localhost`
- Parámetros: IN p_product_id INT UNSIGNED
- Tablas referenciadas por análisis estático: `tb_products`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_buyer_orders_before_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_buyer_orders`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_buyer_orders_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_buyer_orders`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_buyer_orders_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_buyer_orders`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_carts_before_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_carts`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_carts_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_carts`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_carts_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_carts`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbc_categories_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_categories`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbc_categories_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_categories`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbc_categories_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_categories`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_order_cancellations_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_order_cancellations`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_order_cancellations_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_order_cancellations`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_order_cancellations_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_order_cancellations`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_payment_methods_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_payment_methods`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_payment_methods_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_payment_methods`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_payment_methods_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_payment_methods`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_payment_transaction_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_payment_transaction`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_payment_transaction_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_payment_transaction`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_payment_transaction_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_payment_transaction`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_payments_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_payments`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_payments_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_payments`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_payments_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_payments`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_people_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_logs`, `tb_people`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_people_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_logs`, `tb_people`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_people_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_logs`, `tb_people`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trq_products_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_products`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trq_products_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_products`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trq_products_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_products`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_refunds_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_refunds`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_refunds_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_refunds`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_refunds_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_refunds`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_returns_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_returns`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_returns_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_returns`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_returns_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_returns`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_shipments_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_shipments`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_shipments_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_shipments`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_shipments_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_shipments`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_user_addresses_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_logs`, `tb_user_addresses`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_user_addresses_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_logs`, `tb_user_addresses`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tb_user_addresses_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_logs`, `tb_user_addresses`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trq_users_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_users`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trq_users_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_users`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trq_users_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_users`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbc_payment_methods_types_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbc_payment_methods_types`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbc_payment_methods_types_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbc_payment_methods_types`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbc_payment_methods_types_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbc_payment_methods_types`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_address_components_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_logs`, `tbd_address_components`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_address_components_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_logs`, `tbd_address_components`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_address_components_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tb_logs`, `tbd_address_components`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_cancellation_items_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_cancellation_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_cancellation_items_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_cancellation_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_cancellation_items_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_cancellation_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_carts_items_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_carts_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_carts_items_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_carts_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_carts_items_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_carts_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_order_items_before_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_order_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_order_items_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_order_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_order_items_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_order_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_products_categories_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_products_categories`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_products_categories_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_products_categories`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_products_categories_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_products_categories`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_providers_before_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_products_users_providers`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_providers_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_products_users_providers`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_providers_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_products_users_providers`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_return_items_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_return_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_return_items_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_return_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_return_items_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_return_items`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_user_payment_methods_after_insert`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_user_payment_methods`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_user_payment_methods_au`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_user_payment_methods`, `tbd_user_payment_methods_history`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_tbd_user_payment_methods_ad`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_user_payment_methods`, `tbd_user_payment_methods_history`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_wishlist_before_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_users_wishlist_products`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_wishlist_after_update`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_users_wishlist_products`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

### TRIGGER `trg_wishlist_after_delete`

- DEFINER: `root@localhost`
- Parámetros: no aplica/no extraídos
- Tablas referenciadas por análisis estático: `tbd_users_wishlist_products`
- Control transaccional explícito: no detectado
- Lógica: código incluido en el inventario; la descripción funcional se debe leer junto con el cuerpo SQL.

## Complejidad y advertencias

La lógica está fuertemente distribuida en triggers (72 detectados), además de procedimientos. Las escrituras pueden activar efectos secundarios y auditorías que no son visibles desde una llamada aislada.

- `DEFINER=root@localhost` requiere que esa cuenta exista y tenga privilegios compatibles al restaurar o invocar rutinas.
- Las tablas impactadas se infieren por nombres de tabla citados en el SQL; SQL dinámico o referencias indirectas pueden no quedar cubiertos.
- La marca de transacción indica solo sentencias explícitas START TRANSACTION, COMMIT, ROLLBACK o SAVEPOINT; no detectarlas no implica atomicidad o ausencia de transacción de sesión.
- En el esquema hay más de una FK declarada sobre `tb_categories.sup_id_category`; revisar si se esperaba esa duplicidad.
- El dump contiene vistas y objetos de privilegios/dependencias externas de MySQL; la documentación EER aquí abarca las tablas base y sus FK.

## Artefactos

- `modelo_eer_diccionario_respaldo16.html`: MER navegable, diccionario filtrable y visor de rutinas.
- `procedimientos_respaldo16.json`: inventario estructurado con cuerpo fuente.

## Filas cargadas en el dump

Los siguientes conteos corresponden a las tuplas incluidas en sentencias `INSERT INTO ... VALUES` del propio respaldo; las tablas sin sentencia INSERT se muestran con cero. No representan conteos consultados en un servidor en vivo.

| Tabla | Filas |
|---|---:|
| `tb_buyer_orders` | 0 |
| `tb_carts` | 0 |
| `tb_categories` | 100 |
| `tb_logs` | 76,339 |
| `tb_order_cancellations` | 0 |
| `tb_payment_methods` | 0 |
| `tb_payment_transaction` | 0 |
| `tb_payments` | 0 |
| `tb_people` | 20,021 |
| `tb_products` | 12,010 |
| `tb_refunds` | 0 |
| `tb_returns` | 0 |
| `tb_shipments` | 0 |
| `tb_user_addresses` | 0 |
| `tb_users` | 20,030 |
| `tbc_payment_methods_types` | 0 |
| `tbd_address_components` | 0 |
| `tbd_cancellation_items` | 0 |
| `tbd_carts_items` | 0 |
| `tbd_order_items` | 0 |
| `tbd_products_categories` | 12,070 |
| `tbd_products_users_providers` | 0 |
| `tbd_return_items` | 0 |
| `tbd_user_payment_methods` | 0 |
| `tbd_user_payment_methods_history` | 0 |
| `tbd_users_wishlist_products` | 0 |
