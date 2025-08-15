select PROCOD,
       EST2=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=2 and LMEINFALT='E' order by LMEREG desc),0),
       EST3=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=3 and LMEINFALT='E' order by LMEREG desc),0),
       EST4=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=4 and LMEINFALT='E' order by LMEREG desc),0) --,
--       EST5=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=5 and LMEINFALT='E' order by LMEREG desc),0),
--       EST6=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=6 and LMEINFALT='E' order by LMEREG desc),0),
--       EST7=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=7 and LMEINFALT='E' order by LMEREG desc),0)
  into #saldoinicial
  from TBS010 (nolock)

select dbo.saldoTBS051('20170420', 'C', '3790045')

select * from TBS032 with (nolock) where ESTLOC=2 and ESTQTDATU < 0

drop table EST2018 

declare @data char(8)

set @data='20181231'

select PROCOD
       ,EST1=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=1 and LMEINFALT='E' order by LMEREG desc),0)
       ,EST2=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=2 and LMEINFALT='E' order by LMEREG desc),0)
       ,EST3=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=3 and LMEINFALT='E' order by LMEREG desc),0)
       ,EST4=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=4 and LMEINFALT='E' order by LMEREG desc),0)
       ,EST7=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=7 and LMEINFALT='E' order by LMEREG desc),0)
       ,EST9=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=9 and LMEINFALT='E' order by LMEREG desc),0)
  into EST2018
  from TBS010 (nolock)


with tab as (
   select PROCOD 

select PROCOD
       ,EST1=isnull((select ESTQTDATU from SALDODIARIO with (nolock) where SALDODIARIO.PROCOD=TBS010.PROCOD and ESTLOC=1 and ESTQTDATU > 0 and ESTDATSAL='20181231'),0)
       ,EST2=isnull((select ESTQTDATU from SALDODIARIO with (nolock) where SALDODIARIO.PROCOD=TBS010.PROCOD and ESTLOC=2 and ESTQTDATU > 0 and ESTDATSAL='20181231'),0)
       ,EST3=isnull((select ESTQTDATU from SALDODIARIO with (nolock) where SALDODIARIO.PROCOD=TBS010.PROCOD and ESTLOC=3 and ESTQTDATU > 0 and ESTDATSAL='20181231'),0)
       ,EST4=isnull((select ESTQTDATU from SALDODIARIO with (nolock) where SALDODIARIO.PROCOD=TBS010.PROCOD and ESTLOC=4 and ESTQTDATU > 0 and ESTDATSAL='20181231'),0)
       ,EST7=isnull((select ESTQTDATU from SALDODIARIO with (nolock) where SALDODIARIO.PROCOD=TBS010.PROCOD and ESTLOC=7 and ESTQTDATU > 0 and ESTDATSAL='20181231'),0)
       ,EST9=isnull((select ESTQTDATU from SALDODIARIO with (nolock) where SALDODIARIO.PROCOD=TBS010.PROCOD and ESTLOC=9 and ESTQTDATU > 0 and ESTDATSAL='20181231'),0)
  --into EST2018
  from TBS010 with (nolock)

-- sem tabela de saldodiario

select PROCOD
       ,EST1=0
       ,EST2=isnull((select ESTQTDATU from INTG.SIBDBB.dbo.TBS032 with (nolock) where TBS032.PROCOD=TBS010.PROCOD and ESTLOC=2 and ESTQTDATU > 0),0)
       ,EST3=isnull((select ESTQTDATU from INTG.SIBDBB.dbo.TBS032 with (nolock) where TBS032.PROCOD=TBS010.PROCOD and ESTLOC=3 and ESTQTDATU > 0),0)
       ,EST4=isnull((select ESTQTDATU from INTG.SIBDBB.dbo.TBS032 with (nolock) where TBS032.PROCOD=TBS010.PROCOD and ESTLOC=4 and ESTQTDATU > 0),0)
       ,EST7=isnull((select ESTQTDATU from INTG.SIBDBB.dbo.TBS032 with (nolock) where TBS032.PROCOD=TBS010.PROCOD and ESTLOC=7 and ESTQTDATU > 0),0)
       ,EST9=isnull((select ESTQTDATU from INTG.SIBDBB.dbo.TBS032 with (nolock) where TBS032.PROCOD=TBS010.PROCOD and ESTLOC=9 and ESTQTDATU > 0),0)
  into EST2018
  from TBS010 with (nolock)



select * from #saldoFinal where PROCOD='1640054'

select * from TBS034 with (nolock) order by LESCOD

select * from EST2018 with (nolock) where EST2 > 0

update EST2018 set EST2=0 where EST2 < 0

alter table EST2018 add SALDO decimal(12,4)
alter table EST2018 add CUSTO decimal(12,4)

select count(*) from EST2018 with (nolock) where EST1+EST2+EST3+EST4+EST7+EST9 = 0

delete EST2018 where EST1+EST2+EST3+EST4+EST7+EST9 = 0

update EST2018 set SALDO=EST1+EST2+EST3+EST4+EST7+EST9

select count(*) from EST2018 with (nolock) where SALDO is null

select * from EST2018 with (nolock) order by SALDO desc

select distinct empresa from CUSTOAQUISICAO with (nolock) order by empresa

drop table #custos

-- tanby

select '201812' anomes
       ,PROCOD produto
       ,isnull((select top 1 custo from CUSTOAQUISICAO with (nolock)
                 where empresa='TT' and anomes <= '201812' and produto=PROCOD order by empresa,anomes desc),0) as proprio
       ,isnull((select top 1 custo from CUSTOAQUISICAO with (nolock)
                 where empresa='MT' and anomes <= '201812' and produto=PROCOD order by empresa,anomes desc),0) as mt
       ,isnull((select top 1 custo from CUSTOAQUISICAO with (nolock)
                 where empresa='MS' and anomes <= '201812' and produto=PROCOD order by empresa,anomes desc),0) as ms
 into #custos
 from EST2018 a with (nolock)
order by PROCOD

-- sp

select '201812' anomes
       ,PROCOD produto
       ,isnull((select top 1 custo from CUSTOAQUISICAO with (nolock)
                 where empresa='PP' and anomes <= '201812' and produto=PROCOD order by empresa,anomes desc),0) as proprio
       ,isnull((select top 1 custo from CUSTOAQUISICAO with (nolock)
                 where empresa='MS' and anomes <= '201812' and produto=PROCOD order by empresa,anomes desc),0) as ms
       ,isnull((select top 1 custo from CUSTOAQUISICAO with (nolock)
                 where empresa='MT' and anomes <= '201812' and produto=PROCOD order by empresa,anomes desc),0) as mt
 into #custos
 from EST2018 a with (nolock)
order by PROCOD

select * from CUSTOAQUISICAO with (nolock) where produto='0040029' order by anomes desc

select * from #custos where proprio+mt+ms = 0

select * from #custos where proprio+mt = 0 and ms > 0

select top 1 * from CUSTOAQUISICAO with (nolock)

select * from CUSTOAQUISICAO with (nolock) where produto='1172043' order by empresa,anomes desc

select * from #custos where proprio > 0

drop table #tab

-- tanby

select PROCOD,SALDO
       ,isnull((select top 1
                       case
                          when proprio > 0 then proprio
                          when mt > 0 then mt
                          when ms > 0 then ms
                       end
                  from #custos
                 where anomes <= '20181231'
                       and produto=PROCOD),0) CUSTO
       ,EST1
       ,EST2
       ,EST3
       ,EST4
       ,EST7
       ,EST9
  into #tab
  from EST2018 with (nolock)

-- sp

select PROCOD,SALDO
       ,isnull((select top 1
                       case
                          when proprio > 0 then proprio
                          when ms > 0 then ms
                          when mt > 0 then mt
                       end
                  from #custos
                 where anomes <= '20181231'
                       and produto=PROCOD),0) CUSTO
       ,EST1
       ,EST2
       ,EST3
       ,EST4
       ,EST7
       ,EST9
  into #tab
  from EST2018 with (nolock)

select * from #tab where CUSTO=0

select sum(SALDO*CUSTO) from #tab

select sum(EST1*CUSTO) EST1
       ,sum(EST2*CUSTO) EST2
       ,sum(EST3*CUSTO) EST3
       ,sum(EST4*CUSTO) EST4
       ,sum(EST7*CUSTO) EST7
       ,sum(EST9*CUSTO) EST9
       ,sum(SALDO*CUSTO) TOTAL
  from #tab

-- CNPJ/SKU/DESCRICAO/UND/QUANTIDADE/CUSTO/CUSTO TOTAL

select
       (select EMPCGC from TBS023 with (nolock)) -- where EMPCOD=2)
       ,PROCOD
       ,(select PRODES from TBS010 with (nolock) where TBS010.PROCOD=#tab.PROCOD)
       ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=#tab.PROCOD)
       ,SALDO
       ,CUSTO
       ,SALDO*CUSTO
   from #tab
  where CUSTO > 0

select *
  from
(select PROCOD
        ,SALDO*CUSTO VALOR
        ,CUSTO
        ,(select PRODES from TBS010 with (nolock) where TBS010.PROCOD=#tab.PROCOD) DESCRI
        ,(select TDPPRECOR1 from TBS031 with (nolock) where TDPPROCOD=#tab.PROCOD) PRECO
   from #tab) t
 order by CUSTO desc

select * from #custos where proprio > 0 order by proprio desc

select * from #custos where produto='16580006'


select * from EST2018 with (nolock)

-- rodar servidor tanby matriz

select sum([CUSTO TOTAL])
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\18-12-inventario-estoque-tanby-taubate.xlsx', 'select * from [Planilha1$]')

select Left(CNPJ,14)
       ,Left(SKU,10)
       ,Left(DESCRICAO,60)
       ,Left(UND,3)
       ,QUANTIDADE
       ,CUSTO
       ,[CUSTO TOTAL]
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\18-12-inventario-estoque-tanby-taubate.xlsx', 'select * from [Planilha1$]')
