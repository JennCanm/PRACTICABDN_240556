/* 1. CREACIÓN DE LA BASE DE DATOS */
CREATE DATABASE IF NOT EXISTS db_test;

/* 2. CREACIÓN DE ROLES */
CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'common';

/* 3. CREACIÓN DE TODOS LOS USUARIOS (INCLUYENDO SAMUEL) */
CREATE USER IF NOT EXISTS 'Marco.Ramirez'@'%'     IDENTIFIED BY 'qwerty123';
CREATE USER IF NOT EXISTS 'Jennifer.Canales'@'%'  IDENTIFIED BY '240556';
CREATE USER IF NOT EXISTS 'Margaret.Rojas'@'%'    IDENTIFIED BY '240242';
CREATE USER IF NOT EXISTS 'Gadiel.Bobadilla'@'%'   IDENTIFIED BY '240349';
CREATE USER IF NOT EXISTS 'Dara.Gomez'@'%'        IDENTIFIED BY '240765';
CREATE USER IF NOT EXISTS 'Dorian.Barrios'@'%'    IDENTIFIED BY '240065';
CREATE USER IF NOT EXISTS 'Samuel.Vargas'@'%'      IDENTIFIED BY '123456'; /* Creado antes de otorgar permisos */

/* Asegurar contraseñas correctas */
ALTER USER 'Gadiel.Bobadilla'@'%' IDENTIFIED BY '240349';
ALTER USER 'Jennifer.Canales'@'%' IDENTIFIED BY '240556';
ALTER USER 'Dara.Gomez'@'%' IDENTIFIED BY '240765';
ALTER USER 'Margaret.Rojas'@'%' IDENTIFIED BY '240242';
ALTER USER 'Dorian.Barrios'@'%' IDENTIFIED BY '240065';
SET GLOBAL activate_all_roles_on_login = ON;

/* 4. PERMISOS A LOS ROLES */
GRANT ALL PRIVILEGES ON *.* TO 'superadmin' WITH GRANT OPTION;

-- Corregidos los nombres de tablas (sin asteriscos pegados)
GRANT ALL PRIVILEGES ON db_test.tb_users TO 'admin';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.* TO 'seller';

GRANT SELECT, INSERT, UPDATE ON db_test.tbd_products_categories TO 'support';

-- Si la tabla tb_categorias no existe aún, se comenta la línea para evitar el ERROR 1146
-- GRANT SELECT ON db_test.tb_categorias TO 'support';

GRANT SELECT, INSERT, UPDATE, DELETE ON db_test.* TO 'Samuel.Vargas'@'%'; /* Usuario sin rol */

/* 5. ASIGNACIÓN DE PRIVILEGIOS DIRECTOS A USUARIOS */
GRANT ALL PRIVILEGES ON *.* TO 'Marco.Ramirez'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON db_test.* TO 'Marco.Ramirez'@'%';

GRANT ALL PRIVILEGES ON *.* TO 'Gadiel.Bobadilla'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'Jennifer.Canales'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'Dara.Gomez'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'Margaret.Rojas'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'Dorian.Barrios'@'%' WITH GRANT OPTION;

/* 6. ASIGNACIÓN DE ROLES A USUARIOS */
GRANT 'superadmin' TO 'Jennifer.Canales'@'%';
GRANT 'admin'      TO 'Marco.Ramirez'@'%';
GRANT 'support'    TO 'Dara.Gomez'@'%';
GRANT 'seller'     TO 'Dorian.Barrios'@'%';
GRANT 'seller'     TO 'Gadiel.Bobadilla'@'%';

/* 7. DEFINIR ROLES POR DEFECTO */
SET DEFAULT ROLE ALL TO 'Jennifer.Canales'@'%';
SET DEFAULT ROLE ALL TO 'Marco.Ramirez'@'%';
SET DEFAULT ROLE ALL TO 'Dara.Gomez'@'%';
SET DEFAULT ROLE ALL TO 'Dorian.Barrios'@'%';
SET DEFAULT ROLE ALL TO 'Gadiel.Bobadilla'@'%';

/* 8. APLICAR CAMBIOS */
FLUSH PRIVILEGES;