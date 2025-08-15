select convert(char(7),NFSDATEMI,111) as 'mes-ano',
       NFSCLICOD as 'cliente',
       (select CLINOM from TBS002 (nolock) where CLICOD=NFSCLICOD) as 'nome',
       sum(dbo.NFSTOTLIQ(0,TBS067.NFSNUM,0,TBS067.SNESER)) as 'valor'
  from TBS067 (nolock) left join TBS0671 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
 where NFSDATEMI between '20170905' and '20170905' and NFSDEV='N' and NFSCAN='N'
 group by convert(char(7),NFSDATEMI,111),NFSCLICOD


select sum(dbo.NFSTOTLIQ(0,TBS067.NFSNUM,0,TBS067.SNESER)) from TBS067 (nolock) where NFSDATEMI between '20170901' and '20170905' and NFSDEV='N' and NFSCAN='N'