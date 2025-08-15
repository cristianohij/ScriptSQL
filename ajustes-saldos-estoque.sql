declare @dataBase char(8)

set @dataBase = '20190101'

;with MovimentoEstoque as (
   
   -- NF de saída
   select LESCOD as LocalEstoque,
          PROCOD as CodigoProduto,
          0 as NFEntrada,
          0 as MVEntrada,
          0 as AjusteEntrada,
          sum((NFSQTD-NFSQTDDEV)*NFSQTDEMB) as NFSaida,
          0 as ECF,
          0 as MVSaida,
          0 as AjusteSaida,
          0 as devolucao,
          0 as saldoEntrada,
          0 as saldoSaida
     from TBS0671 (nolock) left join TBS067 (nolock) on TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
    where NFSCAN='N' and
          NFSDATEMI >= @dataBase and
          NFSMOVEST='S'
    group by LESCOD,PROCOD
  
   union all  

   -- NF de entrada
   select LESCOD as LocalEstoque,
          PROCOD as CodigoProduto,
          sum((NFEQTD)*NFEQTDEMB) as NFEntrada,
          0 as MVEntrada,
          0 as AjusteEntrada,
          0 as NFSaida, --(select NFSaida from SaldosEmEstoque where CodigoProduto=PROCOD) as NFSaida,
          0 as ECF,
          0 as MVSaida,
          0 as AjusteSaida,
          0 as devolucao,
          0 as saldoEntrada,
          0 as saldoSaida
     from TBS0591 (nolock)
          left join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP  and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
    where NFEUSUEFE<>'' and
          NFEDATENT >= @dataBase and
          NFEMOVEST='S'
    group by LESCOD,PROCOD
    
   union all
    
    -- ajustes dos saldos
   select LESCOD as LocalEstoque,
          PROCOD as CodigoProduto,
          0 as NFEntrada,
          0 as MVEntrada,
          case when MDSTIP='E' then sum(MDSQTD*MDSQTDEMB) else 0 end as AjusteEntrada,
          0 as NFSaida,
          0 as ECF,
          0 as MVSaida,
          case when MDSTIP='S' then sum(MDSQTD*MDSQTDEMB) else 0 end as AjusteSaida,
          0 as devolucao,
          0 as saldoEntrada,
          0 as saldoSaida
     from TBS049 (nolock)
    where convert(char(8),MDSLAN,112) >= @dataBase
    group by LESCOD,MDSTIP,PROCOD

   union all

   -- movimentos internos (saídas)
   -- origem é sempre a saída; destino é sempre a entrada
   select MVILOCORI as LocalEstoque,
          PROCOD as CodigoProduto,
          0 as NFEntrada,
          0 as MVEntrada,
          0 as AjusteEntrada,
          0 as NFSaida,
          0 as ECF,
          sum(MVIQTDATD*MVIQTDEMB) as MVSaida,
          0 as AjusteSaida,
          0 as devolucao,
          0 as saldoEntrada,
          0 as saldoSaida
     from TBS0371 (nolock)
          left join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
    where convert(char(8),MVIDATEFE,112) >= @dataBase and
          MVILOCORI > 0
    group by MVILOCORI,PROCOD

   union all
    
   -- movimentos internos (entradas)
   -- origem é sempre a saída; destino é sempre a entrada
   select MVILOCDES as LocalEstoque,
          PROCOD as CodigoProduto,
          0 as NFEntrada,
          sum(MVIQTDATD*MVIQTDEMB) as MVEntrada,
          0 as AjusteEntrada,
          0 as NFSaida,
          0 as ECF,
          0 as MVSaida,
          0 as AjusteSaida,
          0 as devolucao,
          0 as saldoEntrada,
          0 as saldoSaida
     from TBS0371 (nolock)
          left join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
    where convert(char(8),MVIDATEFE,112) >= @dataBase and
          MVILOCDES > 0
    group by MVILOCDES,PROCOD

   union all
   
   -- vendas via cupom fiscal
   -- estoque 2
   select 2 as LocalEstoque,
          M2_PROCOD as CodigoProduto,
          0 as NFEntrada,
          0 as MVEntrada,
          0 as AjusteEntrada,
          0 as NFSaida,
          sum(M2_QTD) as ECF,
          0 as MVSaida,
          0 as AjusteSaida,
          0 as devolucao,
          0 as saldoEntrada,
          0 as saldoSaida
     from MSL002 (nolock)
    where M2_DAT >= @dataBase and
          M2_TIPREG='01' and
          M2_REGCAN='F'
    group by M2_PROCOD    
    
   union all
   
   -- devoluções de saídas
   select LESCOD as LocalEstoque,
          PROCOD as CodigoProduto,
          0 as NFEntrada,
          0 as MVEntrada,
          0 as AjusteEntrada,
          0 as NFSaida,
          0 as ECF,
          0 as MVSaida,
          0 as AjusteSaida,
          sum(NFDQTD*NFDQTDEMB) as devolucao,
          0 as saldoEntrada,
          0 as saldoSaida
     from TBS117 (nolock)
          left join TBS1172 (nolock) on TBS117.SNESER=TBS1172.SNESER and TBS117.NFDNUM=TBS1172.NFDNUM
    where NFDDATEMI >= @dataBase and
          NFDSTATUS='A' and
          NFDMOVEST='S'
    group by LESCOD,PROCOD

   union all
    
   -- gera saldos manualmente
   select LMELOCEST as LocalEstoque,
          PROCOD as CodigoProduto,
          0 as NFEntrada,
          0 as MVEntrada,
          0 as AjusteEntrada,
          0 as NFSaida,
          0 as ECF,
          0 as MVSaida,
          0 as AjusteSaida,
          0 as devolucao,
          case when LMEACA='E' then sum(LMEQTDMOV) else 0 end as saldoEntrada,
          case when LMEACA='S' then sum(LMEQTDMOV) else 0 end as saldoSaida
     from TBS051 (nolock)
    where convert(char(8),LMEDATHOR,112)  >= @dataBase and
          LMEROT='PEST010' and
          LMEQTDMOV > 0
    group by LMELOCEST,LMEACA,PROCOD
    
)

--drop table #MOV
  
select LocalEstoque as estoque,
       CodigoProduto as produto,
       sum(NFEntrada) as NFentrada,
       sum(MVEntrada) as MovInterEntrada,
       sum(AjusteEntrada) as ajusteEntrada,
       sum(saldoEntrada) as saldoEntrada,
       sum(NFSaida) as NFsaida,
       sum(MVSaida) as MovInterSaida,
       sum(AjusteSaida) as ajusteSaida,
       sum(ECF) as cupomFiscal,
       sum(devolucao) as devolucao,
       sum(saldoSaida) as saldoSaida,
       sum(NFEntrada + MVEntrada + AjusteEntrada + saldoEntrada) as qtdeEntrada,
       sum(NFSaida + MVSaida + AjusteSaida + ECF + devolucao + saldoSaida) as qtdeSaida
  into #MOV
  from MovimentoEstoque
 group by LocalEstoque,CodigoProduto
 order by LocalEstoque,CodigoProduto


select *,
       (select ESTQTDATU from TBS032 (nolock) where ESTLOC=estoque and PROCOD=produto),
       (select ESTQTDATU from TBS032 (nolock) where ESTLOC=estoque and PROCOD=produto)+qtdeSaida-qtdeEntrada
  from #MOV
 where produto='0040177'
 