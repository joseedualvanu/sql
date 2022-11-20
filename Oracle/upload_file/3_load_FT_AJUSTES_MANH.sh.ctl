load data
infile '/home/BI/cargatxt/FT_AJUSTES_MANH.csv'
 "str '\n'"
into table ODS_MERCADERIAS.FT_AJUSTES_MANH
truncate
fields terminated by ';'
trailing nullcols
(
unidad_negocio "DECODE(:unidad_negocio, 'NULL', NULL, NULL, ' ', :unidad_negocio)",
created_timestamp "TO_DATE( DECODE(TRIM(:created_timestamp), 'NULL', NULL, '0', NULL, '' ,NULL ,'00000000', NULL , :created_timestamp),'yyyy-mm-dd hh24:mi:ss')",
item "DECODE(:item, 'NULL', NULL, NULL, ' ', :item)",
estadistico "DECODE(:estadistico, 'NULL', NULL, NULL, ' ', :estadistico)",
unidades "DECODE(:unidades, 'NULL', NULL, NULL, ' ', :unidades)",
peso "DECODE(:peso, 'NULL', NULL, NULL, ' ', :peso)",
reason_code  "DECODE(:reason_code, 'NULL', NULL, NULL, ' ', :reason_code)"
)
