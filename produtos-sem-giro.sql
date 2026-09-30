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

--alter table ProdutosSemGiro add QtdeNFsaidas int default 0 with values
--alter table ProdutosSemGiro drop column QtdeNFsaidas

alter table ProdutosSemGiro add DifDias int default 0 with values
alter table ProdutosSemGiro add DifSemanas int default 0 with values
alter table ProdutosSemGiro add DifMeses int default 0 with values
alter table ProdutosSemGiro add DifAnos int default 0 with values
alter table ProdutosSemGiro add SaldoAntesEntrada int default 0 with values

alter table ProdutosSemGiro add DifDiasEntSai int default 0 with values

alter table ProdutosSemGiro add Rua int default 0 with values

alter table ProdutosSemGiro add DataProcessamento date default '17530101' with values

update ProdutosSemGiro
   set DifDiasEntSai=datediff(day, UltimaEntrada, UltimaSaida)

select *
  from ProdutosSemGiro with (nolock)

select *
  from ProdutosSemGiro with (nolock)
 where QtdeEstoque > 0
       and UltimaSaida <= '20241001'

select max(ESTDATSAL)
  from SALDODIARIO with (nolock)

update ProdutosSemGiro
   set DataProcessamento = getdate()

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
   set DifEntreDias = datediff(day, UltimaEntrada, UltimaSaida)
 where UltimaEntrada > UltimaSaida

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






-- tabela geral para de produtos

/*if object_id('ProdutosSemGiro') is not null
    begin
    	drop table ProdutosSemGiro
    end*/

declare @empresa char(2)
set @empresa = 'bb'

if object_id('UltimasComprasVendas') is not null
    begin
    	drop table UltimasComprasVendas
    end

select p.PROCOD
       ,p.PRODES
       ,p.PROUM1
       ,p.PROUM1QTD
       ,convert(date,'17530101') as UltimaCompra     -- compra
       ,convert(date,'17530101') as UltimaVenda      -- venda
       --,' ' as Classe
       ,convert(decimal(9,3),0) as QtdeEstoque        -- estoque atual
       /*,(select sum(e.ESTQTDATU)
           from TBS032 e with (nolock)
          where e.ESTLOC in (1,2)
                and e.PROCOD = p.PROCOD) as QtdeEstoque*/
       ,convert(decimal(9,3),0) as QtdeLoja           -- estoque atual loja
       ,convert(decimal(9,3),0) as QtdeComprada       -- qtde compras
       ,convert(decimal(9,3),0) as QtdeVendida        -- qtde vendas
       --,convert(varchar(20), '') as Localizacao
       ,p.PROLOCFIS as Localizacao
       ,convert(date,getdate()) as DataProcessamento
       ,@empresa as empresa
       ,dbo.fn_custo_medio_produto(PROCOD) as custo_medio
       ,p.MARNOM
  into UltimasComprasVendas
  from TBS010 p with (nolock)

select *
  from UltimasComprasVendas with (nolock)
 where PROCOD = '19480019'

select *
  from UltimasComprasVendas with (nolock)
 where PROCOD Like ('1072%')

-- tabela de saldos dos produtos

if object_id('tempdb.dbo.#SaldoAtual') is not null
    begin
    	drop table #SaldoAtual
    end

select PROCOD
       ,isnull([1], 0) AS ESTLOC_1
       ,isnull([2], 0) AS ESTLOC_2
  into #SaldoAtual
  from ( select PROCOD
                ,ESTLOC
                ,ESTQTDATU
           from TBS032 with (nolock)
          where ESTLOC in (1,2)
       ) as src
 pivot (sum(ESTQTDATU) for ESTLOC in ([1], [2])) as pvt

select *
  from #SaldoAtual
 where PROCOD = '1080067'

-- update dos saldos atuais

/*update UltimasComprasVendas
   set QtdeEstoque = isnull((select ESTQTDATU
                               from #SaldoDoDia
                              where #SaldoDoDia.PROCOD=ProdutosSemGiro.PROCOD),0)*/

update ucv
   set ucv.QtdeEstoque = sal.ESTLOC_1
       ,ucv.QtdeLoja = sal.ESTLOC_2
  from UltimasComprasVendas ucv
 inner join #SaldoAtual sal
         on sal.PROCOD = ucv.PROCOD

-- best bag, somente estoque 2

update ucv
   set ucv.QtdeLoja = sal.ESTLOC_2
  from UltimasComprasVendas ucv
 inner join #SaldoAtual sal
         on sal.PROCOD = ucv.PROCOD

-- misaspel, papelyna, tanby cd, somente estoque 1

update ucv
   set ucv.QtdeLoja = sal.ESTLOC_1
  from UltimasComprasVendas ucv
 inner join #SaldoAtual sal
         on sal.PROCOD = ucv.PROCOD

select *
  from UltimasComprasVendas
 where PROCOD = '1080067'

-- úlitma entrada da mercadoria

-- códigos dos fornecedores "grupo"

if object_id('tempdb.dbo.#grupo_fornecedores') is not null
    begin
    	drop table #grupo_fornecedores
    end

create table #grupo_fornecedores (codigo int)

insert into #grupo_fornecedores
exec usp_FornecedoresGrupo 2

-- últimos produtos recebidos

-- CFOP's de entradas

if object_id('tempdb.dbo.#CFOP_entradas') is not null
    begin
    	drop table #CFOP_entradas
    end

create table #CFOP_entradas (CFOP varchar(10))

insert into #CFOP_entradas (CFOP)
values ('1.102')
       ,('1.403')
       ,('2.102')
       ,('2.403')
       ,('2.922')

if object_id('tempdb.dbo.#ultima_entrada') is not null
    begin
    	drop table #ultima_entrada
    end;

-- captura o último produto recebido

with ProdutosOrdenados as (
   select c.NFETIP
          ,c.NFENUM
          ,c.NFECOD
          ,c.NFEDATEFE
          ,i.PROCOD
          ,i.NFEQTD
          ,row_number() over (partition by i.PROCOD order by c.NFEDATEFE desc) as rn
     from TBS0591 i with (nolock)
     Left join TBS059 c with (nolock)
            on i.NFETIP = c.NFETIP
               and i.NFENUM = c.NFENUM
               and i.NFECOD = c.NFECOD
               and i.SERCOD = c.SERCOD
    where c.NFETIP = 'N'
          and c.NFECAN <> 'S'
          and i.NFECFOP collate database_default in (select CFOP from #CFOP_entradas)
          and c.NFECOD not in (select codigo from #grupo_fornecedores)
)
select NFETIP
       ,NFENUM
       ,NFECOD
       ,NFEDATEFE
       ,PROCOD
       ,NFEQTD
  into #ultima_entrada
  from ProdutosOrdenados
 where rn = 1;

select *
  from #ultima_entrada

-- checa duplicidades

select PROCOD
       ,count(*)
  from #ultima_entrada
 group by PROCOD
having count(*) > 1

-- update da última entrada

update ucv
   set ucv.UltimaCompra = ue.NFEDATEFE
       ,ucv.QtdeComprada = ue.NFEQTD
  from UltimasComprasVendas ucv
 inner join #ultima_entrada ue
         on ue.PROCOD = ucv.PROCOD

-- úlitma saída da mercadoria

-- códigos dos clientes "grupo"

if object_id('tempdb.dbo.#grupo_clientes') is not null
    begin
    	drop table #grupo_clientes
    end

create table #grupo_clientes (codigo int)

insert into #grupo_clientes
exec usp_ClientesGrupo 2

-- CFOP's de saídas

/*
if object_id('tempdb.dbo.#CFOP_saidas') is not null
    begin
    	drop table #CFOP_saidas
    end

create table #CFOP_saidas (CFOP varchar(10))

insert into #CFOP_saidas (CFOP)
values ('5.102')
       ,('5.117')
       ,('5.119')
       ,('5.123')
       ,('5.405')
       ,('5.922')
       ,('5.923')
       ,('5.929')
       ,('6.102')
       ,('6.108')
       ,('6.119')
       ,('6.403')
       ,('6.404')
       ,('6.923')
       ,('6.929')

-- opcional: visualizar o conteúdo

select *
  from #CFOP_saidas
*/

-- captura a última saída do produto

select top(1000) *
  from DWVendas with (nolock)
 where numeroSerieDocumento = 3

if object_id('tempdb.dbo.#ultima_saida') is not null
    begin
    	drop table #ultima_saida
    end;

with ProdutosOrdenados as (
    select numeroSerieDocumento
           ,numeroDocumento
           ,[data]
           ,codigoProduto
           ,quantidade
           ,row_number() over (partition by codigoProduto order by [data] desc) as rn
      from DWVendas with (nolock)
     where cancelado = 'N'
           and numeroSerieDocumento <> 3
)
select numeroSerieDocumento
       ,numeroDocumento
       ,[data]
       ,codigoProduto
       ,quantidade
  into #ultima_saida
  from ProdutosOrdenados
 where rn = 1;

-- update da última saída

update ucv
   set ucv.UltimaVenda = [data]
       ,ucv.QtdeVendida = quantidade
  from UltimasComprasVendas ucv
 inner join #ultima_saida us
         on us.codigoProduto = ucv.PROCOD

-- resulta final

declare @data date
set @data = '20241001'

select *
  from UltimasComprasVendas with (nolock)
 where UltimaVenda <= @data
       and QtdeEstoque + QtdeLoja <> 0

declare @data date
set @data = '20241001'

-- tanby matriz
select *
  from UltimasComprasVendas with (nolock)
 where UltimaVenda <= @data
       and QtdeEstoque + QtdeLoja <> 0

union

-- best bag
select *
  from bb.SIBD2.dbo.UltimasComprasVendas with (nolock)
 where UltimaVenda <= @data
       and QtdeEstoque + QtdeLoja <> 0

union

-- misaspel
select *
  from mi.SIBD3.dbo.UltimasComprasVendas with (nolock)
 where UltimaVenda <= @data
       and QtdeEstoque + QtdeLoja <> 0

union

-- papelyna
select *
  from pp.SIBD.dbo.UltimasComprasVendas with (nolock)
 where UltimaVenda <= @data
       and QtdeEstoque + QtdeLoja <> 0

union

-- tanby cd
select PROCOD collate database_default
       ,PRODES  collate database_default
       ,PROUM1  collate database_default
       ,PROUM1QTD
       ,UltimaCompra
       ,UltimaVenda
       ,QtdeEstoque
       ,QtdeLoja
       ,QtdeComprada
       ,QtdeVendida
       ,Localizacao  collate database_default
       ,DataProcessamento
       ,empresa collate database_default
       ,custo_medio
       ,MARNOM collate database_default
  from cd.SIBD.dbo.UltimasComprasVendas with (nolock)
 where UltimaVenda <= @data
       and QtdeEstoque + QtdeLoja <> 0

union

-- tanby taubaté
select *
  from tt.SIBD.dbo.UltimasComprasVendas with (nolock)
 where UltimaVenda <= @data
       and QtdeEstoque + QtdeLoja <> 0

select top(1) CUSTO
  from SALDOINICIAL with (nolock)
 where CODIGO = '1080067'
 order by[DATA] desc

/*
IF EXISTS (SELECT 1 
             FROM sys.objects 
            WHERE type = 'P' 
              AND name = 'usp_custo_medio_produto')
    DROP PROCEDURE usp_custo_medio_produto;
GO

CREATE PROCEDURE usp_custo_medio_produto
    @CODIGO VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (1) CUSTO
      FROM SALDOINICIAL WITH (NOLOCK)
     WHERE CODIGO = @CODIGO
     ORDER BY [DATA] DESC;
END
GO
*/

IF OBJECT_ID('dbo.fn_obter_custo_produto', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_obter_custo_produto;
GO


CREATE FUNCTION fn_custo_medio_produto(@CODIGO VARCHAR(20))
RETURNS DECIMAL(18, 4)
AS
BEGIN
    DECLARE @CUSTO DECIMAL(18, 4);

    SELECT TOP (1) @CUSTO = CUSTO
      FROM SALDOINICIAL WITH (NOLOCK)
     WHERE CODIGO = @CODIGO
     ORDER BY [DATA] DESC;

    RETURN @CUSTO;
END
GO



-- comparação da NCM entre nota de compra e cadastro do produto

-- úlitma entrada da mercadoria

-- códigos dos fornecedores "grupo"

if object_id('tempdb.dbo.#grupo_fornecedores') is not null
    begin
    	drop table #grupo_fornecedores
    end

create table #grupo_fornecedores (codigo int)

insert into #grupo_fornecedores
exec usp_FornecedoresGrupo 1

-- últimos produtos recebidos

-- CFOP's de entradas

if object_id('tempdb.dbo.#CFOP_entradas') is not null
    begin
    	drop table #CFOP_entradas
    end

create table #CFOP_entradas (CFOP varchar(10))

insert into #CFOP_entradas (CFOP)
values ('1.102')
       ,('1.403')
       ,('2.102')
       ,('2.403')
       ,('2.922')

if object_id('NCM_ENTRADA') is not null
    begin
    	drop table NCM_ENTRADA
    end

declare @empresa char(2)
set @empresa = 'tt'

-- captura o último produto recebido

;with ProdutosOrdenados as (
   select c.NFETIP
          ,c.NFENUM
          ,c.NFECOD
          ,c.NFEDATEFE
          ,i.PROCOD
          ,i.NFENCMXML
          ,@empresa as empresa
          ,row_number() over (partition by i.PROCOD order by c.NFEDATEFE desc) as rn
     from TBS0591 i with (nolock)
     Left join TBS059 c with (nolock)
            on i.NFETIP = c.NFETIP
               and i.NFENUM = c.NFENUM
               and i.NFECOD = c.NFECOD
               and i.SERCOD = c.SERCOD
    where c.NFETIP = 'N'
          and c.NFECAN <> 'S'
          and i.NFECFOP collate database_default in (select CFOP from #CFOP_entradas)
          and c.NFECOD not in (select codigo from #grupo_fornecedores)
)
select NFETIP
       ,NFENUM
       ,NFECOD
       ,NFEDATEFE
       ,PROCOD
       ,NFENCMXML
       ,empresa
  into NCM_ENTRADA
  from ProdutosOrdenados
 where rn = 1;

select *
  from NCM_ENTRADA with (nolock)

-- ncm do grupo papelyna

if object_id('NCM_GRUPO') is not null
    begin
    	drop table NCM_GRUPO
    end

-- tanby nd
select *
  into NCM_GRUPO
  from NCM_ENTRADA with (nolock)
 where NFENCMXML <> ''

union 

-- best bag
select *
  from bb.SIBD2.dbo.NCM_ENTRADA with (nolock)
 where NFENCMXML <> ''

union 

-- misaspel
select *
  from mi.SIBD3.dbo.NCM_ENTRADA with (nolock)
 where NFENCMXML <> ''

union 

-- papelyna
select *
  from pp.SIBD.dbo.NCM_ENTRADA with (nolock)
 where NFENCMXML <> ''

union 

-- tanby cd
select NFETIP collate database_default
       ,NFENUM
       ,NFECOD
       ,NFEDATEFE
       ,PROCOD  collate database_default
       ,NFENCMXML  collate database_default
       ,empresa  collate database_default
  from cd.SIBD.dbo.NCM_ENTRADA with (nolock)
 where NFENCMXML <> ''

union 

-- tanby taubaté
select *
  from tt.SIBD.dbo.NCM_ENTRADA with (nolock)
 where NFENCMXML <> ''

select *
  from NCM_GRUPO with (nolock)

-- ncm agrupado

select PROCOD
       ,NFENCMXML
  from NCM_GRUPO with (nolock)
 group by PROCOD
          ,NFENCMXML

-- lista NCM duplicados

select PROCOD
       ,NFENCMXML
       ,count(*)
  from NCM_GRUPO with (nolock)
 group by PROCOD
          ,NFENCMXML
having count(*) > 1

-- Produtos que possuem mais de um NCM

SELECT PROCOD
     , COUNT(DISTINCT NFENCMXML) AS QtdeNCMs
FROM NCM_GRUPO
GROUP BY PROCOD
HAVING COUNT(DISTINCT NFENCMXML) > 1;

-- Listar detalhado (PROCOD + seus respectivos NCMs)

SELECT DISTINCT PROCOD
     , NFENCMXML
FROM NCM_GRUPO
WHERE PROCOD IN (
    SELECT PROCOD
    FROM NCM_GRUPO
    GROUP BY PROCOD
    HAVING COUNT(DISTINCT NFENCMXML) > 1
)
ORDER BY PROCOD, NFENCMXML;


-- Ver todos, incluindo quem tem 1 NCM

SELECT PROCOD
     , COUNT(DISTINCT NFENCMXML) AS QtdeNCMs
FROM NCM_GRUPO
GROUP BY PROCOD
ORDER BY QtdeNCMs DESC;

-- Produtos com um único NCM

SELECT PROCOD
     , COUNT(DISTINCT NFENCMXML) AS QtdeNCMs
FROM NCM_GRUPO
GROUP BY PROCOD
HAVING COUNT(DISTINCT NFENCMXML) = 1
ORDER BY PROCOD;

-- Se quiser ver também o NCM correspondente

if object_id('tempdb.dbo.#ncm_unicos') is not null
    begin
    	drop table #ncm_unicos
    end

SELECT PROCOD
     , MIN(NFENCMXML) AS NCM -- funciona porque só tem 1 distinto
into #ncm_unicos
FROM NCM_GRUPO
GROUP BY PROCOD
HAVING COUNT(DISTINCT NFENCMXML) = 1
ORDER BY PROCOD;

-- Para ver linha a linha (sem agrupar)

SELECT PROCOD
     , NFENCMXML
FROM NCM_GRUPO
WHERE PROCOD IN (
    SELECT PROCOD
    FROM NCM_GRUPO
    GROUP BY PROCOD
    HAVING COUNT(DISTINCT NFENCMXML) = 1
)
ORDER BY PROCOD;

select p.PROCOD
       ,p.PRODES
       ,p.PROSTATUS
       ,p.PROCLAFIS as NCM_produto
       ,ncm.NCM as NCM_fornecedor
  from TBS010 p with (nolock)
 inner join #ncm_unicos ncm
         on ncm.PROCOD = p.PROCOD
            and ncm.NCM <> p.PROCLAFIS
            and ncm.existe = 'S'

select *
  from #ncm_unicos
 where not exists (select NCMCOD from TBS092 with (nolock) where NCMCOD = NCM)

ALTER TABLE #ncm_unicos
ADD existe CHAR(1);

update u
   set u.existe = 'N'
  from #ncm_unicos u
 where not exists (
           select 1
             from TBS092 t with (nolock)
            where t.NCMCOD = u.NCM
       );

update #ncm_unicos
   set existe = 'S'
 where existe is null

select PROCOD
       ,PRODES
       ,PROCLAFIS
       ,PROSTATUS
  from TBS010 with (nolock)
 where not exists (select NCMCOD from TBS092 with (nolock) where NCMCOD = PROCLAFIS)
       and PROCLAFIS <> ''



