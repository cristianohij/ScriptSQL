select TBS0591.NFENUM,TBS059.NFEDATENT,
       TBS0591.PROCOD,
       sum(NFEQTD*NFEQTDEMB)-isnull(sum(TBS0597.NFENFDQTD),0),
       sum(dbo.NFETOTITE(0,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,0,TBS0591.SERCOD,TBS0591.NFEITE))
       
  from TBS059 (nolock)
       Left join TBS0591 (nolock) on TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFENUM=TBS059.NFENUM and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.SERCOD=TBS059.SERCOD
       Left join TBS0597 (nolock) on TBS0597.NFETIP=TBS059.NFETIP and TBS0597.NFENUM=TBS059.NFENUM and TBS0597.NFECOD=TBS059.NFECOD and TBS0591.SERCOD=TBS059.SERCOD and
                                     TBS0591.NFEITE=TBS0597.NFEITE
 where TBS059.NFEDATENT between '20150801' and '20150831' and
       TBS059.NFETIP='N' and
       TBS059.NFECAN<>'S' and
       TBS0591.NFEMOVEST='S'
 group by TBS0591.NFENUM,TBS0591.PROCOD,TBS059.NFEDATENT
having sum(NFEQTD*NFEQTDEMB)-isnull(sum(TBS0597.NFENFDQTD),0) > 0


-- 2015-08-27 00:00:00.000                                1784522         1.0000                1.0000                28.3400

select * from TBS0591 (nolock)

drop table #COMPRASJULHO

declare @dataDe char(8), @dataAte char(8), @referencia char(7)

set @dataDe='20150701'
set @dataAte='20150731'
set @referencia=subString(@dataDe,1,4)+'/'+subString(@dataDe,5,2)

select TBS0591.PROCOD as 'CodigoProduto',
       sum(NFEQTD*NFEQTDEMB)-isnull(sum(TBS0597.NFENFDQTD),0) as 'QtdeComprada',
       sum(dbo.NFETOTITE(0,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,0,TBS0591.SERCOD,TBS0591.NFEITE)) as 'TotalCompra',
       isnull((select sum(SALQTD) from TBS098 (nolock) where SALREF=@referencia and TBS098.PROCOD=TBS0591.PROCOD),0) as 'SaldoFinal'
       into #COMPRASJULHO
  from TBS059 (nolock)
       Left join TBS0591 (nolock) on TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFENUM=TBS059.NFENUM and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.SERCOD=TBS059.SERCOD
       Left join TBS0597 (nolock) on TBS0597.NFETIP=TBS059.NFETIP and TBS0597.NFENUM=TBS059.NFENUM and TBS0597.NFECOD=TBS059.NFECOD and TBS0591.SERCOD=TBS059.SERCOD and
                                     TBS0591.NFEITE=TBS0597.NFEITE
 where NFEDATENT between @dataDe and @dataAte and
       TBS059.NFETIP='N' and
       TBS059.NFECAN<>'S' and
       TBS0591.NFEMOVEST='S'
 group by TBS0591.PROCOD
having sum(NFEQTD*NFEQTDEMB)-isnull(sum(TBS0597.NFENFDQTD),0) > 0


select sum(SALQTD) from TBS098 (nolock) where PROCOD='1640054' and SALREF='2015/07'

select * from #COMPRASJUNHO
select * from #COMPRASJULHO


-- vendas

declare @dataDe char(8), @dataAte char(8), @produtoDe char(10), @produtoAte char(10)

set @dataDe='20150701'
set @dataAte='20150731'

set @produtoDe=''
set @produtoAte=''

-- elimina a tabela temporária

set nocount on

if object_id('TempDB.dbo.#VENDAS') is not null
   drop table #VENDAS

create table #VENDAS (
   codigo char(15) not null default '',
   precoMedioCorp decimal(12,4) default 0,
   qtdeCorp decimal(12,4) default 0,
   totalCorp decimal(12,4) default 0,
   precoMedioLoja decimal(12,4) default 0,
   qtdeLoja decimal(12,4) default 0,
   totalLoja decimal(12,4) default 0,
   primary key (codigo)
) on [PRIMARY]

-- contabiliza vendas via NFE

insert into #VENDAS (codigo, precoMedioCorp, qtdeCorp, totalCorp)
select PROCOD,
       avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)/TBS0671.NFSQTDEMB),
       sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE))
--       into #VENDAS
  from TBS067 (nolock)
          left join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
          left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
          left join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
 where TBS067.NFSDATEMI between @dataDe and @dataAte and
       TBS0671.PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       TBS067.NFSTIP='N' and
       TBS067.NFSCAN='N' and
       TBS067.NFSDEV='N' and
       (TBS0671.NFSROPCNTVEN='S' or TBS042.TESCNTVEN='S') and
--       TBS067.NFSCLINOM not Like('%BEST BAG%') and
--       TBS067.NFSCLINOM not Like('%BEST OFFICE%') and
--       TBS067.NFSCLINOM not Like('%MISASPEL%') and
--       TBS067.NFSCLINOM not Like('%PAPELYNA%') and 
       TBS067.NFSCLINOM not Like('%TANBY%')
 group by TBS0671.PROCOD

-- insere dados na tabela de vendas

--insert into #VENDAS select * from #CUPOMFISCAL where not exists(select '' from #VENDAS where #VENDAS.codigo=#CUPOMFISCAL.codigo)


-- elimina a tabela temporária de cupons fiscais caso exista

if object_id('TempDB.dbo.#CUPOMFISCAL') is not null
   drop table #CUPOMFISCAL

-- contabiliza as vendas via ECF

select M2_PROCOD as 'codigo',
       avg(MSL002.M2_VALUNI) as 'precoMedioLoja',
       sum(MSL002.M2_QTD) as 'qtdeLoja',
       sum(MSL002.M2_VALTOT-MSL002.M2_ABT) as 'totalLoja'
       into #CUPOMFISCAL
  from MSL002 (nolock) 
 where MSL002.M2_DAT between @dataDe and @dataAte and
       MSL002.M2_PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       MSL002.M2_TIPREG = '01' and
       MSL002.M2_REGCAN = 'F'
 group by MSL002.M2_PROCOD

-- insere dados na tabela de vendas

insert into #VENDAS (codigo, precoMedioLoja, qtdeLoja, totalLoja) select codigo, precoMedioLoja, qtdeLoja, totalLoja
  from #CUPOMFISCAL
 where not exists(select '' from #VENDAS where #VENDAS.codigo collate database_default=#CUPOMFISCAL.codigo collate database_default)

update #VENDAS set precoMedioLoja=#CUPOMFISCAL.precoMedioLoja, qtdeLoja=#CUPOMFISCAL.qtdeLoja, totalLoja=#CUPOMFISCAL.totalLoja
  from #CUPOMFISCAL where #VENDAS.codigo collate database_default=#CUPOMFISCAL.codigo collate database_default

select top 1 * from #COMPRASJUNHO
select top 1 * from #VENDAS


select #VENDAS.codigo as 'CodigoProduto',
       #VENDAS.totalCorp+#VENDAS.totalLoja as 'VendaTotal',
       #COMPRASJUNHO.TotalCompra/#COMPRASJUNHO.QtdeComprada as 'PrecoMedioCompra',
       (#VENDAS.totalCorp+#VENDAS.totalLoja) * (#COMPRASJUNHO.TotalCompra/#COMPRASJUNHO.QtdeComprada) as 'CustoMedioVenda'
  from #VENDAS Right join #COMPRASJUNHO on #VENDAS.codigo=#COMPRASJUNHO.CodigoProduto collate database_default
