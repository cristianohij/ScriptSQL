-- procedure: popula a tabela de kardex diário das movimentações dos produtos

if exists(select name from sysobjects where name='SP_PopulaKardexDiario' and type='P')
   drop procedure [dbo].[SP_PopulaKardexDiario]
go

create procedure [dbo].[SP_PopulaKardexDiario] as
   begin

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
       0,                 -- outras entradas/saídas

       -- compras 
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
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='C' and PROCOD=CodigoProduto and LMELOCEST=9 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)),

       -- pendência
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
        isnull((select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='P' and PROCOD=CodigoProduto and LMELOCEST=9 and convert(date,LMEDATHOR)<=data order by LMEREG desc),0)),

       (select top 1 LMEQTDSAL from TBS051 (nolock) where LMEINFALT='E' and PROCOD=CodigoProduto and LMELOCEST=LocalEstoque and convert(date,LMEDATHOR)<=data order by LMEREG desc)

  from tab11
 where isnull((select 1 from TBS125 (nolock) where KESEMPCOD=0 and KESDAT=data and LESEMPCOD=0 and LESCOD=LocalEstoque and KESPROEMP=0 and KESPROCOD=CodigoProduto),0) = 0 and
       data is not null
 order by data,LocalEstoque,CodigoProduto

end

-- fim: popula a tabela de kardex diário das movimentações dos produtos
