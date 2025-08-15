select * from TBS034 (nolock)

select ESTLOC,COUNT(*) from TBS032 (nolock) group by ESTLOC

select PROCLAFIS,
       PROCOD,
       PRODES,
       PROSTBA+PROSTBB,
       isnull((select ESTQTDATU from TBS032 (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),0),
       isnull((select ESTQTDATU from TBS032 (nolock) where ESTLOC=2 and TBS032.PROCOD=TBS010.PROCOD),0)
  from TBS010 (nolock)
 where PROCLAFIS in('38109000','90258000','90330000') or PROCLAFIS Like('8515%') and PROSTATUS='A'
