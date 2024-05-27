--Query por role
-- Replace <query_metadata> with USER_NAME, ROLE_NAME, or QUERY_TAG
--https://docs.snowflake.com/en/user-guide/cost-attributing#attribute-cost-for-a-shared-warehouse
-- ROLES
WITH hour_execution_time_cte AS (
    SELECT ROLE_NAME,
      warehouse_name,
      DATE_TRUNC('hour',START_TIME) AS start_time_hour,
      SUM(execution_time) AS hour_execution_time
    FROM snowflake.account_usage.query_history
    WHERE warehouse_name IS NOT NULL
    AND execution_time > 0

--Change the below filter if you want to look at a longer range than the last 1 month
    AND START_TIME > DATEADD(Month,-1,CURRENT_TIMESTAMP())
    GROUP BY 1,2,3
    ),
    hour_execution_total_cte AS (
      SELECT start_time_hour,
        warehouse_name,
        SUM(hour_execution_time) AS hour_execution_total
      FROM hour_execution_time_cte
      GROUP BY 1,2
    ),
    hour_approximate_credits_used AS (
        SELECT
          A.ROLE_NAME,
          C.WAREHOUSE_NAME,
          (A.hour_execution_time/B.hour_execution_total)*C.credits_used AS hour_approximate_credits_used
        FROM hour_execution_time_cte A
        JOIN hour_execution_total_cte B ON A.start_time_hour = B.start_time_hour and B.warehouse_name = A.warehouse_name
        JOIN snowflake.account_usage.warehouse_metering_history C ON C.warehouse_name = A.warehouse_name AND C.start_time = A.start_time_hour
    )

SELECT
  ROLE_NAME,
  warehouse_name,
  SUM(hour_approximate_credits_used) AS approximate_credits_used
FROM hour_approximate_credits_used
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 6;

--Query por user
-- USERS
WITH hour_execution_time_cte AS (
    SELECT USER_NAME,
      warehouse_name,
      DATE_TRUNC('hour',START_TIME) AS start_time_hour,
      SUM(execution_time) AS hour_execution_time
    FROM snowflake.account_usage.query_history
    WHERE warehouse_name IS NOT NULL
    AND execution_time > 0

--Change the below filter if you want to look at a longer range than the last 1 month
    AND START_TIME > DATEADD(Month,-1,CURRENT_TIMESTAMP())
    GROUP BY 1,2,3
    ),
    hour_execution_total_cte AS (
      SELECT start_time_hour,
        warehouse_name,
        SUM(hour_execution_time) AS hour_execution_total
      FROM hour_execution_time_cte
      GROUP BY 1,2
    ),
    hour_approximate_credits_used AS (
        SELECT
          A.USER_NAME,
          C.WAREHOUSE_NAME,
          (A.hour_execution_time/B.hour_execution_total)*C.credits_used AS hour_approximate_credits_used
        FROM hour_execution_time_cte A
        JOIN hour_execution_total_cte B ON A.start_time_hour = B.start_time_hour and B.warehouse_name = A.warehouse_name
        JOIN snowflake.account_usage.warehouse_metering_history C ON C.warehouse_name = A.warehouse_name AND C.start_time = A.start_time_hour
    )

SELECT
  USER_NAME,
  warehouse_name,
  SUM(hour_approximate_credits_used) AS approximate_credits_used
FROM hour_approximate_credits_used
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10; 