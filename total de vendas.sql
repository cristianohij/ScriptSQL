declare @database char(8)

set @database='20141015'

select T1.PROCOD as 'código do produto',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=T1.PROCOD) as 'descrição do produto',
       (select MARNOM from TBS010 (nolock) where TBS010.PROCOD=T1.PROCOD) as 'nome da marca',
       sum(T1.NFSQTD*T1.NFSQTDEMB) as 'qtde retaguarda',
       sum(dbo.NFSTOTITE(T1.NFSEMPCOD,T1.NFSNUM,T1.SNEEMPCOD,T1.SNESER,T1.NFSITE)) as 'valor retaguarda',
       isnull((select sum(M2_QTD) from MSL002 (nolock) where M2_DATMOV >= @database and M2_TIPREG='01' and M2_REGCAN='F' and M2_PROCOD=T1.PROCOD),0) as 'qtde loja',
       isnull((select sum(M2_VALTOT) from MSL002 (nolock) where M2_DATMOV >= @database and M2_TIPREG='01' and M2_REGCAN='F' and M2_PROCOD=T1.PROCOD),0) as 'valor loja'
  from TBS0671 as T1 (nolock) right join TBS067 as T2 (nolock) on T2.SNESER=T1.SNESER and T2.NFSNUM=T1.NFSNUM
 where T2.NFSDATEMI >= @database and
       T2.NFSCAN='N' and
       T2.NFSDEV='N' and
       T2.NFSTIP='N'
 group by T1.PROCOD


declare @database char(8)

--set @database='20141015'
set @database='20140810'

--select T1.PROCOD as 'código do produto',
--       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=T1.PROCOD) as 'descrição do produto',
--       (select MARNOM from TBS010 (nolock) where TBS010.PROCOD=T1.PROCOD) as 'nome da marca',
--       sum(T1.NFSQTD*T1.NFSQTDEMB) as 'qtde retaguarda',
--       sum(dbo.NFSTOTITE(T1.NFSEMPCOD,T1.NFSNUM,T1.SNEEMPCOD,T1.SNESER,T1.NFSITE)) as 'valor retaguarda',
--       isnull((select sum(M2_QTD) from MSL002 (nolock) where M2_DATMOV >= @database and M2_TIPREG='01' and M2_REGCAN='F' and M2_PROCOD=T1.PROCOD),0) as 'qtde loja',
--       isnull((select sum(M2_VALTOT) from MSL002 (nolock) where M2_DATMOV >= @database and M2_TIPREG='01' and M2_REGCAN='F' and M2_PROCOD=T1.PROCOD),0) as 'valor loja'
--  from TBS0671 as T1 (nolock) right join TBS067 as T2 (nolock) on T2.SNESER=T1.SNESER and T2.NFSNUM=T1.NFSNUM
-- where T2.NFSDATEMI >= @database and
--       T2.NFSCAN='N' and
--       T2.NFSDEV='N' and
--       T2.NFSTIP='N'
-- group by T1.PROCOD


select TBS010.PROCOD as 'código do produto',
       PRODES as 'descrição do produto',
       MARNOM as 'nome da marca',
       isnull(sum(NFSQTD*NFSQTDEMB),0) as 'qtde retaguarda',
       isnull(sum(dbo.NFSTOTITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,NFSITE)),0) as 'valor retaguarda',
       isnull(sum(M2_QTD),0) as 'qtde loja',
       isnull(sum(M2_VALTOT-M2_ABT),0) as 'valor loja'
  from TBS010 (nolock) left join TBS0671 (nolock) on TBS0671.PROCOD=TBS010.PROCOD
                       full join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM and
                                               NFSDATEMI >= @database and
                                               NFSCAN='N' and
                                               NFSDEV='N' and
                                               NFSTIP='N'
                       full join MSL002 (nolock) on M2_PROCOD=TBS010.PROCOD and
                                               M2_DAT >= @database and
                                               M2_TIPREG='01' and
                                               M2_REGCAN='F'
 group by TBS010.PROCOD,PRODES,MARNOM
--having isnull(sum(NFSQTD*NFSQTDEMB),0) > 0 or
--       isnull(sum(M2_QTD),0) > 0