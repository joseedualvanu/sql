spool 'log/load_FT_AJUSTES_MANH_callsp.sql.log'

PROMPT Calling DWH.SP_CARGA_FT_AJUSTES_MANH ...
exec DWH.SP_CARGA_FT_AJUSTES_MANH;

spool off;
exit;
