select * from importar where not exists(select 'ne' from TBS010 where PROCOD=B1_COD)

begin tran
insert into TBS010 (PROEMPCOD,PROCOD,PROSTATUS,PRODES,PROUM1)
select 0,B1_COD,'N',B1_DESC,B1_UM from importar where not exists(select 'ne' from TBS010 where PROCOD=B1_COD)

commit tran
rollback tran


select * from TBS010 where MARNOM is null

begin tran
update TBS010 set PROCODBAR1='',PROCODBAR2='',PROCODBAR3='',PROCODBAR4='',FOREMPCOD=0,MARCOD=0,MAREMPCOD=0,PROICMSSAI=0,
                  PROPESLIQ=0,PROPESBRU=0,PROEMPUM=0,PROICMSENT=0,PROPBISAI=0,PROPBIENT=0,PROIPI=0,
                  PRODATCAD='5/5/2008',FABCOD=0,FABEMPCOD=0,PROLOCFIS='',PROREFFOR='',PROISS=0,PROSTBA='',PROSTBB='',
                  PROPRIVEN='1/1/1753',PROMVDDAT='1/1/1753',PROMVDVAL=0,PROUVDDAT='1/1/1753',PROUVDVAL=0,
                  PROPRICOM='1/1/1753',PROMCPDAT='1/1/1753',PROMCPVAL=0,PROUCPDAT='1/1/1753',PROUCPVAL=0,
                  PROGERPEN='S',PROSAIEMP=0,PROSAICOD=0,PROENTEMP=0,PROENTCOD=0,PROPVDVAL=0,PROPVDNFS=0,PROUVDNFS=0,
                  PROMVDNFS=0,PROPCPVAL=0,PROPCPNFE=0,PROUCPNFE=0,PROMCPNFE=0,MARNOM=''
 where MARNOM is null
commit tran


begin tran
update TBS010 set FOREMPCOD=0,FORCOD=0 where FORCOD is null
commit tran

begin tran
update TBS010 set MARCOD=cast(subString(PROCOD,1,3) as smallint) where MARCOD=0 and Len(Ltrim(PROCOD))=7

begin tran
update TBS010 set MARCOD=cast(subString(PROCOD,1,4) as smallint) where MARCOD=0 and Len(Ltrim(PROCOD))=8

select top 10 cast(subString(PROCOD,1,3) as smallint) from TBS010 

select count(*) from TBS010 where MARCOD=0 and Len(Ltrim(PROCOD))=7


begin tran
update TBS010 set MARNOM=TBS014.MARNOM from TBS010,TBS014 where TBS010.MARNOM='' and TBS010.MARCOD=TBS014.MARCOD


select TBS010.MARCOD,TBS010.MARNOM,TBS014.MARCOD,TBS014.MARNOM from TBS010,TBS014
 where TBS010.MARNOM='' and TBS010.MARCOD=TBS014.MARCOD
