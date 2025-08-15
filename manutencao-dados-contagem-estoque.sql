select * from TBS058 (nolock)

-- erro: não considera as solicitações de compras

select *
  from TBS032 (nolock) 
 where ESTLOC=1 and ESTQTDRES > 0 and
       not exists(select '' from TBS058 (nolock) where PRPESTLOC=ESTLOC and TBS058.PROCOD=TBS032.PROCOD)

update TBS032 set ESTQTDRES=0
  from TBS032 (nolock) 
 where ESTLOC=1 and ESTQTDRES > 0 and
       not exists(select '' from TBS058 (nolock) where PRPESTLOC=ESTLOC and TBS058.PROCOD=TBS032.PROCOD)

select * from TBS076 (nolock)
select * from TBS0761 (nolock)

select * from TBS0761 (nolock) where SDCQTDATD-(SDCQTDBAI+SDCQTDRES) > 0

select *
  from TBS076 (nolock) inner join TBS0761 (nolock) on TBS076.SDCNUM=TBS0761.SDCNUM
 where SDCQTDATD-(SDCQTDBAI+SDCQTDRES) > 0

select * from TBS036 (nolock) where CCSCOD in(111,112)


-- quantidade faturada maior do que a quantidade pedida

select PDVDATCAD,PDVQTD,PDVQTDFAT,PDVNFSNUM,* from TBS0551 (nolock) join TBS055 (nolock) on TBS055.PDVNUM=TBS0551.PDVNUM where PDVQTDFAT>PDVQTD

begin tran
update TBS0551 set PDVQTDFAT=PDVQTD where PDVQTDFAT>PDVQTD
commit tran

-- erro: divergência para pedidos aglutinados

select PDVDATCAD,PDVQTD,PDVQTDFAT,PDVNFSNUM,* from TBS0551 (nolock) join TBS055 (nolock) on TBS055.PDVNUM=TBS0551.PDVNUM
 where PDVQTDFAT>0 and PDVQTD<>PDVQTDFAT and
       PDVQTDFAT*PDVQTDEMB<>(select sum(NFSQTD*NFSQTDEMB) from TBS0671 (nolock) join TBS0672 (nolock) on TBS0672.SNESER=TBS0671.SNESER and TBS0672.NFSNUM=TBS0671.NFSNUM
                              where NFSPDVNUM=TBS0551.PDVNUM and TBS0671.PROCOD=TBS0551.PROCOD)

select PDVDATCAD,PDVQTD,PDVQTDFAT,PDVNFSNUM,*
  from TBS0551 (nolock) inner join TBS055 (nolock) on TBS055.PDVNUM=TBS0551.PDVNUM
 where PDVQTD-PDVQTDFAT = 0 and
       PDVQTDFAT*PDVQTDEMB<>(select sum(NFSQTD*NFSQTDEMB)
                               from TBS0671 (nolock) inner join TBS0672 (nolock) on TBS0672.SNESER=TBS0671.SNESER and TBS0672.NFSNUM=TBS0671.NFSNUM
                              where NFSPDVNUM=TBS0551.PDVNUM and TBS0671.PROCOD=TBS0551.PROCOD)

select * from TBS058 (nolock) where not exists(select '' from TBS055 (nolock) where PDVNUM=PRPNUM)

select * from TBS0551 (nolock)
 where (PDVQTD-PDVQTDFAT)*PDVQTDEMB<>(select sum(PRPQTD*PRPQTDEMB) from TBS058 (nolock) where PRPNUM=PDVNUM and PRPITEM=PDVITEM and TBS058.PROCOD=TBS0551.PROCOD)


-- orçamentos

select count(*) from TBS043 (nolock)

select min(ORCDATCAD) from TBS043 (nolock)

select year(ORCDATCAD),count(*) from TBS043 (nolock) group by year(ORCDATCAD) order by year(ORCDATCAD)

select count(*) from TBS043 (nolock) where year(ORCDATCAD) > 2017

select ORCNUM,(select top 1 ORCNUM from TBS043 (nolock) where year(ORCDATCAD) <= 2017 and ORCNUM<A.ORCNUM order by ORCNUM desc)
  from TBS043 (nolock) as A
 where year(ORCDATCAD) > 2017

select convert(char(8),ORCDATCAD,112),* from TBS043 (nolock) where year(ORCDATCAD)=3115

select ORCNUM,PDVNUM,PDVDATCAD
  from TBS043 (nolock) innder join TBS055 (nolock) on PDVNUM=ORCPDVNUM
 where ORCDATCAD='17530101'
 order by PDVDATCAD

begin tran
update TBS043 set ORCDATCAD=PDVDATCAD
  from TBS043 (nolock) innder join TBS055 (nolock) on PDVNUM=ORCPDVNUM
 where ORCDATCAD='17530101'
commit tran

select * from TBS043 (nolock) where ORCDATCAD='17530101' and ORCPDVNUM=0

select top 10 * from TBS043 (nolock) order by ORCNUM desc

select ORCNUM,(select top 1 ORCDATCAD from TBS043 (nolock) as B where ORCDATCAD<>'17530101' and B.ORCNUM<A.ORCNUM)
  from TBS043 (nolock) as A
 where ORCDATCAD='17530101'

select ORCNUM,(select top 1 ORCNUM from TBS043 (nolock) as B where ORCDATCAD<>'17530101' and B.ORCNUM<A.ORCNUM order by ORCNUM desc)
  from TBS043 (nolock) as A
 where ORCDATCAD='17530101'

select ORCNUM,ORCDATCAD from TBS043 (nolock) where ORCNUM in(537856,537855)

begin tran
update TBS043 set ORCDATCAD=(select top 1 ORCDATCAD from TBS043 (nolock) as B where ORCDATCAD<>'17530101' and B.ORCNUM<A.ORCNUM order by ORCNUM desc)
  from TBS043 (nolock) as A
 where ORCDATCAD='17530101'
commit tran

begin tran
update TBS043 set ORCDATCAD=(select top 1 ORCDATCAD from TBS043 (nolock) where year(ORCDATCAD) <= 2017 and ORCNUM<A.ORCNUM order by ORCNUM desc)
  from TBS043 (nolock) as A
 where year(ORCDATCAD) > 2017
commit tran


select * from TBS053 (nolock) where BCPTIPTRN='P'

select * from TBS002 (nolock) where CLIPEDBLQ > 0
select * from TBS002 (nolock) where CLIPEDLIB > 0
