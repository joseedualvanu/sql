
-- set timeout to the warehouse
ALTER WAREHOUSE SET STATEMENT_TIMEOUT_IN_SECONDS = 3600;

-- store procedure is created in order to resize the warehouse and optimize the resources
CREATE OR REPLACE PROCEDURE SP_RESIZE_WH("WH_NAME" VARCHAR(16777216), "NEW_SIZE" VARCHAR(16777216), "MAX_CLUSTERS" VARCHAR(16777216), "MIN_CLUSTERS" VARCHAR(16777216), "SCALING_POLICY" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS OWNER
AS '
  var sql_command = `ALTER WAREHOUSE ${WH_NAME} SET WAREHOUSE_SIZE = ''${NEW_SIZE}'' MIN_CLUSTER_COUNT = ${MIN_CLUSTERS} MAX_CLUSTER_COUNT = ${MAX_CLUSTERS} SCALING_POLICY = ''${SCALING_POLICY}'';`;
  try {
    var stmt = snowflake.createStatement({sqlText: sql_command});
    var res = stmt.execute();
    return `Warehouse ${WH_NAME} resized successfully.`;
  } catch (err) {
    return `Failed to resize warehouse ${WH_NAME}. Error: ` + err.message;
  }
';

