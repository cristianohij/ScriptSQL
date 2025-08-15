select *
  from CUSTOAQUISICAO with (nolock)
 where anomes >= 201501
       and empresa='CD'
       and produto='1640054'
 order by anomes

select min(ESTDATSAL),max(ESTDATSAL)
       --*
  from SALDODIARIO with (nolock)
 where ESTDATSAL <= '20151231'

select min(LMEDATHOR) from TBS051 with (nolock)

select min(SINDAT)
       --top 1 *
  from TBS124 with (nolock)
USE [SIBD]
GO

drop table FECHAESTOQUES

create table [dbo].[FECHAESTOQUES](
	[ANOMES] [varchar](6) NULL default '',
	[CODIGO] [varchar](10) NOT NULL default '',
	[E1] [decimal] (10,4) NULL default 0,
	[E2] [decimal] (10,4) NULL default 0,
	[E3] [decimal] (10,4) NULL default 0,
	[E4] [decimal] (10,4) NULL default 0,
	[E5] [decimal] (10,4) NULL default 0,
	[E6] [decimal] (10,4) NULL default 0,
	[E7] [decimal] (10,4) NULL default 0,
	[E8] [decimal] (10,4) NULL default 0,
	[E9] [decimal] (10,4) NULL default 0,
	[CUSTO] [decimal] (10,4) NULL default 0
) on [primary]

drop table SALDOINICIAL

create table [dbo].[SALDOINICIAL](
        [DATA] [date] null default '17530101'
	,[ANOMES] [varchar](6) NULL default ''
	,[CODIGO] [varchar](10) NOT NULL default ''
	,[UNI] [char] (2) NULL default ''
	,[QEMBALAGEM] [decimal] (10,4) NULL default 0
	,[QTDENTRADA] [decimal] (10,4) NULL default 0
	,[VALENTRADA] [decimal] (10,4) NULL default 0
	,[CUSTO] [decimal] (10,6) NULL default 0
	,[E1] [decimal] (16,4) NULL default 0
	,[E2] [decimal] (16,4) NULL default 0
	,[E3] [decimal] (16,4) NULL default 0
	,[E4] [decimal] (16,4) NULL default 0
	,[E5] [decimal] (16,4) NULL default 0
	,[E6] [decimal] (16,4) NULL default 0
	,[E7] [decimal] (16,4) NULL default 0
	,[E8] [decimal] (16,4) NULL default 0
	,[E9] [decimal] (16,4) NULL default 0
) on [PRIMARY]


select * from FECHAESTOQUES with (nolock)

delete FECHAESTOQUES

declare @datai date, @dataf date

set @datai='20160301'
set @dataf='20181231'

;with tab as (
select str(year(ESTDATSAL),4)+right('00'+Ltrim(str(month(ESTDATSAL),2)),2) anomes
       ,ESTLOC estoque
       ,PROCOD produto
--       ,(select top 1 ESTQTDATU from SALDODIARIO with (nolock) where )
--  into 
  from SALDODIARIO with (nolock)
 where ESTDATSAL between @datai and @dataf
 group by year(ESTDATSAL),month(ESTDATSAL),ESTLOC,PROCOD
-- order by year(ESTDATSAL),month(ESTDATSAL),ESTLOC,PROCOD
)

--select * from tab where produto='1640054' order by anomes desc

insert into FECHAESTOQUES
select *
       ,0 custo
  from (
select *
       ,(select top 1 ESTQTDATU from SALDODIARIO with (nolock)
                 where str(year(ESTDATSAL),4)+right('00'+Ltrim(str(month(ESTDATSAL),2)),2)=anomes
                       and ESTLOC=estoque
                       and PROCOD=produto
                 order by ESTDATSAL desc, ESTLOC, PROCOD) qtde
  from tab
 where not exists(select '' from FECHAESTOQUES with (nolock) where FECHAESTOQUES.ANOMES=tab.anomes and FECHAESTOQUES.CODIGO=tab.produto)
--       and produto='1640054'
) em_linha
pivot (sum(qtde) for estoque in ([1], [2], [3], [4] ,[5], [6], [7], [8], [9])) em_colunas


insert into SALDOINICIAL
select *
  from (
select SINDAT data
       ,convert(char(6), SINDAT, 112) anomes
       ,SINPROCOD codigo
       ,(select PROUM1 from TBS010 with (nolock) where PROCOD=SINPROCOD) unidade
       ,(select PROUM1QTD from TBS010 with (nolock) where PROCOD=SINPROCOD) embalagem
       ,0 qentrada
       ,0 ventrada
       ,0 custo
       ,LESCOD estoque
       ,SINQTD qtde
  from TBS124 with (nolock)
) em_linha
pivot (sum(qtde) for estoque in ([1], [2], [3], [4] ,[5], [6], [7], [8], [9])) em_colunas

select top 1 * from TBS124 with (nolock) where SINPROCOD='          13/01'
select * from SALDOINICIAL with (nolock) where CODIGO='1640054' order by ANOMES

select * from SALDOINICIAL with (nolock) where CUSTO > 0

select count(*) from SALDOINICIAL with (nolock) where ANOMES='201901' and E1+E2+E3+E4+E7+E9 > 0

select count(*) from SALDOINICIAL with (nolock) where DATA='20190101' and E1 > 0 +E2+E3+E4+E7+E9 > 0

select * from SALDOINICIAL with (nolock) order by E1+E2+E3+E4+E7+E9 desc

select * from SALDOINICIAL with (nolock) order by QTDENTRADA desc

delete TBS124 where SINPROCOD='          13/01'

select * from TBS124 with (nolock) where Len(SINPROCOD) > 10

delete TBS124 where Len(SINPROCOD) > 10

select * from TBS051 with (nolock) where Len(PROCOD) > 10

delete TBS051 where Len(PROCOD) > 10

select --min(ESTDATSAL),max(ESTDATSAL)
       *
  from SALDODIARIO with (nolock)
 where year(ESTDATSAL)=2018
       and month(ESTDATSAL)=12
       and PROCOD='1640054'
 order by ESTDATSAL desc

select top 1
       *
       ,ESTQTDATU
  from SALDODIARIO with (nolock)
 where str(year(ESTDATSAL),4)+right('00'+Ltrim(str(month(ESTDATSAL),2)),2)='201812'
                and ESTLOC=1
                and PROCOD='1640054'
 order by ESTDATSAL desc, ESTLOC, PROCOD

select * from FECHAESTOQUES with (nolock) where CODIGO='1640054' order by ANOMES

select * from CUSTOAQUISICAO with (nolock) where ano=2016 and mes=8 and produto='1640054'

update FECHAESTOQUES set CUSTO=0

update FECHAESTOQUES
   set CUSTO=(
select --*
--       ,
case 
           when 
              (select custo
                 from CUSTOAQUISICAO with (nolock)
                where empresa='CD'
                      and CUSTOAQUISICAO.anomes=FECHAESTOQUES.ANOMES
                      and CUSTOAQUISICAO.produto=FECHAESTOQUES.CODIGO) > 0
           then           
              (select custo
                 from CUSTOAQUISICAO with (nolock)
                where empresa='CD'
                      and CUSTOAQUISICAO.anomes=FECHAESTOQUES.ANOMES
                      and CUSTOAQUISICAO.produto=FECHAESTOQUES.CODIGO)
           when 
              (select custo
                 from CUSTOAQUISICAO with (nolock)
                where empresa='MT'
                      and CUSTOAQUISICAO.anomes=FECHAESTOQUES.ANOMES
                      and CUSTOAQUISICAO.produto=FECHAESTOQUES.CODIGO) > 0
           then           
              (select custo
                 from CUSTOAQUISICAO with (nolock)
                where empresa='MT'
                      and CUSTOAQUISICAO.anomes=FECHAESTOQUES.ANOMES
                      and CUSTOAQUISICAO.produto=FECHAESTOQUES.CODIGO)
           when 
              (select custo
                 from CUSTOAQUISICAO with (nolock)
                where empresa='MS'
                      and CUSTOAQUISICAO.anomes=FECHAESTOQUES.ANOMES
                      and CUSTOAQUISICAO.produto=FECHAESTOQUES.CODIGO) > 0
           then           
              (select custo
                 from CUSTOAQUISICAO with (nolock)
                where empresa='MS'
                      and CUSTOAQUISICAO.anomes=FECHAESTOQUES.ANOMES
                      and CUSTOAQUISICAO.produto=FECHAESTOQUES.CODIGO)
           else
              0
        end
)
  from FECHAESTOQUES with (nolock)
 where ANOMES='201606'
       and E1+E2+E3+E4+E5+E6+E7+E8+E9 > 0

select *
  from SALDODIARIO with (nolock)
 where PROCOD='1640054'
       and ESTDATSAL --<=convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, ESTDATSAL) + 1, 0)))
                    =(select max(ESTDATSAL) from SALDODIARIO with (nolock) where PROCOD='1640054' and year(ESTDATSAL)=2016 and month(ESTDATSAL)=9)
       and year(ESTDATSAL)=2016 and month(ESTDATSAL)=9
 order by ESTDATSAL desc

select *
  from SALDODIARIO with (nolock)
 where PROCOD='1640054'
       and year(ESTDATSAL)=2016 and month(ESTDATSAL)=7
-- order by ESTDATSAL desc
 order by ESTDATSAL desc, ESTLOC, PROCOD


if exists(select name from sysobjects where name='SP_CustoMensal' and type='P')
   drop procedure [dbo].[SP_CustoMensal]
go

create procedure [dbo].[SP_CustoMensal] @anomes char(6) as -- @dataDe as date, @dataAte as date as
   begin
      select str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2) anomes
             ,PROCOD codigo

             -- qtde compra na menor unidade * preço unitário (sem alguns impostos)
             ,sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) -- valor total do mês
             /
             case sum(NFEQTD * NFEQTDEMB) when 0 then 1 else sum(NFEQTD * NFEQTDEMB) end as custo -- qtde total do mês

             ,isnull(sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)),0) as valor
             ,isnull(sum(NFEQTD * NFEQTDEMB),0) as qtde -- qtde total do mês
             ,str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2)+'01' data
             ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=TBS0591.PROCOD) uni
             ,(select PROUM1QTD from TBS010 with (nolock) where TBS010.PROCOD=TBS0591.PROCOD) qemb

        into #TMP
        from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                              inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

       where --TBS059.NFEDATEFE between @dataDe and @dataAte
             convert(char(6),TBS059.NFEDATEFE,112) = @anomes
             and TBS0591.NFETIP='N'
             and TBS059.NFECAN<>'S'
             and FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350')
             and right(NFECFOP,3) in('102','403','121','202','411')
       group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),PROCOD

      update SALDOINICIAL
	     set SALDOINICIAL.QTDENTRADA=#TMP.qtde
		     ,SALDOINICIAL.VALENTRADA=#TMP.valor
			 ,SALDOINICIAL.CUSTO=#TMP.custo
        from SALDOINICIAL with (nolock)
             inner join #TMP
             on SALDOINICIAL.ANOMES=#TMP.anomes and SALDOINICIAL.CODIGO=#TMP.codigo

      insert into SALDOINICIAL 
      select #TMP.data
             ,#TMP.anomes
             ,#TMP.codigo
             ,#TMP.uni
             ,#TMP.qemb
             ,#TMP.qtde
             ,#TMP.valor
             ,#TMP.custo
             ,0 E1
             ,0 E2
             ,0 E3
             ,0 E4
             ,0 E5
             ,0 E6
             ,0 E7
             ,0 E8
             ,0 E9
			 ,'' EMPRESA
        from #TMP
       where not exists(select ''
                          from SALDOINICIAL with (nolock) 
                         where SALDOINICIAL.ANOMES=#TMP.anomes and SALDOINICIAL.CODIGO=#TMP.codigo)

--      select * from #TMP
   end

declare @tab as table (anomes char(6), codigo varchar(10), custo decimal(10,6), valor decimal(10,4), qtde decimal(10,4))

insert into @tab
--exec SP_CustoMensal '20181201','20181231'

exec SP_CustoMensal '202002'

update SALDOINICIAL set CUSTO=0

update SALDOINICIAL set QTDENTRADA=0, VALENTRADA=0

-- mês fechado

declare @datai date, @dataf date, @comando varchar(50)

select @datai='20170101', @dataf='20191201'

while @datai <= @dataf
   begin
      -- não foi possível rodar passando a variável @datai diretamente como parâmetro

      set @comando='exec SP_CustoMensal ''' + convert(char(6),@datai,112) + ''''
      execute(@comando)
--print @datai
      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
   end


select * from SALDOINICIAL with (nolock) where CUSTO > 0

select * from SALDOINICIAL with (nolock) where CUSTO is null or VALENTRADA is null or QTDENTRADA is null or CODIGO is null or UNI is null
select * from SALDOINICIAL with (nolock) where VENTRADA is null

select *  from @tab

select round(E1*CUSTO,6)
       ,round(E1+QTDENTRADA,4)
       ,round(E1*CUSTO+VALENTRADA,6)
       ,round((E1*CUSTO+VALENTRADA)/(E1+QTDENTRADA),6),*
  from SALDOINICIAL with (nolock)
 where CODIGO='1640054' order by ANOMES

Select DateAdd(mm, DateDiff(mm,0,GetDate()) - 1, 0) as [Primeiro dia do mês Anterior]
Select DateAdd(mm, DateDiff(mm,0,GetDate()) + 1, 0) as [Primeiro dia do mês Posterior]

       

 

--B – Invocando uma Multi-statement table-valued function:
 

SELECT * FROM teste('20181201', '20181231')

alter table SALDOINICIAL alter column CUSTO decimal(16,6)

--if exists(select name from sysobjects where name='SP_RecalculoCusto' and type='P')
--   drop procedure [dbo].[SP_RecalculoCusto]
--go

--create procedure [dbo].[SP_RecalculoCusto] @anomes char(6) as -- @dataDe as date, @dataAte as date as
--   begin
--      declare @proxData date

--      update SALDOINICIAL
--         set CUSTO=round
--                   (
--                      (
--                         -- valor em estoque + valor de compras
--                         case
--                            when
--                            ( 
--                               case when E1 > 0 then E1 else 0 end +
--                               case when E2 > 0 then E2 else 0 end +
--                               case when E3 > 0 then E3 else 0 end +
--                               case when E4 > 0 then E4 else 0 end +
--                               case when E7 > 0 then E7 else 0 end +
--                               case when E9 > 0 then E9 else 0 end
--                            ) > 0
--                            then 
--                            (
--                               case when E1 > 0 then E1 else 0 end +
--                               case when E2 > 0 then E2 else 0 end +
--                               case when E3 > 0 then E3 else 0 end +
--                               case when E4 > 0 then E4 else 0 end +
--                               case when E7 > 0 then E7 else 0 end +
--                               case when E9 > 0 then E9 else 0 end
--                            ) * isnull(CUSTO,0) --+ isnull(VALENTRADA,0)
--                            else 0 --isnull(CUSTO,0)
--                         end
--                         + isnull(VALENTRADA,0)
--                      )
--                      -- dividido pela quantidade em estoque + quantidade de compras
--                      / case
--                           when
--                           (
--                              case when E1 > 0 then E1 else 0 end +
--                              case when E2 > 0 then E2 else 0 end +
--                              case when E3 > 0 then E3 else 0 end +
--                              case when E4 > 0 then E4 else 0 end +
--                              case when E7 > 0 then E7 else 0 end +
--                              case when E9 > 0 then E9 else 0 end
--                              + isnull(QTDENTRADA,0)
--                           ) > 0
--                           then
--                           (
--                              case when E1 > 0 then E1 else 0 end +
--                              case when E2 > 0 then E2 else 0 end +
--                              case when E3 > 0 then E3 else 0 end +
--                              case when E4 > 0 then E4 else 0 end +
--                              case when E7 > 0 then E7 else 0 end +
--                              case when E9 > 0 then E9 else 0 end
--                              + isnull(QTDENTRADA,0)
--                           )
--                           else 1
--                        end
--                   ,6)
--       where ANOMES=@anomes and CODIGO='3252185'

--      set @proxData=(select top 1 DateAdd(mm, DateDiff(mm,0,DATA) + 1, 0) from SALDOINICIAL with (nolock) where ANOMES=@anomes and CODIGO='3252185')

--      update SALDOINICIAL
--         set CUSTO=(select top 1 CUSTO from SALDOINICIAL b with (nolock) where b.ANOMES >= @anomes and b.CODIGO=a.CODIGO and b.CUSTO > 0 order by b.ANOMES desc, b.CODIGO)
--        from SALDOINICIAL a
--       where DATA=@proxData and CODIGO='3252185'
--   end

if exists(select name from sysobjects where name='SP_RecalculoCusto' and type='P')
   drop procedure [dbo].[SP_RecalculoCusto]
go

create procedure [dbo].[SP_RecalculoCusto] @anomes char(6) as -- @dataDe as date, @dataAte as date as
	begin
		declare @proxData date

		update SALDOINICIAL
			set CUSTO = case
							when round
							(
								(
									-- valor em estoque + valor de compras
									case
										when
										( 
											case when E1 > 0 then E1 else 0 end +
											case when E2 > 0 then E2 else 0 end +
											case when E3 > 0 then E3 else 0 end +
											case when E4 > 0 then E4 else 0 end +
											case when E7 > 0 then E7 else 0 end +
											case when E9 > 0 then E9 else 0 end
										) > 0
										then 
										(
										   case when E1 > 0 then E1 else 0 end +
										   case when E2 > 0 then E2 else 0 end +
										   case when E3 > 0 then E3 else 0 end +
										   case when E4 > 0 then E4 else 0 end +
										   case when E7 > 0 then E7 else 0 end +
										   case when E9 > 0 then E9 else 0 end
										) * isnull(CUSTO,0) --+ isnull(VALENTRADA,0)
										else 0 --isnull(CUSTO,0)
									end
									+ isnull(VALENTRADA,0)
								)
								-- dividido pela quantidade em estoque + quantidade de compras
								/	case
										when
										(
										  case when E1 > 0 then E1 else 0 end +
										  case when E2 > 0 then E2 else 0 end +
										  case when E3 > 0 then E3 else 0 end +
										  case when E4 > 0 then E4 else 0 end +
										  case when E7 > 0 then E7 else 0 end +
										  case when E9 > 0 then E9 else 0 end
										  + isnull(QTDENTRADA,0)
										) > 0
										then
										(
										  case when E1 > 0 then E1 else 0 end +
										  case when E2 > 0 then E2 else 0 end +
										  case when E3 > 0 then E3 else 0 end +
										  case when E4 > 0 then E4 else 0 end +
										  case when E7 > 0 then E7 else 0 end +
										  case when E9 > 0 then E9 else 0 end
										  + isnull(QTDENTRADA,0)
										)
										else 1
									end
								,6) > 0
							then
								round
								(
									(
										-- valor em estoque + valor de compras
										case
											when
											( 
												case when E1 > 0 then E1 else 0 end +
												case when E2 > 0 then E2 else 0 end +
												case when E3 > 0 then E3 else 0 end +
												case when E4 > 0 then E4 else 0 end +
												case when E7 > 0 then E7 else 0 end +
												case when E9 > 0 then E9 else 0 end
											) > 0
											then
											(
												case when E1 > 0 then E1 else 0 end +
												case when E2 > 0 then E2 else 0 end +
												case when E3 > 0 then E3 else 0 end +
												case when E4 > 0 then E4 else 0 end +
												case when E7 > 0 then E7 else 0 end +
												case when E9 > 0 then E9 else 0 end
											) * isnull(CUSTO,0) --+ isnull(VALENTRADA,0)
											else 0 --isnull(CUSTO,0)
										end
										+ isnull(VALENTRADA,0)
								)
								-- dividido pela quantidade em estoque + quantidade de compras
								/	case
										when
										(
											case when E1 > 0 then E1 else 0 end +
											case when E2 > 0 then E2 else 0 end +
											case when E3 > 0 then E3 else 0 end +
											case when E4 > 0 then E4 else 0 end +
											case when E7 > 0 then E7 else 0 end +
											case when E9 > 0 then E9 else 0 end
											+ isnull(QTDENTRADA,0)
										) > 0
										then
										(
											case when E1 > 0 then E1 else 0 end +
											case when E2 > 0 then E2 else 0 end +
											case when E3 > 0 then E3 else 0 end +
											case when E4 > 0 then E4 else 0 end +
											case when E7 > 0 then E7 else 0 end +
											case when E9 > 0 then E9 else 0 end
											+ isnull(QTDENTRADA,0)
										)
										else 1
									end
								,6)

							else CUSTO

						end

			where ANOMES=@anomes -- and CODIGO='7881412'

		set @proxData=(select top 1 DateAdd(mm, DateDiff(mm,0,DATA) + 1, 0) from SALDOINICIAL with (nolock) where ANOMES=@anomes) -- and CODIGO='7881412')

		update SALDOINICIAL
			set CUSTO=(select top 1 CUSTO from SALDOINICIAL b with (nolock) where b.DATA < @proxData and b.CODIGO=a.CODIGO and b.CUSTO > 0 order by b.ANOMES desc, b.CODIGO)
			from SALDOINICIAL a
			where DATA=@proxData -- and CODIGO='7881412'
	end


exec SP_RecalculoCusto '202002'

declare @datai date, @dataf date, @comando varchar(50)

select @datai='20190101', @dataf='20190901' -- até o mês fechado

while @datai <= @dataf
   begin
      set @comando='exec SP_RecalculoCusto ''' + convert(char(6),@datai,112) + ''''
      execute(@comando)

      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
   end


select * from SALDOINICIAL with (nolock) where ANOMES=201812 and E1+E3+E4+E7+E9 > 0

select '201812' anomes
       ,CODIGO produto
       ,isnull((select top 1 custo from CUSTOAQUISICAO with (nolock)
                 where empresa='TT' and anomes <= '201812' and produto=CODIGO order by empresa,anomes desc),0) as proprio
       ,isnull((select top 1 custo from CUSTOAQUISICAO with (nolock)
                 where empresa='MT' and anomes <= '201812' and produto=CODIGO order by empresa,anomes desc),0) as mt
       ,isnull((select top 1 custo from CUSTOAQUISICAO with (nolock)
                 where empresa='MS' and anomes <= '201812' and produto=CODIGO order by empresa,anomes desc),0) as ms
 into #custos
 from SALDOINICIAL a with (nolock)
order by CODIGO

select CODIGO --,SALDO
       ,isnull((select top 1
                       case
                          when proprio > 0 then proprio
                          when mt > 0 then mt
                          when ms > 0 then ms
                       end
                  from #custos
                 where anomes <= '20181231'
                       and produto=CODIGO),0) CUSTO
       ,E1
       ,E2
       ,E3
       ,E4
       ,E7
       ,E9
  into #tab
  from SALDOINICIAL with (nolock)

select sum(E1*CUSTO) E1
       ,sum(E2*CUSTO) E2
       ,sum(E3*CUSTO) E3
       ,sum(E4*CUSTO) E4
       ,sum(E7*CUSTO) E7
       ,sum(E9*CUSTO) E9
       ,sum((E1+E2+E3+E4+E7+E9)*CUSTO) TOTAL
  from #tab


select top 1 * from EST2018 with (nolock)
select top 1 * from SALDOINICIAL with (nolock)
select top 1 * from SALDODIARIO with (nolock)

select *
  from SALDOINICIAL with (nolock)
 where not exists(select '' from SALDODIARIO with (nolock) where PROCOD=CODIGO)


select *
  from SALDOINICIAL with (nolock)
 where DATA='20190101'
       and E1+E2+E3+E4+E7+E9 > 0
       and not exists(select '' from EST2018 with (nolock) where PROCOD=CODIGO)

select * from SALDOINICIAL with (nolock) where CUSTO = 0

select *
  from SALDOINICIAL with (nolock)
 where DATA='20190201'
       --and E1+E2+E3+E4+E7+E9 > 0
       and
       (
          case when E1 > 0 then E1 else 0 end +
          case when E2 > 0 then E2 else 0 end +
          case when E3 > 0 then E3 else 0 end +
          case when E4 > 0 then E4 else 0 end +
          case when E7 > 0 then E7 else 0 end +
          case when E9 > 0 then E9 else 0 end
       ) > 0
       --and CUSTO is null
       and CUSTO=0

select * from SALDOINICIAL with (nolock) where CODIGO='3255328' and CUSTO > 0

select top 500 * from SALDOINICIAL with (nolock) order by CUSTO desc

select * from SALDOINICIAL with (nolock) where CUSTO < 0

select * from SALDOINICIAL with (nolock) where CUSTO is null

begin tran
delete SALDOINICIAL where CUSTO is null
commit tran

select * from master..sysservers

begin tran;

declare @datai date, @dataf date

select @datai='20170101', @dataf='20190901'

   merge SALDOINICIAL as destino
   using tt.SIBD.dbo.SALDOINICIAL as origem
      on destino.DATA between @datai and @dataf and destino.DATA=origem.DATA and destino.CODIGO=origem.CODIGO collate database_default

   -- se encontrado
   --when matched and (destino.CUSTO=0 or destino.CUSTO is null or destino.DATA <= origem.DATA) and origem.CUSTO > 0 then
   when matched --then (select * from destino)
        --and (destino.CUSTO=0 or destino.CUSTO is null)
        and isnull((select top 1 S.CUSTO from SALDOINICIAL S with (nolock) where S.CODIGO=origem.CODIGO collate database_default and S.CUSTO > 0),0) = 0
        and destino.DATA <= origem.DATA
        and origem.CUSTO > 0 then
      update
         set destino.CUSTO = origem.CUSTO;

output $action, INSERTED.*;

rollback tran

declare @datai date, @dataf date

select @datai='20190401', @dataf='20190701'

--update SALDOINICIAL
--   set CUSTO=
select *
,(select top 1 CUSTO
                from cd.SIBD.dbo.SALDOINICIAL d
               where d.CODIGO=o.CODIGO collate database_default
                     and o.CUSTO > 0
                     and o.DATA >= d.DATA
               order by o.DATA desc)
 from SALDOINICIAL o with (nolock)
where o.DATA between @datai and @dataf
      and o.CUSTO=0


-- rollback tran
-- commit tran

drop table SALDOINICIAL_BKP

select * into SALDOINICIAL_BKP from SALDOINICIAL with (nolock)

-- rollback tran
-- commit tran

select * from SALDOINICIAL with (nolock) where DATA='20190201'

drop table #inventario

-- valor em estoque

select '2019-09' referencia
       ,CODIGO produto
       ,(
           case when E1 > 0 then E1 else 0 end +
           case when E2 > 0 then E2 else 0 end +
           case when E3 > 0 then E3 else 0 end +
           case when E4 > 0 then E4 else 0 end +
           case when E7 > 0 then E7 else 0 end +
           case when E9 > 0 then E9 else 0 end
        ) saldo
       ,case
           when CUSTO > 0
              then CUSTO
           when isnull((select top 1 CUSTO
                          from SALDOINICIAL b with (nolock)
                         where DATA <= '20191001'
                               and b.CODIGO=a.CODIGO 
                               and CUSTO > 0
                         order by DATA desc),0) > 0
              then isnull((select top 1 CUSTO
                             from SALDOINICIAL b with (nolock)
                            where DATA <= '20191001'
                                  and b.CODIGO=a.CODIGO 
                                  and CUSTO > 0
                            order by DATA desc),0)
           else isnull(dbo.CUSTOPOLITICA(0,CODIGO),0)
        end custo
  into #inventario
  from SALDOINICIAL a with (nolock)
 where DATA='20191001'
       --and E1+E2+E3+E4+E7+E9 > 0
       and
       (
          case when E1 > 0 then E1 else 0 end +
          case when E2 > 0 then E2 else 0 end +
          case when E3 > 0 then E3 else 0 end +
          case when E4 > 0 then E4 else 0 end +
          case when E7 > 0 then E7 else 0 end +
          case when E9 > 0 then E9 else 0 end
       ) > 0

select count(*)
  from
  (
     select '1' col1 from TBS032 with (nolock) where ESTQTDATU > 0 and ESTLOC in(1,2,3,4,7,9) group by PROCOD
  ) t


select * from #inventario where custo=0

select referencia,sum(saldo*custo) from #inventario group by referencia

select * from #inventario order by custo desc

select top 1 * from #inventario

select *,saldo*custo from #inventario

select (select top 1 EMPCGC from TBS023 with (nolock) order by EMPCOD desc) CNPJ
       ,Left(produto,10) SKU
       ,(select PRODES from TBS010 with (nolock) where PROCOD=produto) DESCRICAO
       ,(select PROUM1 from TBS010 with (nolock) where PROCOD=produto) UND
       ,saldo QUANTIDADE
       ,custo CUSTO
       ,(saldo * custo) [CUSTO TOTAL]
  from #inventario

select sum(E1*CUSTO) V1
       ,sum(E2*CUSTO) V2
	   ,sum(E3*CUSTO) V3
	   ,sum(E4*CUSTO) V4
	   ,sum(E5*CUSTO) V5
	   ,sum(E6*CUSTO) V6
	   ,sum(E7*CUSTO) V7
	   ,sum(E8*CUSTO) V8
	   ,sum(E9*CUSTO) V9
  from SALDOINICIAL with (nolock)
 where ANOMES='201909'  

select CODIGO
       ,isnull((select top 1
	                   CUSTO
	              from SALDOINICIAL B with (nolock)
		         where B.CODIGO=A.CODIGO
		               and DATA<='20191001'
				       and CUSTO > 0
			     order by DATA desc, CODIGO),0) as CUSTO
  into #custos
  from SALDOINICIAL A with (nolock)
 group by CODIGO
 
 
update #custos set CUSTO=isnull(dbo.CUSTOPOLITICA(0,CODIGO),0)
 where CUSTO=0

select *
  from #custos
 
select '2019-10' referencia
       ,CODIGO produto
       ,case when E1 > 0 then E1 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end
	   ,case when E2 > 0 then E2 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end
	   ,case when E3 > 0 then E3 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end
	   ,case when E4 > 0 then E4 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end
	   ,case when E5 > 0 then E5 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end
	   ,case when E6 > 0 then E6 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end
	   ,case when E7 > 0 then E7 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end
	   ,case when E8 > 0 then E8 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end
	   ,case when E9 > 0 then E9 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end
  from SALDOINICIAL with (nolock)
 where DATA='20191001'

select '2019-10' referencia
       ,CODIGO produto
       ,case when E1 > 0 then E1 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end V1
	   ,case when E2 > 0 then E2 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end V2
	   ,case when E3 > 0 then E3 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end V3
	   ,case when E4 > 0 then E4 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end V4
	   ,case when E5 > 0 then E5 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end V5
	   ,case when E6 > 0 then E6 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end V6
	   ,case when E7 > 0 then E7 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end V7
	   ,case when E8 > 0 then E8 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end V8
	   ,case when E9 > 0 then E9 * (select CUSTO from #custos where #custos.CODIGO=SALDOINICIAL.CODIGO) else 0 end V9
  into #estoques
  from SALDOINICIAL with (nolock)
 where DATA='20191001'

select referencia
       ,sum(V1)
	   ,sum(V2)
	   ,sum(V3)
	   ,sum(V4)
	   ,sum(V5)
	   ,sum(V6)
	   ,sum(V7)
	   ,sum(V8)
	   ,sum(V9)
  from #estoques
 group by referencia
 
-- rodar na tanby matriz

declare @codigo varchar(15)

set @codigo='0070018'

print 'tanby matriz'

select top 1 *
  from TBS0591 (nolock) inner join
       TBS059  (nolock)
          on TBS0591.SERCOD=TBS059.SERCOD
             and TBS0591.NFETIP=TBS059.NFETIP
             and TBS0591.NFECOD=TBS059.NFECOD
             and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT between '20170101' and '20181231'
       and TBS0591.NFETIP<>'D'
       and TBS059.NFECAN<>'S'
       --and TBS0591.PROCOD=@codigo
       and TBS0591.PROCOD in(select produto from #inventario where custo=0)
 order by TBS059.NFEDATENT desc

-- CD

print 'tanby CD'

select top 1 *
  from cd.SIBD.dbo.TBS0591 inner join
       cd.SIBD.dbo.TBS059  
          on TBS0591.SERCOD=TBS059.SERCOD
             and TBS0591.NFETIP=TBS059.NFETIP
             and TBS0591.NFECOD=TBS059.NFECOD
             and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT between '20170101' and '20181231'
       and TBS0591.NFETIP<>'D'
       and TBS059.NFECAN<>'S'
       --and TBS0591.PROCOD=@codigo
       and TBS0591.PROCOD collate database_default in(select produto from #inventario where custo=0)
 order by TBS059.NFEDATENT desc

-- taubaté

print 'tanby taubaté'

select top 1 *
  from tt.SIBD.dbo.TBS0591 inner join
       tt.SIBD.dbo.TBS059  
          on TBS0591.SERCOD=TBS059.SERCOD
             and TBS0591.NFETIP=TBS059.NFETIP
             and TBS0591.NFECOD=TBS059.NFECOD
             and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT between '20170101' and '20181231'
       and TBS0591.NFETIP<>'D'
       and TBS059.NFECAN<>'S'
       --and TBS0591.PROCOD=@codigo
       and TBS0591.PROCOD in(select produto from #inventario where custo=0)
 order by TBS059.NFEDATENT desc

-- best bag

print 'best bag'

select top 1 *
  from bb.SIBD2.dbo.TBS0591 inner join
       bb.SIBD2.dbo.TBS059  
          on TBS0591.SERCOD=TBS059.SERCOD
             and TBS0591.NFETIP=TBS059.NFETIP
             and TBS0591.NFECOD=TBS059.NFECOD
             and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT between '20170101' and '20181231'
       and TBS0591.NFETIP<>'D'
       and TBS059.NFECAN<>'S'
       --and TBS0591.PROCOD=@codigo
       and TBS0591.PROCOD in(select produto from #inventario where custo=0)
 order by TBS059.NFEDATENT desc

-- misaspel

print 'misaspel'

select top 1 *
  from mi.SIBD.dbo.TBS0591 inner join
       mi.SIBD.dbo.TBS059  
          on TBS0591.SERCOD=TBS059.SERCOD
             and TBS0591.NFETIP=TBS059.NFETIP
             and TBS0591.NFECOD=TBS059.NFECOD
             and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT between '20170101' and '20181231'
       and TBS0591.NFETIP<>'D'
       and TBS059.NFECAN<>'S'
       --and TBS0591.PROCOD=@codigo
       and TBS0591.PROCOD in(select produto from #inventario where custo=0)
 order by TBS059.NFEDATENT desc

-- papelyna

print 'papelyna'

select top 1 *
  from py.SIBD.dbo.TBS0591 inner join
       py.SIBD.dbo.TBS059  
          on TBS0591.SERCOD=TBS059.SERCOD
             and TBS0591.NFETIP=TBS059.NFETIP
             and TBS0591.NFECOD=TBS059.NFECOD
             and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT between '20170101' and '20181231'
       and TBS0591.NFETIP<>'D'
       and TBS059.NFECAN<>'S'
       --and TBS0591.PROCOD=@codigo
       and TBS0591.PROCOD in(select produto from #inventario where custo=0)
 order by TBS059.NFEDATENT desc

select sum(CUSTO*E1)
       ,sum(CUSTO*E2)
  from SALDOINICIAL with (nolock)
 where ANOMES='201907'
       and E1+E2 > 0

select *
  from SALDOINICIAL with (nolock)
 where ANOMES='201909'
       and E1+E2 > 0
       and CUSTO = 0


-- custo das mercadorias por estoque

select round(sum(case when E1 > 0 then E1 * CUSTO_FINAL else 0 end),2) ESTOQUE
       ,round(sum(case when E2 > 0 then E2 * CUSTO_FINAL else 0 end),2) LOJA
  from
  (
select *
       ,(select top 1 c.CUSTO
           from SALDOINICIAL c with (nolock) 
          where c.CODIGO=s.CODIGO
                and c.DATA <= s.DATA
                and c.CUSTO > 0
          order by c.DATA desc) as CUSTO_FINAL
  from SALDOINICIAL s with (nolock)
 where DATA='20191001'
       and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E5 > 0 or E6 > 0 or E7 > 0 or E8 > 0 or E9 > 0)
  ) tab
 where (E1 > 0 or E2 > 0)
       and CUSTO_FINAL > 0


----

select ANOMES
  from SALDOINICIAL with (nolock)
 group by ANOMES
 order by ANOMES
 
select ANOMES
       ,CODIGO
       ,count(*)
  from SALDOINICIAL with (nolock)
 group by ANOMES, CODIGO
 having count(*) > 1

select count(*)
  from SALDOINICIAL with (nolock)
 where CUSTO > 0
 
select *
  from SALDOINICIAL with (nolock)
 where ANOMES='201909'
       and CODIGO='7870125'

--delete SALDOINICIAL

select count(*) from SALDODIARIO with (nolock)

select * from SALDODIARIO with (nolock) order by ESTDATSAL desc

select top 100 * from SALDODIARIO with (nolock)

select top 100
       convert(char(6),ESTDATSAL,112)
	   ,count(*)
  from SALDODIARIO with (nolock)
 where ESTQTDATU > 0
 group by convert(char(6),ESTDATSAL,112)
 order by convert(char(6),ESTDATSAL,112) desc
 
select ESTLOC
       ,count(*)
  from SALDODIARIO with (nolock)
 where 
 --convert(char(6),ESTDATSAL,112)='201909'
       ESTDATSAL>='20191101'
 group by ESTLOC
 order by ESTLOC
  
update SALDODIARIO
   set ESTQTDATU=0
 where --convert(char(6),ESTDATSAL,112) >= '201901'
       --and
	   ESTQTDATU is null

update SALDODIARIO
   set ESTQTDRES=0
 where --convert(char(6),ESTDATSAL,112) >= '201901'
       --and
	   ESTQTDRES is null

update SALDODIARIO
   set ESTQTDPEN=0
 where --convert(char(6),ESTDATSAL,112) >= '201901'
       --and 
	   ESTQTDPEN is null

update SALDODIARIO
   set ESTQTDCMP=0
 where --convert(char(6),ESTDATSAL,112) >= '201901'
       --and
	   ESTQTDCMP is null
	   
delete SALDOINICIAL
 where ANOMES >= '201901'
 
select *
  from SALDODIARIO with (nolock)
 where convert(char(6),ESTDATSAL,112)='201908'

select *
  from SALDODIARIO with (nolock)
 where ESTDATSAL='20190830'


select *
  from SALDODIARIO with (nolock)


-- último registro do mês

select a.ESTLOC
       ,a.PROCOD
       ,a.ESTDATSAL
  from SALDODIARIO a with (nolock)
 where a.ESTDATSAL = (select max(b.ESTDATSAL)
                       from SALDODIARIO b with (nolock)
					  where convert(char(6),b.ESTDATSAL,112)=convert(char(6),b.ESTDATSAL,112)
					        and a.PROCOD = b.PROCOD)
 order by 1, 2, 3 desc
