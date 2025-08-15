-- unidades de medidas

select UNICOD
       ,UNIDES
  from nd.SIBD.dbo.TBS011 with (nolock)

drop table unidades

select PROUM1+'|'+PROUM2+'|'+PROUM3+'|'+PROUM4 as unidade
  into unidades
  from TBS010 with (nolock)
 group by PROUM1+'|'+PROUM2+'|'+PROUM3+'|'+PROUM4

select PROUM1 as unidade
  into unidades
  from TBS010 with (nolock)
 where PROUM1 <> ''
union
select PROUM2 as unidade
  from TBS010 with (nolock)
 where PROUM2 <> ''  
union
select PROUM3 as unidade
  from TBS010 with (nolock)
 where PROUM3 <> ''  
union
select PROUM4 as unidade
  from TBS010 with (nolock)
 where PROUM4 <> ''

select *
  from unidades

select *
  from TBS011 with (nolock)
 where UNICOD not in(select unidade
  from unidades
)

            select convert(date, dateadd(mm, datediff(mm,0,colunas.data) + 1, 0)) as data
                   ,convert(char(6), dateadd(mm, datediff(mm,0,colunas.data) + 1, 0), 112) as anomes
                   ,colunas.codigo
                   ,(select PROUM1 from TBS010 with (nolock) where PROEMPCOD=0 and PROCOD=codigo) as unidade
                   ,(select PROUM1QTD from TBS010 with (nolock) where PROEMPCOD=0 and PROCOD=codigo) as embalagem
                   ,0 as qentrada
                   ,0 as ventrada
                   ,0 as custo
                   ,coalesce([1], 0) as E1
                   ,coalesce([2], 0) as E2
                   ,coalesce([3], 0) as E3
                   ,coalesce([4], 0) as E4
                   ,coalesce([5], 0) as E5
                   ,coalesce([6], 0) as E6
                   ,coalesce([7], 0) as E7
                   ,coalesce([8], 0) as E8
                   ,coalesce([9], 0) as E9
				       ,''
               from
               (
                 select SD.ESTDATSAL as data
                        ,SD.ESTLOC as estoque
                        ,SD.PROCOD as codigo
                        ,sum(SD.ESTQTDATU) as quantidade
                   from SALDODIARIO SD with (nolock)
                  where SD.ESTDATSAL=@datas
				            and isnull((select top 1 1
						                    from SALDOINICIAL SI with (nolock)
								             where SI.DATA=@dbusca
									                and SI.CODIGO=SD.PROCOD
								             order by SI.DATA, SI.CODIGO),0) = 0
                  group by SD.ESTDATSAL, SD.ESTLOC, SD.PROCOD
               ) linhas
            pivot (sum(quantidade) for estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9])) colunas

drop table #unidades

select UNICOD
       ,'TM' as empresa
       ,1 as reg
  into #unidades
  from TBS011 with (nolock)
union
select UNICOD
       ,'BB'
       ,1
  from bb.SIBD2.dbo.TBS011 with (nolock)
union
select UNICOD
       ,'MI'
       ,1
  from mi.SIBD3.dbo.TBS011 with (nolock)
union
select UNICOD
       ,'PY'
       ,1
  from pp.SIBD.dbo.TBS011 with (nolock)

select *
  from #unidades
  
select UNICOD
       ,[TM] AS TM
       ,[BB] AS BB
       ,[MI] AS MI
       ,[PY] AS PY
FROM #unidades PIVOT (SUM(reg)
FOR empresa IN ([TM],[BB],[MI],[PY])) P
ORDER BY 1;

select *
  from bb.SIBD2.dbo.TBS011 with (nolock)
 where UNICOD='T'

drop table #marcas

select MARCOD
       ,MARNOM
       ,'TM' as empresa
       ,1 as reg
  into #marcas
  from TBS014 with (nolock)
union
select MARCOD
       ,MARNOM
       ,'BB'
       ,1
  from bb.SIBD2.dbo.TBS014 with (nolock)
union
select MARCOD
       ,MARNOM
       ,'MI'
       ,1
  from mi.SIBD3.dbo.TBS014 with (nolock)
union
select MARCOD
       ,MARNOM
       ,'PY'
       ,1
  from pp.SIBD.dbo.TBS014 with (nolock)

select *
  from #marcas

select MARCOD
       ,MARNOM
       ,[TM] AS TM
       ,[BB] AS BB
       ,[MI] AS MI
       ,[PY] AS PY
  from #marcas pivot (sum(reg)
   for empresa IN ([TM],[BB],[MI],[PY])) P
 order by 1;

select MARCOD
       ,MARNOM
  from #marcas

select MARCOD
       ,MARNOM
  into #marcas_duplicacadas
  from #marcas
 group by MARCOD, MARNOM
 order by MARCOD, MARNOM

select MARCOD
       ,MARNOM
  from #marcas_duplicacadas
 order by MARCOD

select MARCOD
       ,count(*)
  from #marcas_duplicacadas
 group by MARCOD
having count(*) > 1 
 order by MARCOD

select MARCOD
       ,MARNOM
  from #marcas
 where MARCOD in(select MARCOD
                   from #marcas_duplicacadas
                  group by MARCOD
                 having count(*) > 1)
 group by MARCOD, MARNOM
 order by MARCOD

declare @marcod smallint

set @marcod=24

select MARCOD
       ,count(*)
       ,'TM' as empresa
  from TBS010 with (nolock)
 where MARCOD=@marcod
 group by MARCOD
union
select MARCOD
       ,count(*)
       ,'BB' as empresa
  from bb.SIBD2.dbo.TBS010 with (nolock)
 where MARCOD=@marcod
 group by MARCOD
union
select MARCOD
       ,count(*)
       ,'MI' as empresa
  from mi.SIBD.dbo.TBS010 with (nolock)
 where MARCOD=@marcod
 group by MARCOD
union
select MARCOD
       ,count(*)
       ,'PY' as empresa
  from pp.SIBD.dbo.TBS010 with (nolock)
 where MARCOD=@marcod
 group by MARCOD

drop table #grupos

select GRUCOD
       ,GRUDES
       ,'TM' as empresa
       ,1 as reg
  into #grupos
  from TBS012 with (nolock)
union
select GRUCOD
       ,GRUDES
       ,'BB'
       ,1
  from bb.SIBD2.dbo.TBS012 with (nolock)
union
select GRUCOD
       ,GRUDES
       ,'MI'
       ,1
  from mi.SIBD3.dbo.TBS012 with (nolock)
union
select GRUCOD
       ,GRUDES
       ,'PY'
       ,1
  from pp.SIBD.dbo.TBS012 with (nolock)

select *
  from #grupos

select GRUCOD
       ,GRUDES
       ,[TM] AS TM
       ,[BB] AS BB
       ,[MI] AS MI
       ,[PY] AS PY
  from #grupos pivot (sum(reg)
   for empresa IN ([TM],[BB],[MI],[PY])) P
 order by 1;

select GRUCOD
       ,GRUDES
  into #grupos_duplicacados
  from #grupos
 group by GRUCOD, GRUDES
 order by GRUCOD, GRUDES

select *
  from #grupos_duplicacados

select GRUCOD
       ,GRUDES
  from #grupos
 where GRUCOD in(select GRUCOD
                   from #grupos_duplicacados
                  group by GRUCOD
                 having count(*) > 1)
 group by GRUCOD, GRUDES
 order by GRUCOD

drop table #subgrupos

select GRUCOD
       ,SUBGRUCOD
       ,SUBGRUDES
       ,'TM' as empresa
       ,1 as reg
  into #subgrupos
  from TBS0121 with (nolock)
union
select GRUCOD
       ,SUBGRUCOD
       ,SUBGRUDES
       ,'BB'
       ,1
  from bb.SIBD2.dbo.TBS0121 with (nolock)
union
select GRUCOD
       ,SUBGRUCOD
       ,SUBGRUDES
       ,'MI'
       ,1
  from mi.SIBD3.dbo.TBS0121 with (nolock)
union
select GRUCOD
       ,SUBGRUCOD
       ,SUBGRUDES
       ,'PY'
       ,1
  from pp.SIBD.dbo.TBS0121 with (nolock)

select *
  from #subgrupos

select GRUCOD
       ,SUBGRUCOD
       ,SUBGRUDES
       ,[TM] AS TM
       ,[BB] AS BB
       ,[MI] AS MI
       ,[PY] AS PY
  from #subgrupos pivot (sum(reg)
   for empresa IN ([TM],[BB],[MI],[PY])) P
 order by 1;

drop table #subgrupos_duplicados

select GRUCOD
       ,SUBGRUCOD
       ,SUBGRUDES
  into #subgrupos_duplicados
  from #subgrupos
 group by GRUCOD, SUBGRUCOD, SUBGRUDES
 order by GRUCOD, SUBGRUCOD

select *
  from #subgrupos_duplicados


select GRUCOD
       ,SUBGRUCOD
       ,SUBGRUDES
  from #subgrupos_duplicados
 where convert(varchar(3),GRUCOD)+convert(varchar(3),SUBGRUCOD) in(select convert(varchar(3),GRUCOD)+convert(varchar(3),SUBGRUCOD)
                   from #grupos_duplicacados
                  group by GRUCOD
                 having count(*) > 1)
 group by GRUCOD, SUBGRUCOD, SUBGRUDES
 order by GRUCOD, SUBGRUCOD

select GRUCOD
       ,isnull((select max(SUBGRUCOD)
           from TBS0121 b with (nolock)
          where b.GRUCOD=a.GRUCOD),0)
       ,SUBGRUUIT
  from TBS012 a with (nolock)
 order by a.GRUCOD

begin tran
update TBS012
   set SUBGRUUIT=isnull((select max(SUBGRUCOD)
           from TBS0121 b with (nolock)
          where b.GRUCOD=a.GRUCOD),0)
  from TBS012 a with (nolock)

rollback tran 
commit tran 

select top(1)
       *
  from TBS0103 with (nolock)

drop table #barras

select CBPPROCOD
       ,CBPCODBAR
       ,'TM' as empresa
       ,1 as reg
  into #barras
  from TBS0103 with (nolock)
union
select CBPPROCOD
       ,CBPCODBAR
       ,'BB'
       ,1
  from bb.SIBD2.dbo.TBS0103 with (nolock)

select CBPPROCOD
       ,CBPCODBAR
       ,[TM] as TM
       ,[BB] as BB
  from #barras pivot (sum(reg)
   for empresa IN ([TM],[BB])) P

select CBPPROCOD
       ,CBPCODBAR
       ,'TM' as empresa
       ,1 as reg
  into #barras
  from TBS0103 with (nolock)
union
select CBPPROCOD
       ,CBPCODBAR
       ,'BB'
       ,1
  from bb.SIBD2.dbo.TBS0103 with (nolock)
union
select CBPPROCOD
       ,CBPCODBAR
       ,'MI'
       ,1
  from mi.SIBD3.dbo.TBS0103 with (nolock)
union
select CBPPROCOD
       ,CBPCODBAR
       ,'PY'
       ,1
  from pp.SIBD.dbo.TBS0103 with (nolock)

select *
  from #grupos

drop table #produtos

select PROCOD
       ,PRODES
       ,'TM' as empresa
       ,1 as reg
  into #produtos
  from TBS010 with (nolock)
union
select PROCOD
       ,PRODES
       ,'BB'
       ,1
  from bb.SIBD2.dbo.TBS010 with (nolock)
union
select PROCOD
       ,PRODES
       ,'MI'
       ,1
  from mi.SIBD3.dbo.TBS010 with (nolock)
union
select PROCOD
       ,PRODES
       ,'PY'
       ,1
  from pp.SIBD.dbo.TBS010 with (nolock)

select *
  from #produtos

select PROCOD
       ,PRODES
       ,[TM] AS TM
       ,[BB] AS BB
       ,[MI] AS MI
       ,[PY] AS PY
  from #produtos pivot (sum(reg)
   for empresa IN ([TM],[BB],[MI],[PY])) P
 order by 1;

select PROCOD
       ,PRODES
  into #produtos_duplicacados
  from #produtos
 group by PROCOD, PRODES
 order by PROCOD, PRODES

select *
  from #produtos_duplicacados

select PROCOD
       ,PRODES
  from #produtos
 where PROCOD in(select PROCOD
                   from #produtos_duplicacados
                  where empresa in ('BB','PY')
                  group by PROCOD
                 having count(*) > 1)
       and empresa in ('BB','PY')
 group by PROCOD, PRODES
 order by PROCOD

select PROCOD
       ,PRODES
  from #produtos
 where PROCOD in(select PROCOD
                   from #produtos_duplicacados
                  where empresa in ('BB')
                  group by PROCOD, PRODES
                 having count(*) > 1)
       and empresa in ('TM')
 group by PROCOD, PRODES
 order by PROCOD

declare @base char(2)

set @base='BB'

select a.PROCOD
       ,a.PRODES as comparada
       ,a.empresa
       ,(select c.PRODES
           from #produtos c
          where c.empresa=@base and c.PROCOD=a.PROCOD) as base
  from #produtos a
 where a.empresa in ('PY')
       and (select 1
              from #produtos b
             where b.empresa=@base
                   and b.PROCOD=a.PROCOD
                   and b.PRODES<>a.PRODES) > 0
 group by a.PROCOD, a.PRODES, a.empresa
 order by a.PROCOD

declare @base char(2), @comparada char(2)

select @base='TM', @comparada='PY'

select a.PROCOD
       ,a.PRODES as comparada
       ,a.empresa
       ,(select c.PRODES
           from #produtos c
          where c.empresa=@base and c.PROCOD=a.PROCOD) as base
  into #temp
  from #produtos a
 where a.empresa in ('BB','MI','PY')  -- =@comparada
       and (select 1
              from #produtos b
             where b.empresa=@base
                   and b.PROCOD=a.PROCOD
                   and b.PRODES<>a.PRODES) > 0
 group by a.PROCOD, a.PRODES, a.empresa
 order by a.PROCOD

select distinct PROCOD
  from #produtos

select distinct PROCOD
       ,(select PRODES from #produtos p where p.empresa='BB' and p.PROCOD=t.PROCOD) as BB
       ,(select PRODES from #produtos p where p.empresa='MI' and p.PROCOD=t.PROCOD) as MI
       ,(select PRODES from #produtos p where p.empresa='PY' and p.PROCOD=t.PROCOD) as PY
       ,(select PRODES from #produtos p where p.empresa='TM' and p.PROCOD=t.PROCOD) as TM
  from #temp t

if object_id('tempdb.dbo.#precos') is not null 
begin 
	drop table #precos
end 

select TDPPROCOD as codigo
       ,TDPCUSBAS as custo
       ,'TM' as empresa
       ,1 as reg
  into #precos
  from TBS031 with (nolock)
union
select TDPPROCOD as codigo
       ,TDPCUSBAS as custo
       ,'BB' as empresa
       ,1 as reg
  from bb.SIBD2.dbo.TBS031 with (nolock)
union
select TDPPROCOD as codigo
       ,TDPCUSBAS as custo
       ,'MI' as empresa
       ,1 as reg
  from mi.SIBD3.dbo.TBS031 with (nolock)
union
select TDPPROCOD as codigo
       ,TDPCUSBAS as custo
       ,'PY' as empresa
       ,1 as reg
  from pp.SIBD.dbo.TBS031 with (nolock)

select codigo
       ,custo
       ,[TM] AS TM
       ,[BB] AS BB
       ,[MI] AS MI
       ,[PY] AS PY
  from #precos pivot (sum(reg)
   for empresa IN ([TM],[BB],[MI],[PY])) P
 order by 1

select codigo
       ,[TM] as TM
       ,[BB] as BB
       ,[MI] as MI
       ,[PY] as PY
  into #custos
  from #precos pivot (sum(custo)
   for empresa in ([TM],[BB],[MI],[PY])) p
 order by 1

select *
  from #custos
 where TM not in(BB,MI,PY)

select *
       ,(select PRODES
           from TBS010 with (nolock)
          where PROCOD=codigo)
  from #custos
 where (TM <> BB
       or TM <> MI
       or TM <> PY
       or BB <> MI
       or BB <> PY 
       or MI <> PY)
       and exists(select 1 
                    from TBS010 with (nolock)
                   where PROCOD=codigo
                         and PROSTATUS='A')
       and exists(select 1 
                    from bb.SIBD2.dbo.TBS010 with (nolock)
                   where PROCOD=codigo
                         and PROSTATUS='A')
       and exists(select 1 
                    from mi.SIBD3.dbo.TBS010 with (nolock)
                   where PROCOD=codigo
                         and PROSTATUS='A')
       and exists(select 1 
                    from pp.SIBD.dbo.TBS010 with (nolock)
                   where PROCOD=codigo
                         and PROSTATUS='A')

