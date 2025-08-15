-- coleta temporário de dados

declare @dataDe as date, @dataAte as date

set @dataDe  = '20151219'
set @dataAte = '20160731'

if object_id('TempDB.dbo.#PERIODO') is not null
   begin
      drop table #PERIODO
   end

select @dataDe as dataDe,@dataAte as dataAte into #PERIODO
go


-- ENTRADAS

-- NF de entrada

if object_id('TempDB.dbo.#NFENT') is not null
   begin
      drop table #NFENT
   end
go

select TBS059.NFEDATEFE as data,
       TBS0591.PROCOD as CodigoProduto,
       TBS0591.LESCOD as LocalEstoque,
       sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB) as QTDE
  into #NFENT
  from TBS0591 (nolock)
       inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
 where TBS059.NFEUSUEFE<>'' and
       TBS059.NFETIP<>'D' and
       TBS059.NFEDATEFE between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       TBS0591.NFEMOVEST='S'
 group by TBS059.NFEDATEFE,TBS0591.LESCOD,TBS0591.PROCOD
go

-- NF de entrada de devolução

if object_id('TempDB.dbo.#NFENTDEV') is not null
   begin
      drop table #NFENTDEV
   end
go

select TBS059.NFEDATEFE as data,
       TBS0591.PROCOD as CodigoProduto,
       TBS0591.LESCOD as LocalEstoque,
       sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB) as QTDE
  into #NFENTDEV
  from TBS0591 (nolock)
       inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
 where TBS059.NFEUSUEFE<>'' and
       TBS059.NFETIP='D' and
       TBS059.NFEDATEFE between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       TBS0591.NFEMOVEST='S'
 group by TBS059.NFEDATEFE,TBS0591.LESCOD,TBS0591.PROCOD
go

-- NF de saída canceladas

if object_id('TempDB.dbo.#NFSAICAN') is not null
   begin
      drop table #NFSAICAN
   end
go

select TBS067.NFSDATCAN as data,
       TBS0671.PROCOD as CodigoProduto,
       TBS0671.LESCOD as LocalEstoque,
       sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB) as QTDE
  into #NFSAICAN
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
 where TBS067.NFSTIP='N' and
       TBS067.NFSCAN='S' and
       TBS067.NFSDATCAN between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       TBS0671.NFSMOVEST='S'
 group by TBS067.NFSDATCAN,TBS0671.LESCOD,TBS0671.PROCOD
go

-- ECF cancelados

if object_id('TempDB.dbo.#ECFCAN') is not null
   begin
      drop table #ECFCAN
   end
go

select M2_DATPROC as data,
       M2_PROCOD as CodigoProduto,
       2 as LocalEstoque,
       sum(M2_QTD) as QTDE
  into #ECFCAN
  from MSL002 (nolock)
 where M2_DATPROC between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       M2_TIPREG='01' and
       M2_REGCAN='T'
 group by M2_DATPROC,M2_PROCOD
go

-- NF de devolução para fornecedor cancelada ou em aberto

if object_id('TempDB.dbo.#NFDEVCAN') is not null
   begin
      drop table #NFDEVCAN
   end
go

select TBS117.NFDDATEMI as data,
       TBS1172.PROCOD as CodigoProduto,
       TBS1172.LESCOD as LocalEstoque,
       sum(TBS1172.NFDQTD * TBS1172.NFDQTDEMB) as QTDE
  into #NFDEVCAN
  from TBS1172 (nolock) inner join TBS117 (nolock) on TBS117.SNESER=TBS1172.SNESER and TBS117.NFDNUM=TBS1172.NFDNUM
 where (TBS117.NFDSTATUS='C' or TBS117.NFDSTATUS='O') and
       TBS117.NFDDATEMI between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       TBS1172.NFDMOVEST='S'
 group by TBS117.NFDDATEMI,TBS1172.LESCOD,TBS1172.PROCOD
go

-- movimentos internos

if object_id('TempDB.dbo.#MOVENT') is not null
   begin
      drop table #MOVENT
   end
go

select convert(date,TBS037.MVIDATEFE) as data,
       TBS0371.PROCOD as CodigoProduto,
       TBS037.MVILOCDES as LocalEstoque,
       sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as QTDE
  into #MOVENT
  from TBS0371 (nolock)
       inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
       inner join TBS033 (nolock) on TBS033.TMVCOD=TBS037.TMVCOD
 where convert(date,TBS037.MVIDATEFE) between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       TBS037.MVILOCDES > 0
 group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCDES,TBS0371.PROCOD
go

-- manutenção dos saldos

if object_id('TempDB.dbo.#SALENT') is not null
   begin
      drop table #SALENT
   end
go

select convert(date,TBS049.MDSLAN) as data,
       TBS049.PROCOD as CodigoProduto,
       TBS049.LESCOD as LocalEstoque,
       sum(TBS049.MDSQTD * TBS049.MDSQTDEMB) as QTDE
  into #SALENT
  from TBS049 (nolock)
 where convert(date,TBS049.MDSLAN) between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       TBS049.MDSTIP='E'
 group by convert(date,TBS049.MDSLAN),TBS049.LESCOD,TBS049.PROCOD
go

-- outras entradas... eram feitas via reserva de PV (YEST008) onde o saldo era adicionado ao estoque sem registro da movimentação

-- programa atualizado:
--    tanby matriz/taubaté/papelyna 14/07/16
--    tanby cd 15/08/16

if object_id('TempDB.dbo.#OUTENT') is not null
   begin
      drop table #OUTENT
   end
go

declare @antesAtualizacao date
set @antesAtualizacao='20160714'

select convert(date,TBS051.LMEDATHOR) as data,
       TBS051.PROCOD as CodigoProduto,
       TBS051.LMELOCEST as LocalEstoque,
       sum(TBS051.LMEQTDMOV) as QTDE
  into #OUTENT
  from TBS051 (nolock)
 where --convert(date,TBS051.LMEDATHOR) between (select dataDe from #PERIODO) and @antesAtualizacao and
       convert(date,TBS051.LMEDATHOR) between '20151220' and @antesAtualizacao and
       LMEROT='PEST029' and
       LMEINFALT='E'
 group by convert(date,TBS051.LMEDATHOR),TBS051.LMELOCEST,TBS051.PROCOD
go


-- fim ENTRADAS



-- SAÍDAS

-- NF de saída

if object_id('TempDB.dbo.#NFSAI') is not null
   begin
      drop table #NFSAI
   end
go

select TBS067.NFSDATEMI as data,
       TBS0671.PROCOD as CodigoProduto,
       TBS0671.LESCOD as LocalEstoque,
       sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB) as QTDE
  into #NFSAI
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
 where TBS067.NFSTIP='N' and
       TBS067.NFSDATEMI between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       TBS0671.NFSMOVEST='S'
 group by TBS067.NFSDATEMI,TBS0671.LESCOD,TBS0671.PROCOD
go

-- ECF

if object_id('TempDB.dbo.#ECF') is not null
   begin
      drop table #ECF
   end
go

select M2_DATPROC as data,
       M2_PROCOD as CodigoProduto,
       2 as LocalEstoque,
       sum(M2_QTD) as QTDE
  into #ECF
  from MSL002 (nolock)
 where M2_DATPROC between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       M2_TIPREG='01'
 group by M2_DATPROC,M2_PROCOD
go

-- NF de devolução para fornecedor

if object_id('TempDB.dbo.#NFDEV') is not null
   begin
      drop table #NFDEV
   end
go

select TBS117.NFDDATEMI as data,
       TBS1172.PROCOD as CodigoProduto,
       TBS1172.LESCOD as LocalEstoque,
       sum(TBS1172.NFDQTD * TBS1172.NFDQTDEMB) as QTDE
  into #NFDEV
  from TBS1172 (nolock) inner join TBS117 (nolock) on TBS117.SNESER=TBS1172.SNESER and TBS117.NFDNUM=TBS1172.NFDNUM
 where TBS117.NFDDATEMI between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       TBS1172.NFDMOVEST='S'
 group by TBS117.NFDDATEMI,TBS1172.LESCOD,TBS1172.PROCOD
go

-- movimentos internos

if object_id('TempDB.dbo.#MOVSAI') is not null
   begin
      drop table #MOVSAI
   end
go

select convert(date,TBS037.MVIDATEFE) as data,
       TBS0371.PROCOD as CodigoProduto,
       TBS037.MVILOCORI as LocalEstoque,
       sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as QTDE
  into #MOVSAI
  from TBS0371 (nolock)
       inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
       inner join TBS033 (nolock) on TBS033.TMVCOD=TBS037.TMVCOD
 where convert(date,TBS037.MVIDATEFE) between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
--       TBS033.TMVTIP='S' and
       TBS037.MVILOCORI > 0
 group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCORI,TBS0371.PROCOD
go

-- manutenção dos saldos

if object_id('TempDB.dbo.#SALSAI') is not null
   begin
      drop table #SALSAI
   end
go

select convert(date,TBS049.MDSLAN) as data,
       TBS049.PROCOD as CodigoProduto,
       TBS049.LESCOD as LocalEstoque,
       sum(TBS049.MDSQTD * TBS049.MDSQTDEMB) as QTDE
  into #SALSAI
  from TBS049 (nolock)
 where convert(date,TBS049.MDSLAN) between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and
       TBS049.MDSTIP='S'
 group by convert(date,TBS049.MDSLAN),TBS049.LESCOD,TBS049.PROCOD
go

-- fim SAÍDAS

-- fim da coleta temporária de dados


-- popula a tabela de kardex diário das movimentações dos produtos

-- tabelas

/*     #NFENT
    1. #NFENTDEV
    2. #NFSAICAN
    3. #ECFCAN
    4. #NFDEVCAN
    5. #MOVENT
    6. #SALENT
    7. #NFSAI
    8. #ECF
    9. #NFDEV
   10. #MOVSAI
   11. #SALSAI */

with tab1 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.QTDE,0) as NFentrada,
          isnull(B.QTDE,0) as EntradaDevolucao
     from #NFENT as A
          full join #NFENTDEV as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab2 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(B.QTDE,0) as NFsaidaCan
     from tab1 as A
          full join #NFSAICAN as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab3 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(B.QTDE,0) as ECFcan
     from tab2 as A
          full join #ECFCAN as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab4 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(B.QTDE,0) as DEVcan
     from tab3 as A
          full join #NFDEVCAN as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab5 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(B.QTDE,0) as MOVentrada
     from tab4 as A
          full join #MOVENT as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab6 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(B.QTDE,0) as SALentrada
     from tab5 as A
          full join #SALENT as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab7 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(B.QTDE,0) as NFsaida
     from tab6 as A
          full join #NFSAI as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab8 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(A.NFsaida,0) as NFsaida,
          isnull(B.QTDE,0) as ECF
     from tab7 as A
          full join #ECF as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab9 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(A.NFsaida,0) as NFsaida,
          isnull(A.ECF,0) as ECF,
          isnull(B.QTDE,0) as NFdevolucao
     from tab8 as A
          full join #NFDEV as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab10 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(A.NFsaida,0) as NFsaida,
          isnull(A.ECF,0) as ECF,
          isnull(A.NFdevolucao,0) as NFdevolucao,
          isnull(B.QTDE,0) as MOVsaida
     from tab9 as A
          full join #MOVSAI as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab11 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(A.NFsaida,0) as NFsaida,
          isnull(A.ECF,0) as ECF,
          isnull(A.NFdevolucao,0) as NFdevolucao,
          isnull(A.MOVsaida,0) as MOVsaida,
          isnull(B.QTDE,0) as SALsaida
     from tab10 as A
          full join #SALSAI as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab12 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(A.NFsaida,0) as NFsaida,
          isnull(A.ECF,0) as ECF,
          isnull(A.NFdevolucao,0) as NFdevolucao,
          isnull(A.MOVsaida,0) as MOVsaida,
          isnull(A.SALsaida,0) as SALsaida,
          isnull(B.QTDE,0) as Outras
     from tab11 as A
          full join #OUTENT as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)

insert into TBS125
select 0,                -- empresa do kardex
       data,             -- data da movimentação
       0,                -- empresa do local de estoque
       LocalEstoque,     -- local do estoque
       0,                -- empresa do produto
       CodigoProduto,    -- código do produto
       -- entradas
       NFentrada,        -- nf de entrada
       EntradaDevolucao, -- entrada de devolução
       NFsaidaCan,       -- nf de saída cancelada
       ECFcan,           -- cupom fiscal cancelado
       DEVcan,           -- cancelamento de nf de devolução de saída
       MOVentrada,       -- movimento interno de entrada
       SALentrada,       -- entrada via manutenção do saldo 
       -- saídas
       NFsaida,          -- nota fiscal de saída
       ECF,              -- cupom fiscal
       NFdevolucao,      -- nf de saída de devolução
       MOVsaida,         -- movimento interno de saída
       SALsaida,         -- saída via manutenção do saldo
       0,                -- custo médio de compra
       (select PROUM1QTD from TBS010 (nolock) where PROCOD=CodigoProduto), -- quantidade da embalagem da menor unidade de medida
       (select PROUM1 from TBS010 (nolock) where PROCOD=CodigoProduto),    -- menor unidade de medida do produto
       Outras
  from tab12
 order by data,LocalEstoque,CodigoProduto

-- fim: popula a tabela de kardex diário das movimentações dos produtos


-- saldos iniciais após contagem - atenção, somente rodar 1 vez

-- saldo inicial da contagem
-- 12/12/15 tanby matriz
-- 11/12/15 tanby cd
-- 19/12/15 tanby taubaté - retaguarda/loja
-- 19/12/15 papelyna
-- 22/12/15 best bag ?
-- 30/12/15 misaspel

declare @dataSaldo date

set @dataSaldo='20151219'

insert into TBS124
select 0,             -- empresa da tabela de saldos iniciais
       @dataSaldo,    -- data do saldo inicial
       0,             -- empresa do local de estoque
       LESCOD,        -- local de estoque
       0,             -- empresa do produto
       KESPROCOD,     -- código do produto
       (select PROUM1 from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default),    -- menor unidade de medida
       (select PROUM1QTD from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
       sum(KESMOVENT-KESMOVSAI),
       0
  from TBS125 (nolock)
 where KESDAT=@dataSaldo
 group by LESCOD,KESPROCOD

-- fim: saldos iniciais após contagem - atenção, somente rodar 1 vez


-- comparativo com inventário

select convert(date,TBS037.MVIDATEFE) as data,
       TBS0371.PROCOD as CodigoProduto,
       TBS037.MVILOCDES as LocalEstoque,
       sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as QTDE
  into #entrada
  from TBS0371 (nolock)
       inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
       inner join TBS033 (nolock) on TBS033.TMVCOD=TBS037.TMVCOD
 where convert(date,TBS037.MVIDATEFE)='20151212' and
       TBS037.MVILOCDES > 0
 group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCDES,TBS0371.PROCOD

select convert(date,TBS037.MVIDATEFE) as data,
       TBS0371.PROCOD as CodigoProduto,
       TBS037.MVILOCORI as LocalEstoque,
       sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as QTDE
  into #saida
  from TBS0371 (nolock)
       inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
       inner join TBS033 (nolock) on TBS033.TMVCOD=TBS037.TMVCOD
 where convert(date,TBS037.MVIDATEFE)='20151212' and
       TBS037.MVILOCORI > 0
 group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCORI,TBS0371.PROCOD

select A.CodigoProduto as produto,
       A.LocalEstoque,
       isnull(A.QTDE,0) as entrada,
       isnull(B.QTDE,0) as saida,
       isnull(A.QTDE,0)-isnull(B.QTDE,0) as saldo
  into #inventario
  from #entrada A full join #saida B on B.data=A.data and B.CodigoProduto=A.CodigoProduto and B.LocalEstoque=A.LocalEstoque
 where A.LocalEstoque in(1,2)

select * from #inventario

select * from TBS124 (nolock) inner join #inventario on LESCOD=LocalEstoque and SINPROCOD=produto where SINQTD=saldo

-- fim: comparativo com inventário


-- saldo iniciais dos proutos que não foram inventariados

select distinct LMELOCEST from TBS051 (nolock) where LMEDATHOR<='20151219'

declare @data date

set @data='20151219'

select PROCOD,
       EST2=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=2 and LMEINFALT='E' order by LMEREG desc),0),
       EST3=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=3 and LMEINFALT='E' order by LMEREG desc),0),
       EST4=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=4 and LMEINFALT='E' order by LMEREG desc),0) --,
--       EST5=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=5 and LMEINFALT='E' order by LMEREG desc),0),
--       EST6=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=6 and LMEINFALT='E' order by LMEREG desc),0),
--       EST7=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and LMEDATHOR<=@data and LMELOCEST=7 and LMEINFALT='E' order by LMEREG desc),0)
  into #saldoinicial
  from TBS010 (nolock)

select * from #saldoinicial where EST2+EST3+EST4 > 0

select count(*) from #saldoinicial where EST2+EST3+EST4 > 0

delete #saldoinicial where EST2+EST3+EST4 = 0

select distinct LESCOD from TBS124 (nolock)

declare @data date,@estoque int

set @data='20151211'
set @estoque=7

insert into TBS124
select 0,             -- empresa da tabela de saldos iniciais
       @data,         -- data do saldo inicial
       0,             -- empresa do local de estoque
       @estoque,      -- local de estoque
       0,             -- empresa do produto
       PROCOD,        -- código do produto
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=#saldoinicial.PROCOD),    -- menor unidade de medida
       (select PROUM1QTD from TBS010 (nolock) where TBS010.PROCOD=#saldoinicial.PROCOD), -- quantidade da embalagem da menor unidade de medida
       EST7,
       0
  from #saldoinicial

-- fim: saldo iniciais dos proutos que não foram inventariados


-- saldo inicial nos demais meses após a contagem

declare @dataSaldo as date, @dataRegistro as date, @dataDe as date, @dataAte as date

-- data do saldo inicial
set @dataSaldo='20160701'

-- data do registro do próximo saldo inicial
set @dataRegistro='20160801'

-- período de contabilização das entradas e saídas
set @dataDe  = '20160701'
set @dataAte = '20160731'

insert into TBS124
select 0,             -- empresa da tabela de saldos iniciais
       @dataRegistro, -- data do saldo inicial
       0,             -- empresa do local de estoque
       LESCOD,        -- local de estoque
       0,             -- empresa do produto
       KESPROCOD,     -- código do produto
       (select PROUM1 from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default),    -- menor unidade de medida
       (select PROUM1QTD from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
       -- cálculo do saldo = saldo inicial + entradas - saídas
       case when isnull((select 1 from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0) > 0
            then isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0)
            else isnull((select top 1 SINQTD
                           from TBS124 (nolock)
                          where TBS124.SINDAT < @dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD
                          order by TBS124.SINDAT desc),0) end                                                                                                -- saldo inicial
       + sum((KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT + KESOUT)                                              -- entradas
       -     (KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI)),                                                                                  -- saídas
       0 -- custo da aquisição da mercadoria
  from TBS125 (nolock)
 where KESDAT between @dataDe and @dataAte
 group by LESCOD,KESPROCOD

-- fim: saldo inicial nos demais meses após a contagem


-- custo

select top 1
       year(PDCDATPRE),
       month(PDCDATPRE),
       convert(char(7),TBS0451.PDCDATPRE,111),
       TBS0451.PROCOD,
       round(avg(dbo.PDCTOTITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE)/TBS0451.PDCQTD/TBS0451.PDCQTDEMB),4)
  from TBS0451 (nolock)
 where TBS0451.PROCOD='1080067'
 group by PDCDATPRE,convert(char(7),TBS0451.PDCDATPRE,111),TBS0451.PROCOD
 order by convert(char(7),TBS0451.PDCDATPRE,111) desc


select convert(char(7),TBS045.PDCDATCAD,111),
       TBS0451.PROCOD,avg(dbo.PDCTOTITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE)/TBS0451.PDCQTD/TBS0451.PDCQTDEMB)
  from TBS0451 (nolock)
       inner join TBS045 (nolock) on TBS045.PDCEMPCOD=TBS0451.PDCEMPCOD and TBS045.PDCNUM=TBS0451.PDCNUM
 where TBS0451.PROCOD='1080067'
 group by convert(char(7),TBS045.PDCDATCAD,111),TBS0451.PROCOD

select top 1
       year(PDCDATPRE),
       month(PDCDATPRE),
       TBS0451.PROCOD,
       round(avg(dbo.PDCTOTITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE)/TBS0451.PDCQTD/TBS0451.PDCQTDEMB),4)
  from TBS0451 (nolock)
 where TBS0451.PROCOD='1080067'
 group by year(PDCDATPRE),month(TBS0451.PDCDATPRE),TBS0451.PROCOD
 order by year(PDCDATPRE) desc,month(TBS0451.PDCDATPRE) desc


update TBS124 set SINCUSAQU=(
select top 1
       round(avg(dbo.PDCTOTITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE)/TBS0451.PDCQTD/TBS0451.PDCQTDEMB),4)
  from TBS0451 (nolock)
 where TBS0451.PROCOD=TBS124.SINPROCOD collate database_default and
       year(SINDAT) >= year(TBS0451.PDCDATPRE) and
       month(SINDAT) >= month(TBS0451.PDCDATPRE)
 group by year(TBS0451.PDCDATPRE),month(TBS0451.PDCDATPRE),TBS0451.PROCOD
 order by year(TBS0451.PDCDATPRE) desc,month(TBS0451.PDCDATPRE) desc)

-- fim: custo


-- elimina registros das tabelas

select count(*) from TBS124 (nolock)

select count(*) from TBS124 (nolock) where SINDAT<>'20151212'

delete TBS124 where SINDAT<>'20151211'
delete TBS125

-- fim: elimina registros das tabelas



-- inclui outras entradas (reserva manual)









select * into KARDEX from tab11 order by data,CodigoProduto

----

select * from KARDEX

select * into KARDEX from #MOV

select MOVentrada-MOVsaida,* from KARDEX (nolock) where data='20151212'

drop table KARDEX

select top 1 * from TBS124

delete TBS124

select top 1 * from KARDEX (nolock)

insert into TBS124 select 0,data,0,LocalEstoque,0,CodigoProduto,(select PROUM1 from TBS010 (nolock) where PROCOD=CodigoProduto),1,MOVentrada-MOVsaida
  from KARDEX (nolock) where data='20151212'

select * from TBS124 (nolock)

select count(*) from TBS124 (nolock) where SINQTD > 0

select top 1 * from KARDEX

-- por local de estoque

select CodigoProduto,
       LocalEstoque,
       sum(NFentrada+EntradaDevolucao+NFsaidaCan+ECFcan+DEVcan+MOVentrada+SALentrada) as entradas,
       sum(NFsaida+ECF+NFdevolucao+MOVsaida+SALsaida) as saidas,
       isnull((select SINQTD from TBS124 (nolock) where LESCOD=LocalEstoque and SINPROCOD=CodigoProduto),0),
       isnull((select SINQTD from TBS124 (nolock) where LESCOD=LocalEstoque and SINPROCOD=CodigoProduto),0) +
       sum(NFentrada+EntradaDevolucao+NFsaidaCan+ECFcan+DEVcan+MOVentrada+SALentrada) -
       sum(NFsaida+ECF+NFdevolucao+MOVsaida+SALsaida) as saldoFinal
  from KARDEX (nolock)
 where data between '20151213' and '20151231'
 group by LocalEstoque,CodigoProduto
 order by CodigoProduto,LocalEstoque

-- agrupados

select CodigoProduto,
       isnull((select sum(SINQTD) from TBS124 (nolock) where SINPROCOD=CodigoProduto),0) as saldoInicial,
       sum(NFentrada+EntradaDevolucao+NFsaidaCan+ECFcan+DEVcan+MOVentrada+SALentrada) as entradas,
       sum(NFsaida+ECF+NFdevolucao+MOVsaida+SALsaida) as saidas,
       isnull((select sum(SINQTD) from TBS124 (nolock) where SINPROCOD=CodigoProduto),0)+sum(NFentrada+EntradaDevolucao+NFsaidaCan+ECFcan+DEVcan+MOVentrada+SALentrada)-sum(NFsaida+ECF+NFdevolucao+MOVsaida+SALsaida) as saldoFinal
  from KARDEX (nolock)
 where data between '20151213' and '20151231'
 group by CodigoProduto
 order by CodigoProduto

insert into TBS124 select 0,'20160301',0,LocalEstoque,0,CodigoProduto,(select PROUM1 from TBS010 (nolock) where PROCOD=CodigoProduto),1,
       isnull((select SINQTD from TBS124 (nolock) where SINDAT='20160201' and LESCOD=LocalEstoque and SINPROCOD=CodigoProduto),0) +
       sum(NFentrada+EntradaDevolucao+NFsaidaCan+ECFcan+DEVcan+MOVentrada+SALentrada) -
       sum(NFsaida+ECF+NFdevolucao+MOVsaida+SALsaida) as saldoFinal
  from KARDEX (nolock) where data between '20160201' and '20160229'
 group by LocalEstoque,CodigoProduto


select * from TBS124 (nolock) where SINPROCOD in('1080067','1640054') order by SINDAT,SINPROCOD,LESCOD

select distinct SINDAT from TBS124 (nolock)

select top 1 * from KARDEX
select * from TBS125 (nolock)

select * from TBS124 (nolock) where SINPROCOD='1640054' order by SINDAT,LESCOD

select * from TBS098 (nolock) where SALREF in('2016/01','2016/02','2016/03') and PROCOD='1640054'

select * into TBS124BKP from TBS124 (nolock)

delete TBS124 

select top 1 * from TBS124 (nolock)
select top 1 * from TBS125 (nolock)

-- saldo inicial da contagem
-- 12/12/15 tanby matriz
-- 11/12/15 tanby cd
-- 18/12/15 tanby taubaté - retaguarda
-- 19/12/15 tanby taubaté - loja
-- 19/12/15 papelyna
-- 22/12/15 best bag ?
-- 30/12/15 misaspel

select count(*) from TBS125 (nolock) where month(KESDAT)=12

select year(KESDAT),month(KESDAT),count(*) from TBS125 (nolock) group by year(KESDAT),month(KESDAT) order by year(KESDAT),month(KESDAT)

insert into TBS124
select 0,             -- empresa da tabela de saldos iniciais
       '20151212',    -- data do saldo inicial
       0,             -- empresa do local de estoque
       LESCOD,        -- local de estoque
       0,             -- empresa do produto
       KESPROCOD,     -- código do produto
       (select PROUM1 from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default),    -- menor unidade de medida
       (select PROUM1QTD from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
       sum(KESMOVENT-KESMOVSAI),
       0
  from TBS125 (nolock)
 where KESDAT='20151212'
 group by LESCOD,KESPROCOD


delete TBS124 where SINDAT<>'20151212'

select year(SINDAT),month(SINDAT),count(*) from TBS124 (nolock) group by year(SINDAT),month(SINDAT) order by year(SINDAT),month(SINDAT)

-- saldo inicial nos demais meses após a contagem

declare @dataSaldo as date, @dataRegistro as date, @dataDe as date, @dataAte as date

-- data do saldo inicial
set @dataSaldo='20151212'

-- data do registro do próximo saldo inicial
set @dataRegistro='20160101'

-- período de contabilização das entradas e saídas
set @dataDe  = '20151212'
set @dataAte = '20151231'

/*
insert into TBS124
select 0,             -- empresa da tabela de saldos iniciais
       @dataRegistro, -- data do saldo inicial
       0,             -- empresa do local de estoque
       LESCOD,        -- local de estoque
       0,             -- empresa do produto
       KESPROCOD,     -- código do produto
       (select PROUM1 from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default),    -- menor unidade de medida
       (select PROUM1QTD from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
       -- cálculo do saldo = saldo inicial + entradas - saídas
       isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0)   -- saldo inicial
       + sum((KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT)                                                       -- entradas
       -     (KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI)),                                                                                  -- saídas
       0 -- custo da aquisição da mercadoria
  from TBS125 (nolock)
 where KESDAT between @dataDe and @dataAte
 group by LESCOD,KESPROCOD
*/

-- reformulando

insert into TBS124
select 0,             -- empresa da tabela de saldos iniciais
       @dataRegistro, -- data do saldo inicial
       0,             -- empresa do local de estoque
       LESCOD,        -- local de estoque
       0,             -- empresa do produto
       KESPROCOD,     -- código do produto
       (select PROUM1 from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default),    -- menor unidade de medida
       (select PROUM1QTD from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
       -- cálculo do saldo = saldo inicial + entradas - saídas
       case when isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0) > 0
            then isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0)
            else isnull((select top 1 SINQTD
                           from TBS124 (nolock)
                          where TBS124.SINDAT < @dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD
                          order by TBS124.SINDAT desc),0) end                                                                                                -- saldo inicial
       + sum((KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT)                                                       -- entradas
       -     (KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI)),                                                                                  -- saídas
       0 -- custo da aquisição da mercadoria
  from TBS125 (nolock)
 where KESDAT between @dataDe and @dataAte
 group by LESCOD,KESPROCOD

--

select distinct SINDAT from TBS124 (nolock) order by SINDAT desc

select * from TBS124 (nolock) where SINPROCOD in('1080067','1640054') and LESCOD in(1,2) order by SINPROCOD,LESCOD

select SINQTD from TBS124 (nolock) where SINDAT='20160401' and LESCOD=1 and SINPROCOD='1640054'

select LESCOD,SINPROCOD,count(*) from TBS124 (nolock) group by LESCOD,SINPROCOD having count(*) > 1

select * from TBS124 (nolock) where SINDAT='20160101' and SINPROCOD='1640054' and LESCOD in(1,2)

select * from TBS124 (nolock) where SINDAT='20160101' and SINPROCOD='1080067' and LESCOD=1

select convert(char(8),codigo),
       saldo,
       (select sum(SINQTD) from TBS124 (nolock) where SINDAT='20160101' and SINPROCOD=codigo collate database_default and LESCOD in(1,2) group by SINPROCOD)
  from INVND (nolock)
 where saldo<>(select sum(SINQTD) from TBS124 (nolock) where SINDAT='20160101' and SINPROCOD=codigo collate database_default and LESCOD in(1,2) group by SINPROCOD)

select sum(SINQTD) from TBS124 (nolock) where SINDAT='20160101' and SINPROCOD='1640054' and LESCOD in(1,2)


-- custo

select top 1
       year(PDCDATPRE),
       month(PDCDATPRE),
       convert(char(7),TBS0451.PDCDATPRE,111),
       TBS0451.PROCOD,
       round(avg(dbo.PDCTOTITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE)/TBS0451.PDCQTD/TBS0451.PDCQTDEMB),4)
  from TBS0451 (nolock)
 where TBS0451.PROCOD='1080067'
 group by PDCDATPRE,convert(char(7),TBS0451.PDCDATPRE,111),TBS0451.PROCOD
 order by convert(char(7),TBS0451.PDCDATPRE,111) desc


select convert(char(7),TBS045.PDCDATCAD,111),
       TBS0451.PROCOD,avg(dbo.PDCTOTITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE)/TBS0451.PDCQTD/TBS0451.PDCQTDEMB)
  from TBS0451 (nolock)
       inner join TBS045 (nolock) on TBS045.PDCEMPCOD=TBS0451.PDCEMPCOD and TBS045.PDCNUM=TBS0451.PDCNUM
 where TBS0451.PROCOD='1080067'
 group by convert(char(7),TBS045.PDCDATCAD,111),TBS0451.PROCOD

select top 1
       year(PDCDATPRE),
       month(PDCDATPRE),
       TBS0451.PROCOD,
       round(avg(dbo.PDCTOTITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE)/TBS0451.PDCQTD/TBS0451.PDCQTDEMB),4)
  from TBS0451 (nolock)
 where TBS0451.PROCOD='1080067'
 group by year(PDCDATPRE),month(TBS0451.PDCDATPRE),TBS0451.PROCOD
 order by year(PDCDATPRE) desc,month(TBS0451.PDCDATPRE) desc


update TBS124 set SINCUSAQU=(
select top 1
       round(avg(dbo.PDCTOTITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE)/TBS0451.PDCQTD/TBS0451.PDCQTDEMB),4)
  from TBS0451 (nolock)
 where TBS0451.PROCOD=TBS124.SINPROCOD and
       year(SINDAT) >= year(TBS0451.PDCDATPRE) and
       month(SINDAT) >= month(TBS0451.PDCDATPRE)
 group by year(TBS0451.PDCDATPRE),month(TBS0451.PDCDATPRE),TBS0451.PROCOD
 order by year(TBS0451.PDCDATPRE) desc,month(TBS0451.PDCDATPRE) desc)

select count(*) from TBS124 (nolock) where SINCUSAQU > 0
select count(*) from TBS124 (nolock) where SINCUSAQU = 0
select count(*) from TBS124 (nolock) where SINCUSAQU is null

select *
  from TBS124 (nolock)
 where SINCUSAQU is null and
       (select PROSTATUS from TBS010 (nolock) where PROCOD=SINPROCOD)<>'A'
 order by SINDAT,SINPROCOD,LESCOD

select count(SINQTD) from TBS124 (nolock) where SINQTD=0
select count(SINQTD) from TBS124 (nolock) where SINQTD>0
select count(SINQTD) from TBS124 (nolock) where SINQTD<0

select * from TBS034 (nolock)

select top 5 * from TBS015 (nolock) 

select '2017/12' as referencia,
       SINPROCOD as produto,
       (select PRODES from TBS010 (nolock) where PROCOD=SINPROCOD) as descricao,
       SINUNI as unidade,
       --custoCompra = isnull(round(avg(SINCUSAQU),4),0),
       custoCompra = isnull((select top 1 SINCUSAQU from TBS124 (nolock) B where B.SINPROCOD=A.SINPROCOD and SINDAT='20171201'),0), --  round(avg(SINCUSAQU),4),0),
       custoPolitica = isnull(round((select dbo.PDPCUSBAS(0,PDPCOD) from TBS015 (nolock) where PDPCOD=SINPROCOD),4),0),
       estoque1 = isnull(sum(case when LESCOD=1 then SINQTD end),0),
       estoque2 = isnull(sum(case when LESCOD=2 then SINQTD end),0),
       estoque3 = isnull(sum(case when LESCOD=3 then SINQTD end),0),
       estoque4 = isnull(sum(case when LESCOD=4 then SINQTD end),0),
       estoque5 = isnull(sum(case when LESCOD=5 then SINQTD end),0),
       estoque6 = isnull(sum(case when LESCOD=6 then SINQTD end),0),
       estoque7 = isnull(sum(case when LESCOD=7 then SINQTD end),0),
       estoque8 = isnull(sum(case when LESCOD=8 then SINQTD end),0),
       estoque9 = isnull(sum(case when LESCOD=9 then SINQTD end),0)
  from TBS124 (nolock) A
 where SINDAT='20180101' and SINQTD > 0
 group by SINPROCOD,SINUNI

-- requer a compatibilidade do SQL setada para um valor mais alto

select B.SINPROCOD,
       B.[1] as Estoque1,
       B.[2] as Estoque2,
       B.[3] as Estoque3,
       B.[4] as Estoque4,
       B.[5] as Estoque5,
       B.[6] as Estoque6,
       B.[7] as Estoque7,
       B.[8] as Estoque8,
       B.[9] as Estoque9
  from TBS124 as A
 PIVOT (SINQTD for LESCOD in([1],[2],[3],[4],[5],[6],[7],[8],[9])) as B
 order by 1








drop table #EST

declare @dataSaldo as date, @dataRegistro as date, @dataDe as date, @dataAte as date

-- data do saldo inicial
set @dataSaldo='20151212'

-- data do registro do próximo saldo inicial
set @dataRegistro='20160101'

-- período de contabilização das entradas e saídas
set @dataDe  = '20151214'
set @dataAte = '20151231'

--insert into TBS124
select 0 as emp,             -- empresa da tabela de saldos iniciais
       @dataRegistro as data, -- data do saldo inicial
       0 as empest,             -- empresa do local de estoque
       LESCOD as estoque,        -- local de estoque
       0 as emppro,             -- empresa do produto
       KESPROCOD as produto,     -- código do produto
       (select PROUM1 from TBS010 (nolock) where PROCOD=KESPROCOD) as un,    -- menor unidade de medida
       (select PROUM1QTD from TBS010 (nolock) where PROCOD=KESPROCOD) as emb, -- quantidade da embalagem da menor unidade de medida
       -- cálculo do saldo = saldo inicial + entradas - saídas
       isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0), -- saldo inicial
       isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0) +  -- saldo inicial
       sum(KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT) -                      -- entradas
       sum(KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI) as saldo,                                                    -- saídas
       0 as custo -- susto da aquisição da mercadoria
--  into #EST
  from TBS125 (nolock)
 where KESDAT between @dataDe and @dataAte and KESPROCOD='16130055' and LESCOD=6
 group by LESCOD,KESPROCOD

select produto,estoque,saldo,PROCOD,ESTLOC,ESTQTDATU
  from #EST
       inner join TBS032COMP (nolock) on ESTLOC=estoque and PROCOD=produto

select * from #EST where produto='1640054'

select * from TBS125 (nolock) where KESPROCOD='1640054' and KESDAT between '20160101' and '20160131' and LESCOD=1 order by KESDAT,LESCOD

select * from #NFENT where CodigoProduto='1640054' and LocalEstoque=1 order by data

select * from TBS124 (nolock) where SINPROCOD='1640054' and LESCOD in(1,2) order by SINDAT desc,LESCOD

select * from SIBD3103.dbo.TBS032 (nolock) where PROCOD='1640054' and ESTLOC in(1,2) order by ESTLOC

select KESPROCOD,sum(KESCUPFIS) from TBS125 (nolock) group by KESPROCOD

delete TBS125





---

select ESTLOC,ESTQTDATU,* from TBS032COMP (nolock) order by ESTLOC,PROCOD

select * from TBS059 (nolock) where NFENUM=22556
select * from TBS0591 (nolock) where NFENUM=22556

select count(*)
  from TBS051 (nolock)
 where LMEROT='PEST029' and
       convert(date,LMEDATHOR) >= '20160101' and
       LMEINFALT='E'
 group by LMEDOC,PROCOD

select *
  from TBS051 (nolock)
 where LMEROT='PEST029' and
       convert(date,LMEDATHOR) >= '20160101' and
       LMEINFALT='E'

---

select convert(date,TBS037.MVIDATEFE) as data,
       TBS0371.PROCOD as CodigoProduto,
       TBS037.MVILOCDES as LocalEstoque,
       sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as ENTRADA
  from TBS0371 (nolock)
       inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
 where convert(date,TBS037.MVIDATEFE)='20151212' and
       TBS037.MVILOCDES > 0
       and PROCOD='1080067'
 group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCDES,TBS0371.PROCOD

select convert(date,TBS037.MVIDATEFE) as data,
       TBS0371.PROCOD as CodigoProduto,
       TBS037.MVILOCDES as LocalEstoque,
       sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as SAIDA
  from TBS0371 (nolock)
       inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
 where convert(date,TBS037.MVIDATEFE)='20151212' and
       TBS037.MVILOCORI > 0
       and PROCOD='1080067'
 group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCDES,TBS0371.PROCOD

select convert(date,TBS037.MVIDATEFE) as data,
       TBS0371.PROCOD as CodigoProduto,
       TBS037.MVILOCORI as LocalEstoque,
       sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as QTDE
  into #movsai
  from TBS0371 (nolock)
       inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
       inner join TBS033 (nolock) on TBS033.TMVCOD=TBS037.TMVCOD
 where convert(date,TBS037.MVIDATEFE)='20151212' and
       TBS033.TMVTIP='S' and
       TBS037.MVILOCDES=0
 group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCORI,TBS0371.PROCOD

drop table #inventario

select A.CodigoProduto as produto,
       A.LocalEstoque,
       isnull(A.QTDE,0) as entrada,
       isnull(B.QTDE,0) as saida,
       isnull(A.QTDE,0)-isnull(B.QTDE,0) as saldo
  into #inventario
  from #movent A full join #movsai B on B.data=A.data and B.CodigoProduto=A.CodigoProduto and B.LocalEstoque=A.LocalEstoque
 where A.LocalEstoque in(1,2)

select *
  from #inventario
       full join TBS124 (nolock) on SINPROCOD=produto and LESCOD=LocalEstoque
 where SINDAT='20151212' and
       LESCOD in(1,2)
       and produto='1080067'
       and saldo<>SINQTD


----


select '2016/04' as referencia,
       SINPROCOD as produto,
       estoque1 = isnull(sum(case when LESCOD=1 then SINQTD end),0),
       estoque2 = isnull(sum(case when LESCOD=2 then SINQTD end),0)
  into #saldo
  from TBS124 (nolock)
 where SINDAT='20160501'
 group by SINPROCOD

drop table #saldo

select * from #saldo

select count(*) from #saldo

select count(*)
  from #saldo inner join SIBD3103.dbo.TBS032 (nolock) on PROCOD=produto
 where ESTLOC=1 and estoque1 <> ESTQTDATU

select *
  from #saldo inner join SIBD3103.dbo.TBS032 (nolock) on PROCOD=produto
 where ESTLOC=1 and estoque1 = ESTQTDATU

select * from SALDODIARIO (nolock) order by ESTDATSAL desc

select count(*)
  from #saldo inner join SALDODIARIO (nolock) on PROCOD=produto
 where ESTDATSAL='20160430' and ESTLOC=1 and estoque1 <> ESTQTDATU

select count(*)
  from #saldo inner join SALDODIARIO (nolock) on PROCOD=produto
 where ESTDATSAL='20160430' and ESTLOC=1 and estoque1 = ESTQTDATU

select * from SALDODIARIO (nolock) where ESTDATSAL='20160430' and ESTLOC in(1,2) and PROCOD='1640054'
select * from SALDODIARIO (nolock) where ESTDATSAL='20160430' and ESTLOC in(1,2) and PROCOD='1080067'


select convert(date,'20160101')

select UFEDATCAD,UFEDATCAD-1 from TBS001 (nolock)

select max(KESDAT) from TBS125 (nolock)


select * from TBS124 (nolock) where SINPROCOD='16130055' and LESCOD=6

select * from TBS125 (nolock) where KESPROCOD='16130055' and LESCOD=6 order by KESDAT


select * from TBS124 (nolock) where SINPROCOD='0650001' and LESCOD=1 order by SINDAT,LESCOD

select ESTLOC,ESTQTDATU from TBS032 (nolock) where PROCOD='0650001' and ESTLOC=1 order by ESTLOC

select top 1 LMEDATHOR,LMEQTDSAL from TBS051 (nolock) where LMEDATHOR < '20160601' and LMEINFALT='E' and PROCOD='0650001' and LMELOCEST=1 order by LMEDATHOR desc

select * from SALDODIARIO (nolock) where ESTDATSAL='20160531' and ESTLOC=1 and PROCOD='0650001'






select top 1 convert(datetime,ESTDATSAL)+1 from SALDODIARIO (nolock)

select SINQTD,ESTQTDATU,case when ESTQTDATU>0 then (1-SINQTD/ESTQTDATU)*100 else 0 end,* from TBS124 (nolock) inner join SALDODIARIO on LESCOD=ESTLOC and SINPROCOD=PROCOD
 where LESCOD=1 and SINDAT='20160801' and ESTDATSAL='20160730' and
       SINQTD<>ESTQTDATU

select * from SALDODIARIO (nolock) where month(ESTDATSAL)=7


select * into TBS124BKP from TBS124 (nolock)
select * into TBS125BKP from TBS125 (nolock)

delete TBS124
delete TBS125BKP

select * from TBS125BKP

drop table TBS124BKP

select min(convert(date,ESTDATSAL)) from SALDODIARIO (nolock)


---------------------------------------------------------------------------------------------------------------------------------------------

-- procedure: coletar movimentações

if exists(select name from sysobjects where name='SP_MovimentacaoDiaria' and type='P')
   drop procedure [dbo].[SP_MovimentacaoDiaria]
go

create procedure [dbo].[SP_MovimentacaoDiaria] @dataDe as date, @dataAte as date as
   begin
      -- empresa em execução
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))
      ;

      -- ENTRADAS

      -- NF de entrada

      if object_id('TempDB.dbo.##NFENT') is not null
         begin
            drop table ##NFENT
         end
      ;

      select TBS059.NFEDATEFE as data,
             TBS0591.PROCOD as CodigoProduto,
             TBS0591.LESCOD as LocalEstoque,
             sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB) as QTDE
        into ##NFENT
        from TBS0591 (nolock)
             inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       where TBS059.NFEUSUEFE<>'' and
             TBS059.NFETIP<>'D' and
             TBS059.NFEDATEFE between @dataDe and @dataAte and
             TBS0591.NFEMOVEST='S'
       group by TBS059.NFEDATEFE,TBS0591.LESCOD,TBS0591.PROCOD
      ;

      -- NF de entrada de devolução

      if object_id('TempDB.dbo.##NFENTDEV') is not null
         begin
            drop table ##NFENTDEV
         end
      ;

      select TBS059.NFEDATEFE as data,
             TBS0591.PROCOD as CodigoProduto,
             TBS0591.LESCOD as LocalEstoque,
             sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB) as QTDE
        into ##NFENTDEV
        from TBS0591 (nolock)
             inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       where TBS059.NFEUSUEFE<>'' and
             TBS059.NFETIP='D' and
             TBS059.NFEDATEFE between @dataDe and @dataAte and
             TBS0591.NFEMOVEST='S'
       group by TBS059.NFEDATEFE,TBS0591.LESCOD,TBS0591.PROCOD
      ;

      -- NF de saída canceladas

      if object_id('TempDB.dbo.##NFSAICAN') is not null
         begin
           drop table ##NFSAICAN
         end
      ;

      select TBS067.NFSDATCAN as data,
             TBS0671.PROCOD as CodigoProduto,
             TBS0671.LESCOD as LocalEstoque,
             sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB) as QTDE
        into ##NFSAICAN
        from TBS0671 (nolock)
             inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       where TBS067.NFSTIP='N' and
             TBS067.NFSCAN='S' and
             TBS067.NFSDATCAN between @dataDe and @dataAte and
             TBS0671.NFSMOVEST='S'
       group by TBS067.NFSDATCAN,TBS0671.LESCOD,TBS0671.PROCOD
      ;

      -- ECF cancelados

      if object_id('TempDB.dbo.##ECFCAN') is not null
         begin
            drop table ##ECFCAN
         end
      ;

      create table ##ECFCAN (data datetime,CodigoProduto varchar(20) collate database_default,LocalEstoque smallint,QTDE smallmoney);

      -- se empresa igual a best bag ou tanby matriz ou taubaté
      if @emp = 'BB' or @emp = 'TM' or @emp = 'TT'
         begin
            declare @comando as char(500)

            set @comando = 'execute(''select data,Ltrim(cdprod) as CodigoProduto,2 as LocalEstoque,sum(quant) as QTDE from movcaixa where data between "'+convert(char(8),@dataDe,112)+'" and "'+convert(char(8),@dataAte,112)+'"  and status="01" and cancelado="S" group by data,Ltrim(cdprod)'') at MYSQLGZ'

            insert into ##ECFCAN exec(@comando)

            update ##ECFCAN set CodigoProduto=right('0000000'+Ltrim(CodigoProduto),7) where Len(CodigoProduto) < 7
         end
      ;

      -- NF de devolução para fornecedor cancelada ou em aberto

      if object_id('TempDB.dbo.##NFDEVCAN') is not null
         begin
            drop table ##NFDEVCAN
         end
      ;

      select TBS117.NFDDATEMI as data,
             TBS1172.PROCOD as CodigoProduto,
             TBS1172.LESCOD as LocalEstoque,
             sum(TBS1172.NFDQTD * TBS1172.NFDQTDEMB) as QTDE
        into ##NFDEVCAN
        from TBS1172 (nolock) inner join TBS117 (nolock) on TBS117.SNESER=TBS1172.SNESER and TBS117.NFDNUM=TBS1172.NFDNUM
       where (TBS117.NFDSTATUS='C' or TBS117.NFDSTATUS='O') and
             TBS117.NFDDATEMI between @dataDe and @dataAte and
             TBS1172.NFDMOVEST='S'
       group by TBS117.NFDDATEMI,TBS1172.LESCOD,TBS1172.PROCOD
      ;

      -- movimentos internos

      if object_id('TempDB.dbo.##MOVENT') is not null
         begin
            drop table ##MOVENT
         end
      ;

      select convert(date,TBS037.MVIDATEFE) as data,
             TBS0371.PROCOD as CodigoProduto,
             TBS037.MVILOCDES as LocalEstoque,
             sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as QTDE
        into ##MOVENT
        from TBS0371 (nolock)
             inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
             inner join TBS033 (nolock) on TBS033.TMVCOD=TBS037.TMVCOD
       where convert(date,TBS037.MVIDATEFE) between @dataDe and @dataAte and
             TBS037.MVILOCDES > 0
       group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCDES,TBS0371.PROCOD
      ;

      -- manutenção dos saldos

      if object_id('TempDB.dbo.##SALENT') is not null
         begin
            drop table ##SALENT
         end
      ;

      select convert(date,TBS049.MDSLAN) as data,
             TBS049.PROCOD as CodigoProduto,
             TBS049.LESCOD as LocalEstoque,
             sum(TBS049.MDSQTD * TBS049.MDSQTDEMB) as QTDE
        into ##SALENT
        from TBS049 (nolock)
       where convert(date,TBS049.MDSLAN) between @dataDe and @dataAte and
             TBS049.MDSTIP='E'
       group by convert(date,TBS049.MDSLAN),TBS049.LESCOD,TBS049.PROCOD
      ;

      -- fim ENTRADAS



      -- SAÍDAS

      -- NF de saída

      if object_id('TempDB.dbo.##NFSAI') is not null
         begin
            drop table ##NFSAI
         end
      ;

      select TBS067.NFSDATEMI as data,
             TBS0671.PROCOD as CodigoProduto,
             TBS0671.LESCOD as LocalEstoque,
             sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB) as QTDE
        into ##NFSAI
        from TBS0671 (nolock)
             inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       where TBS067.NFSTIP='N' and
             TBS067.NFSDATEMI between @dataDe and @dataAte and
             TBS0671.NFSMOVEST='S'
       group by TBS067.NFSDATEMI,TBS0671.LESCOD,TBS0671.PROCOD
      ;

      -- ECF

      if object_id('TempDB.dbo.##ECF') is not null
         begin
            drop table ##ECF
         end
      ;

      create table ##ECF (data datetime,CodigoProduto varchar(20) collate database_default,LocalEstoque smallint,QTDE smallmoney);

      -- se empresa igual a best bag ou tanby matriz ou taubaté
      if @emp = 'BB' or @emp = 'TM' or @emp = 'TT'
         begin
            declare @comando2 as char(500)

            set @comando2 = 'execute(''select data,Ltrim(cdprod) as CodigoProduto,2 as LocalEstoque,sum(quant) as QTDE from movcaixa where data between "'+convert(char(8),@dataDe,112)+'" and "'+convert(char(8),@dataAte,112)+'"  and status="01" group by data,Ltrim(cdprod)'') at MYSQLGZ'

            insert into ##ECF exec(@comando2)

            update ##ECF set CodigoProduto=right('0000000'+Ltrim(CodigoProduto),7) where Len(CodigoProduto) < 7
         end
      ;

      -- NF de devolução para fornecedor

      if object_id('TempDB.dbo.##NFDEV') is not null
         begin
            drop table ##NFDEV
         end
      ;

      select TBS117.NFDDATEMI as data,
             TBS1172.PROCOD as CodigoProduto,
             TBS1172.LESCOD as LocalEstoque,
             sum(TBS1172.NFDQTD * TBS1172.NFDQTDEMB) as QTDE
        into ##NFDEV
        from TBS1172 (nolock) inner join TBS117 (nolock) on TBS117.SNESER=TBS1172.SNESER and TBS117.NFDNUM=TBS1172.NFDNUM
       where TBS117.NFDDATEMI between @dataDe and @dataAte and
             TBS1172.NFDMOVEST='S'
       group by TBS117.NFDDATEMI,TBS1172.LESCOD,TBS1172.PROCOD
      ;

      -- movimentos internos

      if object_id('TempDB.dbo.##MOVSAI') is not null
         begin
            drop table ##MOVSAI
         end
      ;

      select convert(date,TBS037.MVIDATEFE) as data,
             TBS0371.PROCOD as CodigoProduto,
             TBS037.MVILOCORI as LocalEstoque,
             sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as QTDE
        into ##MOVSAI
        from TBS0371 (nolock)
             inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
             inner join TBS033 (nolock) on TBS033.TMVCOD=TBS037.TMVCOD
       where convert(date,TBS037.MVIDATEFE) between @dataDe and @dataAte and
             TBS037.MVILOCORI > 0
       group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCORI,TBS0371.PROCOD
      ;

      -- manutenção dos saldos

      if object_id('TempDB.dbo.##SALSAI') is not null
         begin
            drop table ##SALSAI
         end
      ;

      select convert(date,TBS049.MDSLAN) as data,
             TBS049.PROCOD as CodigoProduto,
             TBS049.LESCOD as LocalEstoque,
             sum(TBS049.MDSQTD * TBS049.MDSQTDEMB) as QTDE
        into ##SALSAI
        from TBS049 (nolock)
       where convert(date,TBS049.MDSLAN) between @dataDe and @dataAte and
             TBS049.MDSTIP='S'
       group by convert(date,TBS049.MDSLAN),TBS049.LESCOD,TBS049.PROCOD
      ;

      -- fim SAÍDAS

      -- fim da coleta temporária de dados

   end




-- procedure: popula a tabela de kardex diário das movimentações dos produtos

if exists(select name from sysobjects where name='SP_PopulaKardexDiario' and type='P')
   drop procedure [dbo].[SP_PopulaKardexDiario]
go

create procedure [dbo].[SP_PopulaKardexDiario] as
   begin

      if object_id('TempDB.dbo.#mov') is not null
         begin
         drop table #compra
      end
      ;

      declare @datai date

      -- data inicial para pesquisa da tabela... 1 ano antes da data corrente
      set @datai = dateadd(day, -365, convert(date, getdate()))

      select row_number() over(partition by PROCOD order by LMEREG desc, PROCOD) as rank,
             convert(date,LMEDATHOR) data,
             LMELOCEST estoque,
             PROCOD codigo,
             LMEQTDSAL qtde
        into #compra
        from TBS051 (nolock)
       where LMEDATHOR between @datai and convert(date, getdate()) and LMEINFALT='C' and LMELOCEST in(1,2,3,6,9)
      ;

      if object_id('TempDB.dbo.#pendencia') is not null
         begin
         drop table #pendencia
      end
      ;

      select row_number() over(partition by PROCOD order by LMEREG desc, PROCOD) as rank,
             convert(date,LMEDATHOR) data,
             LMELOCEST estoque,
             PROCOD codigo,
             LMEQTDSAL qtde
        into #pendencia
        from TBS051 (nolock)
       where LMEDATHOR between @datai and convert(date, getdate()) and LMEINFALT='P' and LMELOCEST in(1,2,3,6,9)
      ;

/*
      select * from #compra where estoque<>1 order by data desc

      select * from #compra where codigo='3790045' order by data desc

      select * from #compra where estoque=2 order by data desc

      select * from #mov where codigo='3790001' order by data desc, codigo, rank

      select data,codigo,sum(qtde) qtde into #kardex from #mov group by data, codigo

      select * from #kardex where codigo='3790001' order by data desc

select max(data),estoque,codigo from #mov where estoque in(1,2) and codigo='0060186' group by estoque,codigo
*/

-- tabelas

/*     #NFENT
    1. #NFENTDEV
    2. #NFSAICAN
    3. #ECFCAN
    4. #NFDEVCAN
    5. #MOVENT
    6. #SALENT
    7. #NFSAI
    8. #ECF
    9. #NFDEV
   10. #MOVSAI
   11. #SALSAI */

/*
if object_id('TempDB.dbo.#kardex') is not null
   begin
      drop table #kardex
   end
;
*/

with tab1 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.QTDE,0) as NFentrada,
          isnull(B.QTDE,0) as EntradaDevolucao
     from ##NFENT as A
          full join ##NFENTDEV as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab2 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(B.QTDE,0) as NFsaidaCan
     from tab1 as A
          full join ##NFSAICAN as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab3 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(B.QTDE,0) as ECFcan
     from tab2 as A
          full outer join ##ECFCAN as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab4 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(B.QTDE,0) as DEVcan
     from tab3 as A
          full join ##NFDEVCAN as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab5 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(B.QTDE,0) as MOVentrada
     from tab4 as A
          full join ##MOVENT as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab6 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(B.QTDE,0) as SALentrada
     from tab5 as A
          full join ##SALENT as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab7 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(B.QTDE,0) as NFsaida
     from tab6 as A
          full join ##NFSAI as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab8 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(A.NFsaida,0) as NFsaida,
          isnull(B.QTDE,0) as ECF
     from tab7 as A
          full outer join ##ECF as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab9 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(A.NFsaida,0) as NFsaida,
          isnull(A.ECF,0) as ECF,
          isnull(B.QTDE,0) as NFdevolucao
     from tab8 as A
          full join ##NFDEV as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab10 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(A.NFsaida,0) as NFsaida,
          isnull(A.ECF,0) as ECF,
          isnull(A.NFdevolucao,0) as NFdevolucao,
          isnull(B.QTDE,0) as MOVsaida
     from tab9 as A
          full join ##MOVSAI as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)
,
tab11 as (
   select case when A.data is not null then A.data else B.data end as data, 
          case when A.CodigoProduto is not null then A.CodigoProduto else B.CodigoProduto end as CodigoProduto,
          case when A.LocalEstoque is not null then A.LocalEstoque else B.LocalEstoque end as LocalEstoque,
          isnull(A.NFentrada,0) as NFentrada,
          isnull(A.EntradaDevolucao,0) as EntradaDevolucao,
          isnull(A.NFsaidaCan,0) as NFsaidaCan,
          isnull(A.ECFcan,0) as ECFcan,
          isnull(A.DEVcan,0) as DEVcan,
          isnull(A.MOVentrada,0) as MOVentrada,
          isnull(A.SALentrada,0) as SALentrada,
          isnull(A.NFsaida,0) as NFsaida,
          isnull(A.ECF,0) as ECF,
          isnull(A.NFdevolucao,0) as NFdevolucao,
          isnull(A.MOVsaida,0) as MOVsaida,
          isnull(B.QTDE,0) as SALsaida
     from tab10 as A
          full join ##SALSAI as B on B.data=A.data and B.LocalEstoque=A.LocalEstoque and B.CodigoProduto=A.CodigoProduto)

--select * into #kardex from tab11;

-- select * from #kardex

insert into TBS125
select 0 empresa,                -- empresa do kardex
       data,             -- data da movimentação
       0 empEstoque,                -- empresa do local de estoque
       LocalEstoque,     -- local do estoque
       0 empProduto,                -- empresa do produto
       CodigoProduto,    -- código do produto
       -- entradas
       NFentrada,        -- nf de entrada
       EntradaDevolucao, -- entrada de devolução
       NFsaidaCan,       -- nf de saída cancelada
       ECFcan,           -- cupom fiscal cancelado
       DEVcan,           -- cancelamento de nf de devolução de saída
       MOVentrada,       -- movimento interno de entrada
       SALentrada,       -- entrada via manutenção do saldo 
       -- saídas
       NFsaida,          -- nota fiscal de saída
       ECF,              -- cupom fiscal
       NFdevolucao,      -- nf de saída de devolução
       MOVsaida,         -- movimento interno de saída
       SALsaida,         -- saída via manutenção do saldo
       0 custoMedio,                -- custo médio de compra
       (select PROUM1QTD from TBS010 (nolock) where PROCOD=CodigoProduto) qtdeEmb, -- quantidade da embalagem da menor unidade de medida
--       0 qtdEmb,
       (select PROUM1 from TBS010 (nolock) where PROCOD=CodigoProduto) uni,    -- menor unidade de medida do produto
--       '' uni,
       0 outras,                 -- outras entradas/saídas

       -- compras 
       --dbo.saldoTBS051(data, 'C', CodigoProduto) compras,
       /*
       (isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=CodigoProduto and LMELOCEST=1 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=CodigoProduto and LMELOCEST=2 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=CodigoProduto and LMELOCEST=3 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=CodigoProduto and LMELOCEST=4 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=CodigoProduto and LMELOCEST=5 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=CodigoProduto and LMELOCEST=6 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=CodigoProduto and LMELOCEST=7 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=CodigoProduto and LMELOCEST=8 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=CodigoProduto and LMELOCEST=9 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0))
       */
       --0 compras,
       isnull((select top 1 #compra.qtde from #compra (nolock)
                where #compra.codigo=tab11.CodigoProduto and #compra.estoque=1 and #compra.data <= tab11.data order by rank),0)
       +
       isnull((select top 1 #compra.qtde from #compra (nolock)
                where #compra.codigo=tab11.CodigoProduto and #compra.estoque=2 and #compra.data <= tab11.data order by rank),0)
       +
       isnull((select top 1 #compra.qtde from #compra (nolock)
                where #compra.codigo=tab11.CodigoProduto and #compra.estoque=3 and #compra.data <= tab11.data order by rank),0)
       +
       isnull((select top 1 #compra.qtde from #compra (nolock)
                where #compra.codigo=tab11.CodigoProduto and #compra.estoque=6 and #compra.data <= tab11.data order by rank),0)
       +
       isnull((select top 1 #compra.qtde from #compra (nolock)
                where #compra.codigo=tab11.CodigoProduto and #compra.estoque=9 and #compra.data <= tab11.data order by rank),0) compras,

       -- pendência
       --dbo.saldoTBS051(data, 'P', CodigoProduto) pendencias,

       /*
       (isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=CodigoProduto and LMELOCEST=1 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=CodigoProduto and LMELOCEST=2 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=CodigoProduto and LMELOCEST=3 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=CodigoProduto and LMELOCEST=4 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=CodigoProduto and LMELOCEST=5 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=CodigoProduto and LMELOCEST=6 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=CodigoProduto and LMELOCEST=7 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=CodigoProduto and LMELOCEST=8 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)
        +
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=CodigoProduto and LMELOCEST=9 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0))
       */
       --0 pendecias,

       isnull((select top 1 #pendencia.qtde from #pendencia (nolock)
                where #pendencia.codigo=tab11.CodigoProduto and #pendencia.estoque=1 and #pendencia.data <= tab11.data order by rank),0)
       +
       isnull((select top 1 #pendencia.qtde from #pendencia (nolock)
                where #pendencia.codigo=tab11.CodigoProduto and #pendencia.estoque=2 and #pendencia.data <= tab11.data order by rank),0)
       +
       isnull((select top 1 #pendencia.qtde from #pendencia (nolock)
                where #pendencia.codigo=tab11.CodigoProduto and #pendencia.estoque=3 and #pendencia.data <= tab11.data order by rank),0)
       +
       isnull((select top 1 #pendencia.qtde from #pendencia (nolock)
                where #pendencia.codigo=tab11.CodigoProduto and #pendencia.estoque=6 and #pendencia.data <= tab11.data order by rank),0)
       +
       isnull((select top 1 #pendencia.qtde from #pendencia (nolock)
                where #pendencia.codigo=tab11.CodigoProduto and #pendencia.estoque=9 and #pendencia.data <= tab11.data order by rank),0) pendencias,

       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='E' and PROCOD=CodigoProduto and LMELOCEST=LocalEstoque and convert(date,LMEDATHOR)<=data order by LMEREG desc) saldo
--       0

--  into #kardex
  from tab11
 where isnull((select 1 from TBS125 (nolock) where KESEMPCOD=0 and KESDAT=data and LESEMPCOD=0 and LESCOD=LocalEstoque and KESPROEMP=0 and KESPROCOD=CodigoProduto),0) = 0 and
       data is not null
 order by data,LocalEstoque,CodigoProduto;

--insert into TBS125 select * from #kardex

end

-- fim: popula a tabela de kardex diário das movimentações dos produtos




-- função: saldo da tabela 51

if exists(select name from sysobjects where name='SP_saldoTBS051' and type='P')
   drop procedure [dbo].[SP_saldoTBS051]
go

create procedure [dbo].[SP_saldoTBS051] @data date, @info char(1), @produto varchar(15), @retorno decimal(10,3) output as
   begin

--drop function saldoTBS051
--go

--create function saldoTBS051(@data date, @info char(1), @produto varchar(15)) returns decimal(10,3) as
--   begin
--      declare @retorno decimal(10,3)

      select convert(date,LMEDATHOR) dataMov,LMELOCEST,LMEINFALT,PROCOD,LMEQTDSAL
        into #mov
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMEINFALT=@info and PROCOD=@produto
       order by LMEREG desc, LMELOCEST

      set @retorno = 0

      select top 1 @retorno += isnull(LMEQTDSAL,0) from #mov where LMELOCEST=1

/*
      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=2 and LMEINFALT=@informacao and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=3 and LMEINFALT=@informacao and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=4 and LMEINFALT=@informacao and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=5 and LMEINFALT=@informacao and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=6 and LMEINFALT=@informacao and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=7 and LMEINFALT=@informacao and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=8 and LMEINFALT=@informacao and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=9 and LMEINFALT=@informacao and PROCOD=@produto order by LMEREG desc
*/
--      return @retorno
   end
--go

select dbo.saldoTBS051('20170420', 'C', '3790045')

drop function saldoTBS051
go

create function saldoTBS051(@data date, @info char(1), @produto varchar(15)) returns decimal(10,3) as
   begin
      declare @retorno decimal(10,3)

--      exec [dbo].[SP_saldoTBS051] @data, @info, @produto, @retorno output

      set @retorno = 0

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=1 and LMEINFALT=@info and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=2 and LMEINFALT=@info and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=3 and LMEINFALT=@info and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=6 and LMEINFALT=@info and PROCOD=@produto order by LMEREG desc

      select top 1 @retorno += isnull(LMEQTDSAL,0)
        from TBS051 (nolock)
       where convert(date,LMEDATHOR)<=@data and LMELOCEST=9 and LMEINFALT=@info and PROCOD=@produto order by LMEREG desc

      return @retorno
   end


declare @ret decimal(10,3)

exec [dbo].[SP_saldoTBS051] '20180228', 'C', '1080067', @ret output

select @ret


-- cursor

select top 1 * from TBS125 (nolock)

declare @emp smallint, @data date, @empEst smallint, @estoque smallint, @empPro smallint, @produto varchar(15), @saldo decimal(10,3)

-- declara o cursor
declare cursor_kardex cursor for
    select KESEMPCOD, KESDAT, LESEMPCOD, LESCOD, KESPROEMP, KESPROCOD
      from TBS125 (nolock)
     where KESDAT between '20180201' and '20180228'

-- abre o cursor
open cursor_kardex

-- le próxima linha
fetch next from cursor_kardex into @emp, @data, @empEst, @estoque, @empPro, @produto

if object_id('TempDB.dbo.#kardex') is not null
   begin
      drop table #kardex
   end

select @emp emp, @data data, @empEst empEst, @estoque estoque, @empPro empPro, @produto produto, '' info, 10.3 saldo into #kardex

--delete #kardex

-- percorre linhas do cursor
while @@fetch_status = 0
   begin
      -- atualiza compras
      --set @saldo = 0

      select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=@produto and LMELOCEST=@estoque and convert(date,LMEDATHOR)<=@data order by LMEREG desc

--      exec [dbo].[SP_saldoTBS051] @data, 'C', @produto, @saldo output;
--      insert into #kardex
--      select @emp, @data, @empEst, @estoque, @empPro, @produto, 'C', @saldo
      
--      update TBS125 set KESQTDCOM=@saldo where KESEMPCOD=@emp and KESDAT=@data and LESEMPCOD=@empEst and LESCOD=@estoque and KESPROEMP=@empPro and KESPROCOD=@produto;

      -- atualiza pendências
      set @saldo = 0
--      exec [dbo].[SP_saldoTBS051] @data, 'P', @produto, @saldo output
--      update TBS125 set KESQTDCOM=@saldo where KESEMPCOD=@emp and KESDAT=@data and LESEMPCOD=@empEst and LESCOD=@estoque and KESPROEMP=@empPro and KESPROCOD=@produto;

      -- le próxima linha
      fetch next from cursor_kardex into @emp, @data, @empEst, @estoque, @empPro, @produto
   end

-- eecha o cursor
close cursor_kardex

-- desaloca o cursor
deallocate cursor_kardex

select * from #kardex

-- fim: cursor


-- procedure: saldos iniciais após contagem

if exists(select name from sysobjects where name='SP_SaldoInicialInventario' and type='P')
   drop procedure [dbo].[SP_SaldoInicialInventario]
go

create procedure [dbo].[SP_SaldoInicialInventario] @dataSaldo as date as
   begin

      -- saldo inicial da contagem
      -- 12/12/15 tanby matriz
      -- 11/12/15 tanby cd
      -- 19/12/15 tanby taubaté - retaguarda/loja
      -- 19/12/15 papelyna
      -- 22/12/15 best bag ?
      -- 30/12/15 misaspel

      insert into TBS124
      select 0,             -- empresa da tabela de saldos iniciais
             @dataSaldo,    -- data do saldo inicial
             0,             -- empresa do local de estoque
             LESCOD,        -- local de estoque
             0,             -- empresa do produto
             KESPROCOD,     -- código do produto
             (select PROUM1 from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default),    -- menor unidade de medida
             (select PROUM1QTD from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
             sum(KESMOVENT-KESMOVSAI),
             0
        from TBS125 (nolock)
       where KESDAT=@dataSaldo and
             isnull((select 1 from TBS124 (nolock) where SINEMPCOD=0 and SINDAT=@dataSaldo and LESEMPCOD=0 and TBS124.LESCOD=TBS125.LESCOD and SINEMPPRO=0 and SINPROCOD=KESPROCOD),0) = 0
       group by LESCOD,KESPROCOD

   end

-- fim: saldos iniciais após contagem - atenção, somente rodar 1 vez



-- procedure: saldo inicial nos demais meses após a contagem

if exists(select name from sysobjects where name='SP_SaldoInicialMensal' and type='P')
   drop procedure [dbo].[SP_SaldoInicialMensal]
go

create procedure [dbo].[SP_SaldoInicialMensal] @dataSaldoBase as date as
   begin

      /* inclusão através da contabilização do saldo anterior e as movimentações de entradas/saídas

      declare @ultimoDiaMes as date, @dataProximoSaldoInicial as date, @movimentoDe as date, @movimentoAte as date

      -- último dia do mês
      set @ultimoDiaMes = convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, @dataSaldoBase) + 1, 0)))

      -- data do próximo saldo inicial = 
      set @dataProximoSaldoInicial = DATEADD(day, 1, @ultimoDiaMes)

      -- período das movimentações
      set @movimentoDe  = @dataSaldoBase
      set @movimentoAte = @ultimoDiaMes

      insert into TBS124
      select 0,                          -- empresa da tabela de saldos iniciais
             @dataProximoSaldoInicial,   -- data do saldo inicial
             0,                          -- empresa do local de estoque
             LESCOD,                     -- local de estoque
             0,                          -- empresa do produto
             KESPROCOD,                  -- código do produto
             (select PROUM1 from TBS010 (nolock) where PROCOD = KESPROCOD collate database_default),    -- menor unidade de medida
             (select PROUM1QTD from TBS010 (nolock) where PROCOD = KESPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
             -- cálculo do saldo = saldo inicial + entradas - saídas
             case when isnull((select 1 from TBS124 (nolock) where TBS124.SINDAT=@dataSaldoBase and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0) > 0
                  then isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldoBase and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0)
                  else isnull((select top 1 SINQTD
                                 from TBS124 (nolock)
                                where TBS124.SINDAT < @dataSaldoBase and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD
                                order by TBS124.SINDAT desc),0) end                                                                                                -- saldo inicial
             + sum((KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT + KESOUT)                                              -- entradas
             -     (KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI)),                                                                                  -- saídas
             0 -- custo da aquisição da mercadoria
        from TBS125 (nolock)
       where KESDAT between @movimentoDe and @movimentoAte and
             isnull((select 1 from TBS124 (nolock)
                      where SINEMPCOD=0 and SINDAT=@dataProximoSaldoInicial and LESEMPCOD=0 and TBS124.LESCOD=TBS125.LESCOD and SINEMPPRO=0 and SINPROCOD=KESPROCOD),0) = 0
       group by LESCOD,KESPROCOD

       if @@rowcount = 0
          insert into TBS124
          select 0,                          -- empresa da tabela de saldos iniciais
                 @dataProximoSaldoInicial,   -- data do saldo inicial
                 0,                          -- empresa do local de estoque
                 LESCOD,                     -- local de estoque
                 0,                          -- empresa do produto
                 SINPROCOD,                  -- código do produto
                 (select PROUM1 from TBS010 (nolock) where PROCOD = SINPROCOD collate database_default),    -- menor unidade de medida
                 (select PROUM1QTD from TBS010 (nolock) where PROCOD = SINPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
                 SINQTD,                     -- saldo inicial
                 0 -- custo da aquisição da mercadoria
            from TBS124 (nolock) A
           where SINDAT=@dataSaldoBase and
                 not exists(select '' from TBS124 (nolock) B
                             where B.SINEMPCOD=A.SINEMPCOD and B.SINDAT=A.SINDAT and B.LESEMPCOD=A.LESEMPCOD and B.LESCOD=A.LESCOD and B.SINEMPPRO=A.SINEMPPRO and B.SINPROCOD=A.SINPROCOD)
      */

      -- inclusão do saldo inicial através do registro da TBS051

      with tab as (
      select max(LMEREG) registro,
             LMELOCEST estoque,
             PROCOD produto,
             (select top 1 LMEQTDSAL from TBS051 (nolock) B
               where B.PROCOD=A.PROCOD and convert(date,LMEDATHOR) <= dateAdd(day,-1,@dataSaldoBase) and B.LMELOCEST=A.LMELOCEST and LMEINFALT='E'
               order by LMEREG desc) saldo
        from TBS051 (nolock) A
       where convert(date,LMEDATHOR) <= dateAdd(day,-1,@dataSaldoBase) and LMEINFALT='E'
       group by LMELOCEST,PROCOD)

      insert into TBS124
      select 0,                          -- empresa da tabela de saldos iniciais
             @dataSaldoBase,             -- data do saldo inicial
             0,                          -- empresa do local de estoque
             estoque,                    -- local de estoque
             0,                          -- empresa do produto
             produto,                    -- código do produto
             (select PROUM1 from TBS010 (nolock) where PROCOD=produto collate database_default),    -- menor unidade de medida
             (select PROUM1QTD from TBS010 (nolock) where PROCOD=produto collate database_default), -- quantidade da embalagem da menor unidade de medida
             saldo,
             0, -- custo da aquisição da mercadoria
             convert(char(6), @dataSaldoBase, 112)
        from tab
       where isnull((select 1 from TBS124 (nolock)
                      where SINEMPCOD=0 and SINDAT=@dataSaldoBase and LESEMPCOD=0 and TBS124.LESCOD=estoque and SINEMPPRO=0 and SINPROCOD=produto collate database_default),0) = 0

       if @@rowcount = 0
          insert into TBS124
          select 0,                          -- empresa da tabela de saldos iniciais
                 @dataSaldoBase,             -- data do saldo inicial
                 0,                          -- empresa do local de estoque
                 LESCOD,                     -- local de estoque
                 0,                          -- empresa do produto
                 SINPROCOD,                  -- código do produto
                 (select PROUM1 from TBS010 (nolock) where PROCOD = SINPROCOD collate database_default),    -- menor unidade de medida
                 (select PROUM1QTD from TBS010 (nolock) where PROCOD = SINPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
                 SINQTD,                     -- saldo inicial
                 0, -- custo da aquisição da mercadoria
                 convert(char(6), @dataSaldoBase, 112)
            from TBS124 (nolock) A
           where SINDAT < @dataSaldoBase and
                 not exists(select '' from TBS124 (nolock) B
                             where B.SINEMPCOD=A.SINEMPCOD and B.SINDAT=A.SINDAT and B.LESEMPCOD=A.LESEMPCOD and B.LESCOD=A.LESCOD and B.SINEMPPRO=A.SINEMPPRO and B.SINPROCOD=A.SINPROCOD)

   end

insert into SALDOINICIAL
select *
  from 
(select convert(date,SINDAT,112) data
        ,convert(char(6),SINDAT,112) anomes
        ,SINPROCOD codigo
        ,LESCOD estoque
        ,SINUNI unidade
        ,SINQTDEMB embalagem
        ,0 custo
        ,SINQTD qtde
   from TBS124 with (nolock)
  where SINPROCOD='1640054') em_linha
pivot (sum(qtde) for estoque in ([1], [2], [3], [4] ,[5], [6], [7], [8], [9])) em_colunas

select top 1 * from TBS124 with (nolock)
select top 1 * from SALDOINICIAL with (nolock)

select * from SALDOINICIAL with (nolock)

-- fim: saldo inicial nos demais meses após a contagem


-- CNPJ grupo

/* bb   05118717000156
   bb   05118717000237
   bo   09135487000194
   cd   65069593000350
   mi   52080207000117
   pp   44125185000136
   tm   65069593000198
   tt   65069593000279
*/

-- procedure: custos

drop table CUSTOAQUISICAO

-- procedure: grava custo médio mensal

if exists(select name from sysobjects where name='SP_CustoMedioAquisicao' and type='P')
   drop procedure [dbo].[SP_CustoMedioAquisicao]
go

create procedure [dbo].[SP_CustoMedioAquisicao] @dataDe as date, @dataAte as date as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  --when '94' then 'BA'
                                  when '50' then 'CD'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      -- criação da tabela de custos, senão existir
      if object_id('CUSTOAQUISICAO') is null
         create table CUSTOAQUISICAO
            (
                empresa varchar(2) collate database_default default '',
                ano smallint not null default 0,
                mes smallint not null default 0,
                produto varchar(15) collate database_default not null,
                custo decimal(11,4) default 0,

                valor decimal(11,4) default 0,
                qtde decimal(11,4) default 0,

                constraint PK_CUSTO primary key (empresa,ano,mes,produto)
            )

      insert into CUSTOAQUISICAO
         select @emp,
                ano=year(TBS059.NFEDATEFE),
                mes=month(TBS059.NFEDATEFE),
                PROCOD,

                -- qtde compra na menor unidade * preço unitário (sem alguns impostos)
                sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) -- valor total do mês
                /
                sum(NFEQTD * NFEQTDEMB) as custo, -- qtde total do mês

                sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as valor,
                sum(NFEQTD * NFEQTDEMB) as qtde -- qtde total do mês

--                avg(dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as custo

           from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                                 inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

          where not exists(select null from CUSTOAQUISICAO where empresa=@emp and ano=year(TBS059.NFEDATEFE) and mes=month(TBS059.NFEDATEFE) and produto=PROCOD collate database_default) and
                --TBS059.NFEDATEFE between @dataDe and @dataAte and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and
                TBS059.NFEDATEFE between @dataDe and @dataAte and --TBS0591.NFETIP<>'D' and
                TBS059.NFECAN<>'S' and
                --FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350') and
                --NFECFOP in('1.102','1.403','1.407','1.556','2.102','2.403','2.407','2.556')
                --right(NFECFOP,3) in('102','152','403','409','121','202','411')
                right(NFECFOP,3) in('102','403','121','202','411')
--                and right(NFECFOP,3) in('202','411') -- devoluções
--                and TBS059.NFENUM<>263505
          group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),PROCOD
   end

select top 1 * from CUSTOAQUISICAO (nolock)

exec SP_CustoMedioAquisicao '20150101','20180331'

select * from CUSTOAQUISICAO where produto='1640054'

declare @data date

set @data='20170331'

select PROCOD as codigo,
       QTDE=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=1 and LMEINFALT='E' order by LMEREG desc),0)+
       isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=2 and LMEINFALT='E' order by LMEREG desc),0)+
       isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=3 and LMEINFALT='E' order by LMEREG desc),0)+
       isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=4 and LMEINFALT='E' order by LMEREG desc),0)+
       isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=5 and LMEINFALT='E' order by LMEREG desc),0)+
       isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=6 and LMEINFALT='E' order by LMEREG desc),0)+
       isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=7 and LMEINFALT='E' order by LMEREG desc),0)+
       isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=9 and LMEINFALT='E' order by LMEREG desc),0)
  from TBS010 (nolock)
 where PROCOD='1640054'

select * from TBS034 (nolock)

select produto,count(*) from CUSTOAQUISICAO group by produto

-- criar link com servidores

if exists(select name from sysobjects where name='SP_CriaLinkServidores' and type='P')
   drop procedure [dbo].[SP_CriaLinkServidores]
go

create procedure [dbo].[SP_CriaLinkServidores] as
   begin
      declare @emp varchar(2)

      select * from master..sysservers where srvname='BA'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'BA', @srvproduct=N'Best Arts', @provider=N'SQLNCLI10', @datasrc=N'192.168.7.5'

      select * from master..sysservers where srvname='BB'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'BB', @srvproduct=N'Best Bag', @provider=N'SQLNCLI10', @datasrc=N'192.168.0.3'
 
      select * from master..sysservers where srvname='CD'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'CD', @srvproduct=N'Tanby CD', @provider=N'SQLNCLI10', @datasrc=N'192.168.10.7'

      select * from master..sysservers where srvname='MI'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'MI', @srvproduct=N'Misaspel', @provider=N'SQLNCLI10', @datasrc=N'192.168.0.2'

      select * from master..sysservers where srvname='PP'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'PP', @srvproduct=N'Papelyna', @provider=N'SQLNCLI10', @datasrc=N'192.168.0.7'

      select * from master..sysservers where srvname='TM'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'TM', @srvproduct=N'Tanby matriz', @provider=N'SQLNCLI10', @datasrc=N'192.168.1.205'

      select * from master..sysservers where srvname='TT'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'TT', @srvproduct=N'Tanby Taubate', @provider=N'SQLNCLI10', @datasrc=N'192.168.3.205'
   end

exec SP_CriaLinkServidores

select * from master..sysservers

--

update SALDOINICIAL
   set CUSTO=0
 where CUSTO is null


drop table #produtos

select ANOMES
       ,CODIGO
  --into #produtos
  from SALDOINICIAL with (nolock)
 where CUSTO=0
       and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E5 > 0 or E6 > 0 or E7 > 0 or E8 > 0 or E9 > 0)
 --group by CODIGO
 group by ANOMES, CODIGO
 order by ANOMES, CODIGO

select *
  from #produtos


select *
       ,isnull((select CUSTO from cd.SIBD.dbo.SALDOINICIAL ori where ori.ANOMES=des.ANOMES collate database_default and ori.CODIGO=des.CODIGO collate database_default and ori.CUSTO > 0),0)
  from SALDOINICIAL des with (nolock)
  inner join #produtos pro on pro.ANOMES=des.ANOMES and pro.CODIGO=des.CODIGO

begin tran

-- busca preços de compras em outra unidades

select * from sysservers

update SALDOINICIAL
   set CUSTO=valor

  from
  (
    select ANOMES periodo
           ,CODIGO produto
	       ,CUSTO valor
      from tt.SIBD.dbo.SALDOINICIAL
     where rtrim(ANOMES) + rtrim(CODIGO) collate database_default in(select rtrim(ANOMES) + rtrim(CODIGO)
                                                                       from SALDOINICIAL with (nolock)
                                                                      where CUSTO=0
                                                                            and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E5 > 0 or E6 > 0 or E7 > 0 or E8 > 0 or E9 > 0)
                                                                      group by ANOMES, CODIGO)
           and CUSTO > 0
   ) tab

 where ANOMES=periodo collate database_default
       and CODIGO=produto collate database_default

commit tran



-- mescla custo médio mensal de todas as unidades do grupo

if exists(select name from sysobjects where name='SP_MesclaCustoMedioAquisicao' and type='P')
   drop procedure [dbo].[SP_MesclaCustoMedioAquisicao]
go

create procedure [dbo].[SP_MesclaCustoMedioAquisicao] @dataDe as date, @dataAte as date, @atualizar as varchar(1) as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  --when '94' then 'BA'                                  
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '50' then 'CD'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      /*
      if @emp <> 'BA'
         begin
            merge CUSTOAQUISICAO as destino
            using BA.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro

            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end
      */

      if @emp <> 'BB'
         begin
            merge CUSTOAQUISICAO as destino
            using BB.SIBD2.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'CD'
         begin
            merge CUSTOAQUISICAO as destino
            using CD.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'MI'
         begin
            merge CUSTOAQUISICAO as destino
            using MI.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'PP'
         begin
            merge CUSTOAQUISICAO as destino
            using PP.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'TM'
         begin
            merge CUSTOAQUISICAO as destino
            using TM.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'TT'
         begin
            merge CUSTOAQUISICAO as destino
            using TT.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      -- custo médio entre as unidades tanby
      --insert into CUSTOAQUISICAO (empresa,ano,mes,produto,custo) select 'MT',ano,mes,produto,avg(custo) from CUSTOAQUISICAO (nolock) where empresa in('TM','CD','TT','BA') group by ano,mes,produto order by produto,mes
      insert into CUSTOAQUISICAO (empresa,ano,mes,produto,custo) select 'MT',ano,mes,produto,avg(custo) from CUSTOAQUISICAO (nolock) where empresa in('TM','CD','TT') group by ano,mes,produto order by produto,mes

      -- custo médio entre as unidades são paulo
      insert into CUSTOAQUISICAO (empresa,ano,mes,produto,custo) select 'MS',ano,mes,produto,avg(custo) from CUSTOAQUISICAO (nolock) where empresa in('BB','MI','PP') group by ano,mes,produto order by produto,mes

      -- custo médio entre todas as unidades
      insert into CUSTOAQUISICAO (empresa,ano,mes,produto,custo) select 'MG',ano,mes,produto,avg(custo) from CUSTOAQUISICAO (nolock) group by ano,mes,produto order by produto,mes
   end

exec SP_MesclaCustoMedioAquisicao '20150101','20180331','N'

select * from CUSTOAQUISICAO where empresa='MG'

select * from CUSTOAQUISICAO where empresa='MT'

delete CUSTOAQUISICAO where empresa='MG'

select empresa from CUSTOAQUISICAO group by empresa order by empresa

-- grava custo na tabela de saldos iniciais

if exists(select name from sysobjects where name='SP_GravaCustoAquisicao' and type='P')
   drop procedure [dbo].[SP_GravaCustoAquisicao]
go

create procedure [dbo].[SP_GravaCustoAquisicao] @dataDe as date, @dataAte as date as
   begin
      declare @emp varchar(2) --, @custo decimal(11,4)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  --when '94' then 'BA'                                  
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '50' then 'CD'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      -- unidades tanby
      --if @emp in('BA','CD','TM','TT')
      --if @emp in('CD','TM','TT')
         -- custo da aquisição

--str(year(SINDAT),4)+right('00'+Ltrim(str(month(SINDAT),2)),2) <= str(year(KESDAT),4)+right('00'+Ltrim(str(month(KESDAT),2)),2)

--select top 1 * from CUSTOAQUISICAO (nolock)


      select empresa, ano, mes, produto, custo
--      select str(ano,4)+right('00'+Ltrim(str(mes,2)),2) a,
--             str(year(@dataDe),4)+right('00'+Ltrim(str(month(@dataDe),2)),2) b,
--             str(year(@dataAte),4)+right('00'+Ltrim(str(month(@dataAte),2)),2) c
        into #custos
        from CUSTOAQUISICAO (nolock)
       where (empresa=@emp or empresa='MG') and 
             str(ano,4)+right('00'+Ltrim(str(mes,2)),2) <= str(year(@dataDe),4)+right('00'+Ltrim(str(month(@dataDe),2)),2) --and
                                                           --     str(year(@dataAte),4)+right('00'+Ltrim(str(month(@dataAte),2)),2)
       order by ano desc, mes desc, produto

/*
      select empresa, ano, mes, produto, custo
        into #custos
        from CUSTOAQUISICAO (nolock)
       where (empresa=@emp or empresa='MG') and 
             str(ano,4)+right('00'+Ltrim(str(mes,2)),2) between str(year(@dataDe),4)+right('00'+Ltrim(str(month(@dataDe),2)),2) and
                                                                str(year(@dataAte),4)+right('00'+Ltrim(str(month(@dataAte),2)),2)
       order by ano desc, mes desc, produto
*/

      -- zera custos antes da atualização
      update TBS124 set SINCUSAQU=0 where SINDAT=@dataDe


--select * from #custos

      -- atualiza custos da própria empresa
      update TBS124 set SINCUSAQU=(select top 1 custo from #custos (nolock)
                                    where empresa=@emp and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

      -- atualiza custos conforme média geral
      update TBS124 set SINCUSAQU=(select top 1 custo from #custos
                                    where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)
       where SINCUSAQU=0


/*
      update TBS124 set SINCUSAQU=(
         case
            when (select top 1 1 from #custos
                   where empresa=@emp and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
               then (select top 1 custo from #custos (nolock)
                      where empresa=@emp and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

            -- média geral
            when (select top 1 1 from #custos
                   where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
               then (select top 1 custo from #custos
                      where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)
            else 0
         end)

        from TBS124 (nolock) where SINDAT=@dataDe -- between @dataDe and @dataAte
*/

/*
      if @emp='CD'
         -- custo da aquisição
         update TBS124 set SINCUSAQU=(
            case
               -- tanby depósito
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='CD' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='CD' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               -- média geral
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               else 0
            end)

           from TBS124 (nolock) where SINDAT between @dataDe and @dataAte

      if @emp='TM'
         begin
            select produto,
                   case empresa when 'TM' then custo else 0 end as cuslocal,
                   case empresa when 'MG' then custo else 0 end as cusgeral
              into #custo
              from CUSTOAQUISICAO (nolock)
             where empresa in('TM','MG') and custo > 0
             order by ano desc, mes desc, produto

            -- custo da aquisição
            update TBS124 set SINCUSAQU=(select top 1 case when cuslocal > 0 then cuslocal else cusgeral end 
                                           from #custo (nolock)
                                          where produto=SINPROCOD) -- order by ano desc, mes desc, produto)
              from TBS124 (nolock) where SINDAT between @dataDe and @dataAte
         end

      if @emp='TT'
         -- custo da aquisição
         update TBS124 set SINCUSAQU=(
            case
               -- tanby taubaté
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='TT' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='TT' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               -- média geral
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               else 0
            end)

           from TBS124 (nolock) where SINDAT between @dataDe and @dataAte

      -- unidades são paulo
      --if @emp in('BB','MI','PP')
      if @emp='BB'
         -- custo da aquisição
         update TBS124 set SINCUSAQU=(
            case
               -- best bag
               when (select top 1 1 from #custos
                      where empresa=@emp and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from #custos (nolock)
                         where empresa='BB' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               -- média geral
               when (select top 1 1 from #custos
                      where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from #custos
                         where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               else 0
            end)

           from TBS124 (nolock) where SINDAT between @dataDe and @dataAte

      if @emp='MI'
         -- custo da aquisição
         update TBS124 set SINCUSAQU=(
            case
               -- misaspel
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='MI' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='MI' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               -- média geral
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               else 0
            end)

           from TBS124 (nolock) where SINDAT between @dataDe and @dataAte

      if @emp='PP'
         -- custo da aquisição
         update TBS124 set SINCUSAQU=(
            case
               -- papelyna
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='PP' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='PP' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               -- média geral
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='MG' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               else 0
            end)

           from TBS124 (nolock) where SINDAT between @dataDe and @dataAte
*/
   end


-- custo médio da empresa
exec [dbo].[SP_CustoMedioAquisicao] '20180801', '20180831'

-- mescla custo médio das empresas
exec [dbo].[SP_MesclaCustoMedioAquisicao] '20180601', '20180831', 'S'

-- grava custo da aquisição na tabela de saldos iniciais
exec [dbo].[SP_GravaCustoAquisicao] '20180501', '20180831'



exec SP_GravaCustoAquisicao '20180501', '20180419'

select * from TBS124 (nolock) where SINDAT='20180301' and LESCOD=1

select top 1 * from CUSTOAQUISICAO (nolock)

select top 1 * from TBS124 (nolock)

-- teste

select count(*) from TBS124BKP (nolock)

drop table TBS124BKP

select count(*) from TBS125BKP (nolock)

drop table TBS125BKP

select * into TBS124BKP from TBS124 (nolock)
select * into TBS125BKP from TBS125 (nolock)



select count(*) from TBS125 (nolock)

delete TBS125


select count(*) from TBS124 (nolock) where SINDAT='20170501'

delete TBS124 where SINDAT='20170701'

delete TBS125 where KESDAT between '20180201' and '20180228'

select * from TBS125 (nolock)

exec [dbo].[SP_MovimentacaoDiaria] '20180101', '20190131'

exec [dbo].[SP_PopulaKardexDiario]


select LESCOD,month(KESDAT),count(*) from TBS125 (nolock) group by LESCOD,month(KESDAT) order by LESCOD,month(KESDAT)


delete TBS124 

exec [dbo].[SP_SaldoInicialMensal] '20190201'

exec [dbo].[SP_SP_GravaCusto] '20170101', '20171231'

select * from TempDB.dbo.##ECF

select top 1 * from TBS124 with (nolock)

select min(SINDAT) from TBS124 with (nolock)

select * from SALDODIARIO with (nolock) where ESTDATSAL='20161231'

select * from SALDOINICIAL with (nolock)

insert into TBS124
select 0
       ,'20170101'
       ,0
       ,ESTLOC
       ,0
       ,PROCOD
       ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=SALDODIARIO.PROCOD)
       ,(select PROUM1QTD from TBS010 with (nolock) where TBS010.PROCOD=SALDODIARIO.PROCOD)
       ,ESTQTDATU
       ,0
       ,'201701'
  from SALDODIARIO with (nolock)
 where ESTDATSAL='20161231'

-- inventário 04/03/17 - retaguarda e loja ND

select * into TBS124BKP from TBS124 (nolock)

select * into TBS125BKP from TBS125 (nolock)

select * from TBS125

select * from proInvRet (nolock)

delete TBS124

delete TBS125


-- insere somente as quantidades, pois os produtos podem repetir

-- estoque retaguarda

insert into TBS125 (KESDAT,LESCOD,KESPROCOD) select '20170304',1,produtoCodigo from proInvRet (nolock) group by produtoCodigo

--update TBS125 set KESMOVENT=0 where LESCOD=1

-- grava as quantidades do inventário

update TBS125 set KESMOVENT=isnull((select sum(produtoQtde) from proInvRet (nolock) where produtoCodigo=KESPROCOD group by produtoCodigo),0)
  from TBS125 (nolock) inner join proInvRet (nolock) on produtoCodigo=KESPROCOD
 where LESCOD=1

delete TBS125 where LESCOD=2

-- estoque loja

insert into TBS125 (KESDAT,LESCOD,KESPROCOD) select '20170304',2,produtoCodigo from proInvLoj (nolock) group by produtoCodigo

--update TBS125 set KESMOVENT=0 where LESCOD=2

-- grava as quantidades do inventário

update TBS125 set KESMOVENT=isnull((select sum(produtoQtde) from proInvLoj (nolock) where produtoCodigo=KESPROCOD group by produtoCodigo),0)
  from TBS125 (nolock) inner join proInvLoj (nolock) on produtoCodigo=KESPROCOD 
 where LESCOD=2


exec [dbo].[SP_SaldoInicialInventario] '20170304'

-- analises

select * from TBS124 (nolock)

--drop table #tmep

select produtoCodigo as codigo,sum(produtoQtde) as qtde into #temp from proInvRet (nolock) group by produtoCodigo

select * from TBS124 (nolock) inner join #temp (nolock) on codigo=SINPROCOD
 where LESCOD=1 and SINQTD=qtde

select max(SINDAT) from TBS124 (nolock)

select max(KESDAT) from TBS125 (nolock)


drop table #est

declare @dataSaldo as char(8), @dataDe as char(8), @dataAte as char(8)

set @dataSaldo='20170101'

set @dataDe  = '20170101'
set @dataAte = '20170131'

select (select top 1 SINDAT
                           from TBS124 (nolock)
                          where TBS124.SINDAT<=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD
                          order by TBS124.SINDAT desc) as data,
       isnull((select top 1 SINQTD
                           from TBS124 (nolock)
                          where TBS124.SINDAT<=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD
                          order by TBS124.SINDAT desc),0) as saldoInicial,
       @dataSaldo as dataSaldo,    -- data do saldo inicial
       LESCOD as estoque,        -- local de estoque
       KESPROCOD as produto,     -- código do produto
       (select PROUM1 from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default) as unidade,    -- menor unidade de medida
       (select PROUM1QTD from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default) as embalagem, -- quantidade da embalagem da menor unidade de medida
       -- cálculo do saldo = saldo inicial + entradas - saídas
       case when isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0) > 0
               then isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0)
            else isnull((select top 1 SINQTD
                           from TBS124 (nolock)
                          where TBS124.SINDAT < @dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD
                          order by TBS124.SINDAT desc),0)
       end                                                                                                -- saldo atual
       + sum((KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT)                                                       -- entradas
       -     (KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI)) as saldo                                                                                  -- saídas

  into #est
  from TBS125 (nolock)
 where KESDAT between @dataDe and @dataAte
 group by LESCOD,KESPROCOD	


select * from #est

select * from TBS125 (nolock) where KESDAT between '20170101' and '20170131' and KESPROCOD='1640054' and LESCOD=2 order by KESDAT

select * from SALDODIARIO (nolock) where ESTDATSAL='20170306'

select * from #est (nolock) inner join SALDODIARIO (nolock) on dataSaldo=ESTDATSAL and produto collate database_default=PROCOD and estoque=ESTLOC
 where ESTLOC=1 and saldo=ESTQTDATU

select (select produtoQtde from proInvLoj where produtoCodigo=PROCOD),* from #est (nolock) inner join TBS032 (nolock) on produto collate database_default=PROCOD and estoque=ESTLOC
 where ESTLOC=1 and saldo<>ESTQTDATU
 order by produto

select count(*) from #est where estoque=1 and dataSaldo='20170306'


select * from TBS124 (nolock) where SINPROCOD='6521770'

--select * from TBS125 (nolock) where KESPROCOD='7780059' and LESCOD=2 order by KESDAT

select * from TBS125 (nolock) where KESPROCOD='6521770' and LESCOD=2 order by KESDAT

begin tran
update TBS032 set ESTQTDATU=1 where ESTLOC=1 and PROCOD='0631929'
commit tran

select * from SALDODIARIO (nolock) where ESTDATSAL='20170306' and ESTLOC=2 and PROCOD='0040193'

select * from TBS125 (nolock) where KESPROCOD='0040003' and LESCOD=2 order by KESDAT

select * from ##ECF



----

select * from TBS124 (nolock) inner join TBS125 (nolock) on TBS124.SINPROCOD=TBS125.KESPROCOD and TBS124.LESCOD=TBS125.LESCOD
 where KESPROCOD='0041016' and TBS124.LESCOD=2
 order by KESDAT

select * from proInvLoj where produtoCodigo='0040193'

select * from TBS125 (nolock) where KESDAT='20170315'

select KESDAT from TBS125 (nolock) group by KESDAT order by KESDAT



-- inventário 18/02/17 - estoque 1

select * into TBS124BKP from TBS124 (nolock)

select * into TBS125BKP from TBS125 (nolock)

select * from TBS125

select * from proInvRet (nolock)

delete TBS124

delete TBS125

select * from inventCD

-- insere somente as quantidades, pois os produtos podem repetir

-- estoque retaguarda

insert into TBS125 (KESDAT,LESCOD,KESPROCOD) select '20170218',1,codigo from inventCD (nolock) group by codigo

-- grava as quantidades do inventário

update TBS125 set KESMOVENT=isnull((select sum(saldoAtual) from inventCD (nolock) where codigo=KESPROCOD group by codigo),0)
  from TBS125 (nolock) inner join inventCD (nolock) on codigo=KESPROCOD
 where LESCOD=1

exec [dbo].[SP_SaldoInicialInventario] '20170501'

exec [dbo].[SP_MovimentacaoDiaria] '20170601', '20170630'

exec [dbo].[SP_PopulaKardexDiario]


-- inventário 25/03/17 - retaguarda e loja taubaté

select max(KESDAT) from TBS125

select max(SINDAT) from TBS124

select * into TBS124BKP from TBS124 (nolock)

select * into TBS125BKP from TBS125 (nolock)

select * from proInvRet (nolock)

delete TBS124

delete TBS125

select LESCOD,count(*) from TBS125 (nolock) group by LESCOD

select top 1 * from TBS125 (nolock)

select LESCOD,count(*) from TBS125 (nolock) where KESMOVENT > 0 group by LESCOD


-- insere somente as quantidades, pois os produtos podem repetir

-- estoque retaguarda

insert into TBS125 (KESDAT,LESCOD,KESPROCOD) select '20170325',1,produtoCodigo from proInvRet2 (nolock) group by produtoCodigo

--update TBS125 set KESMOVENT=0 where LESCOD=1

-- grava as quantidades do inventário

update TBS125 set KESMOVENT=isnull((select sum(produtoQtde) from proInvRet2 (nolock) where produtoCodigo=KESPROCOD group by produtoCodigo),0)
  from TBS125 (nolock) inner join proInvRet2 (nolock) on produtoCodigo=KESPROCOD
 where LESCOD=1

delete TBS125 where LESCOD=2

-- estoque loja

insert into TBS125 (KESDAT,LESCOD,KESPROCOD) select '20170325',2,produtoCodigo from proInvLoj2 (nolock) group by produtoCodigo

--update TBS125 set KESMOVENT=0 where LESCOD=2

-- grava as quantidades do inventário

update TBS125 set KESMOVENT=isnull((select sum(produtoQtde) from proInvLoj2 (nolock) where produtoCodigo=KESPROCOD group by produtoCodigo),0)
  from TBS125 (nolock) inner join proInvLoj2 (nolock) on produtoCodigo=KESPROCOD 
 where LESCOD=2

select count(*) from TBS124 (nolock)

delete TBS125 where KESDAT='20170327'

exec [dbo].[SP_SaldoInicialInventario] '20170325'


-- inventários
--    cd	18/02/17
--    matriz	04/03/17
--    taubaté	25/03/17

--    misaspel	29/04/17
--    papelyna	29/04/17
--    best bag	06/05/17

select * from TBS124 (nolock) where SINPROCOD='1640054'

select * from SALDODIARIO (nolock) where PROCOD='1640054'

select min(KESDAT),max(KESDAT) from TBS125 (nolock)

select min(SINDAT),max(SINDAT) from TBS124 (nolock)

select SINDAT,count(*) from TBS124 (nolock) group by SINDAT order by SINDAT

begin tran
delete TBS124 where SINDAT not in('20170401','20201231')
commit tran

begin tran
delete TBS124 where SINDAT not in('20201231')
commit tran

exec [dbo].[SP_MovimentacaoDiaria] '20170101', '20171231'

exec [dbo].[SP_PopulaKardexDiario]

select * from TBS124 (nolock) where LESCOD=2 and SINPROCOD='6521770'

select KESPROCOD from TBS125 (nolock) where LESCOD=2 and KESPROCOD in('15370004','12130381','12130099','2881671','2880127') group by KESPROCOD order by KESPROCOD

select * from TBS037 (nolock) inner join TBS0371 on TBS0371.MVIDOC=TBS037.MVIDOC where MVIDATLAN >= '20170326' and PROCOD='0631929' order by TBS0371.MVIDOC

select * from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU < 0

select * from proInvLoj2 (nolock) where produtoCodigo='5410169'
union
select * from proInvRet2 (nolock) where produtoCodigo='5410169'


-- papelyna

select * from TBS124
delete TBS124 

select top 500 * from TBS125
delete TBS125

select count(*) from TBS125 (nolock) group by KESPROCOD


select * from TBS010 (nolock) where PROCOD='2860440'

select * from TBS031 (nolock) where TDPPROCOD='2860440'

select count(*) from TBS010 (nolock)

select * from TBS0102 (nolock) where PROCODBAR1='2860440'

select min(KESDAT) from TBS125

select * from TBS124

select * from TBS125 (nolock) where KESDAT between '20170601' and '20170630' and KESPROCOD='1640054' and LESCOD=1

-- regressão do saldo do estoque

select * from TBS124 (nolock) where SINDAT='20170701' and SINPROCOD='1640054'

select * from SALDODIARIO (nolock) where ESTDATSAL='20170701' and PROCOD='1640054'

-- saldo inicial nos demais meses após a contagem

declare @dataSaldo as date, @dataRegistro as date, @dataDe as date, @dataAte as date

-- data do saldo inicial
set @dataSaldo='20170501'

-- data do registro do próximo saldo inicial
set @dataRegistro='20161231'

-- período de contabilização das entradas e saídas
set @dataDe  = '20170101'
set @dataAte = '20170506'

insert into TBS124
select 0,             -- empresa da tabela de saldos iniciais
       @dataRegistro, -- data do saldo inicial
       0,             -- empresa do local de estoque
       LESCOD,        -- local de estoque
       0,             -- empresa do produto
       KESPROCOD,     -- código do produto
       (select PROUM1 from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default),    -- menor unidade de medida
       (select PROUM1QTD from TBS010 (nolock) where PROCOD=KESPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
       -- cálculo do saldo = saldo inicial + entradas - saídas
       case when isnull((select 1 from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD collate database_default),0) > 0
            then isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldo and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD collate database_default),0)
            else 0
       end                                                                                                -- saldo inicial
--       + sum((KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT + KESOUT)                                              -- entradas
--       -     (KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI)),                                                                                  -- saídas
       + sum(-(KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT + KESOUT)                                              -- entradas
       +      (KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI)),
       0 -- custo da aquisição da mercadoria
  from TBS125 (nolock)
 where KESDAT between @dataDe and @dataAte
 group by LESCOD,KESPROCOD


select * from CUSTOENT where emp<>'bestbag'

delete CUSTOENT where emp<>'bestbag'

select LESCOD,
       SINPROCOD,
       (select PRODES from TBS010 (nolock) where PROCOD=SINPROCOD collate database_default),
       SINUNI,
       SINQTD,
       isnull((select top 1 custo from CUSTOENT (nolock) where PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0) as CUSTO,
       0 as TOTAL,
       isnull((select top 1 NFENUM from CUSTOENT (nolock) where PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0) as NF,
       isnull((select top 1 NFECOD from CUSTOENT (nolock) where PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0) as FORNECEDOR,
       isnull((select top 1 NFEDATEFE from CUSTOENT (nolock) where PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0) as DATA
  from TBS124 (nolock) where SINDAT='20161231' and SINQTD > 0


-- adptado para best bag, misaspel e papelyna

select LESCOD,
       SINPROCOD,
       (select PRODES from TBS010 (nolock) where PROCOD=SINPROCOD collate database_default),
       SINUNI,
       SINQTD,
       isnull((select top 1 custo from CUSTOENT (nolock) where PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0) as CUSTO,
       0 as TOTAL,
       case
          when isnull((select top 1 NFENUM from CUSTOENT (nolock) where emp='papelyna' and PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0) > 0
             then isnull((select top 1 NFENUM from CUSTOENT (nolock) where emp='papelyna' and PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0)
          when isnull((select top 1 NFENUM from CUSTOENT (nolock) where emp='bestbag' and PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0) > 0
             then isnull((select top 1 NFENUM from CUSTOENT (nolock) where emp='bestbag' and PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0)
          else 0
       end as NF,
       isnull((select top 1 NFECOD from CUSTOENT (nolock) where PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0) as FORNECEDOR,
       isnull((select top 1 NFEDATEFE from CUSTOENT (nolock) where PROCOD=SINPROCOD collate database_default order by NFEDATEFE desc),0) as DATA
  from TBS124 (nolock) where SINDAT='20161231' and SINQTD > 0


select * from TBS124 (nolock) where SINDAT='20161231' -- 12.370

begin tran
update TBS124 set SINDAT='20201231' where SINDAT='20161231'
commit tran

select * from master..sysservers

select * into CUSTOENT from nd.SIBD.dbo.CUSTOENT

select * from CUSTOENT where PROCOD in('0040622','8711215')

select * from TBS124 

select *
  from TBS051 (nolock)
 where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170507' and LMEUSU='DESENV' and LMEMOD='NENHUM'

insert into TBS124 select 0,'20170501',0,LMELOCEST,0,PROCOD,(select PROUM1 from TBS010 (nolock) where PROCOD=TBS051.PROCOD),1,LMEQTDMOV,0
  from TBS051 (nolock)
 where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170507' and LMEUSU='DESENV' and LMEMOD='NENHUM'


-- comparações

select * from TBS125 (nolock) where KESDAT between '20170401' and '20170630' and LESCOD=1 and KESPROCOD='1640054' order by KESDAT

select * from TBS124 (nolock) where SINDAT='20170401' and LESCOD=2 and SINPROCOD='1640054'

select * from SALDODIARIO (nolock) where ESTDATSAL='20170331' and ESTLOC=2 and PROCOD='1080067'

select * from SALDODIARIO (nolock) where ESTDATSAL between '20170401' and '20170430' and ESTLOC=2 and PROCOD='1080067' order by ESTDATSAL

select * from TBS124 (nolock) where SINDAT='20170401' and LESCOD=1 and SINPROCOD='1640054'


select SINQTD,ESTQTDATU,* from TBS124 (nolock) inner join SALDODIARIO (nolock) on DATEDIFF(DAY, -1, ESTDATSAL)=SINDAT and ESTLOC=LESCOD and PROCOD=SINPROCOD
 where SINPROCOD='1640054' and LESCOD=2

select count(*) from TBS125 (nolock) where KESDAT <= '20170304'

begin tran
delete TBS125 where KESDAT <= '20170304'
commit tran

select * from TBS124 (nolock) where SINPROCOD='1640054' and LESCOD=1

begin tran
delete TBS124 where LESCOD=2 and SINDAT<>'20201231'
commit tran

select * from SALDODIARIO (nolock) where ESTDATSAL='20170401'

insert into TBS124 select 0,'20170401',0,ESTLOC,0,PROCOD,(select PROUM1 from TBS010 (nolock) where PROCOD=SALDODIARIO.PROCOD),1,ESTQTDATU,0
  from SALDODIARIO (nolock)
 where ESTDATSAL='20170401' and ESTLOC=2

select LMEROT from TBS051 (nolock) group by LMEROT order by LMEROT

select LMEROT,* from TBS051 (nolock) where LMEDATHOR between '20170405' and '20170406' and LMELOCEST=2 and LMEUSU='DESENV' order by LMEDOC


delete TBS124 where SINDAT<>'20201231'

delete TBS125

select top 1 * from TBS124 (nolock)

select top 1 * from SALDODIARIO (nolock) where ESTDATSAL='20170331'

insert into TBS124 select 0,'20170401',0,ESTLOC,0,PROCOD,(select PROUM1 from TBS010 (nolock) where PROCOD=SALDODIARIO.PROCOD),1,ESTQTDATU,0
  from SALDODIARIO (nolock)
 where ESTDATSAL='20170331'

select * from TBS124 (nolock) where SINPROCOD in('1080067','1640054') order by SINDAT,SINPROCOD

select * from TBS125 (nolock) where KESPROCOD='1640054' and KESDAT='20170401' order by KESDAT

select * from TBS125 (nolock) where KESPROCOD='12230005' and LESCOD=1 order by KESDAT

select * from TBS124 (nolock) where SINPROCOD='1640054' order by LESCOD,SINDAT

select * from CUSTOAQUISICAO (nolock) where produto='1080504' order by mes,produto

select case
          when (select custo from CUSTOAQUISICAO (nolock) where empresa='TM' and mes=6 and produto='1640054') > 0
             then (select custo from CUSTOAQUISICAO (nolock) where empresa='TM' and mes=6 and produto='1640054')
          when (select max(custo) from CUSTOAQUISICAO (nolock) where mes<=6 and produto='1640054') > 0 -- group by mes,produto) > 0
             then (select max(custo) from CUSTOAQUISICAO (nolock) where mes<=6 and produto='1640054')-- group by mes,produto)
          else 0
       end

select ano,mes,avg(custo) from CUSTOAQUISICAO (nolock) where produto='1640054' group by ano,mes,produto order by mes

insert into CUSTOAQUISICAO select 'MG',ano,mes,produto,avg(custo) from CUSTOAQUISICAO (nolock) group by ano,mes,produto order by produto,mes

select custo from CUSTOAQUISICAO (nolock) group by custo order by custo

select * from CUSTOAQUISICAO (nolock) where custo is null

select empresa,
       mes,
       produto,
--       (select PRODES from TBS010 (nolock) where PROCOD=produto),
--       mes,
       custo
  from CUSTOAQUISICAO (nolock)
 where 
--empresa='TM' and
produto in
('2540001',
'1640054',
'23570001',
'17230003',
'6660029',
'1179933',
'4680560',
'7880240',
'18520001',
'1070029',
'1080067',
'7900732',
'7810598',
'8478633',
'16310001',
'1179932',
'8429995',
'1172995',
'1179903',
'1179950',
'9840182',
'6597197',
'7810380',
'2814060',
'1173019',
'18800005',
'1170172',
'2130372',
'1330669',
'9040001',
'1172884',
'6521894',
'2600056',
'18800004',
'0041238',
'6660219',
'1173020',
'6530150',
'9830001',
'2540056',
'2600048',
'7900782',
'1172885',
'3794512',
'7910045',
'6522903',
'1173049',
'6520847',
'6597192',
'2600021',
'1179951',
'2540003',
'9836894',
'1179901',
'7601018',
'8478838',
'12950002',
'1640089',
'7910223',
'7900760',
'1179902',
'9840191',
'0074241',
'1170173',
'11420009',
'9836895',
'2130371',
'1172999',
'23830001',
'6521770',
'1172698',
'0074696',
'18870001',
'1172998',
'6521711',
'0063258',
'1172997',
'1179900',
'1495999',
'3791025',
'6520316',
'2600178',
'7900651',
'0090809',
'6522924',
'2540064',
'1495998',
'2814062',
'11420008',
'10030002',
'0051322',
'0631929',
'0470465',
'6522923',
'0051330',
'1170019',
'1173010',
'9480041',
'7910274',
'0050431')

drop table #produtos

select produto as codigo,
       (select PRODES from TBS010 (nolock) where PROCOD=produto) as descricao
       into #produtos
  from CUSTOAQUISICAO (nolock)
 where 
--empresa='TM' and
produto in
('2540001',
'1640054',
'23570001',
'17230003',
'6660029',
'1179933',
'4680560',
'7880240',
'18520001',
'1070029',
'1080067',
'7900732',
'7810598',
'8478633',
'16310001',
'1179932',
'8429995',
'1172995',
'1179903',
'1179950',
'9840182',
'6597197',
'7810380',
'2814060',
'1173019',
'18800005',
'1170172',
'2130372',
'1330669',
'9040001',
'1172884',
'6521894',
'2600056',
'18800004',
'0041238',
'6660219',
'1173020',
'6530150',
'9830001',
'2540056',
'2600048',
'7900782',
'1172885',
'3794512',
'7910045',
'6522903',
'1173049',
'6520847',
'6597192',
'2600021',
'1179951',
'2540003',
'9836894',
'1179901',
'7601018',
'8478838',
'12950002',
'1640089',
'7910223',
'7900760',
'1179902',
'9840191',
'0074241',
'1170173',
'11420009',
'9836895',
'2130371',
'1172999',
'23830001',
'6521770',
'1172698',
'0074696',
'18870001',
'1172998',
'6521711',
'0063258',
'1172997',
'1179900',
'1495999',
'3791025',
'6520316',
'2600178',
'7900651',
'0090809',
'6522924',
'2540064',
'1495998',
'2814062',
'11420008',
'10030002',
'0051322',
'0631929',
'0470465',
'6522923',
'0051330',
'1170019',
'1173010',
'9480041',
'7910274',
'0050431')
group by produto


select *,
       'janeiro',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BA' and mes=1 and produto=codigo),0) as 'Best Arts',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BB' and mes=1 and produto=codigo),0) as 'Best Bag',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='MI' and mes=1 and produto=codigo),0) as 'Misaspel',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='PP' and mes=1 and produto=codigo),0) as 'Papelyna',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='CD' and mes=1 and produto=codigo),0) as 'Tanby CD',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TM' and mes=1 and produto=codigo),0) as 'Tanby matriz',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TT' and mes=1 and produto=codigo),0) as 'Tanby Taubaté',
       'fevereiro',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BA' and mes=2 and produto=codigo),0) as 'Best Arts',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BB' and mes=2 and produto=codigo),0) as 'Best Bag',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='MI' and mes=2 and produto=codigo),0) as 'Misaspel',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='PP' and mes=2 and produto=codigo),0) as 'Papelyna',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='CD' and mes=2 and produto=codigo),0) as 'Tanby CD',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TM' and mes=2 and produto=codigo),0) as 'Tanby matriz',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TT' and mes=2 and produto=codigo),0) as 'Tanby Taubaté',
       'março',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BA' and mes=3 and produto=codigo),0) as 'Best Arts',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BB' and mes=3 and produto=codigo),0) as 'Best Bag',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='MI' and mes=3 and produto=codigo),0) as 'Misaspel',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='PP' and mes=3 and produto=codigo),0) as 'Papelyna',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='CD' and mes=3 and produto=codigo),0) as 'Tanby CD',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TM' and mes=3 and produto=codigo),0) as 'Tanby matriz',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TT' and mes=3 and produto=codigo),0) as 'Tanby Taubaté',
       'abril',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BA' and mes=4 and produto=codigo),0) as 'Best Arts',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BB' and mes=4 and produto=codigo),0) as 'Best Bag',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='MI' and mes=4 and produto=codigo),0) as 'Misaspel',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='PP' and mes=4 and produto=codigo),0) as 'Papelyna',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='CD' and mes=4 and produto=codigo),0) as 'Tanby CD',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TM' and mes=4 and produto=codigo),0) as 'Tanby matriz',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TT' and mes=4 and produto=codigo),0) as 'Tanby Taubaté',
       'maio',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BA' and mes=5 and produto=codigo),0) as 'Best Arts',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BB' and mes=5 and produto=codigo),0) as 'Best Bag',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='MI' and mes=5 and produto=codigo),0) as 'Misaspel',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='PP' and mes=5 and produto=codigo),0) as 'Papelyna',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='CD' and mes=5 and produto=codigo),0) as 'Tanby CD',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TM' and mes=5 and produto=codigo),0) as 'Tanby matriz',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TT' and mes=5 and produto=codigo),0) as 'Tanby Taubaté',
       'junho',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BA' and mes=6 and produto=codigo),0) as 'Best Arts',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='BB' and mes=6 and produto=codigo),0) as 'Best Bag',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='MI' and mes=6 and produto=codigo),0) as 'Misaspel',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='PP' and mes=6 and produto=codigo),0) as 'Papelyna',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='CD' and mes=6 and produto=codigo),0) as 'Tanby CD',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TM' and mes=6 and produto=codigo),0) as 'Tanby matriz',
       isnull((select custo from CUSTOAQUISICAO (nolock) where empresa='TT' and mes=6 and produto=codigo),0) as 'Tanby Taubaté'
  from #produtos


--select max(LMEDATHOR) from TBS051 (nolock) where LMEDATHOR<

select KESQTDCOM,KESQTDPEN,* from TBS125 (nolock) where KESPROCOD='1640054' and LESCOD=1 and (KESQTDCOM > 0 or KESQTDPEN > 0) and month(KESDAT)=1 order by KESDAT

select KESQTDCOM,KESQTDPEN,* from TBS125 (nolock) where KESPROCOD='0040320' and LESCOD=1 and month(KESDAT)=1 order by KESDAT

--select top 1 LMEQTDPEN,LMEQTDCMP,* from TBS051 (nolock) where PROCOD='1640054' and convert(varchar(8),LMEDATHOR,112)='20170401' order by LMEDOC desc

select top 1 LMELOCEST,LMEQTDPEN,LMEQTDCMP,convert(varchar(8),LMEDATHOR,112),LMEDATHOR
  from TBS051 (nolock) where PROCOD='0040320' and convert(varchar(8),LMEDATHOR,112)<='20170103' and LMELOCEST=1 order by LMEREG desc

select top 1 LMEQTDCMP,* from TBS051 (nolock) where PROCOD='0040320' and LMELOCEST=1 and convert(varchar(8),LMEDATHOR,112)<='20170103' order by LMEREG desc

select top 1 LMEQTDCMP,* from TBS051 (nolock) where PROCOD='0055706' and LMELOCEST=1 and convert(date,LMEDATHOR)<='20170301' order by LMEREG desc

select A.LMELOCEST,convert(date,A.LMEDATHOR),A.PROCOD,
       (select top 1 LMEQTDCMP from TBS051 as B (nolock) where B.PROCOD=PROCOD and B.LMELOCEST=A.LMELOCEST and convert(date,B.LMEDATHOR)<=convert(date,A.LMEDATHOR) order by B.LMEREG desc),
       (select top 1 LMEQTDPEN from TBS051 as C (nolock) where C.PROCOD=PROCOD and C.LMELOCEST=A.LMELOCEST and convert(date,C.LMEDATHOR)<=convert(date,A.LMEDATHOR) order by C.LMEREG desc)
  from TBS051 as A (nolock)
 where convert(date,A.LMEDATHOR) between '20170301' and '20170331'
 group by A.LMELOCEST,convert(date,A.LMEDATHOR),A.PROCOD

with tab as (
select LMELOCEST as estoque,
       convert(date,LMEDATHOR) as data,
       PROCOD as produto
  from TBS051 (nolock)
 where convert(date,LMEDATHOR) between '20170101' and '20170814' and PROCOD='0055706'
 group by LMELOCEST,convert(date,LMEDATHOR),PROCOD)

select *,
       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=produto and LMELOCEST=estoque and convert(date,LMEDATHOR)<=data order by LMEREG desc),
       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=produto and LMELOCEST=estoque and convert(date,LMEDATHOR)<=data order by LMEREG desc)
  from tab
 order by estoque,data

select KESQTDCOM,KESQTDPEN,KESQTDEST,* from TBS125 (nolock) where KESPROCOD='0055706' and LESCOD=1 order by KESDAT,LESCOD

select KESQTDCOM,KESQTDPEN,* from TBS125 (nolock) where KESPROCOD='0055706' and LESCOD=2 order by KESDAT,LESCOD

select KESQTDCOM,KESQTDPEN,* from TBS125 (nolock) where KESPROCOD='1080067' and LESCOD=1 order by KESDAT,LESCOD

select min(KESDAT),max(KESDAT) from TBS125 (nolock)

select month(KESDAT),count(*) from TBS125 (nolock) group by month(KESDAT)

with tab as (
select LMELOCEST as estoque,
       convert(date,LMEDATHOR) as data,
       PROCOD as produto
  from TBS051 (nolock)
 where convert(date,LMEDATHOR) between '20170301' and '20170331' and PROCOD='0055706'
 group by LMELOCEST,convert(date,LMEDATHOR),PROCOD)

select *,
       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=produto and LMELOCEST=estoque and convert(date,LMEDATHOR)<=data order by LMEREG desc),
       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=produto and LMELOCEST=estoque and convert(date,LMEDATHOR)<=data order by LMEREG desc),
       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='E' and PROCOD=produto and LMELOCEST=estoque and convert(date,LMEDATHOR)<=data order by LMEREG desc)
  from tab
 order by estoque,data

select top 1 * from TBS125 (nolock) where KESOUT > 0

select * from TBS124 (nolock) where SINQTD = 0

select *,
       (select ESTQTDATU from SALDODIARIO where )
 from TBS125 (nolock)


declare @data date;

set @data = '20170814';

with tab as (

select LMELOCEST as estoque,
       convert(date,LMEDATHOR) as data,
       PROCOD as produto
  from TBS051 (nolock)
 where convert(date,LMEDATHOR) between '20160101' and '20170430' and PROCOD='0055706'
 group by LMELOCEST,convert(date,LMEDATHOR),PROCOD)

select *,
       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='E' and PROCOD=produto and LMELOCEST=estoque and convert(date,LMEDATHOR)<=@data order by LMEREG desc)
  from tab
 order by estoque,data


declare @ultimoDiaMes as date

-- último dia do mês
set @ultimoDiaMes = convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, @dataSaldoBase) + 1, 0)))

declare @data date

set @data = '20170331'

select convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, (select top 1 convert(date,LMEDATHOR) from TBS051 (nolock) where LMEINFALT='E' and TBS051.PROCOD=TBS032.PROCOD and LMELOCEST=ESTLOC and convert(date,LMEDATHOR)<=@data order by LMEREG desc)) + 1, 0))),
       ESTLOC,PROCOD,
       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='E' and TBS051.PROCOD=TBS032.PROCOD and LMELOCEST=ESTLOC and convert(date,LMEDATHOR)<=@data order by LMEREG desc)
  from TBS032 (nolock)
 group by ESTLOC,PROCOD
having isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='E' and TBS051.PROCOD=TBS032.PROCOD and LMELOCEST=ESTLOC and convert(date,LMEDATHOR)<=@data order by LMEREG desc),0) > 0
 order by ESTLOC,PROCOD


select top 1 * from TBS032 (nolock)

select convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, (select top 1 convert(date,LMEDATHOR) from TBS051 (nolock) where LMEINFALT='E' and TBS051.PROCOD=TBS032.PROCOD and LMELOCEST=ESTLOC and convert(date,LMEDATHOR)<=convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, convert(date,LMEDATHOR)) + 1, 0))) order by LMEREG desc)) + 1, 0))),
       --(select top 1 convert(date,LMEDATHOR) from TBS051 (nolock) where LMEINFALT='E' and TBS051.PROCOD=TBS032.PROCOD and LMELOCEST=ESTLOC and convert(date,LMEDATHOR)<=convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, convert(date,LMEDATHOR)) + 1, 0))) order by LMEREG desc),
       ESTLOC,PROCOD,
       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='E' and TBS051.PROCOD=TBS032.PROCOD and LMELOCEST=ESTLOC and convert(date,LMEDATHOR)<=convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, convert(date,LMEDATHOR)) + 1, 0))) order by LMEREG desc)
  from TBS032 (nolock)
 group by (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='E' and TBS051.PROCOD=TBS032.PROCOD and LMELOCEST=ESTLOC and convert(date,LMEDATHOR)<=convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, convert(date,LMEDATHOR)) + 1, 0))) order by LMEREG desc),ESTLOC,PROCOD
having isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='E' and TBS051.PROCOD=TBS032.PROCOD and LMELOCEST=ESTLOC and convert(date,LMEDATHOR)<=convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, convert(date,LMEDATHOR)) + 1, 0))) order by LMEREG desc),0) > 0
 order by ESTLOC,PROCOD

select top 1 * from TBS032 (nolock)

select * from TBS0451 (nolock) where PDCQTD-PDCQTDENT > 0 and PROCOD='1640054'

select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and LMELOCEST=1 and PROCOD='0055706' and convert(date,LMEDATHOR)<='20170810'
select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and LMELOCEST=2 and PROCOD='0055706' and convert(date,LMEDATHOR)<='20170810'
select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and LMELOCEST=3 and PROCOD='0055706' and convert(date,LMEDATHOR)<='20170810'
select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and LMELOCEST=4 and PROCOD='0055706' and convert(date,LMEDATHOR)<='20170810'
select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and LMELOCEST=5 and PROCOD='0055706' and convert(date,LMEDATHOR)<='20170810'
select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and LMELOCEST=6 and PROCOD='0055706' and convert(date,LMEDATHOR)<='20170810'
select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and LMELOCEST=7 and PROCOD='0055706' and convert(date,LMEDATHOR)<='20170810'
select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and LMELOCEST=8 and PROCOD='0055706' and convert(date,LMEDATHOR)<='20170810'
select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and LMELOCEST=9 and PROCOD='0055706' and convert(date,LMEDATHOR)<='20170810'


select min(SINDAT),max(SINDAT) from TBS124 (nolock)

delete TBS124 where SINDAT<>'20201231'

select top 1 * from TBS125 (nolock)

declare @data date, @estoque smallint

set @data = '20170401'
set @estoque = 1;

with tab as (
   select PROCOD as codigo,
          saldo = isnull((select top 1 LMEQTDSAL
                            from TBS051 (nolock)
                           where LMEINFALT='E' and TBS051.PROCOD=TBS010.PROCOD and LMELOCEST=@estoque and convert(date,LMEDATHOR)<@data order by LMEREG desc),0),
          PROUM1 as uni,
          PROUM1QTD as emb
          --data = (select top 1 convert(date,LMEDATHOR) from TBS051 (nolock) where LMEINFALT='E' and TBS051.PROCOD=TBS010.PROCOD and LMELOCEST=1 and convert(date,LMEDATHOR)<='20170816' order by LMEREG desc)
     from TBS010 (nolock)
)

--select * from tab where saldo > 0
--select * from tab where data <> '17530101' order by data
insert into TBS124
   select 0,@data,0,@estoque,0,codigo,uni,emb,saldo,0
     from tab
    where saldo > 0 and
          isnull((select 1 from TBS124 (nolock)
                   where SINDAT=@data and TBS124.LESCOD=@estoque and SINPROCOD=codigo),0) = 0


select top 1 * from TBS124 (nolock)

select * from TBS124 (nolock) where SINDAT='20170401' and LESCOD=2
select * from TBS124 (nolock) where SINDAT='20170201'

select SINDAT from TBS124 (nolock) group by SINDAT order by SINDAT

select * from TBS034 (nolock)


-- registra saldo inicial do estoque

declare @data as date, @estoque as smallint, @reg as smallint

set @data='20170801'

select top 1 @estoque = LESCOD from TBS034 (nolock) order by LESCOD

select @reg = count(*) from TBS034 (nolock)

while @estoque <= @reg
   begin
      if isnull((select 1 from TBS034 (nolock) where LESCOD=@estoque),0) > 0
         begin
            with tab as (
               select PROCOD as codigo,
                      saldo = isnull((select top 1 LMEQTDSAL
                                        from TBS051 (nolock)
                                       where LMEINFALT='E' and TBS051.PROCOD=TBS010.PROCOD and LMELOCEST=@estoque and convert(date,LMEDATHOR)<@data order by LMEREG desc),0),
                      PROUM1 as uni,
                      PROUM1QTD as emb
                 from TBS010 (nolock)
            )

            insert into TBS124
               select 0,@data,0,@estoque,0,codigo,uni,emb,saldo,0
                 from tab
                where saldo > 0 and
                      isnull((select 1 from TBS124 (nolock)
                               where SINDAT=@data and TBS124.LESCOD=@estoque and SINPROCOD=codigo),0) = 0
         end

      set @estoque = @estoque + 1
   end


select top 1 * from TBS124 (nolock)
select top 1 * from TBS125 (nolock)

-- listagem para análises dos saldos iniciais e movimentações

select LESCOD estoque,
       KESPROCOD proudto,
       year(KESDAT) ano,
       month(KESDAT) mes,
       isnull((select top 1 SINQTD from TBS124 (nolock)
                where SINPROCOD=KESPROCOD and TBS124.LESCOD=TBS125.LESCOD and str(year(SINDAT),4)+right('00'+Ltrim(str(month(SINDAT),2)),2) <= str(year(KESDAT),4)+right('00'+Ltrim(str(month(KESDAT),2)),2) -- year(SINDAT) <= year(KESDAT) and month(SINDAT) <= month(KESDAT) -- convert(char(6),SINDAT,112) <= convert(char(6),KESDAT,112)
                order by SINDAT desc),0) saldoInicial,

       sum(KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT + KESOUT) entradas,   -- entradas
       sum(KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI) saidas,                                         -- saídas

       --isnull((select max(SINQTD) from TBS124 (nolock) where SINPROCOD=KESPROCOD and TBS124.LESCOD=TBS125.LESCOD and year(SINDAT) <= year(KESDAT) and month(SINDAT) <= month(KESDAT)),0)
       isnull((select top 1 SINQTD from TBS124 (nolock)
                where SINPROCOD=KESPROCOD and TBS124.LESCOD=TBS125.LESCOD and str(year(SINDAT),4)+right('00'+Ltrim(str(month(SINDAT),2)),2) <= str(year(KESDAT),4)+right('00'+Ltrim(str(month(KESDAT),2)),2) -- convert(char(6),SINDAT,112) <= convert(char(6),KESDAT,112) -- year(SINDAT) <= year(KESDAT) and month(SINDAT) <= month(KESDAT)
                order by SINDAT desc),0)
       + 
       sum(  (KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT + KESOUT)                                              -- entradas
            -(KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI)) saldoFinalCalculado,                                                                                  -- saídas
       --sum(KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT + KESOUT)                                              -- entradas
       ---
       --sum(KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI) saldoFinalCalculado,                                                                                  -- saídas

       isnull((select top 1 SINQTD from TBS124 (nolock)
                where SINPROCOD=KESPROCOD and TBS124.LESCOD=TBS125.LESCOD and year(SINDAT) >= year(KESDAT) and year(SINDAT) + month(SINDAT) > year(KESDAT) + month(KESDAT) -- convert(char(2),SINDAT,110) > convert(char(2),KESDAT,110) --  month(SINDAT) > month(KESDAT)
                order by SINDAT),0) saldoFinalRegistrado
  from TBS125 (nolock)
 where KESPROCOD in('1640054','1080067') and LESCOD in(1,2)
 group by KESPROCOD,year(KESDAT),month(KESDAT),LESCOD
 order by LESCOD,KESPROCOD,year(KESDAT),month(KESDAT)

select * from SALDODIARIO (nolock)
 where ESTDATSAL in('20161231','20170131','20170228','20170331','20170430','20170531','20170630','20170731') and PROCOD in('1080067','1640054') and ESTLOC in(1,2)
 order by ESTLOC,PROCOD,ESTDATSAL

select KESDAT,KESNFENT,KESENTDEV,KESCANNFSAI,KESCANCUPFIS,KESCANNFDEV,KESMOVENT,KESSALENT,KESNFSAI,KESCUPFIS,KESNFDEVSAI,KESMOVSAI,KESSALSAI,KESCUSMED,KESQTDEMB,KESUNI,KESOUT,KESQTDCOM,KESQTDPEN,KESQTDEST,KESOUT
  from TBS125 (nolock) where year(KESDAT)=2017 and month(KESDAT)=3 and KESPROCOD='1640054' and LESCOD=1


-- tabela para correção dos saldos

drop table #ajuste

drop table #dados

with tab as (
select LESCOD estoque,
       KESPROCOD produto,
       year(KESDAT) ano,
       month(KESDAT) mes,

       --isnull((select max(SINQTD) from TBS124 (nolock) where SINPROCOD=KESPROCOD and TBS124.LESCOD=TBS125.LESCOD and year(SINDAT) <= year(KESDAT) and month(SINDAT) <= month(KESDAT)),0)
       isnull((select top 1 SINQTD from TBS124 (nolock)
                where SINPROCOD=KESPROCOD and TBS124.LESCOD=TBS125.LESCOD and year(SINDAT) <= year(KESDAT) and month(SINDAT) <= month(KESDAT)
                order by SINDAT desc),0)
       + 
       sum(  (KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT + KESOUT)                                              -- entradas
            -(KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI)) saldoFinalCalculado,                                                                                  -- saídas

       isnull((select top 1 SINQTD from TBS124 (nolock)
                where SINPROCOD=KESPROCOD and TBS124.LESCOD=TBS125.LESCOD and year(SINDAT) >= year(KESDAT) and month(SINDAT) > month(KESDAT)
                order by SINDAT),0) saldoFinalRegistrado
  into #dados
  from TBS125 (nolock)
-- where KESPROCOD in('1640054','1080067') and LESCOD in(1,2)
 where year(KESDAT)=2017 and month(KESDAT)=1
 group by KESEMPCOD,year(KESDAT),month(KESDAT),LESEMPCOD,LESCOD,KESPROEMP,KESPROCOD --)
 order by KESEMPCOD,year(KESDAT),month(KESDAT),LESEMPCOD,LESCOD,KESPROEMP,KESPROCOD

--select *,saldoFinalRegistrado-saldoFinalCalculado correcao from tab where saldoFinalCalculado <> saldoFinalRegistrado
select ano,
       estoque,
       mes,
       produto,
       saldoFinalRegistrado-saldoFinalCalculado qtde,
       (select max(KESDAT) from TBS125 (nolock) where LESCOD=estoque and KESPROCOD=produto and year(KESDAT)<=ano AND month(KESDAT)<=mes) data
  into #ajuste
  from #dados
 where saldoFinalCalculado <> saldoFinalRegistrado order by ano,estoque,mes,produto





-- ajustes das movimentações

drop table #mov

declare @ano int, @mes int

set @ano=2018
set @mes=10

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





select estoque,count(*) from #ajuste group by estoque

select * from #ajuste where produto='1640054'

select max(KESDAT) from TBS125 (nolock),#ajuste where LESCOD=estoque and KESPROCOD=produto and year(KESDAT)<=ano AND month(KESDAT)<=mes and KESPROCOD='1640054'

select *,(select max(KESDAT) from TBS125 (nolock) where LESCOD=estoque and KESPROCOD=produto and year(KESDAT)<=ano AND month(KESDAT)<=mes)
  from #ajuste
 where produto='1640054'

select * from TBS125 (nolock) where KESPROCOD='1640054' and LESCOD=1 and month(KESDAT)=3 order by KESDAT desc

select top 1 * from #ajuste where qtde < 0

select count(*) from TBS125 (nolock) where KESOUT <> 0

select top 1 * from TBS125 (nolock)

select top 1 * from #ajuste

select count(*) from #ajuste

select * from #ajuste

-- lança a diferença do saldo no campo KESOUT (outras)

select count(*) from TBS125 (nolock) where KESOUT <> 0

update TBS125 set KESOUT=qtde from #ajuste where KESDAT=data and LESCOD=estoque and KESPROCOD=produto

select count(*) from TBS125 (nolock) where KESOUT > 0
select count(*) from TBS125 (nolock) where KESOUT = 0

select SINDAT from TBS124 (nolock) group by SINDAT order by SINDAT


-- contabilizar

-- inventários:

select top 1 * from TBS051 (nolock) where LMEROT='SQL' and LMEUSU='DESENV' and LMELOCEST=1 and LMEDESROT Like('%INVENTARIO%') order by LMEDATHOR desc

-- matriz   04/03/2017
-- cd       18/02/2017
-- taubate  25/03/2017

-- best bag 08/05/2017
-- misaspel 01/05/2017
-- papelyna 01/05/2017


select * into TBS124BKP from TBS124 (nolock)

select * into TBS125BKP from TBS125 (nolock)

delete TBS124 --where SINDAT<>'20170301'
delete TBS125

-- 1
exec [dbo].[SP_MovimentacaoDiaria] '20180601', '20180630'

-- 2
exec [dbo].[SP_PopulaKardexDiario]

select * from SALDODIARIO (nolock) where ESTDATSAL='20171231' and ESTQTDATU <> 0 and PROCOD='1640054'

drop table #saldo

declare @buscar date, @gravar date

set @buscar='20170331'
set @gravar='20170401'

;with tab as (
select PROCOD,LMELOCEST from TBS051 (nolock) where LMEINFALT='E' and convert(date,LMEDATHOR) <= @buscar group by PROCOD,LMELOCEST)

select * into #saldo from tab order by PROCOD,LMELOCEST

select * from #saldo where PROCOD='1640054' order by LMELOCEST

select * from TBS051 (nolock) where Left(PROCOD,5)=''

select * from TBS051 (nolock) where isnumeric(PROCOD)=0

begin tran
delete TBS051 where isnumeric(PROCOD)=0
commit tran

-- insere saldo inicial

insert into TBS124
select 0,             -- empresa da tabela de saldos iniciais
       @gravar,       -- data do saldo inicial
       0,             -- empresa do local de estoque
       #saldo.LMELOCEST,        -- local de estoque
       0,             -- empresa do produto
       #saldo.PROCOD,     -- código do produto
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=#saldo.PROCOD collate database_default),    -- menor unidade de medida
       (select PROUM1QTD from TBS010 (nolock) where TBS010.PROCOD=#saldo.PROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida
       (select top 1 LMEQTDSAL from TBS051 (nolock)
         where LMEINFALT='E' and TBS051.PROCOD=#saldo.PROCOD and TBS051.LMELOCEST=#saldo.LMELOCEST and convert(date,LMEDATHOR) <= @buscar order by LMEREG desc),
       0
  from #saldo (nolock)

-- 3
exec [dbo].[SP_SaldoInicialMensal] '20180601'

select min(SINDAT),max(SINDAT) from TBS124 (nolock)

delete TBS124 where SINDAT='20170601'

delete TBS124 where SINQTD=0

select * from TBS125 (nolock) where KESDAT='20170225' and LESCOD=1 and KESPROCOD='1640054'

update TBS125 set KESOUT=-380 where KESDAT='20170225' and LESCOD=1 and KESPROCOD='1640054'

-- analises

select * from TBS124 (nolock) where SINPROCOD='1640054' order by SINDAT desc

--select * from TBS124 (nolock) where SINQTD < 0

select * from SALDODIARIO (nolock) where PROCOD='1640054' and ESTDATSAL in('20161231','20170131','20170228','20170331','20170429','20170531') order by ESTDATSAL desc

select * from TBS125 (nolock) where KESDAT between '20170201' and '20170228' and LESCOD=1 and KESPROCOD='1640054'

select * from TBS125 (nolock) where KESOUT <> 0


select * from CUSTOAQUISICAO (nolock)

select distinct ano, mes from CUSTOAQUISICAO (nolock) order by ano desc,mes desc

drop table CUSTOAQUISICAO

-- grava custo médio mensal de aquisição
exec SP_CustoMedioAquisicao '20180401','20180430'

-- cria links para retornar custo médio das empresas
exec SP_CriaLinkServidores

-- mescla os custos médios das empresas
exec SP_MesclaCustoMedioAquisicao '20180401','20180430','N'

-- grava o custo da aquisição em saldos iniciais
exec SP_GravaCustoAquisicao '20180401', '20180501'



select ano,
       produto,
       (select PRODES from TBS010 (nolock) where PROCOD=produto),
       (select PROUM1 from TBS010 (nolock) where PROCOD=produto),
       coalesce([1], 0) as Jan,
       coalesce([2], 0) as Fev,
       coalesce([3], 0) as Mar,
       coalesce([4], 0) as Abr,
       coalesce([5], 0) as Mai,
       coalesce([6], 0) as Jun,
       coalesce([7], 0) as Jul,
       coalesce([8], 0) as Ago,
       coalesce([9], 0) as 'Set',
       coalesce([10], 0) as 'Out',
       coalesce([11], 0) as Nov,
       coalesce([12], 0) as Dez

from
(
  select ano,produto,mes,custo
    from CUSTOAQUISICAO (nolock)
   where empresa='MG'
) d

pivot (max(custo)

 for mes in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) piv

select * from TBS034 (nolock)

select top 1 * from TBS124 (nolock)

select top 10 MARNOM from TBS010 (nolock)

drop table #inventario

/*
errado

select '2018/01' as referencia,
       SINPROCOD as produto,
       (select PRODES from TBS010 (nolock) where PROCOD=SINPROCOD) as descricao,
       (select MARNOM from TBS010 (nolock) where PROCOD=SINPROCOD) as marca,
       SINUNI as unidade,
       --custoCompra = isnull(round(avg(SINCUSAQU),4),0),
       custoCompra = isnull((select top 1 SINCUSAQU from TBS124 (nolock) B where B.SINPROCOD=A.SINPROCOD and SINDAT <= '20180201' order by SINDAT desc),0),
       custoPolitica = isnull(round((select dbo.PDPCUSBAS(0,PDPCOD) from TBS015 (nolock) where PDPCOD=SINPROCOD),4),0),

       --estoque = isnull(sum(case when LESCOD=1 then SINQTD end),0),
       estoque=isnull((select top 1 SINQTD from TBS124 (nolock) B where B.SINPROCOD=A.SINPROCOD and SINDAT <= '20180201' order by SINDAT desc),0),

       loja = isnull(sum(case when LESCOD=2 then SINQTD end),0),
       estoque3 = isnull(sum(case when LESCOD=3 then SINQTD end),0),
       estoque4 = isnull(sum(case when LESCOD=4 then SINQTD end),0),
       estoque5 = isnull(sum(case when LESCOD=5 then SINQTD end),0),
       almoxarifado = isnull(sum(case when LESCOD=6 then SINQTD end),0),
       estoque7 = isnull(sum(case when LESCOD=7 then SINQTD end),0),
--       estoque8 = isnull(sum(case when LESCOD=8 then SINQTD end),0),
       web = isnull(sum(case when LESCOD=9 then SINQTD end),0)
  into #inventario
  from TBS124 (nolock) A
 where SINDAT<='20180201' and SINQTD > 0 and LESCOD in(1,2,3,4,5,6,7,9)
 group by SINPROCOD,SINUNI
*/

select * from #inventario

select top 1 * from TBS124 (nolock)

select * from TBS034 (nolock)

select SINPROCOD,
       (select PRODES from TBS010 (nolock) where PROCOD=SINPROCOD) as descricao,
       (select MARNOM from TBS010 (nolock) where PROCOD=SINPROCOD) as marca,
       SINUNI as unidade,
       coalesce([1], 0) as est1,
       coalesce([2], 0) as est2,
       coalesce([3], 0) as est3,
       coalesce([4], 0) as est4,
       coalesce([5], 0) as est5,
       coalesce([6], 0) as est6,
       coalesce([7], 0) as est7,
       coalesce([9], 0) as est9
--into #inv1
from
(
  select SINQTD,LESCOD,SINPROCOD,SINUNI
    from TBS124 (nolock)
   where SINDAT='20180401' and SINQTD > 0
) d

pivot (sum(SINQTD)

 for LESCOD in ([1],[2],[3],[4],[5],[6],[7],[9])) piv

select *,
       custoCompra = isnull((select top 1 SINCUSAQU from TBS124 (nolock) where TBS124.SINPROCOD=#inv1.SINPROCOD and TBS124.SINDAT <= '20180401' order by TBS124.SINDAT desc),0),
       custoPolitica = isnull(round((select dbo.PDPCUSBAS(0,PDPCOD) from TBS015 (nolock) where PDPCOD=#inv1.SINPROCOD),4),0)
 into #inv2
 from #inv1

drop table #inv1
drop table #inv2

select * from #inv2

select SINPROCOD,

select sum((est1 + est2 + est3 + est4 + est5 + est6 + est7 + est9) * case when custoCompra > 0 then custoCompra else custoPolitica end) from #inv2

select * from CUSTOAQUISICAO (nolock) where ano=2017 and mes=12 and produto='0050504'

select * from CUSTOAQUISICAO (nolock) where empresa='MG' and produto='1640054' order by ano, mes

select * from TBS034 (nolock)

declare @data date

set @data='20171231'

select PROCOD,
       EST1=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=1 and LMEINFALT='E' order by LMEREG desc),0),
       EST2=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=2 and LMEINFALT='E' order by LMEREG desc),0),
       EST3=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=3 and LMEINFALT='E' order by LMEREG desc),0),
       EST4=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=4 and LMEINFALT='E' order by LMEREG desc),0),
       EST5=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=5 and LMEINFALT='E' order by LMEREG desc),0),
       EST6=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=6 and LMEINFALT='E' order by LMEREG desc),0),
       EST7=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=7 and LMEINFALT='E' order by LMEREG desc),0),
       EST9=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=9 and LMEINFALT='E' order by LMEREG desc),0)
  into #inventario
  from TBS010 (nolock)

select *,
--       isnull((select top 1 custo from CUSTOAQUISICAO (nolock) where empresa='MG' and produto=PROCOD and ano=2017 and mes=12),0) as custo

       isnull((select top 1 custo from CUSTOAQUISICAO (nolock) where empresa='MG' and produto=PROCOD collate database_default and ano=2017 and mes=12),0) as custoin,
       isnull((select top 1 custo from CUSTOMK (nolock) where empresa='T' and produto=PROCOD collate database_default),0) as customk

       --isnull((select top 1 SINCUSAQU from TBS124 (nolock) B where B.SINPROCOD=A.PROCOD and SINDAT <= '20180101' order by SINDAT desc),0) as custo
  from #inventario A where EST1+EST2+EST3+EST4+EST5+EST6+EST7+EST9 > 0

       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='E' and PROCOD=CodigoProduto and LMELOCEST=LocalEstoque and convert(date,LMEDATHOR)<=data order by LMEREG desc)

select top 1 * from SALDODIARIO (nolock)

select top 1 * from TBS032 (nolock)

select count(*) from TBS032 (nolock) where ESTQTDATU > 0 group by ESTLOC,PROCOD

select max(ESTDATSAL) from SALDODIARIO (nolock) where year(ESTDATSAL)=2017

select PROCOD as codigo,sum(ESTQTDATU) as qtde into #estoque from SALDODIARIO where ESTDATSAL='20171230' and ESTLOC in(1,2,3,4,5,6,7,9) group by PROCOD

select *,
       (EST1+EST2+EST3+EST4+EST5+EST6+EST7+EST9) - qtde
  from #inventario inner join #estoque on PROCOD=codigo
 where EST1+EST2+EST3+EST4+EST5+EST6+EST7+EST9 > 0 and
       EST1+EST2+EST3+EST4+EST5+EST6+EST7+EST9 <> qtde

select ESTLOC from SALDODIARIO (nolock) group by ESTLOC

select * from SALDODIARIO (nolock) where PROCOD='16200063'

-- custos mk

drop table CUSTOMK

select * into CUSTOMK
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\CUSTO-levantamento-MK.xlsx', 'select * from [custo$]')

select distinct empresa from CUSTOMK

update CUSTOMK set empresa='M' where empresa='MISASPEL COMERCIO DE PAPEIS LTDA'

select top 1 *  from CUSTOMK (nolock)

update CUSTOMK set produto=Ltrim(produto)

drop table #inventario

declare @data date

set @data='20171231'

select PROCOD as codigo,
       EST1=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=1 and LMEINFALT='E' order by LMEREG desc),0),
       EST2=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=2 and LMEINFALT='E' order by LMEREG desc),0),
       EST3=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=3 and LMEINFALT='E' order by LMEREG desc),0),
       EST4=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=4 and LMEINFALT='E' order by LMEREG desc),0),
       EST5=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=5 and LMEINFALT='E' order by LMEREG desc),0),
       EST6=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=6 and LMEINFALT='E' order by LMEREG desc),0),
       EST7=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=7 and LMEINFALT='E' order by LMEREG desc),0),
       EST9=isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=9 and LMEINFALT='E' order by LMEREG desc),0)
  into #inventario
  from TBS010 (nolock)

select codigo,
       ISNULL((select PRODES from TBS010 (nolock) where TBS010.PROCOD=codigo collate database_default),'') as descricao,
       ISNULL((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=codigo collate database_default),'') as unidade,
       EST1,EST2,EST3,EST4,EST5,EST6,EST7,EST9 as qtde,
       isnull((select top 1 custo from CUSTOAQUISICAO (nolock) where empresa='MG' and produto=codigo collate database_default and ano=2017 and mes=12),0) as custoin,
       isnull((select top 1 custo from CUSTOMK (nolock) where empresa='T' and produto=codigo collate database_default),0) as customk,
       isnull((select top 1 dbo.PDPCUSBAS(0,codigo) from TBS015 (nolock) where PDPCOD=codigo collate database_default),0) as politica
       
  from #inventario 
 where EST1 <> 0 or EST2 <> 0 or EST3 <> 0 or EST4 <> 0 or EST5 <> 0 or EST6 <> 0 or EST7 <> 0 or  EST9 <> 0

select codigo,
       ISNULL((select PRODES from TBS010 (nolock) where TBS010.PROCOD=codigo collate database_default),'') as descricao,
       ISNULL((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=codigo collate database_default),'') as unidade,
       EST1,EST2,EST3,EST4,EST5,EST6,EST7,EST9 as qtde,
       isnull((select top 1 custo from CUSTOAQUISICAO (nolock) where empresa='MG' and produto=codigo collate database_default and ano=2017 and mes=12),0) as custoin --,
--       isnull((select top 1 custo from CUSTOMK (nolock) where empresa='T' and produto=codigo collate database_default),0) as customk,
--       isnull((select top 1 dbo.PDPCUSBAS(0,codigo) from TBS015 (nolock) where PDPCOD=codigo collate database_default),0) as politica
       
  from #inventario 
 where EST1 < 0 or EST2 < 0 or EST3 < 0 or EST4 < 0 or EST5 < 0 or EST6 < 0 or EST7 < 0 or  EST9 < 0


-- compara saldos iniciais com Log (TBS051) do estoque

select *
  from TBS124 (nolock)
 where SINQTD <> (select top 1 LMEQTDSAL from TBS051 (nolock)
                   where TBS051.PROCOD=TBS124.SINPROCOD and convert(date,LMEDATHOR) <= dateAdd(day,-1,SINDAT) and LMELOCEST=LESCOD and LMEINFALT='E'
                   order by LMEREG desc)

select *,
       (select top 1 LMEQTDSAL from TBS051 (nolock)
                   where TBS051.PROCOD=TBS124.SINPROCOD and convert(date,LMEDATHOR) <= dateAdd(day,-1,SINDAT) and LMELOCEST=LESCOD and LMEINFALT='E'
                   order by LMEREG desc),
--       SINQTD+
       ((select top 1 LMEQTDSAL from TBS051 (nolock)
                   where TBS051.PROCOD=TBS124.SINPROCOD and convert(date,LMEDATHOR) <= dateAdd(day,-1,SINDAT) and LMELOCEST=LESCOD and LMEINFALT='E'
                   order by LMEREG desc)
       -SINQTD)
  from TBS124 (nolock)
 where SINQTD <> (select top 1 LMEQTDSAL from TBS051 (nolock)
                   where TBS051.PROCOD=TBS124.SINPROCOD and convert(date,LMEDATHOR) <= dateAdd(day,-1,SINDAT) and LMELOCEST=LESCOD and LMEINFALT='E'
                   order by LMEREG desc)


-- analise quantidades em outros

select top 1 * from TBS125 (nolock)

select year(KESDAT),month(KESDAT),LESCOD,count(*)
  from TBS125 (nolock)
 where KESOUT<>0
 group by year(KESDAT), month(KESDAT), LESCOD order by year(KESDAT) desc, month(KESDAT) desc, LESCOD

select top 1 * from TBS125 (nolock) where KESOUT<>0

select * from TBS125 (nolock) where year(KESDAT)=2018 and month(KESDAT)=1 and LESCOD=1 and KESOUT<>0

select * from TBS125 (nolock) where year(KESDAT)=2018 and month(KESDAT) in(1,2,3) and KESOUT<>0

select * from TBS125 (nolock) where year(KESDAT)=2018 and month(KESDAT)=1 and LESCOD=3 and KESPROCOD='18160062'

select * from TBS125 (nolock) where KESDAT >= '20170101' and LESCOD=3 and KESPROCOD='18160062' order by KESDAT

select * from TBS051 (nolock) where LMEDATHOR >= '20170101' and LMELOCEST=3 and PROCOD='18160062' order by LMEDATHOR

select *
  from TBS125 (nolock)
 where year(KESDAT)=2018 and month(KESDAT)=3 and KESOUT<>0 and
       (KESNFENT+KESENTDEV+KESCANNFSAI+KESCANCUPFIS+KESCANNFDEV+KESMOVENT+KESSALENT)-(KESNFSAI+KESCUPFIS+KESNFDEVSAI+KESMOVSAI+KESSALSAI)<>KESQTDEST

select min(KESDAT),max(KESDAT) from TBS125 (nolock)

select min(SINDAT),max(SINDAT) from TBS124 (nolock)

update TBS125 set KESOUT=0

declare @ano smallint, @mes smallint

set @ano=2018
set @mes=3

select KESDAT,
       LESCOD,
       KESPROCOD,
       KESNFENT+KESENTDEV+KESCANNFSAI+KESCANCUPFIS+KESCANNFDEV+KESMOVENT+KESSALENT ENT,
       KESNFSAI+KESCUPFIS+KESNFDEVSAI+KESMOVSAI+KESSALSAI SAI,
       KESQTDEST ATU
  into #kardex
  from TBS125 A (nolock)
 where year(KESDAT)=@ano and month(KESDAT)=@mes

select *,(select top 1 KESQTDEST
            from TBS125 (nolock)
           where TBS125.KESDAT < #KARDEX.KESDAT and TBS125.LESCOD=#KARDEX.LESCOD and TBS125.KESPROCOD=#KARDEX.KESPROCOD
           order by TBS125.KESDAT desc) ANT
  into #kardex2
  from #kardex
 order by KESDAT

select * from #kardex2 where ANT+ENT-SAI <> ATU

update #kardex2 set OUTRAS=isnull(ATU-(ANT+ENT-SAI),0)

select *,ATU-(ANT+ENT-SAI) OUTRAS into #kardex3 from #kardex2 where ANT+ENT-SAI <> ATU order by KESDAT

select * from #kardex3

select top 1 * from TBS125 (nolock)

select top 1 * from #kardex3

select * from #kardex3 where OUTRAS<>0

begin tran
update TBS125 set KESOUT=OUTRAS
  from TBS125 (nolock)
       inner join #kardex3 on #kardex3.KESDAT=TBS125.KESDAT and #kardex3.LESCOD=TBS125.LESCOD and #kardex3.KESPROCOD=TBS125.KESPROCOD
commit tran

drop table #kardex
drop table #kardex2
drop table #kardex3

drop table SALDOINICIAL_BKP

select * into SALDOINICIAL_BKP from SALDOINICIAL with (nolock)

delete SALDOINICIAL where DATA='20190301'

select *
  from SALDOINICIAL with (nolock)
 where CODIGO='1640054'
 order by ANOMES

if exists(select name from sysobjects where name='SP_GravaSaldoInicial' and type='P')
   drop procedure [dbo].[SP_GravaSaldoInicial]
go

create procedure [dbo].[SP_GravaSaldoInicial] @datai date, @dataf date as
   begin
      declare @datas date

      set @datas='17530101'

      while @datas < @dataf
         begin
            -- último dia do mês processado
            set @datas=DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, @datai) + 1, 0))

            -- última data do saldo diário gravado no mês processado
            set @datas=(select top 1 ESTDATSAL
                          from SALDODIARIO with (nolock)
                         where ESTDATSAL <= @datas
                   order by ESTDATSAL desc)

            insert into SALDOINICIAL
            select convert(date, dateadd(mm, datediff(mm,0,data) + 1, 0)) data
                   ,convert(char(6), dateadd(mm, datediff(mm,0,data) + 1, 0), 112) anomes
                   ,codigo
                   ,(select PROUM1 from TBS010 with (nolock) where PROCOD=codigo) unidade
                   ,(select PROUM1QTD from TBS010 with (nolock) where PROCOD=codigo) embalagem
                   ,0 qentrada
                   ,0 ventrada
                   ,0 custo
                   ,coalesce([1], 0) as E1
                   ,coalesce([2], 0) as E2
                   ,coalesce([3], 0) as E3
                   ,coalesce([4], 0) as E4
                   ,coalesce([5], 0) as E5
                   ,coalesce([6], 0) as E6
                   ,coalesce([7], 0) as E7
                   ,coalesce([8], 0) as E8
                   ,coalesce([9], 0) as E9
              from
              (
                 select ESTDATSAL data
                        ,ESTLOC estoque
                        ,PROCOD codigo
                        ,sum(ESTQTDATU) quantidade
                   from SALDODIARIO with (nolock)
                  where ESTDATSAL=@datas
                  group by ESTDATSAL, ESTLOC, PROCOD
                 having ESTDATSAL=@datas
              ) linhas
            pivot (sum(quantidade) for estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9])) colunas

            set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
         end
   end

declare @datai date, @dataf date, @datas date, @produto varchar(10)

set @datai='20190201'
set @dataf='20190228'
set @datas='17530101'
--set @produto=''

--      print @datai
--      set @datas=dateadd(ms, -3, dateadd(mm, datediff(mm, 0, @datai) + 1, 0))
--      print @datas
--      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
--      print @datai

while @datas < @dataf
   begin
--      set @datas=dateadd(ms, -3, dateadd(mm, datediff(mm, 0, @datai) + 1, 0))
      -- último dia do mês processado
      set @datas=DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, @datai) + 1, 0))
      --print @datas

      /*
      set @datas=(select max(ESTDATSAL)
                    from SALDODIARIO b with (nolock)
                   where --b.ESTLOC=a.ESTLOC
                         --and 
                         b.PROCOD=a.PROCOD
                         and ESTDATSAL between @datai and @datas)
      */

      -- última data do saldo diário gravado no mês processado
      set @datas=(select top 1 ESTDATSAL
                    from SALDODIARIO with (nolock)
                   where --b.ESTLOC=a.ESTLOC
                         --and 
                         ESTDATSAL <= @datas
                   order by ESTDATSAL desc)

      --print @datas

      --set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)

           --select @produto=PROCOD from TBS010 wiht (nolock) where PROCOD > @produto order by PROCOD

      --select top 1 * from SALDODIARIO with (nolock) where ESTDATSAL <= @datas and ESTLOC=1 and PROCOD='1640054' order by ESTDATSAL desc
      insert into SALDOINICIAL
      select convert(date, dateadd(mm, datediff(mm,0,data) + 1, 0)) data
             ,convert(char(6), dateadd(mm, datediff(mm,0,data) + 1, 0), 112) anomes
             ,codigo
             ,(select PROUM1 from TBS010 with (nolock) where PROCOD=codigo) unidade
             ,(select PROUM1QTD from TBS010 with (nolock) where PROCOD=codigo) embalagem
             ,0 qentrada
             ,0 ventrada
             ,0 custo
             ,coalesce([1], 0) as E1
             ,coalesce([2], 0) as E2
             ,coalesce([3], 0) as E3
             ,coalesce([4], 0) as E4
             ,coalesce([5], 0) as E5
             ,coalesce([6], 0) as E6
             ,coalesce([7], 0) as E7
             ,coalesce([8], 0) as E8
             ,coalesce([9], 0) as E9
        from 
        (
           /*
           select top 1
                  ESTDATSAL data
                  ,ESTLOC estoque
                  ,PROCOD codigo
                  ,sum(ESTQTDATU) quantidade
             from SALDODIARIO with (nolock)
            where ESTDATSAL <= @datas
                  and ESTDATSAL
                  --and ESTLOC=1
                  --and PROCOD='1640054'
                  and PROCOD=@produto
            group by ESTDATSAL, ESTLOC, PROCOD
            order by ESTDATSAL desc
           */

           /*
           select ESTDATSAL data
                 ,ESTLOC estoque
                 ,PROCOD codigo
                 ,sum(ESTQTDATU) quantidade
            from SALDODIARIO a with (nolock)
           group by ESTDATSAL, ESTLOC, PROCOD
          having ESTDATSAL = (select max(ESTDATSAL)
                                from SALDODIARIO b with (nolock)
                               where --b.ESTLOC=a.ESTLOC
                                     --and 
                                     b.PROCOD=a.PROCOD
                                     and ESTDATSAL between @datai and @datas)
           */

           select ESTDATSAL data
                 ,ESTLOC estoque
                 ,PROCOD codigo
                 ,sum(ESTQTDATU) quantidade
            from SALDODIARIO with (nolock)
           where ESTDATSAL=@datas
           group by ESTDATSAL, ESTLOC, PROCOD
          having ESTDATSAL=@datas

--ORDER BY a.ESTDATSAL, a.ESTLOC, a.PROCOD

           --declare @datas date
           --set @datas='20190131'
--           select (select max(ESTDATSAL)
--                     from SALDODIARIO b with (nolock)
--                    where b.ESTDATSAL between @datai and @datas
--                          and b.ESTLOC=a.ESTLOC
--                          and b.PROCOD=a.PROCOD) data
--                  ESTLOC estoque
--                  ,PROCOD codigo
--                  ,sum(ESTQTDATU) quantidade
--                  ,0 quantidade
--             from SALDODIARIO a with (nolock)
            --where --ESTDATSAL <= @datas
                  --and ESTLOC=1
                  --PROCOD='1640054'
--            group by ESTLOC, PROCOD
            --order by ESTLOC, PROCOD

        ) linhas
      pivot (sum(quantidade) for estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9])) colunas

      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
   end



declare @data date

set @data=getdate() -- '20190202'

select DateAdd(mm, DateDiff(mm,0,@data), 0) as [Primeiro dia do mês da data]
select dateadd(ms, -3, dateadd(mm, datediff(mm, 0, @data) + 1, 0)) as [Último dia do mês da data]

select DateAdd(mm, DateDiff(mm,0,@data) - 1, 0) as [Primeiro dia do mês anterior]
select DateAdd(mm, DateDiff(mm,0,@data) + 1, 0) as [Primeiro dia do mês posterior]

select top 1 * from SALDODIARIO with (nolock)
select min(ESTDATSAL), max(ESTDATSAL) from SALDODIARIO with (nolock)

select count(*) from SALDODIARIO with (nolock) where ESTQTDATU=0

select top 1 * from SALDODIARIO with (nolock) where ESTLOC=1 and PROCOD='1640054' order by ESTDATSAL desc

select * from TBS032 with (nolock) where ESTLOC=1 and PROCOD='1640054'

select top 1 * from SALDOINICIAL with (nolock)

insert into SALDOINICIAL
select *
  from (
select SINDAT data
       ,convert(char(6), SINDAT, 112) anomes
       ,SINPROCOD codigo
       ,(select PROUM1 from TBS010 with (nolock) where PROCOD=SINPROCOD) unidade
       --,''
       ,(select PROUM1QTD from TBS010 with (nolock) where PROCOD=SINPROCOD) embalagem
       --,SINUNI embalagem
       ,0 qentrada
       ,0 ventrada
       ,0 custo
       ,LESCOD estoque
       ,SINQTD qtde
  from TBS124 with (nolock)
) em_linha
pivot (sum(qtde) for estoque in ([1], [2], [3], [4] ,[5], [6], [7], [8], [9])) em_colunas

declare @datai date, @dataf date

select @datai='20180112', @dataf='20181231'

SELECT ESTDATSAL, ESTLOC, PROCOD, SUM(ESTQTDATU)
FROM SALDODIARIO a with (nolock)
GROUP BY ESTDATSAL, ESTLOC, PROCOD
HAVING ESTDATSAL = (SELECT MAX(ESTDATSAL) FROM SALDODIARIO b with (nolock) WHERE b.ESTLOC=a.ESTLOC and b.PROCOD=a.PROCOD and ESTDATSAL between @datai and @dataf)
ORDER BY a.ESTDATSAL, a.ESTLOC, a.PROCOD


select DATA
       ,ANOMES
       ,CODIGO
       ,UNI
       ,QEMBALAGEM
       ,QTDENTRADA
       ,VALENTRADA
       ,CUSTO
       ,sum(E1) E1
       ,sum(E2) E2
       ,sum(E3) E3
       ,sum(E4) E4
       ,sum(E5) E5
       ,sum(E6) E6
       ,sum(E7) E7
       ,sum(E8) E8
       ,sum(E9) E9
  into #TMP
  from SALDOINICIAL with (nolock)
-- where CODIGO='1640054'
 group by DATA, ANOMES, CODIGO, UNI, QEMBALAGEM, QTDENTRADA, VALENTRADA, CUSTO
 order by ANOMES

delete SALDOINICIAL

insert into SALDOINICIAL select * from #TMP

select top 10 * from TBS124 with (nolock) order by SINQTD desc

select distinct LESCOD from TBS124 with (nolock)

select * from TBS124 with (nolock) where isnumeric(SINPROCOD)=0

delete TBS124 where isnumeric(SINPROCOD)=0

select *
  from SALDOINICIAL with (nolock)
 where not exists(select ''
                    from TBS010 with (nolock)
                   where PROCOD=CODIGO)

begin tran

delete SALDOINICIAL
 where not exists(select ''
                    from TBS010 with (nolock)
                   where PROCOD=CODIGO)
commit tran

-- TBS032 restaurando backup

drop table INV1901
create table [dbo].[INV1902](
   [REF] [char](6)
   ,[CODIGO] [varchar](15) NULL default ''
   ,[DESCRICAO] [varchar](60) NOT NULL default ''
   ,[UNIDADE] [varchar](10) NOT NULL default ''
   ,[EMBALAGEM] [decimal] (10,4) NULL default 0
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

select *
  into INV1901
  from (
select '201901' ref
       ,PROCOD codigo
       ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=E.PROCOD) unidade
       ,(select PROUM1QTD from TBS010 with (nolock) where TBS010.PROCOD=E.PROCOD) embalagem
       ,0 custo
       ,ESTLOC estoque
       ,ESTQTDATU qtde
  from INTG.SIBD.dbo.TBS032 E with (nolock)
) em_linha
pivot (sum(qtde) for estoque in ([1], [2], [3], [4] ,[5], [6], [7], [8], [9])) em_colunas

select * from TBS124 with (nolock) where SINDAT='20190201'

select SINDAT from TBS124 with (nolock) group by SINDAT order by SINDAT

select * from SALDOINICIAL with (nolock) where DATA='20190301'

select *
  into INV1901
  from (
select '201901' ref
       ,PROCOD codigo
       ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=E.PROCOD) unidade
       ,(select PROUM1QTD from TBS010 with (nolock) where TBS010.PROCOD=E.PROCOD) embalagem
       ,0 custo
       ,ESTLOC estoque
       ,ESTQTDATU qtde
  from INTG.SIBD.dbo.TBS032 E with (nolock)
) em_linha
pivot (sum(qtde) for estoque in ([1], [2], [3], [4] ,[5], [6], [7], [8], [9])) em_colunas

select * from INV1901 WITH (NOLOCK)

update INV1812 set E1=0 where E1 is null
update INV1812 set E2=0 where E2 is null
update INV1812 set E3=0 where E3 is null
update INV1812 set E4=0 where E4 is null
update INV1812 set E5=0 where E5 is null
update INV1812 set E6=0 where E6 is null
update INV1812 set E7=0 where E7 is null
update INV1812 set E8=0 where E8 is null
update INV1812 set E9=0 where E9 is null


select '2019-01' referencia
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
                         where DATA <= '20190201'
                               and b.CODIGO=a.CODIGO 
                               and CUSTO > 0
                         order by DATA desc),0) > 0
              then isnull((select top 1 CUSTO
                             from SALDOINICIAL b with (nolock)
                            where DATA <= '20190201'
                                  and b.CODIGO=a.CODIGO 
                                  and CUSTO > 0
                            order by DATA desc),0)
           else isnull(dbo.CUSTOPOLITICA(0,CODIGO),0)
        end custo
  into #inventario
  from INV1901 a with (nolock)
 where (
          case when E1 > 0 then E1 else 0 end +
          case when E2 > 0 then E2 else 0 end +
          case when E3 > 0 then E3 else 0 end +
          case when E4 > 0 then E4 else 0 end +
          case when E7 > 0 then E7 else 0 end +
          case when E9 > 0 then E9 else 0 end
       ) > 0

select * from INV1901

select * from #inventario

select sum(saldo*custo) from #inventario

select sum(saldo*custo) from #inventario
 where produto in('0051322','0051330','18260010','7900473','18260041','8421948','8420160','10993551','16580021','0050042','0054619','8420158')

select sum(saldo*custo) from #inventario
 where produto in
('4520018',
'4520015',
'0068705',
'4520012',
'4525526',
'4520040',
'1083774',
'11420010',
'8490574',
'5412044',
'8130016',
'18260010',
'18260041',
'18990270',
'18990130',
'8420337',
'3251541',
'0630190',
'3250300',
'3250296',
'3250879',
'0630240',
'0630242',
'20200031',
'3250882',
'0630177',
'3257355',
'3256243',
'3256260',
'3257150',
'3257363',
'3250851',
'8422276',
'8422278',
'8422279',
'8421930',
'3250757',
'3251191',
'0630238',
'8420698',
'8420421',
'8420420',
'8420422',
'8423002',
'8421209',
'3251244',
'3251190',
'0630254',
'8421810',
'8421263',
'3257827',
'8423000',
'8421711',
'8423005',
'8422012',
'8421616',
'8421719',
'8429201',
'3256227',
'3251649',
'2130394',
'4680103',
'11138662',
'4520012')

delete INV1812

insert into INV1812
select *
  from (
select '201812' ref
       ,PROCOD codigo
       ,isnull((select PRODES from TBS010 with (nolock) where TBS010.PROCOD=E.PROCOD),'') descricao
       ,isnull((select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=E.PROCOD),'') unidade
       ,isnull((select PROUM1QTD from TBS010 with (nolock) where TBS010.PROCOD=E.PROCOD),0) embalagem
       ,0 custo
       ,ESTLOC estoque
       ,ESTQTDATU qtde
  from INTG.SIBD.dbo.TBS032 E with (nolock)
) em_linha
pivot (sum(qtde) for estoque in ([1], [2], [3], [4] ,[5], [6], [7], [8], [9])) em_colunas

select * from INTG.SIBD.dbo.TBS032 where PROCOD='7653255'

select * from INV1901 with (nolock) where CODIGO='7653255'

select * from SALDODIARIO with (nolock) where ESTDATSAL='20181231' and PROCOD='7653255'

--

select * from master..sysservers


select top 1 * from INTG.SIBD.dbo.TBS080 order by ENFDATEMI desc

select * from INV1901 WITH (NOLOCK)


select sum(saldo*custo) from #inventario


drop table #inventario2

select '2019-01' referencia
       ,CODIGO produto
       ,case when E1 > 0 then E1 else 0 end E1
       ,case when E2 > 0 then E2 else 0 end E2
       ,case when E3 > 0 then E3 else 0 end E3
       ,case when E4 > 0 then E4 else 0 end E4
       ,case when E7 > 0 then E7 else 0 end E7
       ,case when E9 > 0 then E9 else 0 end E9
       ,case
           when CUSTO > 0
              then CUSTO
           when isnull((select top 1 CUSTO
                          from SALDOINICIAL b with (nolock)
                         where DATA <= '20190201'
                               and b.CODIGO=a.CODIGO 
                               and CUSTO > 0
                         order by DATA desc),0) > 0
              then isnull((select top 1 CUSTO
                             from SALDOINICIAL b with (nolock)
                            where DATA <= '20190201'
                                  and b.CODIGO=a.CODIGO 
                                  and CUSTO > 0
                            order by DATA desc),0)
           else isnull(dbo.CUSTOPOLITICA(0,CODIGO),0)
        end custo
  into #inventario2
  from INV1901 a with (nolock)
 where (
          case when E1 > 0 then E1 else 0 end +
          case when E2 > 0 then E2 else 0 end +
          case when E3 > 0 then E3 else 0 end +
          case when E4 > 0 then E4 else 0 end +
          case when E7 > 0 then E7 else 0 end +
          case when E9 > 0 then E9 else 0 end
       ) > 0


select sum(E1*custo)  e1
       ,sum(E2*custo) e2
       ,sum(E3*custo) e3
       ,sum(E4*custo) e4
       ,sum(E7*custo) e7
       ,sum(E9*custo) e9
  from #inventario2

drop table #inv1812

select '2018-12' referencia
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
                         where DATA <= '20190101'
                               and b.CODIGO=a.CODIGO 
                               and CUSTO > 0
                         order by DATA desc),0) > 0
              then isnull((select top 1 CUSTO
                             from SALDOINICIAL b with (nolock)
                            where DATA <= '20190101'
                                  and b.CODIGO=a.CODIGO 
                                  and CUSTO > 0
                            order by DATA desc),0)
           else isnull(dbo.CUSTOPOLITICA(0,CODIGO),0)
        end custo
  into #inv1812
  from INV1812 a with (nolock)
 where (
          case when E1 > 0 then E1 else 0 end +
          case when E2 > 0 then E2 else 0 end +
          case when E3 > 0 then E3 else 0 end +
          case when E4 > 0 then E4 else 0 end +
          case when E7 > 0 then E7 else 0 end +
          case when E9 > 0 then E9 else 0 end
       ) > 0

select sum(saldo*custo) from #inv1812

select '2019-01' referencia
       ,CODIGO produto
       ,(
           case when E1 > 0 then E1 else 0 end +
           case when E2 > 0 then E2 else 0 end +
           case when E3 > 0 then E3 else 0 end +
           case when E4 > 0 then E4 else 0 end +
           case when E7 > 0 then E7 else 0 end +
           case when E9 > 0 then E9 else 0 end
        ) saldo
       ,isnull(dbo.CUSTOPOLITICA(0,CODIGO),0) custo
  into #inventario
  from INV1901 a with (nolock)
 where (
          case when E1 > 0 then E1 else 0 end +
          case when E2 > 0 then E2 else 0 end +
          case when E3 > 0 then E3 else 0 end +
          case when E4 > 0 then E4 else 0 end +
          case when E7 > 0 then E7 else 0 end +
          case when E9 > 0 then E9 else 0 end
       ) > 0

select * from INV1901

select * from #inventario

select sum(saldo*custo) from #inventario

select count(E1),'E1' from INV1812 with (nolock) where E1 > 0
union
select count(E2),'E2' from INV1812 with (nolock) where E2 > 0
union
select count(E3),'E3' from INV1812 with (nolock) where E3 > 0
union
select count(E4),'E4' from INV1812 with (nolock) where E4 > 0
union
select count(E5),'E5' from INV1812 with (nolock) where E5 > 0
union
select count(E6),'E6' from INV1812 with (nolock) where E6 > 0
union
select count(E7),'E7' from INV1812 with (nolock) where E7 > 0
union
select count(E8),'E8' from INV1812 with (nolock) where E8 > 0
union
select count(E9),'E9' from INV1812 with (nolock) where E9 > 0

select sum(E1),'E1' from INV1901 with (nolock) where E1 > 0
union
select sum(E2),'E2' from INV1901 with (nolock) where E2 > 0
union
select sum(E3),'E3' from INV1901 with (nolock) where E3 > 0
union
select sum(E4),'E4' from INV1901 with (nolock) where E4 > 0
union
select sum(E5),'E5' from INV1901 with (nolock) where E5 > 0
union
select sum(E6),'E6' from INV1901 with (nolock) where E6 > 0
union
select sum(E7),'E7' from INV1901 with (nolock) where E7 > 0
union
select sum(E8),'E8' from INV1901 with (nolock) where E8 > 0
union
select sum(E9),'E9' from INV1901 with (nolock) where E9 > 0

select * from INV1901 with (nolock) order by E1 desc
