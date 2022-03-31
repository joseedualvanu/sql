/* 
Información: 
https://docs.snowflake.com/en/user-guide/admin-user-management.html 
https://docs.snowflake.com/en/user-guide-admin-security.html
https://community.snowflake.com/s/article/How-to-Capture-Snowflake-Users-Roles-and-Grants-Into-a-Table
*/

-- Descripcion de un usuario
DESC USER SDEARMAS;

-- Creacion del usuario con su contraseña, rol y warehouses
CREATE USER mmarani PASSWORD = 'mmarani' 
DEFAULT_ROLE = "SYSADMIN" 
DEFAULT_WAREHOUSE = 'COMPUTE_WH' 
MUST_CHANGE_PASSWORD = TRUE
--COMMENT = 'Usuarios con acceso solo a ODS.PRECIOS_RETAIL para cargar precios de la competencia';
FIRST_NAME = 'Maximiliano'
LAST_NAME = 'Marani';

-- Borrar un usuario
DROP USER pruebaprecios;

-- Asignar rol a un usuario
GRANT role BIZMETRIKS TO USER saguirre;

-- Modificar un atributo de un usuario
ALTER USER TATA2 SET COMMENT = 'Usuario para scripts';
ALTER USER <name> SET email='<email_user>';
ALTER USER eliana.cheloni SET DISABLED = TRUE;
ALTER USER "javier.chiste" SET disabled = false;
ALTER USER sdearmas SET email='sebastian.dearmas@adagio.com.uy';
ALTER USER "magela.almandos" RESET PASSWORD;
ALTER USER dfolle SET 
email='diego.folle@tata.com.uy'
first_name = 'Diego'
last_name = 'Folle';
ALTER USER indigo SET
DEFAULT_ROLE = "LECTURA_ESCRITURA_INDIGO";



-- Ver los permisos de un usuario
SHOW GRANTS TO USER BIZMETRIKS;

-- Ver los permisos de un rol
SHOW GRANTS TO ROLE SOLO_LECTURA_ADAGIO;
show grants to role PUBLIC;

-- Ver los usuarios
SHOW users;
-- Ver los roles
SHOW ROLES;


-- Borrar un usuario
--DROP USER eliana.cheloni;

-- Borrar un rol


-- Agregar clave publica a un usuario
ALTER USER TATA2 SET 
rsa_public_key='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtYTt0uCvGMmvy3kn0vdp
XwlvNPIb6NZkbDi38mBbK6v625f8oLe6NMNCrD68F6EkI7YfpTYNhar6c5GCJ7rp
LvexoAxrxsz5a9OfZ+eJAeGD4Hxupq05Dp7ol5YnAMVSnqWHHqGHzFy3PA05vZrh
ZstdlBC3UvvVrI3Yop5hHdzFXN98TzFJvikSwakkD44BkwqNYudSitVusM4d177k
qc5M/LYtez+IuAcoKqkyEmqY7tc+w0WS/N+TZGXtieRlXxcmGzAXuFA8X9hwksic
WlqPj35rqklqr2SD5RZe7/KYck7EKqmR8DFMswo19yf20p6W6SKfkhxaego/xYkV
jwIDAQAB';

-- grant select on all tables in schema mydb.myschema to role analyst;
-- Crear rol
CREATE role SOLO_LECTURA_SANDBOX_PLUS
COMMENT = 'Solo permiso de SELECT EN SANDBOX_PLUS.DWH';
-- Acceso a warehouse
grant usage,operate on warehouse COMPUTE_WH to role SOLO_LECTURA_SANDBOX_PLUS;
-- Acceso a la base de datos
GRANT USAGE ON DATABASE MSTRDB TO ROLE SOLO_LECTURA_ADAGIO;
GRANT USAGE ON DATABASE SANDBOX_PLUS TO ROLE SOLO_LECTURA_SANDBOX_PLUS;
-- Acceso al esquema
GRANT ALL ON SCHEMA "MSTRDB"."PLUS" TO ROLE SOLO_LECTURA_ADAGIO;
GRANT ALL ON SCHEMA "SANDBOX_PLUS"."DWH" TO ROLE SOLO_LECTURA_SANDBOX_PLUS;
-- Acceso a una tabla (acceso a tablas particulares)
GRANT ALL ON TABLE "ODS"."PRECIOS_RETAIL"."PRECIOS_RETAIL_COMPETENCIA" TO ROLE ACCOUNTADMIN;
GRANT ALL ON TABLE "ODS"."PRECIOS_RETAIL"."PRECIOS_RETAIL_COMPETENCIA" TO ROLE ACCOUNTADMIN;
-- Acceso SELECT a una tabla (acceso a tablas particulares)
grant select  ON TABLE "SANDBOX_PLUS"."DWH"."TABLERO_CLIENTES_FIELES" to role SOLO_LECTURA_SANDBOX_PLUS;
-- Permiso de SELECT a las todas tablas y vistas del esquema
grant select on all tables in schema "MSTRDB"."PLUS" to role SOLO_LECTURA_PLUS;
grant select on all views in schema "MSTRDB"."PLUS" to role SOLO_LECTURA_PLUS;
-- Acceso a futuras tablas
grant select on future tables in schema "MSTRDB"."PLUS" to role SOLO_LECTURA_PLUS;

-- Acceso a las bases de datos NO SERIA NECESARIO (SOLO EN CASO PUNTUAL QUE NECESITEMOS CREAR UN USUARIO SYSADMIN)
--GRANT ALL PRIVILEGES ON DATABASE MSTRDB TO ROLE SYSADMIN;
--GRANT ALL PRIVILEGES ON future TABLES in DATABASE MSTRDB to role SYSADMIN;
--GRANT USAGE ON FUTURE PROCEDURES IN DATABASE MSTRDB to role SYSADMIN;

# Creacion de un esquema para usuarios
CREATE SCHEMA USUARIOS;
GRANT ALL PRIVILEGES ON SCHEMA ECOMMERCE TO ROLE SANDBOX_PLUS;
GRANT USAGE ON SCHEMA ECOMMERCE TO ROLE SANDBOX_PLUS;
GRANT ALL PRIVILEGES ON future TABLES in schema ECOMMERCE to role SANDBOX_PLUS;
GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA ECOMMERCE to role SANDBOX_PLUS;
grant select on all views in schema "MSTRDB"."ECOMMERCE" to role SANDBOX_PLUS;


/*
Creacion de tablas para informacion de usuarios
https://community.snowflake.com/s/article/How-to-Capture-Snowflake-Users-Roles-and-Grants-Into-a-Table
*/
# DBUsers Table
CREATE OR REPLACE TABLE DBUSERS (NAME VARCHAR,CREATED_ON TIMESTAMP_LTZ,LOGIN_NAME VARCHAR,DISPLAY_NAME VARCHAR,FIRST_NAME VARCHAR,LAST_NAME VARCHAR,EMAIL VARCHAR,MINS_TO_UNLOCK VARCHAR,DAYS_TO_EXPIRY VARCHAR,TCOMMENT VARCHAR,DISABLED VARCHAR,MUST_CHANGE_PASSWORD VARCHAR,SNOWFLAKE_LOCK VARCHAR,DEFAULT_WAREHOUSE VARCHAR,DEFAULT_NAMESPACE VARCHAR,DEFAULT_ROLE VARCHAR,EXT_AUTHN_DUO VARCHAR,EXT_AUTHN_UID VARCHAR,MINS_TO_BYPASS_MFA VARCHAR,OWNER VARCHAR,LAST_SUCCESS_LOGIN TIMESTAMP_LTZ,EXPIRES_AT_TIME TIMESTAMP_LTZ,LOCKED_UNTIL_TIME TIMESTAMP_LTZ,HAS_PASSWORD VARCHAR,HAS_RSA_PUBLIC_KEY VARCHAR,REFRESH_DATE TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP())
COMMENT = "stores snapshot of current snowflake users" ;
# DBRoles Table
CREATE OR REPLACE TABLE DBROLES (CREATED_ON TIMESTAMP_LTZ,NAME VARCHAR,IS_DEFAULT VARCHAR,IS_CURRENT VARCHAR,IS_INHERITED VARCHAR,ASSIGNED_TO_USERS NUMBER,GRANTED_TO_ROLES NUMBER,GRANTED_ROLES NUMBER,OWNER VARCHAR,RCOMMENT VARCHAR,REFRESH_DATE TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP())
COMMENT = "stores snapshot of current snowflake roles";
# DBGrants Table
CREATE OR REPLACE TABLE DBGRANTS (CREATED_ON TIMESTAMP_LTZ,PRIVILEGE VARCHAR,GRANTED_ON VARCHAR,NAME VARCHAR,GRANTED_TO VARCHAR,GRANTEE_NAME VARCHAR,GRANT_OPTION VARCHAR,GRANTED_BY VARCHAR,REFRESH_DATE TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP())
COMMENT = "stores snapshot of current grants" ;

# Capturing the List of Users

# Carga de tabla usuarios
CREATE OR REPLACE PROCEDURE SNAPSHOT_USERS()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
COMMENT = "Captures the snapshot of users and inserts the records into dbusers"

EXECUTE AS CALLER 
AS '
var result = "SUCCESS";

try {
snowflake.execute( {sqlText: "TRUNCATE TABLE DBUSERS;"} );
snowflake.execute( {sqlText: "show users;"} );
var dbusers_tbl_sql = `insert into dbusers select * ,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));`;
snowflake.execute( {sqlText: dbusers_tbl_sql} );

} catch (err) {
result = "#FAILED: Code: " + err.message + "#Position: " + err.stackTraceTxt;
}
return result;
';

CALL SNAPSHOT_USERS();

# Capturing the List of Roles
CREATE OR REPLACE PROCEDURE SNAPSHOT_ROLES()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT 
COMMENT = "Captures the snapshot of roles and inserts the records into dbroles"

EXECUTE AS CALLER 
AS '
var result = "SUCCESS";

try {
snowflake.execute( {sqlText: "truncate table DBROLES;"} );
snowflake.execute( {sqlText: "show roles;"} );
var dbroles_tbl_sql = `insert into dbroles select *,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));`;
snowflake.execute( {sqlText: dbroles_tbl_sql} );
} catch (err) {
result = "#FAILED: Code: " + err.message + "#Position: " + err.stackTraceTxt;
}
return result;
';
CALL SNAPSHOT_ROLES();

-- Capturing the List of Grants
CREATE OR REPLACE PROCEDURE SNAPSHOT_GRANTS()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
COMMENT = "Captures the snapshot of grants and inserts the records into dbgrants"

EXECUTE AS CALLER
AS $$
//function role_grants() {
snowflake.execute({sqlText: "truncate table DBGRANTS;"} );
var obj_rs = snowflake.execute({sqlText: `SELECT NAME FROM DBROLES;`});
while(obj_rs.next()) {
var role_str = '"'+String(obj_rs.getColumnValue(1))+'"';
var sql_to_role = "show grants to role " + role_str + ";";
var sql_on_role = "show grants on role " + role_str + ";";
snowflake.execute({sqlText: sql_to_role});
snowflake.execute({sqlText: `insert into dbgrants select *,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));`});
snowflake.execute({sqlText: sql_on_role});
snowflake.execute({sqlText: `insert into dbgrants select *,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));`});
}
//}
// — — — — — — — — — — — — — — — — — — — — — — — —
//function user_grants(){
var obj_rs = snowflake.execute({sqlText: `SELECT NAME FROM DBUSERS;`});
while(obj_rs.next()) {
var user_str = '"'+String(obj_rs.getColumnValue(1))+'"';
var sql_to_user = "show grants to user " + user_str + ";";
var sql_on_user = "show grants on user " + user_str + ";";
snowflake.execute({sqlText: sql_to_user});
snowflake.execute({sqlText: `insert into dbgrants select *,null,null,null,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));`});
snowflake.execute({sqlText: sql_on_user});
snowflake.execute({sqlText: `insert into dbgrants select *,CURRENT_TIMESTAMP() from table(result_scan(last_query_id()));`});
}
//}
// — — — — — — — — — — — — — — — — — — — — — — — —
var result = "SUCCESS";
//try {

//role_grants();
//user_grants();
//} catch (err) {
//result = "FAILED: Code: " + err.code + "\n State: " + err.state;result += "\n Message: " + err.message;result += "\nStack Trace:\n" + err.stackTraceTxt;
//result = "#FAILED: Code: " + err.message + "#Position: " + err.stackTraceTxt;
//}
return result;$$;

CALL SNAPSHOT_GRANTS();
