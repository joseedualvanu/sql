
-- check query performance
--SET AUTOTRACE ON
EXPLAIN PLAN FOR
select 
    ARTC_ARSR_COD,
    ARTC_ARSR_DESC, 
    1 as ARTC_SESR_COD  
from DWH.V_LU_ARSR_ARTICULO;