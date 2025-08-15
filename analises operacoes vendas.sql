select distinct TESTXT from TBS042 (nolock)
 where exists(select '' from TBS0671 (nolock) where TBS0671.TESCOD = TBS042.TESCOD)

select distinct TBS042.TESCOD,TBS0671.NFSCFOP,TBS042.TESTXT,TBS0671.NFSCST,TBS0671.PROCOD
  from TBS042 (nolock) right join TBS0671 (nolock) on TBS042.TESEMPCOD = TBS0671.TESEMPCOD and TBS042.TESCOD = TBS0671.TESCOD
-- where exists(select '' from TBS0671 (nolock) where TBS0671.TESCOD = TBS042.TESCOD)

select count(*) from TBS0671 (nolock) where NFSCFOP = ''