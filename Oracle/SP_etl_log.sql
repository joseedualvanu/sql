create or replace PROCEDURE     SP_CARGA_ETL_LOG_EJECUCION(
 p_etl_log_proc IN VARCHAR2,
 p_etl_log_fec IN DATE,
 p_etl_log_err IN VARCHAR2,
 p_etl_log_desc IN VARCHAR2)
AS

--sg_val number;
-- Aislo la escritura del log de la transacción principal
pragma autonomous_transaction;
BEGIN

  INSERT
  INTO DWH.ETL_LOG_EJECUCION
  (ETL_LOG_ID,
   ETL_LOG_PROC,
   ETL_LOG_FEC,
   ETL_LOG_ERR,
   ETL_LOG_DESC)
    VALUES
   (
    FUNC_SEQ_NEXTVAL('SEQ_DWH_ETL_LOG_ID'),
    p_etl_log_proc,
    p_etl_log_fec,
    p_etl_log_err,
    p_etl_log_desc);

    COMMIT;
END;
