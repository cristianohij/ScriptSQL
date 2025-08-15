select top 1 * from TBS059 (nolock)

select top 1 * from TBS099 (nolock)

NFECHAACE
NEECHAACE

NEENFEENT NEENFEEFE

-- entradas sem marcação
select count(*) from TBS099 (nolock) where NEENFEENT='N' and exists(select '' from TBS059 (nolock) where NFECHAACE=NEECHAACE)


select *
  from TBS099 (nolock)
       inner join TBS059 (nolock) on NFECHAACE=NEECHAACE
 where NEENFEENT='N' and NFEUSUEFE<>'' 

