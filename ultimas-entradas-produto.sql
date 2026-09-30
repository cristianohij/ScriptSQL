select * from TBS0671 (nolock) inner join TBS067 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI>='20170101' and NFSCST='010'

select * from TBS080 (nolock) where ENFNUM=200151

select * from TBS0671 (nolock) inner join TBS067 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI>='20170101' and PROCOD='2540001' and UFESIG='SP'


select TBS059.NFEDATEFE
       ,TBS059.NFENOM
	   ,TBS059.NFENUM
       --,*
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where --TBS059.NFEDATENT between '20170101' and '20200131'
       --and 
       TBS0591.NFETIP<>'D'
       and TBS059.NFECAN<>'S'
       and TBS0591.PROCOD in('18310001')
       --and NFENCMXML='0018717'
 order by TBS059.NFEDATENT desc

-- simples nacional

select *
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT between '20100101' and '20181231' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and Len(TBS0591.NFECST) > 3
 order by TBS059.NFEDATENT desc



select TBS059.NFETIP, TBS059.SERCOD, TBS059.NFENUM, TBS059.NFECOD, NFECFOP, NFEDATEFE, NFEITE, dbo.NFETOTITE(0, TBS0591.NFETIP, TBS059.NFENUM, TBS059.NFECOD, 0, TBS059.SERCOD, NFEITE)
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE between '20171001' and '20171031' and TBS0591.NFECFOP in('1.910')
 order by NFEDATEFE, NFECFOP, TBS059.NFENUM

select TBS059.NFETIP,TBS059.SERCOD,TBS059.NFENUM,TBS059.NFECOD,NFECFOP,NFEDATEFE,NFECST
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE between '20171001' and '20171031' and TBS0591.NFECFOP in('1.910')
 group by TBS059.NFETIP,TBS059.SERCOD,TBS059.NFENUM,TBS059.NFECOD,NFECFOP,NFECST, NFEDATEFE
 order by NFEDATEFE, NFECFOP, NFECST, TBS059.NFENUM

select TBS059.NFECOD
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE between '20170801' and '20170831' and TBS0591.NFECFOP in('1.556','2.556')
 group by TBS059.NFECOD
 order by NFECOD

select NFEDATEFE,TBS059.NFENUM
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE between '20170801' and '20170831' and TBS0591.NFECFOP in('1.556','2.556')
 group by NFEDATEFE,TBS059.NFENUM
 order by TBS059.NFENUM


select NFECFOP
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE >= '20170601' and TBS059.NFECAN<>'S'
 group by NFECFOP
 order by NFECFOP

select NFECFOP
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE >= '20170701' and TBS059.NFECAN<>'S' and (NFEDES Like('COMBUST%') or NFEDES Like('%COMBUST%') or NFEDES Like('POSTO%') or NFEDES Like('%POSTO%'))
 group by NFECFOP
 order by NFECFOP


select TBS059.NFENUM, TBS059.NFECOD
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE between '20170101' and '20180420' and TBS0591.NFECFOP in('1.653')
 order by TBS059.NFENUM, TBS059.NFECOD




--

select PROCOD,NFEDES
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE between '20180201' and '20180228' and TBS0591.NFECFOP in('1.556','2.556','1.407','2.407')
 group by PROCOD,NFEDES

-- taubat�

select TBS059.NFETIP, TBS059.SERCOD, TBS059.NFENUM, TBS059.NFECOD, NFECFOP, NFEDATEFE, NFEITE, dbo.NFETOTITE(0, TBS0591.NFETIP, TBS059.NFENUM, TBS059.NFECOD, 0, TBS059.SERCOD, NFEITE)
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE between '20170801' and '20170831' and TBS0591.NFECFOP in('1.556','2.556','1.407','2.407') and
       (TBS0591.NFEDES Like('AUTO POSTO%') or TBS0591.NFEDES Like('AGUA MINERAL%') or TBS0591.NFEDES Like('REFEICOES%') or TBS0591.NFEDES Like('CESTAR BASICA%')
        or TBS0591.NFEDES Like('GASOLINA%') or TBS0591.NFEDES Like('REFEICOES%'))
 order by NFEDATEFE, NFECFOP, TBS059.NFENUM

select convert(date,NFEDATEFE) as data,
       TBS059.NFENUM as numero,
       NFECFOP as CFOP,
       NFEITE as item,
       dbo.NFETOTITE(0, TBS0591.NFETIP, TBS059.NFENUM, TBS059.NFECOD, 0, TBS059.SERCOD, NFEITE) as valor
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE between '20170801' and '20170831' and TBS0591.NFECFOP in('1.556','2.556','1.407','2.407') and
       (TBS0591.NFEDES Like('AUTO POSTO%') or TBS0591.NFEDES Like('AGUA MINERAL%') or TBS0591.NFEDES Like('REFEICOES%') or TBS0591.NFEDES Like('CESTAR BASICA%')
        or TBS0591.NFEDES Like('GASOLINA%') or TBS0591.NFEDES Like('REFEICOES%'))
 order by NFEDATEFE, NFECFOP, TBS059.NFENUM


-- tanby matriz

select TBS059.NFETIP, TBS059.SERCOD, TBS059.NFENUM, TBS059.NFECOD, NFECFOP, NFEDATEFE, NFEITE, dbo.NFETOTITE(0, TBS0591.NFETIP, TBS059.NFENUM, TBS059.NFECOD, 0, TBS059.SERCOD, NFEITE)
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE between '20170801' and '20170831' and TBS0591.NFECFOP in('1.556','2.556','1.407','2.407') and
       (TBS0591.NFEDES Like('AUTO POSTO%') or TBS0591.NFEDES Like('AGUA MINERAL%') or TBS0591.NFEDES Like('REFEICOES%') or TBS0591.NFEDES Like('CESTAR BASICA%')
        or TBS0591.NFEDES Like('GASOLINA%') or TBS0591.NFEDES Like('REFEICOES%'))
 order by NFEDATEFE, NFECFOP, TBS059.NFENUM

select convert(date,NFEDATEFE) as data,
       TBS059.NFENUM as numero,
       NFECFOP as CFOP,
       NFEITE as item,
       dbo.NFETOTITE(0, TBS0591.NFETIP, TBS059.NFENUM, TBS059.NFECOD, 0, TBS059.SERCOD, NFEITE) as valor
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE between '20170801' and '20170831' and TBS0591.NFECFOP in('1.556','2.556','1.407','2.407') and
       (TBS0591.NFEDES Like('ACUCAR%') or TBS0591.NFEDES Like('LUBRIFICANTE WD-40%') or TBS0591.NFEDES Like('AGUA MINERAL%') or TBS0591.NFEDES Like('AUTO POSTO%')
        or TBS0591.NFEDES Like('CESTA BASICA%') or TBS0591.NFEDES Like('REFEICOES%'))
 order by NFEDATEFE, NFECFOP, TBS059.NFENUM

select *
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where --TBS059.NFEDATENT between '20170101' and '20200131'
       --and 
       TBS0591.NFETIP<>'D'
       and TBS059.NFECAN<>'S'
       and TBS0591.NFECFOP in('5.103')
       --and NFENCMXML='0018717'
 order by TBS059.NFEDATENT desc

-- do grupo todo

-- códigos fornecedores grupo

if object_id('tempdb.dbo.#grupo_nd') is not null
    begin
    	drop table #grupo_nd
    end

select f.FORCOD as codigo
  into #grupo_nd
  from TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- best bag

if object_id('tempdb.dbo.#grupo_bb') is not null
    begin
    	drop table #grupo_bb
    end

select f.FORCOD as codigo
  into #grupo_bb
  from bb.SIBD2.dbo.TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- misaspel

if object_id('tempdb.dbo.#grupo_mi') is not null
    begin
    	drop table #grupo_mi
    end

select FORCOD as codigo
  into #grupo_mi	
  from mi.SIBD3.dbo.TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- papelyna

if object_id('tempdb.dbo.#grupo_pp') is not null
    begin
    	drop table #grupo_pp
    end

select FORCOD as codigo
  into #grupo_pp
  from pp.SIBD.dbo.TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- tanby cd

if object_id('tempdb.dbo.#grupo_cd') is not null
    begin
    	drop table #grupo_cd
    end

select FORCOD as codigo
  into #grupo_cd
  from cd.SIBD.dbo.TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- tanby taubaté

if object_id('tempdb.dbo.#grupo_tt') is not null
    begin
    	drop table #grupo_tt
    end

select FORCOD as codigo
  into #grupo_tt
  from tt.SIBD.dbo.TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- produtos

/*
declare @codigo varchar(max)

set @codigo = '1640054,1080067'

-- tanby matriz

select * from (
select top 1
       'TM' as empresa
       ,c.NFEDATEFE
       ,c.NFENOM
	     ,c.NFENUM
       ,d.PROCOD
  from TBS0591 d (nolock)
 inner join TBS059 c (nolock)
         on d.SERCOD = c.SERCOD
            and d.NFETIP = c.NFETIP
            and d.NFECOD = c.NFECOD
            and d.NFENUM = c.NFENUM
 where d.NFETIP <> 'D'
       and c.NFECAN <> 'S'
       and c.NFECOD not in(select codigo from #grupo_nd with (nolock))
       and d.PROCOD in (select * from dbo.SplitString(@codigo, ','))
       and c.NFEDATEFE <> '17530101'
 order by c.NFEDATEFE desc
) tm

union all

-- tanby taubaté

select * from (
select top 1
       'TT' as empresa
       ,c.NFEDATEFE
       ,c.NFENOM
	     ,c.NFENUM
       ,d.PROCOD
  from tt.SIBD.dbo.TBS0591 d (nolock)
 inner join tt.SIBD.dbo.TBS059 c (nolock)
         on d.SERCOD = c.SERCOD
            and d.NFETIP = c.NFETIP
            and d.NFECOD = c.NFECOD
            and d.NFENUM = c.NFENUM
 where d.NFETIP <> 'D'
       and c.NFECAN <> 'S'
       and c.NFECOD not in(select codigo from #grupo_tt with (nolock))
       and d.PROCOD in (select * from dbo.SplitString(@codigo, ','))
       and c.NFEDATEFE <> '17530101'
 order by c.NFEDATEFE desc
) tt

union all

-- tanby cd

select * from (
select top 1
       'CD' collate database_default as empresa
       ,c.NFEDATEFE
       ,c.NFENOM collate database_default as NFENOM
	     ,c.NFENUM
       ,d.PROCOD collate database_default as PROCOD
  from cd.SIBD.dbo.TBS0591 d (nolock)
 inner join cd.SIBD.dbo.TBS059 c (nolock)
         on d.SERCOD = c.SERCOD
            and d.NFETIP = c.NFETIP collate database_default
            and d.NFECOD = c.NFECOD
            and d.NFENUM = c.NFENUM
 where d.NFETIP <> 'D'
       and c.NFECAN <> 'S'
       and c.NFECOD not in(select codigo from #grupo_cd with (nolock))
       and d.PROCOD collate database_default in (select * from dbo.SplitString(@codigo, ','))
       and c.NFEDATEFE <> '17530101'
 order by c.NFEDATEFE desc
) cd

union all

-- best bag

select * from (
select top 1
       'BB' as empresa
       ,c.NFEDATEFE
       ,c.NFENOM
	     ,c.NFENUM
       ,d.PROCOD
  from bb.SIBD2.dbo.TBS0591 d (nolock)
 inner join bb.SIBD2.dbo.TBS059 c (nolock)
         on d.SERCOD = c.SERCOD
            and d.NFETIP = c.NFETIP
            and d.NFECOD = c.NFECOD
            and d.NFENUM = c.NFENUM
 where d.NFETIP <> 'D'
       and c.NFECAN <> 'S'
       and c.NFECOD not in(select codigo from #grupo_bb with (nolock))
       and d.PROCOD in (select * from dbo.SplitString(@codigo, ','))
       and c.NFEDATEFE <> '17530101'
 order by c.NFEDATEFE desc
) bb

union all

-- misaspel

select * from (
select top 1
       'MI' as empresa
       ,c.NFEDATEFE
       ,c.NFENOM
	     ,c.NFENUM
       ,d.PROCOD
  from mi.SIBD3.dbo.TBS0591 d (nolock)
 inner join mi.SIBD3.dbo.TBS059 c (nolock)
         on d.SERCOD = c.SERCOD
            and d.NFETIP = c.NFETIP
            and d.NFECOD = c.NFECOD
            and d.NFENUM = c.NFENUM
 where d.NFETIP <> 'D'
       and c.NFECAN <> 'S'
       and c.NFECOD not in(select codigo from #grupo_mi with (nolock))
       and d.PROCOD in (select * from dbo.SplitString(@codigo, ','))
       and c.NFEDATEFE <> '17530101'
 order by c.NFEDATEFE desc
) mi

union all

-- papelyna

select * from (
select top 1
       'PP' as empresa
       ,c.NFEDATEFE
       ,c.NFENOM
	     ,c.NFENUM
       ,d.PROCOD
  from pp.SIBD.dbo.TBS0591 d (nolock)
 inner join pp.SIBD.dbo.TBS059 c (nolock)
         on d.SERCOD = c.SERCOD
            and d.NFETIP = c.NFETIP
            and d.NFECOD = c.NFECOD
            and d.NFENUM = c.NFENUM
 where d.NFETIP <> 'D'
       and c.NFECAN <> 'S'
       and c.NFECOD not in(select codigo from #grupo_pp with (nolock))
       and d.PROCOD in (select * from dbo.SplitString(@codigo, ','))
       and c.NFEDATEFE <> '17530101'
 order by c.NFEDATEFE desc
) pp
*/

-- versão corrigida

declare @codigo varchar(max)

set @codigo = '12010002'

-- TM
select *
from (
    select 
           'TM' as empresa,
           c.NFEDATEFE,
           c.NFENOM,
           c.NFENUM,
           d.PROCOD,
           row_number() over (partition by d.PROCOD order by c.NFEDATEFE desc) as rn
    from TBS0591 d (nolock)
    inner join TBS059 c (nolock)
        on d.SERCOD = c.SERCOD
       and d.NFETIP = c.NFETIP
       and d.NFECOD = c.NFECOD
       and d.NFENUM = c.NFENUM
    where d.NFETIP <> 'D'
      and c.NFECAN <> 'S'
      and c.NFECOD not in (select codigo from #grupo_nd)
      and d.PROCOD in (select * from dbo.SplitString(@codigo, ','))
      and c.NFEDATEFE <> '17530101'
) tm
where rn = 1

union all

-- TT
select *
from (
    select 
           'TT' as empresa,
           c.NFEDATEFE,
           c.NFENOM,
           c.NFENUM,
           d.PROCOD,
           row_number() over (partition by d.PROCOD order by c.NFEDATEFE desc) as rn
    from tt.SIBD.dbo.TBS0591 d (nolock)
    inner join tt.SIBD.dbo.TBS059 c (nolock)
        on d.SERCOD = c.SERCOD
       and d.NFETIP = c.NFETIP
       and d.NFECOD = c.NFECOD
       and d.NFENUM = c.NFENUM
    where d.NFETIP <> 'D'
      and c.NFECAN <> 'S'
      and c.NFECOD not in (select codigo from #grupo_tt)
      and d.PROCOD in (select * from dbo.SplitString(@codigo, ','))
      and c.NFEDATEFE <> '17530101'
) tt
where rn = 1

union all

-- CD
select *
from (
    select 
           'CD' collate database_default as empresa,
           c.NFEDATEFE,
           c.NFENOM collate database_default as NFENOM,
           c.NFENUM,
           d.PROCOD collate database_default as PROCOD,
           row_number() over (
               partition by d.PROCOD collate database_default 
               order by c.NFEDATEFE desc
           ) as rn
    from cd.SIBD.dbo.TBS0591 d (nolock)
    inner join cd.SIBD.dbo.TBS059 c (nolock)
        on d.SERCOD = c.SERCOD
       and d.NFETIP = c.NFETIP collate database_default
       and d.NFECOD = c.NFECOD
       and d.NFENUM = c.NFENUM
    where d.NFETIP <> 'D'
      and c.NFECAN <> 'S'
      and c.NFECOD not in (select codigo from #grupo_cd)
      and d.PROCOD collate database_default in (select * from dbo.SplitString(@codigo, ','))
      and c.NFEDATEFE <> '17530101'
) cd
where rn = 1

union all

-- BB
select *
from (
    select 
           'BB' as empresa,
           c.NFEDATEFE,
           c.NFENOM,
           c.NFENUM,
           d.PROCOD,
           row_number() over (partition by d.PROCOD order by c.NFEDATEFE desc) as rn
    from bb.SIBD2.dbo.TBS0591 d (nolock)
    inner join bb.SIBD2.dbo.TBS059 c (nolock)
        on d.SERCOD = c.SERCOD
       and d.NFETIP = c.NFETIP
       and d.NFECOD = c.NFECOD
       and d.NFENUM = c.NFENUM
    where d.NFETIP <> 'D'
      and c.NFECAN <> 'S'
      and c.NFECOD not in (select codigo from #grupo_bb)
      and d.PROCOD in (select * from dbo.SplitString(@codigo, ','))
      and c.NFEDATEFE <> '17530101'
) bb
where rn = 1

union all

-- MI
select *
from (
    select 
           'MI' as empresa,
           c.NFEDATEFE,
           c.NFENOM,
           c.NFENUM,
           d.PROCOD,
           row_number() over (partition by d.PROCOD order by c.NFEDATEFE desc) as rn
    from mi.SIBD3.dbo.TBS0591 d (nolock)
    inner join mi.SIBD3.dbo.TBS059 c (nolock)
        on d.SERCOD = c.SERCOD
       and d.NFETIP = c.NFETIP
       and d.NFECOD = c.NFECOD
       and d.NFENUM = c.NFENUM
    where d.NFETIP <> 'D'
      and c.NFECAN <> 'S'
      and c.NFECOD not in (select codigo from #grupo_mi)
      and d.PROCOD in (select * from dbo.SplitString(@codigo, ','))
      and c.NFEDATEFE <> '17530101'
) mi
where rn = 1

union all

-- PP
select *
from (
    select 
           'PP' as empresa,
           c.NFEDATEFE,
           c.NFENOM,
           c.NFENUM,
           d.PROCOD,
           row_number() over (partition by d.PROCOD order by c.NFEDATEFE desc) as rn
    from pp.SIBD.dbo.TBS0591 d (nolock)
    inner join pp.SIBD.dbo.TBS059 c (nolock)
        on d.SERCOD = c.SERCOD
       and d.NFETIP = c.NFETIP
       and d.NFECOD = c.NFECOD
       and d.NFENUM = c.NFENUM
    where d.NFETIP <> 'D'
      and c.NFECAN <> 'S'
      and c.NFECOD not in (select codigo from #grupo_pp)
      and d.PROCOD in (select * from dbo.SplitString(@codigo, ','))
      and c.NFEDATEFE <> '17530101'
) pp
where rn = 1
go

CREATE PROCEDURE dbo.usp_UltimaCompraProdutoGrupo
(
    @codigo VARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;

    /* =========================================================
       FORNECEDORES DO GRUPO
    ========================================================= */

    IF OBJECT_ID('tempdb..#grupo_nd') IS NOT NULL
        DROP TABLE #grupo_nd;

    SELECT f.FORCOD AS codigo
      INTO #grupo_nd
      FROM TBS006 f WITH (NOLOCK)
     WHERE f.FORCGC LIKE '65069593%' OR -- tanby
           f.FORCGC LIKE '05118717%' OR -- misaspel
           f.FORCGC LIKE '52080207%' OR -- best bag
           f.FORCGC LIKE '44125185%' OR -- papelyna
           f.FORCGC LIKE '41952080%';   -- winpack


    IF OBJECT_ID('tempdb..#grupo_bb') IS NOT NULL
        DROP TABLE #grupo_bb;

    SELECT f.FORCOD AS codigo
      INTO #grupo_bb
      FROM bb.SIBD2.dbo.TBS006 f WITH (NOLOCK)
     WHERE f.FORCGC LIKE '65069593%' OR
           f.FORCGC LIKE '05118717%' OR
           f.FORCGC LIKE '52080207%' OR
           f.FORCGC LIKE '44125185%' OR
           f.FORCGC LIKE '41952080%';


    IF OBJECT_ID('tempdb..#grupo_mi') IS NOT NULL
        DROP TABLE #grupo_mi;

    SELECT f.FORCOD AS codigo
      INTO #grupo_mi
      FROM mi.SIBD3.dbo.TBS006 f WITH (NOLOCK)
     WHERE f.FORCGC LIKE '65069593%' OR
           f.FORCGC LIKE '05118717%' OR
           f.FORCGC LIKE '52080207%' OR
           f.FORCGC LIKE '44125185%' OR
           f.FORCGC LIKE '41952080%';


    IF OBJECT_ID('tempdb..#grupo_pp') IS NOT NULL
        DROP TABLE #grupo_pp;

    SELECT f.FORCOD AS codigo
      INTO #grupo_pp
      FROM pp.SIBD.dbo.TBS006 f WITH (NOLOCK)
     WHERE f.FORCGC LIKE '65069593%' OR
           f.FORCGC LIKE '05118717%' OR
           f.FORCGC LIKE '52080207%' OR
           f.FORCGC LIKE '44125185%' OR
           f.FORCGC LIKE '41952080%';


    IF OBJECT_ID('tempdb..#grupo_cd') IS NOT NULL
        DROP TABLE #grupo_cd;

    SELECT f.FORCOD AS codigo
      INTO #grupo_cd
      FROM cd.SIBD.dbo.TBS006 f WITH (NOLOCK)
     WHERE f.FORCGC LIKE '65069593%' OR
           f.FORCGC LIKE '05118717%' OR
           f.FORCGC LIKE '52080207%' OR
           f.FORCGC LIKE '44125185%' OR
           f.FORCGC LIKE '41952080%';


    IF OBJECT_ID('tempdb..#grupo_tt') IS NOT NULL
        DROP TABLE #grupo_tt;

    SELECT f.FORCOD AS codigo
      INTO #grupo_tt
      FROM tt.SIBD.dbo.TBS006 f WITH (NOLOCK)
     WHERE f.FORCGC LIKE '65069593%' OR
           f.FORCGC LIKE '05118717%' OR
           f.FORCGC LIKE '52080207%' OR
           f.FORCGC LIKE '44125185%' OR
           f.FORCGC LIKE '41952080%';

    /* =========================================================
       CONSULTA
    ========================================================= */

    SELECT *
    FROM
    (

        /* ================= TM ================= */

        SELECT *
        FROM (
            SELECT
                   'TM' AS empresa,
                   c.NFEDATEFE,
                   c.NFENOM,
                   c.NFENUM,
                   d.PROCOD,
                   ROW_NUMBER() OVER
                   (
                       PARTITION BY d.PROCOD
                       ORDER BY c.NFEDATEFE DESC
                   ) AS rn
            FROM TBS0591 d WITH (NOLOCK)
            INNER JOIN TBS059 c WITH (NOLOCK)
                    ON d.SERCOD = c.SERCOD
                   AND d.NFETIP = c.NFETIP
                   AND d.NFECOD = c.NFECOD
                   AND d.NFENUM = c.NFENUM
            WHERE d.NFETIP <> 'D'
              AND c.NFECAN <> 'S'
              AND c.NFECOD NOT IN (SELECT codigo FROM #grupo_nd)
              AND d.PROCOD IN (SELECT * FROM dbo.SplitString(@codigo, ','))
              AND c.NFEDATEFE <> '17530101'
        ) tm
        WHERE rn = 1

        UNION ALL

        /* ================= TT ================= */

        SELECT *
        FROM (
            SELECT
                   'TT' AS empresa,
                   c.NFEDATEFE,
                   c.NFENOM,
                   c.NFENUM,
                   d.PROCOD,
                   ROW_NUMBER() OVER
                   (
                       PARTITION BY d.PROCOD
                       ORDER BY c.NFEDATEFE DESC
                   ) AS rn
            FROM tt.SIBD.dbo.TBS0591 d WITH (NOLOCK)
            INNER JOIN tt.SIBD.dbo.TBS059 c WITH (NOLOCK)
                    ON d.SERCOD = c.SERCOD
                   AND d.NFETIP = c.NFETIP
                   AND d.NFECOD = c.NFECOD
                   AND d.NFENUM = c.NFENUM
            WHERE d.NFETIP <> 'D'
              AND c.NFECAN <> 'S'
              AND c.NFECOD NOT IN (SELECT codigo FROM #grupo_tt)
              AND d.PROCOD IN (SELECT * FROM dbo.SplitString(@codigo, ','))
              AND c.NFEDATEFE <> '17530101'
        ) tt
        WHERE rn = 1

        UNION ALL

        /* ================= CD ================= */

        SELECT *
        FROM (
            SELECT
                   'CD' COLLATE DATABASE_DEFAULT AS empresa,
                   c.NFEDATEFE,
                   c.NFENOM COLLATE DATABASE_DEFAULT AS NFENOM,
                   c.NFENUM,
                   d.PROCOD COLLATE DATABASE_DEFAULT AS PROCOD,
                   ROW_NUMBER() OVER
                   (
                       PARTITION BY d.PROCOD COLLATE DATABASE_DEFAULT
                       ORDER BY c.NFEDATEFE DESC
                   ) AS rn
            FROM cd.SIBD.dbo.TBS0591 d WITH (NOLOCK)
            INNER JOIN cd.SIBD.dbo.TBS059 c WITH (NOLOCK)
                    ON d.SERCOD = c.SERCOD
                   AND d.NFETIP = c.NFETIP COLLATE DATABASE_DEFAULT
                   AND d.NFECOD = c.NFECOD
                   AND d.NFENUM = c.NFENUM
            WHERE d.NFETIP <> 'D'
              AND c.NFECAN <> 'S'
              AND c.NFECOD NOT IN (SELECT codigo FROM #grupo_cd)
              AND d.PROCOD COLLATE DATABASE_DEFAULT IN
                  (SELECT * FROM dbo.SplitString(@codigo, ','))
              AND c.NFEDATEFE <> '17530101'
        ) cd
        WHERE rn = 1

        UNION ALL

        /* ================= BB ================= */

        SELECT *
        FROM (
            SELECT
                   'BB' AS empresa,
                   c.NFEDATEFE,
                   c.NFENOM,
                   c.NFENUM,
                   d.PROCOD,
                   ROW_NUMBER() OVER
                   (
                       PARTITION BY d.PROCOD
                       ORDER BY c.NFEDATEFE DESC
                   ) AS rn
            FROM bb.SIBD2.dbo.TBS0591 d WITH (NOLOCK)
            INNER JOIN bb.SIBD2.dbo.TBS059 c WITH (NOLOCK)
                    ON d.SERCOD = c.SERCOD
                   AND d.NFETIP = c.NFETIP
                   AND d.NFECOD = c.NFECOD
                   AND d.NFENUM = c.NFENUM
            WHERE d.NFETIP <> 'D'
              AND c.NFECAN <> 'S'
              AND c.NFECOD NOT IN (SELECT codigo FROM #grupo_bb)
              AND d.PROCOD IN (SELECT * FROM dbo.SplitString(@codigo, ','))
              AND c.NFEDATEFE <> '17530101'
        ) bb
        WHERE rn = 1

        UNION ALL

        /* ================= MI ================= */

        SELECT *
        FROM (
            SELECT
                   'MI' AS empresa,
                   c.NFEDATEFE,
                   c.NFENOM,
                   c.NFENUM,
                   d.PROCOD,
                   ROW_NUMBER() OVER
                   (
                       PARTITION BY d.PROCOD
                       ORDER BY c.NFEDATEFE DESC
                   ) AS rn
            FROM mi.SIBD3.dbo.TBS0591 d WITH (NOLOCK)
            INNER JOIN mi.SIBD3.dbo.TBS059 c WITH (NOLOCK)
                    ON d.SERCOD = c.SERCOD
                   AND d.NFETIP = c.NFETIP
                   AND d.NFECOD = c.NFECOD
                   AND d.NFENUM = c.NFENUM
            WHERE d.NFETIP <> 'D'
              AND c.NFECAN <> 'S'
              AND c.NFECOD NOT IN (SELECT codigo FROM #grupo_mi)
              AND d.PROCOD IN (SELECT * FROM dbo.SplitString(@codigo, ','))
              AND c.NFEDATEFE <> '17530101'
        ) mi
        WHERE rn = 1

        UNION ALL

        /* ================= PP ================= */

        SELECT *
        FROM (
            SELECT
                   'PP' AS empresa,
                   c.NFEDATEFE,
                   c.NFENOM,
                   c.NFENUM,
                   d.PROCOD,
                   ROW_NUMBER() OVER
                   (
                       PARTITION BY d.PROCOD
                       ORDER BY c.NFEDATEFE DESC
                   ) AS rn
            FROM pp.SIBD.dbo.TBS0591 d WITH (NOLOCK)
            INNER JOIN pp.SIBD.dbo.TBS059 c WITH (NOLOCK)
                    ON d.SERCOD = c.SERCOD
                   AND d.NFETIP = c.NFETIP
                   AND d.NFECOD = c.NFECOD
                   AND d.NFENUM = c.NFENUM
            WHERE d.NFETIP <> 'D'
              AND c.NFECAN <> 'S'
              AND c.NFECOD NOT IN (SELECT codigo FROM #grupo_pp)
              AND d.PROCOD IN (SELECT * FROM dbo.SplitString(@codigo, ','))
              AND c.NFEDATEFE <> '17530101'
        ) pp
        WHERE rn = 1

    ) x
    ORDER BY PROCOD, NFEDATEFE DESC;

END
GO

-- execução

EXEC dbo.usp_UltimaCompraProdutoGrupo
    @codigo = '1080067,1640054,8470030'