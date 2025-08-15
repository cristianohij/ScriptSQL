drop table ProdutosSemGiro

alter table ProdutosSemGiro drop constraint DF__ProdutosS__DifEn__2180BCDC

alter table ProdutosSemGiro drop column DifEntreDias

select PROCOD
       ,PRODES
       ,PROUM1
       ,PROUM1QTD
       ,convert(date,'17530101') as UltimaEntrada
       ,convert(date,'17530101') as UltimaSaida
       ,' ' as Classe
       ,0 as QtdeEstoque
       ,0 as QtdeLoja
  into ProdutosSemGiro
  from TBS010 with (nolock)

alter table ProdutosSemGiro add Localizacao varchar(15)

alter table ProdutosSemGiro add QtdeNFsaidas int default 0 with values

alter table ProdutosSemGiro drop column QtdeNFsaidas

alter table ProdutosSemGiro add DifDias int default 0 with values
alter table ProdutosSemGiro add DifSemanas int default 0 with values
alter table ProdutosSemGiro add DifMeses int default 0 with values
alter table ProdutosSemGiro add DifAnos int default 0 with values
alter table ProdutosSemGiro add SaldoAntesEntrada int default 0 with values

alter table ProdutosSemGiro add DifDiasEntSai int default 0 with values

alter table ProdutosSemGiro add Rua int default 0 with values

update ProdutosSemGiro
   set DifDiasEntSai=datediff(day, UltimaEntrada, UltimaSaida)

select *
  from ProdutosSemGiro with (nolock)

select max(ESTDATSAL)
  from SALDODIARIO with (nolock)

-- saldo até a data do dia 10/03
update ProdutosSemGiro
   set QtdeEstoque=isnull((select ESTQTDATU
                             from #SaldoDoDia
                            where #SaldoDoDia.PROCOD=ProdutosSemGiro.PROCOD),0)

select *
  from ProdutosSemGiro with (nolock)
 where QtdeEstoque > 0
       -- PROCOD='2320055'

drop table #SaldoDoDia

select a.*
  into #SaldoDoDia
	from SALDODIARIO a,
	(select PROCOD
          ,ESTLOC
          ,max(ESTDATSAL) as ESTDATSAL
      from SALDODIARIO
     where ESTLOC=1
     group by PROCOD, ESTLOC) b
 where a.PROCOD=b.PROCOD
       and a.ESTLOC=b.ESTLOC
       and a.ESTDATSAL=b.ESTDATSAL

select *
  from #SaldoDoDia

select PROCOD
       ,count(*)
  from #SaldoDoDia
 group by PROCOD
having count(*) > 1

select *
  from #SaldoDoDia
 where PROCOD='5300797'

update ProdutosSemGiro
   set Localizacao=isnull((select PROLOCFIS
                             from TBS010 with (nolock)
                            where TBS010.PROCOD=ProdutosSemGiro.PROCOD),'')

drop table #ProdutoClasse

select [_Código] as codigo
       ,[ABCD (Valor)] as classe
  into #ProdutoClasse
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\Curva ABCD (Papelyna).xlsx', 'select [_Código],[ABCD (Valor)] from [Planilha1$]')

select *
  from #ProdutoClasse

update ProdutosSemGiro
   set Classe=isnull((select classe
                        from #ProdutoClasse
                       where codigo=PROCOD collate database_default),'')

select top 1
       convert(date,NFEDATEFE)
       ,*
  from TBS059 with (nolock)
 order by NFEDATEFE desc

drop table #UltimaEntrada

-- última entrada da mercadoria

select i.PROCOD as codigo
       ,max(c.NFEDATEFE) as Efetivacao
  into #UltimaEntrada
  from TBS0591 i with (nolock)
 inner join TBS059 c (nolock)
       on i.SERCOD=c.SERCOD and i.NFETIP=c.NFETIP and i.NFECOD=c.NFECOD and i.NFENUM=c.NFENUM
 where c.NFETIP ='N'
       and c.NFECAN <> 'S'
       and i.NFECFOP in ('1.102','1.403','2.102','2.403','1.916','2.916')
 group by i.PROCOD

select *
  from #UltimaEntrada

select i.NFECFOP
       ,count(*) as reg
       ,(select COPDES
           from TBS041 with (nolock)
          where COPCODDDE=i.NFECFOP or COPCODDFE=i.NFECFOP)
  from TBS0591 i with (nolock)
 inner join TBS059 c (nolock)
       on i.SERCOD=c.SERCOD and i.NFETIP=c.NFETIP and i.NFECOD=c.NFECOD and i.NFENUM=c.NFENUM
 where c.NFEDATEFE between '20220201' and '20220228' -- >= '20180101'
 group by i.NFECFOP
 order by reg desc

select NFETIP
       ,count(*) as reg
  from TBS059 with (nolock)
 where NFEDATEFE >= '20180101'
 group by NFETIP
 order by reg desc

select *
  from TBS041 with (nolock)
 where COPCODDDE=COPCODDFE

select codigo
       ,count(*)
  from #UltimaEntrada
 group by codigo
having count(*) > 1

update ProdutosSemGiro
   set UltimaEntrada=isnull((select Efetivacao
                        from #UltimaEntrada
                       where codigo=PROCOD collate database_default),'17530101')

select i.NFSCFOP
       ,count(*) as reg
       ,(select COPDES
           from TBS041 with (nolock)
          where COPCODDDE=i.NFSCFOP or COPCODDFE=i.NFSCFOP)
  from TBS0671 i with (nolock)
 inner join TBS067 c (nolock)
       on i.SNESER=c.SNESER and i.NFSNUM=c.NFSNUM
 where c.NFSDATEMI >= '20180101'
       and i.NFSCFOP<>''
 group by i.NFSCFOP
 order by reg desc

select i.PROCOD as codigo
       ,max(c.NFSDATEMI) as Emissao
  into #UltimaSaida
  from TBS0671 i with (nolock)
 inner join TBS067 c (nolock)
       on i.SNESER=c.SNESER
          and i.NFSNUM=c.NFSNUM
 inner join TBS080 e (nolock)
       on e.SNESER=c.SNESER
          and e.ENFNUM=c.NFSNUM
 where e.ENFSIT=6
       and i.NFSCFOP in ('5.102','5.405','6.108','6.102','6.404','5.117')
 group by i.PROCOD

select top 1 *
  from TBS080 with (nolock)
 order by ENFDATEMI desc

select *
  from #UltimaSaida

select codigo
       ,count(*)
  from #UltimaSaida
 group by codigo
having count(*) > 1

update ProdutosSemGiro
   set UltimaSaida=isnull((select Emissao
                             from #UltimaSaida
                            where codigo=PROCOD collate database_default),'17530101')

select i.PROCOD as codigo
       ,count(*) as conta
  --into #UltimaSaida
  from TBS0671 i with (nolock)
 inner join TBS067 c (nolock)
       on i.SNESER=c.SNESER
          and i.NFSNUM=c.NFSNUM
 inner join TBS080 e (nolock)
       on e.SNESER=c.SNESER
          and e.ENFNUM=c.NFSNUM
 where e.ENFSIT=6
       and i.NFSCFOP in ('5.102','5.405','6.108','6.102','6.404','5.117')
 group by i.PROCOD

select SNESER
       ,NFSNUM
       ,count(*)
  from TBS067 c with (nolock)
 inner join TBS080 e (nolock)
       on e.SNESER=c.SNESER
          and e.ENFNUM=c.NFSNUM
 where e.ENFSIT=6
       and i.NFSCFOP in ('5.102','5.405','6.108','6.102','6.404','5.117')

select PROCOD
       ,isnull((select count(*) 
                  from TBS067 c with (nolock)
                 inner join TBS080 e (nolock)
                       on e.SNESER=c.SNESER
                          and e.ENFNUM=c.NFSNUM
                 inner join TBS0671 i (nolock)
                       on i.SNESER=c.SNESER
                          and i.NFSNUM=c.NFSNUM
                 where e.ENFSIT=6
                       and c.NFSDATEMI >= b.UltimaEntrada
                       and i.PROCOD=b.PROCOD
                       and i.NFSCFOP in ('5.102','5.405','6.108','6.102','6.404','5.117')),0)
 from ProdutosSemGiro b with (nolock)

select c.*
  from TBS067 c with (nolock)
  inner join TBS080 e (nolock)
        on e.SNESER=c.SNESER
           and e.ENFNUM=c.NFSNUM
  inner join TBS0671 i (nolock)
        on i.SNESER=c.SNESER
           and i.NFSNUM=c.NFSNUM
  where e.ENFSIT=6
        and c.NFSDATEMI >= '20110606'
        and i.PROCOD='2320055'
        and i.NFSCFOP in ('5.102','5.405','6.108','6.102','6.404','5.117')

update ProdutosSemGiro
   set QtdeNFsaidas=isnull((select count(*) 
                              from TBS067 c with (nolock)
                             inner join TBS080 e (nolock)
                                   on e.SNESER=c.SNESER
                                      and e.ENFNUM=c.NFSNUM
                             inner join TBS0671 i (nolock)
                                   on i.SNESER=c.SNESER
                                      and i.NFSNUM=c.NFSNUM
                             where e.ENFSIT=6
                                   and c.NFSDATEMI >= b.UltimaEntrada
                                   and i.PROCOD=b.PROCOD
                                   and i.NFSCFOP in ('5.102','5.405','6.108','6.102','6.404','5.117')),0)
 from ProdutosSemGiro b with (nolock)

select datediff(day, UltimaEntrada, UltimaSaida)
       ,*
  from ProdutosSemGiro with (nolock)
 where UltimaSaida <> '17530101'
--       and UltimaEntrada <> '17530101'

    and UltimaEntrada > UltimaSaida

update ProdutosSemGiro
   set DifEntreDias=datediff(day, UltimaEntrada, UltimaSaida)
 where UltimaSaida <> '17530101'

select *
  from ProdutosSemGiro with (nolock)
 where DifEntreDias > 0
       and UltimaEntrada='17530101'

select *
  from ProdutosSemGiro with (nolock)
 where DifEntreDias > 0
       and UltimaEntrada='17530101'
       and QtdeEstoque > 0

select convert(date,getdate()-1)

select DifDiasEntSai as es_dias
       ,DifDiasEntSai/7 as es_semanas
       ,DifDiasEntSai/30 as es_meses
       ,DifDiasEntSai/365 as es_anos
       --,datediff(day, UltimaEntrada, UltimaSaida) as cv_dias
       --,datediff(week, UltimaEntrada, UltimaSaida) as cv_semanas
       --,datediff(month, UltimaEntrada, UltimaSaida) as cv_meses
       --,datediff(day, UltimaEntrada, UltimaSaida)/365 as cv_anos
       ,*
       ,case when UltimaSaida='17530101' then 0 else datediff(day, UltimaSaida, convert(date, getdate()-1)) end as v_dias
       ,datediff(week, UltimaSaida, convert(date, getdate()-1)) as v_semanas
       ,datediff(month, UltimaSaida, convert(date, getdate()-1)) as v_meses
       ,datediff(year, UltimaSaida, convert(date, getdate()-1)) as v_anos
  from ProdutosSemGiro with (nolock)
 where QtdeEstoque > 0 
       and PROCOD='1640054'

-- média de dias entre a entrada e a saída do produto

select avg(DifDiasEntSai)
  from ProdutosSemGiro with (nolock)
 where QtdeEstoque > 0
       --and not UltimaEntrada is null
       --and not UltimaSaida is null
       and UltimaEntrada<>'17530101'
       and UltimaSaida<>'17530101'
       and DifDiasEntSai > 0

-- moda: número de dias que mais ocorre entre a diferença de dias da entrada versus a saída

select top(1) with ties DifDiasEntSai as Moda
  from ProdutosSemGiro
 where QtdeEstoque > 0
       and UltimaEntrada<>'17530101'
       and UltimaSaida<>'17530101'
       and DifDiasEntSai > 0
 group by DifDiasEntSai
having count(*) > 1
order by count(*) desc;

-- amplitude

select max(DifDiasEntSai)
       ,min(DifDiasEntSai)
       ,max(DifDiasEntSai)-min(DifDiasEntSai)
  from ProdutosSemGiro
 where QtdeEstoque > 0
       and UltimaEntrada<>'17530101'
       and UltimaSaida<>'17530101'
       and DifDiasEntSai > 0

select *
  from ProdutosSemGiro with (nolock)
 where DifDiasEntSai=4425

with tmModa as (
select DifDiasEntSai
       ,count(*) as freqAbs
  from ProdutosSemGiro
 where QtdeEstoque > 0
       and UltimaEntrada<>'17530101'
       and UltimaSaida<>'17530101'
       and DifDiasEntSai > 0
 group by DifDiasEntSai
having count(*) > 1
)
select top (1) with ties DifDiasEntSai as Moda
  from tmModa
  order by freqAbs desc;

select DifDiasEntSai
       ,count(*) as conta
  from ProdutosSemGiro
 where DifDiasEntSai > 0
 group by DifDiasEntSai
having count(*) > 1
 order by conta desc

select top 1 *
  from SALDODIARIO with (nolock)

select PROCOD
       ,isnull((select top 1
                       ESTQTDATU
                  from SALDODIARIO s with (nolock)
                 where s.ESTLOC=1
                       and s.PROCOD=b.PROCOD
                       and s.ESTDATSAL < b.UltimaEntrada
                 order by ESTDATSAL desc),0)
 from ProdutosSemGiro b with (nolock)

update ProdutosSemGiro
   set SaldoAntesEntrada=isnull((select top 1
                                        ESTQTDATU
                                   from SALDODIARIO s with (nolock)
                                  where s.ESTLOC=1
                                        and s.PROCOD=b.PROCOD
                                        and s.ESTDATSAL < b.UltimaEntrada
                                  order by ESTDATSAL desc),0)
 from ProdutosSemGiro b with (nolock)

select count(*)
  from ProdutosSemGiro with (nolock)
 where Localizacao=''

select count(*)
  from ProdutosSemGiro with (nolock)
 where Localizacao<>''

select count(*)
  from ProdutosSemGiro with (nolock)
 where Len(Localizacao)=6

select count(*)
  from ProdutosSemGiro with (nolock)
 where Localizacao<>''
       and Len(Localizacao)<>6

update ProdutosSemGiro
   set Rua=Left(Localizacao,2)

select max(DifDiasEntSai)
       ,min(DifDiasEntSai)
       ,max(DifDiasEntSai)-min(DifDiasEntSai)
  from ProdutosSemGiro
 where QtdeEstoque > 0
       and UltimaEntrada<>'17530101'
       and UltimaSaida<>'17530101'
       and DifDiasEntSai >= 365

-- moda

select top(1) with ties Rua as Moda
  from ProdutosSemGiro
 where QtdeEstoque > 0
       and UltimaEntrada<>'17530101'
       and UltimaSaida<>'17530101'
       and DifDiasEntSai >= 365
       and Rua > 0
 group by Rua
having count(*) > 1
order by count(*) desc;

select count(*)
  from ProdutosSemGiro with (nolock)
 where Rua='0'

select *
  from ProdutosSemGiro with (nolock)
 where Rua='0'

-- produtos com saldos e sem localização

select count(*)
  from ProdutosSemGiro
 where QtdeEstoque > 0
       and UltimaEntrada<>'17530101'
       and UltimaSaida<>'17530101'
       and Rua=0

-- quantidade de produtos por rua sem movimentação à pelo menos 1 ano

select Rua
       ,count(*) as registros
  from ProdutosSemGiro
 where QtdeEstoque > 0
       and UltimaEntrada<>'17530101'
       and UltimaSaida<>'17530101'
       and DifDiasEntSai >= 365
       and Rua > 0
 group by Rua
 order by registros desc








