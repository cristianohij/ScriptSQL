select * from TBS055 (nolock) 

select PDVNUM,PROCOD from TBS0551 (nolock) where PDVQTD-PDVQTD select sum(PRPQTD) from 


select PDVDATCAD,PDVQTD,PDVQTDFAT,PDVNFSNUM,* from TBS0551 (nolock) join TBS055 (nolock) on TBS055.PDVNUM=TBS0551.PDVNUM where PDVQTDFAT>PDVQTD

begin tran
update TBS0551 set PDVQTDFAT=PDVQTD where PDVQTDFAT>PDVQTD
commit tran

begin tran
update TBS0551 set PDVQTD=1 where PDVNUM=329879 and PDVITEM=3 and PROCOD='1534932'
commit tran

select PDVDATCAD,PDVQTD,PDVQTDFAT,PDVNFSNUM,* from TBS0551 (nolock) join TBS055 (nolock) on TBS055.PDVNUM=TBS0551.PDVNUM
 where PDVQTDFAT>0 and PDVQTD<>PDVQTDFAT and
       PDVQTDFAT*PDVQTDEMB<>(select sum(NFSQTD*NFSQTDEMB) from TBS0671 (nolock) join TBS0672 (nolock) on TBS0672.SNESER=TBS0671.SNESER and TBS0672.NFSNUM=TBS0671.NFSNUM
                              where NFSPDVNUM=TBS0551.PDVNUM and TBS0671.PROCOD=TBS0551.PROCOD)

select * from TBS058 (nolock) where not exists(select '' from TBS055 (nolock) where PDVNUM=PRPNUM)

select * from TBS0551 (nolock)
 where (PDVQTD-PDVQTDFAT)*PDVQTDEMB<>(select sum(PRPQTD*PRPQTDEMB) from TBS058 (nolock) where PRPNUM=PDVNUM and PRPITEM=PDVITEM and TBS058.PROCOD=TBS0551.PROCOD)

begin tran
update TBS058 set PRPQTD=6 where PRPNUM=331566 and PROCOD='0053554'
commit tran

begin tran
delete TBS058 where PRPNUM=338158 and PRPITEM=1 and PROCOD='1179933'
commit tran

