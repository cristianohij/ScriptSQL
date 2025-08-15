select TBS055.PDVDATCAD,TBS055.PDVNUM,TBS055.PDVORCNUM,TBS004.VENNOM
  from TBS055 (nolock) 
       join TBS0551 (nolock) on TBS055.PDVNUM=TBS0551.PDVNUM
       join TBS042 (nolock) on TBS042.TESCOD=TBS0551.TESCOD
       join TBS004 (nolock) on TBS004.VENCOD=TBS055.VENCOD
 where TBS055.PDVDATCAD>='20150601' and
       TBS0551.PDVMOVEST<>'S' and
       TBS042.TESEST='S' and
       TBS0551.PDVQTD<>TBS0551.PDVQTDFAT
 group by TBS055.PDVDATCAD,TBS055.PDVNUM,TBS055.PDVORCNUM,TBS004.VENNOM
 order by TBS055.PDVNUM

select * from TBS067 (nolock)
 where not exists (select '' from TBS080 (nolock) where TBS080.SNESER=TBS067.SNESER and TBS080.ENFNUM=TBS067.NFSNUM)
 order by TBS067.NFSDATEMI desc

select * from TBS032 (nolock) where PROCOD='17640003'

select * from TBS0921 (nolock) where NCMCOD='82119390'

delete TBS0921 where NCMCOD='82119390' and UFESIG='RJ'

select * from TBS0551 (nolock) where PDVNUM=342940

update TBS0551 set PDVCFOP='6.403',PDVPERICMSST=7,PDVCST='010' where PDVNUM=342940 and PDVITEM=18


insert into TBS032 select '0',7,'17640003',0,0,0,0,getdate(),'','','','',(select PRODES from TBS010 (nolock) where TBS010.PROCOD='17640003'),0,1764,'A',0,0,0,0,0,'17530101','17530101',0,0,0,'17530101'

select * 
  from TBS0671 (nolock)
       join TBS110 (nolock) on TBS110.ROPREG=TBS0671.NFSROPREG
 where ROPCNTVEN='S' and NFSROPREG>0 and NFSROPCNTVEN=''

begin tran
update TBS0671 set NFSROPCNTVEN='S'
  from TBS0671 (nolock)
       join TBS110 (nolock) on TBS110.ROPREG=TBS0671.NFSROPREG
 where ROPCNTVEN='S' and NFSROPREG>0 and NFSROPCNTVEN=''
commit tran
rollback tran

select NFSPRECUS,NFSROPCNTVEN,*
  from TBS0671 (nolock) 
       join TBS067 (nolock) on TBS067.NFSNUM=TBS0671.NFSNUM
where NFSDATEMI>='20150601' and
      NFSROPREG>0

update TBS0671 set NFSPRECUS=TDPCUSBAS*NFSQTDEMB
  from TBS0671 (nolock) 
       join TBS067 (nolock) on TBS067.NFSNUM=TBS0671.NFSNUM
       join TBS031 (nolock) on TBS031.TDPPROCOD=TBS0671.PROCOD
where NFSDATEMI>='20150601' and
      NFSPRECUS=0
 
select NFSPRECUS,TDPCUSBAS
  from TBS0671 (nolock) 
       join TBS067 (nolock) on TBS067.NFSNUM=TBS0671.NFSNUM
       join TBS031 (nolock) on TBS031.TDPPROCOD=TBS0671.PROCOD
where NFSDATEMI>='20150601' and
      NFSPRECUS=0


select * from TBS058 (nolock) where PRPQTDCONF > 0 and PRPUSUCNF='' order by PRPDATREG desc


select ORCPRECUS,TDPCUSBAS
  from TBS0431 (nolock) 
       join TBS043 (nolock) on TBS043.ORCNUM=TBS0431.ORCNUM
       join TBS031 (nolock) on TBS031.TDPPROCOD=TBS0431.PROCOD
where ORCDATCAD>='20150601' and
      ORCPRECUS=0 and
      TBS043.ORCNUM=455202


begin tran
update TBS0431 set ORCPRECUS=TDPCUSBAS*ORCQTDEMB
  from TBS0431 (nolock) 
       join TBS043 (nolock) on TBS043.ORCNUM=TBS0431.ORCNUM
       join TBS031 (nolock) on TBS031.TDPPROCOD=TBS0431.PROCOD
where ORCDATCAD>='20150601' and
      ORCPRECUS=0 and
      TBS043.ORCNUM=455202
commit tran

select * from TBS0671 (nolock) where NFSCFOP='6.929' order by NFSNUM desc 

select PDVPRECUS,TDPCUSBAS
  from TBS0551 (nolock) 
       join TBS055 (nolock) on TBS055.PDVNUM=TBS0551.PDVNUM
       join TBS031 (nolock) on TBS031.TDPPROCOD=TBS0551.PROCOD
where PDVDATCAD>='20150601' and
      PDVPRECUS=0

begin tran
update TBS0551 set PDVPRECUS=TDPCUSBAS*PDVQTDEMB
  from TBS0551 (nolock) 
       join TBS055 (nolock) on TBS055.PDVNUM=TBS0551.PDVNUM
       join TBS031 (nolock) on TBS031.TDPPROCOD=TBS0551.PROCOD
where PDVDATCAD>='20150601' and
      PDVPRECUS=0
commit tran


select * from TBS051 (nolock) where PROCOD='3800024' order by LMEDATHOR desc