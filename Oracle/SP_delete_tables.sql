-- Store procedure created to delete specific tables every day

CREATE OR REPLACE PROCEDURE     SP_LIMP_TABLAS_TEMP_MICRO 
AS 

PROC VARCHAR2(100);
num_tables int;

BEGIN
	PROC:= 'SP_LIMPIEZA_TABLAS_TEMP_MICRO';
	DWH.SP_CARGA_ETL_LOG_EJECUCION(Proc, sysdate, 'Inicio', 'Inicio ..');
	
	SELECT COUNT(*) INTO num_tables FROM dba_tables WHERE table_name like 'T__________00_' AND LAST_ANALYZED < trunc(SYSDATE) ORDER BY LAST_ANALYZED ASC;
	DWH.SP_CARGA_ETL_LOG_EJECUCION(Proc, sysdate, 'Cantidad de tablas a borrar', num_tables);
	-- Split the input string into table names
	BEGIN
	FOR table_name IN (
						SELECT table_name
						from   user_tables
						where  table_name like 'T__________00_'
						AND LAST_ANALYZED < trunc(SYSDATE)
						ORDER BY LAST_ANALYZED DESC
	                     )
	  LOOP
	    -- Drop the table
	    EXECUTE IMMEDIATE 'DROP TABLE ' || table_name.table_name;
	  END LOOP;
	END;
 
	DWH.SP_CARGA_ETL_LOG_EJECUCION(Proc, sysdate, 'Fin', 'Fin ..');

	EXCEPTION
	WHEN OTHERS THEN
	DWH.SP_CARGA_ETL_LOG_EJECUCION(Proc, sysdate, 'Error' , SQLERRM);
	ROLLBACK;

END SP_LIMP_TABLAS_TEMP_MICRO ;