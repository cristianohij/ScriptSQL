select year(ENFDATEMI) as ano,
       ENFESTDES as UF,
       count(*) as qtde
  from TBS080 (nolock)
 where ENFDATEMI >= '20140101' and
       ENFESTDES <> 'SP' and ENFESTDES <> '' and
       ENFFINEMI=4 and
       ENFSIT=6
 group by year(ENFDATEMI),ENFESTDES
 order by year(ENFDATEMI),ENFESTDES

--select top 1 * from TBS080 (nolock)

declare @empresa char(15)

set @empresa = 'Tanby matriz'

select @empresa,
       TBS0671.NFSCFOP,count(*)
  from TBS0671 (nolock)
       right join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
 where TBS067.NFSDATEMI >= '20140101' and
       TBS067.NFSTIP='N' and
       TBS067.NFSCAN<>'S'
 group by TBS0671.NFSCFOP


--select top 1 * from TBS059 (nolock)

declare @empresa char(15)

set @empresa = 'Tanby matriz'

select @empresa as empresa,
       year(NFEDATENT) as ano,
       NFEESTORI as UF,
       count(*) as qtde
  from TBS059 (nolock)
 where NFEDATENT >= '20140101' and
       NFETIP='N' and
       NFEESTORI <> '' and
       NFECAN<>'S'
 group by year(NFEDATENT),NFEESTORI
 order by year(NFEDATENT),NFEESTORI
