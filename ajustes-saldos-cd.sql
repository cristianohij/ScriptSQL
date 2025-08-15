update TBS032 set ESTQTDATU = 0,ESTQTDRES=0,ESTQTDPEN=0,ESTQTDCMP=0

update TBS032 set STQTDATU = 0,ESTQTDRES=0,ESTQTDPEN=0,ESTQTDCMP=0

select ESTQTDATU,ESTQTDRES,ESTQTDPEN,ESTQTDCMP from TBS032 (nolock) where ESTQTDATU<>0 or ESTQTDRES<>0 or ESTQTDPEN<>0 or ESTQTDCMP<>0

select ESTQTDATU,ESTQTDRES from TBS032 (nolock) where ESTQTDRES>ESTQTDATU and ESTQTDATU<>0

update TBS032 set ESTQTDRES=0

update TBS032 set ESTQTDATU=ESTQTDRES where ESTQTDRES>ESTQTDATU and ESTQTDATU=0

delete TBS0451

select * from TBS0451 (nolock)

select A.PROEMPCOD,A.ESTLOC,A.PROCOD,A.ESTQTDCMP,isNull(sum((B.PDCQTD - (B.PDCQTDENT + B.PDCQTDRES)) * B.PDCQTDEMB),0)
  from TBS032 A (nolock) join TBS0451 B (nolock) on B.PROEMPCOD = A.PROEMPCOD and B.PROCOD = A.PROCOD and B.LESCOD = A.ESTLOC
 group by A.PROEMPCOD,A.ESTLOC,A.PROCOD,A.ESTQTDCMP
having A.ESTQTDCMP <> isNull(sum((B.PDCQTD - (B.PDCQTDENT + B.PDCQTDRES)) * B.PDCQTDEMB),0)

SELECT Left(produto,8),convert(money,right(produto,14)) FROM OPENROWSET('MSDASQL','Driver={Microsoft Text Driver (*.txt; *.csv)};DefaultDir=C:\temp','SELECT * FROM saldocd.txt')

SELECT Left(produto,8),convert(money,right(produto,14))
  FROM OPENROWSET('MSDASQL','Driver={Microsoft Text Driver (*.txt; *.csv)};DefaultDir=C:\temp','SELECT * FROM saldocd.txt')
 where Left(produto,8) = '0050539'

update TBS032 set ESTQTDATU = 0

update TBS032 set ESTQTDATU = (SELECT convert(money,right(produto,14))
                                FROM OPENROWSET('MSDASQL','Driver={Microsoft Text Driver (*.txt; *.csv)};DefaultDir=C:\temp','SELECT * FROM saldocd.txt')
                               where Left(produto,8) = PROCOD)

select * from TBS032 (nolock) where PROCOD = '4220260'

delete TBS032 where ESTLOC <> 1

delete TBS0591 where not exists(select '' from TBS059 where TBS0591.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFENUM=TBS059.NFENUM and
                                             TBS0591.NFECOD=TBS059.NFECOD and TBS0591.SEREMPCOD=TBS059.SEREMPCOD and TBS0591.SERCOD=TBS059.SERCOD)

delete TBS0594 where not exists(select '' from TBS059 where TBS0594.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0594.NFETIP=TBS059.NFETIP and 
TBS0594.NFENUM=TBS059.NFENUM and
                                             TBS0594.NFECOD=TBS059.NFECOD and TBS0594.SEREMPCOD=TBS059.SEREMPCOD and TBS0594.SERCOD=TBS059.SERCOD)

delete TBS0593 where not exists(select '' from TBS059 where TBS0593.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0593.NFETIP=TBS059.NFETIP and 
TBS0593.NFENUM=TBS059.NFENUM and
                                             TBS0593.NFECOD=TBS059.NFECOD and TBS0593.SEREMPCOD=TBS059.SEREMPCOD and TBS0593.SERCOD=TBS059.SERCOD)

delete TBS0592 where not exists(select '' from TBS059 where TBS0592.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0592.NFETIP=TBS059.NFETIP and 
TBS0592.NFENUM=TBS059.NFENUM and
                                             TBS0592.NFECOD=TBS059.NFECOD and TBS0592.SEREMPCOD=TBS059.SEREMPCOD and TBS0592.SERCOD=TBS059.SERCOD)

select * from TBS0163 where LESCOD <> 1

delete TBS0163 where LESCOD <> 1

select top 10 subString(NFEUSUEFE,7,4)+subString(NFEUSUEFE,4,2)+subString(NFEUSUEFE,1,2),NFEUSUEFE,*
  from TBS059 (nolock)
 where subString(NFEUSUEFE,7,4)+subString(NFEUSUEFE,4,2)+subString(NFEUSUEFE,1,2) < '20130710'

delete TBS059 where subString(NFEUSUEFE,7,4)+subString(NFEUSUEFE,4,2)+subString(NFEUSUEFE,1,2) < '20130710'

update TBS032 set ESTQTDATU = 0 where ESTQTDATU is null

select * from TBS058 (nolock) where not exists(select '' from TBS0551 (nolock) where TBS0551.PDVNUM=TBS058.PRPNUM and TBS0551.PDVITEM=TBS058.PRPITEM)

delete TBS058 where not exists(select '' from TBS0551 (nolock) where TBS0551.PDVNUM=TBS058.PRPNUM and TBS0551.PDVITEM=TBS058.PRPITEM)

select * from TBS053 (nolock) where BCPTIPTRN='P' and not exists(select '' from TBS055 (nolock) where TBS055.PDVNUM=TBS053.BCPNUM)

select count(*) from TBS053 (nolock)
select count(*) from TBS102 (nolock)

delete TBS078

select count(*) from TBS0801 (nolock)