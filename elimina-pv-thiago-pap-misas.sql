select max(PDVNUM) from TBS055 (nolock) where PDVDATCAD <= '20170115'

select PROCOD,PRODES from TBS010 (nolock) where PRODES Like('%GASOLINA%')

select * from TBS014 (nolock) where MARCOD in(240,9997)

select * into TBS058_PV_ELIMINADOS from TBS058 (nolock) where PRPNUM <= (select max(PDVNUM) from TBS055 (nolock) where PDVDATCAD <= '20170115')

select count(*) from TBS058_PV_ELIMINADOS group by PRPNUM

