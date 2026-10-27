# Informe de inspección — `respaldo12.sql`

## Resumen

El archivo es un volcado de `mysqldump 10.13` para **MySQL 8.0.36**, base `db_test`. El análisis identificó **17 tablas físicas**, **18 vistas**, **136 columnas**, **22 restricciones de clave foránea declaradas** y **55,505 filas confirmadas** en los lotes de datos del volcado.

| Objeto | Columnas | Filas confirmadas | FK declaradas |
|---|---:|---:|---:|
| `tb_buyer_orders` | 8 | 0 | 1 |
| `tb_carts` | 5 | 0 | 1 |
| `tb_categories` | 7 | 100 | 2 |
| `tb_logs` | 7 | 25,254 | 0 |
| `tb_people` | 12 | 12,521 | 1 |
| `tb_products` | 9 | 5,010 | 0 |
| `tb_user_addresses` | 12 | 0 | 1 |
| `tb_users` | 8 | 12,530 | 0 |
| `tbc_payment_methods_types` | 6 | 0 | 0 |
| `tbd_address_components` | 8 | 0 | 2 |
| `tbd_carts_items` | 5 | 0 | 3 |
| `tbd_order_items` | 9 | 0 | 3 |
| `tbd_products_categories` | 5 | 90 | 2 |
| `tbd_products_users_providers` | 7 | 0 | 2 |
| `tbd_user_payment_methods` | 11 | 0 | 2 |
| `tbd_user_payment_methods_history` | 12 | 0 | 0 |
| `tbd_users_wishlist_products` | 5 | 0 | 2 |

## Método de conteo

Se leyeron las sentencias `CREATE TABLE` y se recorrieron los `INSERT ... VALUES` contando tuplas SQL de nivel superior, respetando comillas, escapes y paréntesis anidados. Se sumaron los lotes por tabla. Las sentencias `INSERT` en cuerpos de triggers se excluyeron porque describen acciones futuras y no filas insertadas al restaurar el respaldo. No se encontraron instrucciones `UPDATE` o `DELETE` de datos independientes en el volcado. Por eso, los conteos corresponden a filas proporcionadas explícitamente por los `INSERT` del archivo, no a una ejecución en un servidor.

## Estructura y hallazgos

- Todas las tablas físicas usan el motor y las opciones SQL registradas por tabla en `metadatos_respaldo12.json`; allí también constan columnas, tipos originales, nulabilidad, valores predeterminados, `AUTO_INCREMENT`, `ON UPDATE`, enumeraciones, índices, claves y atributos SQL sin normalizar.
- El respaldo incluye 18 objetos `VIEW` y definiciones de triggers. Las vistas se inventariaron por nombre; sus definiciones permanecen en el archivo SQL original.
- Las claves foráneas se tomaron únicamente de restricciones `FOREIGN KEY` declaradas. Las columnas opcionales se determinan por su nulabilidad.
- La cardinalidad `1:1` se deriva cuando las columnas FK también tienen una restricción única; en los demás casos declarados, la relación de registros es de muchos a uno desde la tabla que contiene la FK hacia la tabla referenciada. Las tablas `tbd_*` con varias FKs actúan como asociaciones entre entidades según sus nombres y restricciones.
- Se señalaron dos relaciones inferidas: `tbd_user_payment_methods_history.user_ID` → `tb_users.id` y `tbd_user_payment_methods_history.payment_method_type_ID` → `tbc_payment_methods_types.ID`. Son hipótesis basadas en nombres únicos compatibles; el SQL no declara estas dos FK.
- Los textos amigables de tablas y columnas son interpretaciones generadas a partir de nombres, tipos, claves y contexto inmediato. No sustituyen documentación funcional explícita.

## Entregables

- `modelo_eer_diccionario_respaldo12.html`: diagrama navegable y diccionario integrado, con búsqueda, filtros, modo claro/oscuro y paneles de detalle.
- `modelo_eer_respaldo12.archify.json`: representación EER tipada en formato Archify; las relaciones inferidas usan trazo discontinuo.
- `metadatos_respaldo12.json`: inventario estructurado completo, incluidos lotes INSERT con línea de origen, conteos y relaciones.
- `procedimientos_respaldo12.json`: inventario de triggers y definiciones SQL, con tablas impactadas y referencias faltantes.

El inventario y las cifras derivan exclusivamente de `backups/respaldo12.sql`.

## Anexo técnico: procedimientos, funciones y triggers

La inspección de `backups/respaldo12.sql` encontró **40 triggers**, **0 procedimientos almacenados**, **0 funciones almacenadas** y **0 eventos**. Por tanto, el respaldo no contiene objetos `CREATE PROCEDURE` ni `CREATE FUNCTION`; la lógica almacenada identificada está implementada en triggers. El inventario JSON conserva la definición SQL completa, el cuerpo, el evento, la tabla activadora y las tablas referenciadas detectables en el código.

La lógica de negocio incrustada tiene complejidad **moderada a alta**: los triggers realizan validaciones de estados y montos, actualizaciones automáticas, propagación de cambios entre tablas, mantenimiento de agregados y registros de auditoría. Hay reglas procedimentales ramificadas y operaciones con efectos secundarios; cambios de esquema deben revisar conjuntamente trigger y tablas afectadas. Esta apreciación es cualitativa y se basa en la estructura y operaciones visibles en las definiciones, no en métricas de rendimiento.

La extracción comparó las 40 definiciones del SQL con las del visor HTML. No se detectaron referencias a tablas inexistentes en los cuerpos de las rutinas analizadas. La comprobación es estática: no valida permisos del `DEFINER`, existencia de usuarios en el servidor destino, ni dependencias dinámicas construidas mediante SQL dinámico. Las relaciones inferidas documentadas anteriormente siguen sin ser claves foráneas declaradas.

El módulo **Rutinas** del HTML permite explorar las definiciones de los triggers; los contadores de procedimientos y funciones indican cero. `procedimientos_respaldo12.json` contiene los 40 objetos con parámetros (contexto `OLD`/`NEW` en triggers), tablas impactadas, descripción funcional y código fuente.
