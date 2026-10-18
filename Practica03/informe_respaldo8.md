# Informe tecnico - respaldo8.sql

- Dialecto y motor: MySQL 8.0.46; restaurado correctamente en MySQL Community Server 8.0.46.
- Metodo: restauracion en instancia temporal aislada; SELECT COUNT(*) para cada tabla fisica. Todos verificados.
- Suma de filas: 5,422 (no entidades unicas).
- Inventario: 9 tablas fisicas, 5 vistas, 60 columnas, 9 constraints FK, 12 triggers.
- DML: 6 INSERT; sin INSERT IGNORE, REPLACE, UPDATE ni DELETE. Los triggers se ejecutaron durante la restauracion.

## Tablas y conteos

| Tabla | Columnas | COUNT(*) |
|---|---:|---:|
| `consulta_verificacion` | 7 | 3 |
| `tb_carts` | 5 | 0 |
| `tb_categories` | 7 | 100 |
| `tb_logs` | 7 | 210 |
| `tb_products` | 9 | 5,010 |
| `tb_users` | 8 | 9 |
| `tbd_products_categories` | 5 | 90 |
| `tbd_products_users_providers` | 7 | 0 |
| `tbd_users_wishlist_products` | 5 | 0 |

## Relaciones
- tb_carts_ibfk_1: tb_carts.user_ID -> tb_users.id
- fk_categories_superior: tb_categories.sup_id_category -> tb_categories.id
- fk_superior_category: tb_categories.sup_id_category -> tb_categories.id
- fk_pc_categories: tbd_products_categories.category_ID -> tb_categories.id
- fk_pc_products: tbd_products_categories.product_ID -> tb_products.id
- fk_pup_products: tbd_products_users_providers.product_ID -> tb_products.id
- fk_pup_users: tbd_products_users_providers.user_ID -> tb_users.id
- fk_products3: tbd_users_wishlist_products.product_ID -> tb_products.id
- fk_user2: tbd_users_wishlist_products.user_ID -> tb_users.id
- Inferida (FK no declarada): tb_logs.table_name contiene tbd_products_categories.

## Vistas
- vw_total_products_by_category
- vw_trazabilidad_categorias
- vw_trazabilidad_categorizacion_productos
- vw_trazabilidad_productos
- vw_trazabilidad_usuarios

## Anomalias y limites
- tb_categories.sup_id_category tiene dos constraints FK hacia tb_categories.id; ambas se conservan.
- tbd_products_categories, tbd_products_users_providers y tbd_users_wishlist_products son asociativas por PK compuesta y FK.
- Conteos pendientes: 0. No se afirma herencia ni semantica no documentada.