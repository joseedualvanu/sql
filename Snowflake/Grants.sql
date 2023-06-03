-- Create 
CREATE ROLE <role_name>;

-- Warehouse
GRANT USAGE, OPERATE ON WAREHOUSE <warehouse_name> to role <role_name>;

-- Database
GRANT USAGE ON DATABASE <database_name> TO ROLE <role_name>; 

-- Schema
GRANT USAGE ON SCHEMA <schema_name> to role <role_name>;
GRANT USAGE ON ALL SCHEMAS IN DATABASE <database_name> to role <role_name>;
GRANT SELECT ON FUTURE TABLES IN SCHEMA <schema_name> to role <role_name>;

-- Table
GRANT SELECT ON TABLE <table_name> to role <role_name>;

-- Grants of role
SHOW GRANTS TO ROLE <role_name>;

-- Grant ownership of object
GRANT OWNERSHIP ON <object> TO <role_name> REVOKE CURRENT GRANTS;