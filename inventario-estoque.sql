select * from TBS037 (nolock) order by MVIDATLAN

select distinct SALREF from TBS098 (nolock)

select * from TBS098 (nolock) where SALREF='12/2012'

select SALQTD*SALVAL,* from TBS098 (nolock) where SALREF='12/2012' and PROCOD='6531938'

select count(*) from TBS098 (nolock) where SALREF='12/2014' and SALQTD>0 and SALVAL>0

select * from TBS098 (nolock) where SALREF='12/2014' and SALQTD>100000

update TBS098 set SALQTD=0 where SALREF='12/2014' and PROCOD='3634033'

select * from TBS034 (nolock)

drop table #INV

select PROCOD,SALQTD as 'QTDE',SALVAL as 'VALOR' into #INV from TBS098 (nolock) where SALREF='12/2014'

select *,(select PRODES from TBS010 (nolock) where TBS010.PROCOD=#INV.PROCOD),(select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=#INV.PROCOD)
  from #INV
 where QTDE>100000

delete from #INV where QTDE=0

select PROCOD,PRODES,PROUM1,isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=PROCOD),0),
       isnull((select sum(ESTQTDATU-ESTQTDRES) from TBS032 (nolock) where TBS032.PROCOD=TBS010.PROCOD and ESTLOC in(1,2)),0)
  from TBS010 (nolock)

select PROCOD,PRODES,PROUM1,isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=PROCOD),0),
       isnull((select sum(ESTQTDATU-ESTQTDRES) from TBS032 (nolock) where TBS032.PROCOD=TBS010.PROCOD and ESTLOC=1),0)
  from TBS010 (nolock)

select isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=PROCOD),0) *
       isnull((select sum(ESTQTDATU-ESTQTDRES) from TBS032 (nolock) where TBS032.PROCOD=TBS010.PROCOD and ESTLOC in(1,2)),0)
  from TBS010 (nolock)

