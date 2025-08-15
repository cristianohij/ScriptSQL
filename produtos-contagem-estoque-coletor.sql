select ESTDATALT from TBS032 (nolock) order by ESTDATALT

select PROCOD,sum(ESTQTDATU) from TBS032 (nolock) group by PROCOD having sum(ESTQTDATU) <> 0

select PROCOD,sum(ESTQTDATU) from TBS032 (nolock) where ESTDATALT >= '20160701' group by PROCOD

select TBS010.PROCOD,PRODES,MARCOD,MARNOM
  from TBS010 (nolock)
 where (select top 1 1 from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)>='20160701' order by LMEDATHOR desc) > 0

select PROCOD,sum(ESTQTDATU) from TBS032 (nolock) where ESTDATALT < '20160701' group by PROCOD

