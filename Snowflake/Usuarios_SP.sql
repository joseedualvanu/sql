-- DBUsers Table
CREATE OR REPLACE TABLE DBUSERS (NAME VARCHAR,CREATED_ON TIMESTAMP_LTZ,LOGIN_NAME VARCHAR,DISPLAY_NAME VARCHAR,FIRST_NAME VARCHAR,LAST_NAME VARCHAR,EMAIL VARCHAR,MINS_TO_UNLOCK VARCHAR,DAYS_TO_EXPIRY VARCHAR,TCOMMENT VARCHAR,DISABLED VARCHAR,MUST_CHANGE_PASSWORD VARCHAR,SNOWFLAKE_LOCK VARCHAR,DEFAULT_WAREHOUSE VARCHAR,DEFAULT_NAMESPACE VARCHAR,DEFAULT_ROLE VARCHAR,EXT_AUTHN_DUO VARCHAR,EXT_AUTHN_UID VARCHAR,MINS_TO_BYPASS_MFA VARCHAR,OWNER VARCHAR,LAST_SUCCESS_LOGIN TIMESTAMP_LTZ,EXPIRES_AT_TIME TIMESTAMP_LTZ,LOCKED_UNTIL_TIME TIMESTAMP_LTZ,HAS_PASSWORD VARCHAR,HAS_RSA_PUBLIC_KEY VARCHAR,REFRESH_DATE TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP())
COMMENT = "stores snapshot of current snowflake users" ;
-- DBRoles Table
CREATE OR REPLACE TABLE DBROLES (CREATED_ON TIMESTAMP_LTZ,NAME VARCHAR,IS_DEFAULT VARCHAR,IS_CURRENT VARCHAR,IS_INHERITED VARCHAR,ASSIGNED_TO_USERS NUMBER,GRANTED_TO_ROLES NUMBER,GRANTED_ROLES NUMBER,OWNER VARCHAR,RCOMMENT VARCHAR,REFRESH_DATE TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP())
COMMENT = "stores snapshot of current snowflake roles";
-- DBGrants Table
CREATE OR REPLACE TABLE DBGRANTS (CREATED_ON TIMESTAMP_LTZ,PRIVILEGE VARCHAR,GRANTED_ON VARCHAR,NAME VARCHAR,GRANTED_TO VARCHAR,GRANTEE_NAME VARCHAR,GRANT_OPTION VARCHAR,GRANTED_BY VARCHAR,REFRESH_DATE TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP())
COMMENT = "stores snapshot of current grants" ;

-- Capturing the List of Users
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

-- Capturing the List of Roles
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

-- Agendar SPs
SHOW tasks;
DESCRIBE task MYTASK_HOUR;

CREATE TASK snapshot_users
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON 0 2 * * * America/Montevideo'
  TIMESTAMP_INPUT_FORMAT = 'YYYY-MM-DD HH24'
  COMMENT = "SP para cargar datos de los usuarios"
AS
CALL SNAPSHOT_USERS();

ALTER TASK snapshot_users SET resume;

CREATE TASK snapshot_roles
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON 0 2 * * * America/Montevideo'
  TIMESTAMP_INPUT_FORMAT = 'YYYY-MM-DD HH24'
  COMMENT = "SP para cargar datos de los roles"
AS
CALL SNAPSHOT_ROLES();

CREATE TASK snapshot_grants
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON 0 2 * * * America/Montevideo'
  TIMESTAMP_INPUT_FORMAT = 'YYYY-MM-DD HH24'
  COMMENT = "SP para cargar datos de los permisos"
AS
CALL SNAPSHOT_GRANTS();
