-- schedule task
CREATE OR REPLACE TASK <task_name>
  WAREHOUSE = <warehouse_name>
  SCHEDULE = 'USING CRON 30 8 * * * America/Montevideo'
  TIMESTAMP_INPUT_FORMAT = 'YYYY-MM-DD HH24'
  COMMENT = 'comments'
AS 
BEGIN
call 'XXX'
END;

ALTER TASK <task_name> resume;
ALTER TASK <task_name> suspend;