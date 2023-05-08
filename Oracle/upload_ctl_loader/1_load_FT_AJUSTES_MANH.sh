#!/bin/bash
. /home/BI/.bash_profile
PATH=$PATH:$ORACLE_HOME/perl/bin
NLS_LANG=AMERICAN_AMERICA.AL32UTF8
export PATH
export NLS_LANG

cd /home/BI/cargatxt/

fecha=`date +%Y%m%d`
log='/home/BI/cargas/log/load_FT_AJUSTES_MANH.sh.log'
rutatxt='/home/BI/cargatxt/'
archivotxt='FT_AJUSTES_MANH.csv'

#***********EJECUTA CARGA ***************************************
echo `date +%F%t%T` : 'Inicia ejecucion: load_FT_AJUSTES_MANH.sh ' >> $log

cd /home/BI/cargas/

day=`date +%Y%m%d`

if [ -f $rutatxt$archivotxt ]
then
     sh load_FT_AJUSTES_MANH_encoding.sh
else
    echo `date +%F%t%T` : 'ERROR: No se encuentra el archivo FT_AJUSTES_MANH.csv' >> $log
fi
echo `date +%F%t%T` : 'Fin de ejecucion: load_FT_AJUSTES_MANH.sh' >> $log
echo '------------------------------------------------------------------------------------' >> $log

#Muevo el archivo a respaldo

mv /home/BI/cargatxt/FT_AJUSTES_MANH.csv /home/BI/cargatxt/BKP_COMPETENCIA/FT_AJUSTES_MANH.`date -d "$day 1 day ago" +"%Y%m%d"`.csv

sh load_FT_AJUSTES_MANH_callsp.sh

echo `date +%F%t%T` : 'Fin de llamada a sp en load_FT_AJUSTES_MANH.sh' >> $log
