set nocount on

declare @dataDe char(10), @dataAte char(10)

set @dataDe='20141001'
set @dataAte='20141031'

-- cria tabela temporária

if object_id('tempdb..#VENDAS') is not null
   begin
      drop table #VENDAS
   end

select T2.PROCOD as 'codigoDoProduto',
       T2.NFSPERICMS as 'aliquotaDoICMS',
       dbo.NFSTOTITE(0,T2.NFSNUM,0,T2.SNESER,T2.NFSITE) as 'valorTotal',
       dbo.NFSVALICMS(0,T2.NFSNUM,0,T2.SNESER,T2.NFSITE) as 'valorDoICMS'
  into #VENDAS
  from TBS067 as T1 (nolock) left join TBS0671 as T2 (nolock) on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
 where T1.NFSDATEMI between @dataDe and @dataAte and
       T1.NFSTIP='N' and
       T1.NFSCAN='N' and
       T2.NFSPERICMS > 0
 order by T2.PROCOD


-- lista os dados

select codigoDoProduto as 'código do produto',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=codigoDoProduto) as 'descricaoDoProduto',
       aliquotaDoICMS as 'alíquota do ICMS',
       sum(valorTotal) as 'valor total',
       sum(valorDoICMS) as 'valor do ICMS',
       '1.65' as 'alíquota do PIS',
       sum(valorTotal)*1.65/100 as 'valor do PIS',
       '7.6' as 'alíquota do COFINS',
       sum(valorTotal)*7.6/100 as 'valor do COFINS'
  from #VENDAS
 group by aliquotaDoICMS,codigoDoProduto
 order by codigoDoProduto


-- dados da loja

set nocount on

declare @dataDe char(10), @dataAte char(10)

set @dataDe='20141001'
set @dataAte='20141031'

if object_id('tempdb..#VENDASGZ') is not null
   begin
      drop table #VENDASGZ
   end

select M2_PROCOD as 'codigoDoProduto',
       convert(smallmoney,subString(M2_TRB,2,5)) as 'aliquotaDoICMS',
       M2_VALTOT as 'valorTotal'
       into #VENDASGZ
  from MSL002 (nolock)
 where M2_DATMOV between @dataDe and @dataAte and
       M2_TIPREG='01' and
       M2_REGCAN='F' and
       subString(M2_TRB,1,1)='T'

select codigoDoProduto as 'código do produto',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=codigoDoProduto) as 'descricaoDoProduto',
       aliquotaDoICMS as 'alíquota do ICMS',
       sum(valorTotal) as 'valor total',
       sum(aliquotaDoICMS*valorTotal/100) as 'valor do ICMS',
       '1.65' as 'alíquota do PIS',
       sum(valorTotal)*1.65/100 as 'valor do PIS',
       '7.6' as 'alíquota do COFINS',
       sum(valorTotal)*7.6/100 as 'valor do COFINS'
  from #VENDASGZ
 group by aliquotaDoICMS,codigoDoProduto
 order by codigoDoProduto