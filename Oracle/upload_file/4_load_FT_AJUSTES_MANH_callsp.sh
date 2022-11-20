dirlog=/home/BI/cargas/log
log=$dirlog/load_FT_AJUSTES_MANH_callsp.sh.log

echo " load_FT_AJUSTES_MANH_callsp.sh.. " > $log

sqlplus  / <  load_FT_AJUSTES_MANH_callsp.sql >> $log
