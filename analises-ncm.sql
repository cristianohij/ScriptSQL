select * from TBS0921 (nolock)
 where NCMCOD in(select PROCLAFIS from TBS010 where PROSTBB='00')

select * from TBS010 (nolock) where PROCLAFIS='38249079'

select PROCLAFIS,PROSTBB,count(*)
  from TBS010 as A (nolock)
 where (select count(*) from TBS010 as B (nolock) where B.PROCLAFIS=A.PROCLAFIS and B.PROSTBB<>A.PROSTBB) > 1
 group by PROCLAFIS,PROSTBB

select produto from ESTOQUE T1 (nolock) where (select count(*) from ESTOQUE T2 (nolock) where T1.produto=T2.produto) > 1

select PROCLAFIS,PROSTBB from TBS010 (nolock) where PROCLAFIS='48059300'