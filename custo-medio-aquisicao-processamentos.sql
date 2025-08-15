exec [dbo].[SP_MovimentacaoDiaria] '20181001', '20181031'

exec [dbo].[SP_PopulaKardexDiario]

-- ajustes das movimentações

drop table #mov

declare @ano int, @mes int

set @ano=2018
set @mes=11

update TBS125 set KESOUT=0 where year(KESDAT)=@ano and month(KESDAT)=@mes

;with tab as (
select year(KESDAT) ano,
       month(KESDAT) mes,
       LESCOD estoque,
       KESPROCOD produto,
--       sum(KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT + KESOUT) entradas,
       sum(KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT) entradas,
       sum(KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI) saidas

  from TBS125 (nolock)
 where year(KESDAT)=@ano and month(KESDAT)=@mes
 group by KESEMPCOD,year(KESDAT),month(KESDAT),LESEMPCOD,LESCOD,KESPROEMP,KESPROCOD)

-- temporária criada devido a problema de perfomance no SQL (lentidão no sistema)
select * into #mov from tab 


drop table #saldo

select *,
       isnull((select top 1 SINQTD from TBS124 (nolock)
                where TBS124.SINPROCOD=#mov.produto and TBS124.LESCOD=#mov.estoque and year(SINDAT) <= #mov.ano and month(SINDAT) <= #mov.mes
                order by SINEMPCOD,SINDAT desc),0)
       + #mov.entradas
       - #mov.saidas saldoFinalCalculado,
       isnull((select top 1 SINQTD from TBS124 (nolock)
                where TBS124.SINPROCOD=#mov.produto and TBS124.LESCOD=#mov.estoque and year(SINDAT) >= #mov.ano and month(SINDAT) > #mov.mes
                order by SINEMPCOD,SINDAT),0) saldoFinalRegistrado

  into #saldo
  from #mov

drop table #ajuste

select *,
       saldoFinalRegistrado-saldoFinalCalculado qtde,
       (select max(KESDAT) from TBS125 (nolock) where LESCOD=estoque and KESPROCOD=produto and year(KESDAT)<=ano and month(KESDAT)<=mes) data

  into #ajuste
  from #saldo

 where saldoFinalCalculado <> saldoFinalRegistrado


select * from #ajuste

-- lança a quantidade em outros para ajuste dos saldos dos produtos

update TBS125 set KESOUT=qtde from #ajuste where KESDAT=data and LESCOD=estoque and KESPROCOD=produto

drop table #mov
drop table #saldo
drop table #ajuste

-- fim dos ajustes


exec [dbo].[SP_SaldoInicialMensal] '20181201'


select top 1 * from CUSTOAQUISICAO with (nolock) order by ano desc,mes desc

select distinct ano,mes from CUSTOAQUISICAO with (nolock) order by ano desc,mes desc

select * from CUSTOAQUISICAO with (nolock) where produto in('1080067','1640054') order by ano desc,mes desc

select distinct empresa from CUSTOAQUISICAO with (nolock) order by empresa

select * from CUSTOAQUISICAO with (nolock)
 where produto in('1080067','1640054')
       and empresa in('TM','MT')
 order by ano desc,mes desc


-- grava custo da aquisição na tabela de saldos iniciais
exec [dbo].[SP_GravaCustoAquisicao] '20180701', 'S'
go

-- grava custo da aquisição na tabela de saldos iniciais
exec [dbo].[SP_GravaCustoAquisicaoTanby] '20180701', 'S'
go

-- grava custo da aquisição na tabela de saldos iniciais
--exec [dbo].[SP_GravaCustoAquisicaoSP] '20180501', 'S'
--go

-- grava custo da aquisição na tabela de saldos iniciais
exec [dbo].[SP_GravaCustoAquisicaoGeral] '20180701', 'S'
go
