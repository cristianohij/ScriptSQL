declare @datai char(10), @dataf char(10)

set @datai = '2012-01-01'
set @dataf = '2012-01-20'

select PROCOD,PRODES from TBS010 (nolock)
 where not exists(select 'ne' from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.NFSNUM = TBS067.NFSNUM
                   where TBS0671.PROCOD=TBS010.PROCOD and not TBS067.NFSDATEMI between @datai and @dataf)