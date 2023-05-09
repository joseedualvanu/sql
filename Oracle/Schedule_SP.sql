-- create job
BEGIN
DBMS_SCHEDULER.CREATE_JOB(
	job_name => 'JOB_CARGA_ODS_LU_PROMO_RPM',
	job_type => 'STORED_PROCEDURE',
	job_action => 'DWH.SP_CARGA_ODS_LU_PROMO_RPM',
	start_date => TO_TIMESTAMP_TZ('2022-11-07 08:00:00.0 -3:00', 'yyyy-mm-dd hh24:mi:ss.ff tzr'),
	repeat_interval => 'freq=DAILY;',
	enabled => TRUE
);
END;

-- change schdeule
BEGIN
  DBMS_SCHEDULER.SET_ATTRIBUTE(
    name => 'name',
    attribute => 'start_date',
    value => TO_TIMESTAMP_TZ('2020-04-23 08:00:00.0 -3:00', 'yyyy-mm-dd hh24:mi:ss.ff tzr')
   );
END;

