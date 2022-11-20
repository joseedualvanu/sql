#!/bin/bash
dirlog=/home/BI/cargas/log
log=$dirlog/load_FT_AJUSTES_MANH_encoding.log

echo "load_FT_AJUSTES_MANH_encoding.sh .. "> $log

# cambio en enconding a utf8
var=$(file -bi /home/BI/cargatxt/FT_AJUSTES_MANH.csv | awk '{print $2}')

if [ $var = "charset=utf-16le" ]; then
        mv /home/BI/cargatxt/FT_AJUSTES_MANH.csv /home/BI/cargatxt/FT_AJUSTES_MANH.csv.tmp
        iconv -f utf-16le -t utf8 /home/BI/cargatxt/FT_AJUSTES_MANH.csv.tmp > /home/BI/cargatxt/FT_AJUSTES_MANH.csv
fi

sqlplus / < pre_load.sql

sqlldr / control=load_FT_AJUSTES_MANH.sh.ctl  log=load_FT_AJUSTES_MANH.sh.ctl.log errors=999999 skip=1
more load_FT_AJUSTES_MANH.sh.ctl.log >> $log

sqlplus / < post_load.sql
