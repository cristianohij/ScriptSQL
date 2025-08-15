select NFSDATEMI,
       NFSCLICOD,
       count(*) as 'conta'
       into #notas
  from TBS067 (nolock)
 where NFSDATEMI >= '20130101'
 group by NFSDATEMI,NFSCLICOD
 order by conta desc

select NFSNUM,NFSCLICOD from TBS067 (nolock) where NFSDATEMI = '20130327' and NFSCLICOD = 7605

select * from #notas order by NFSDATEMI

select NFSDATEMI,count(*) from #notas group by NFSDATEMI order by NFSDATEMI
