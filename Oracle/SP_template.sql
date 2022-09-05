create or replace PROCEDURE SP_name IS Proc VARCHAR2(100);

BEGIN
   PROC:= 'SP_name';

DWH.SP_CARGA_ETL_LOG_EJECUCION(Proc, sysdate, 'Inicio', 'Inicio ..');

-- truncate?
--EXECUTE IMMEDIATE 'TRUNCATE TABLE table_name';

 INSERT INTO table_name(
 -- where to get the info
);

-- SP log
DWH.SP_CARGA_ETL_LOG_EJECUCION(Proc,
                             SYSDATE,
                             'Insert en table_name ',
                             SQL%ROWCOUNT);
COMMIT;

DWH.SP_CARGA_ETL_LOG_EJECUCION(Proc, sysdate, 'Fin', 'Fin ..');

EXCEPTION
    WHEN OTHERS THEN
    DWH.SP_CARGA_ETL_LOG_EJECUCION(Proc, sysdate, 'Error' , SQLERRM);
    ROLLBACK;

END SP_name;
