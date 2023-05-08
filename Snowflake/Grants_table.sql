
-- Database
GRANT USAGE ON DATABASE <database_name> TO ROLE <role_name>; 

-- Schema
-- grant for one schema
GRANT USAGE ON SCHEMA <schema_name> to role <role_name>;
-- grant for all schemas
GRANT USAGE ON ALL SCHEMAS IN DATABASE <database_name> to role <role_name>;

-- Acceso SELECT a una tabla (acceso a tablas particulares)
grant select ON TABLE "MSTRDB"."DWH".RFM_SANROQUE to role SYSADMIN;
-- todas las tablas
grant select on all views in schema "MSTRDB"."TIA" to role SYSADMIN;