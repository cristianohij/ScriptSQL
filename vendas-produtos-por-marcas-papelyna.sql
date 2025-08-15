declare @dataDe varchar(8),@dataAte varchar(8),@produtoDe varchar(15),@produtoAte varchar(15),@codigoDaMarca smallint,@nomeDaMarca varchar(30),@unidade varchar(8),@query varchar(2100),
        @valorTotal money

set @unidade='PAPELYNA'

set @dataDe='20150501'
set @dataAte='20150515'

set @produtoDe='0074605'
set @produtoAte='0074605'

set @codigoDaMarca=0
set @nomeDaMarca=''

select isnull(sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)),0) as 'ValorTotal'
  from TBS0671 (nolock)
       left join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       left join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
       left join TBS042 (nolock) on TBS042.TESEMPCOD=TBS0671.TESEMPCOD and TBS042.TESCOD=TBS0671.TESCOD
       join TBS002 (nolock) on TBS002.CLIEMPCOD=TBS067.NFSCLIEMP and TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSDATEMI between @dataDe and @dataAte and
       TBS0671.PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       TBS067.NFSTIP='N' and
       TBS067.NFSCAN='S' and
       TBS067.NFSDEV='N' and
       TBS042.TESCNTVEN = 'S' and
       TBS002.RDLCOD<>1 and
       TBS010.MARCOD between @CodigoDaMarca and case when @CodigoDaMarca=0 then 9999 else @CodigoDaMarca end and
       TBS010.MARNOM between @nomeDaMarca and case when @nomeDaMarca='' then 'Z' else @nomeDaMarca end
 group by TBS0671.PROCOD

print @valorTotal

select (select rtrim(MARNOM)+' ('+ltrim(str(MARCOD,4))+')' from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'NomeECodigoDaMarca',
       TBS0671.PROCOD as 'CodigoDoProduto',
       isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'') as 'DescricaoDoProduto',
       sum(TBS0671.NFSQTD*TBS0671.NFSQTDEMB) as 'QuantidadeVendida',
       isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'') as 'UnidadeDeMedida',
       avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)) as 'ValorMedioDoItem',
       isnull((select TBS032.ESTQTDATU-TBS032.ESTQTDRES from TBS032 (nolock) where TBS032.PROCOD=TBS0671.PROCOD and ESTLOC=1),0) as 'QuantidadeDisponivel',
       isnull((select PROCODBAR1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),0) as 'CodigoDeBarras1',
       isnull((select PROCODBAR2 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),0) as 'CodigoDeBarras2',
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)) as 'TotalVendido'
  from TBS0671 (nolock)
       left join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       left join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
       left join TBS042 (nolock) on TBS042.TESEMPCOD=TBS0671.TESEMPCOD and TBS042.TESCOD=TBS0671.TESCOD
       join TBS002 (nolock) on TBS002.CLIEMPCOD=TBS067.NFSCLIEMP and TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSDATEMI between @dataDe and @dataAte and
       TBS0671.PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       TBS067.NFSTIP='N' and
       TBS067.NFSCAN='S' and
       TBS067.NFSDEV='N' and
       TBS042.TESCNTVEN = 'S' and
       TBS002.RDLCOD<>1 and
       TBS010.MARCOD between @CodigoDaMarca and case when @CodigoDaMarca=0 then 9999 else @CodigoDaMarca end and
       TBS010.MARNOM between @nomeDaMarca and case when @nomeDaMarca='' then 'Z' else @nomeDaMarca end
 group by TBS0671.PROCOD
 order by 'MarcaDoProduto'

set @query='select (select rtrim(MARNOM)+'' (''+ltrim(str(MARCOD,4))+'')'' from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as ''NomeECodigoDaMarca'',
       TBS0671.PROCOD as ''CodigoDoProduto'',
       isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'''') as ''DescricaoDoProduto'',
       sum(TBS0671.NFSQTD*TBS0671.NFSQTDEMB) as ''QuantidadeVendida'',
       isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'''') as ''UnidadeDeMedida'',
       avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)) as ''ValorMedioDoItem'',
       isnull((select TBS032.ESTQTDATU-TBS032.ESTQTDRES from TBS032 (nolock) where TBS032.PROCOD=TBS0671.PROCOD and ESTLOC=1),0) as ''QuantidadeDisponivel'',
       isnull((select PROCODBAR1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),0) as ''CodigoDeBarras1'',
       isnull((select PROCODBAR2 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),0) as ''CodigoDeBarras2''
  from TBS0671 (nolock)
       left join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       left join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
       left join TBS042 (nolock) on TBS042.TESEMPCOD=TBS0671.TESEMPCOD and TBS042.TESCOD=TBS0671.TESCOD
       join TBS002 (nolock) on TBS002.CLIEMPCOD=TBS067.NFSCLIEMP and TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSDATEMI between '''+@dataDe+''' and '''+@dataAte+''' and
       TBS0671.PROCOD between '''+@produtoDe+''' and case when '''+@produtoAte+'''='''' then ''Z'' else '''+@produtoAte+''' end and
       TBS067.NFSTIP=''N'' and
       TBS067.NFSCAN=''S'' and
       TBS067.NFSDEV=''N'' and
       TBS042.TESCNTVEN = ''S'' and
       TBS002.RDLCOD<>1 and
       TBS010.MARCOD between '+ltrim(str(@CodigoDaMarca,4))+' and case when '+ltrim(str(@CodigoDaMarca,4))+'=0 then 9999 else '+ltrim(str(@CodigoDaMarca,4))+' end and
       TBS010.MARNOM between '''+@nomeDaMarca+''' and case when '''+@nomeDaMarca+'''='''' then ''Z'' else '''+@nomeDaMarca+''' end
 group by TBS0671.PROCOD
 order by ''MarcaDoProduto'''

execute (@query)

--print @query

-- query utilizada

-- relatório papelyna - não tem estoque 2 - loja

select (select rtrim(MARNOM)+' ('+ltrim(str(MARCOD,4))+')' from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'NomeECodigoDaMarca',
       TBS0671.PROCOD as 'CodigoDoProduto',
       isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'') as 'DescricaoDoProduto',
       sum(TBS0671.NFSQTD*TBS0671.NFSQTDEMB) as 'QuantidadeVendida',
       isnull((select ESTQTDCMP from TBS032 (nolock) where TBS032.PROCOD=TBS0671.PROCOD and ESTLOC=1),0) as 'QuantidadeComprada',
       isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'') as 'UnidadeDeMedida',
       avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)/TBS0671.NFSQTDEMB) as 'ValorMedioDoItem',
       isnull((select TBS032.ESTQTDATU-TBS032.ESTQTDRES from TBS032 (nolock) where TBS032.PROCOD=TBS0671.PROCOD and ESTLOC=1),0) as 'QuantidadeDisponivel',
       isnull((select PROCODBAR1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),0) as 'CodigoDeBarras1',
       isnull((select PROCODBAR2 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),0) as 'CodigoDeBarras2',
       isnull((select PROLOCFIS from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'') as 'LocalizacaoFisica',
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)) as 'TotalVendido'
  from TBS0671 (nolock)
       right join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       left join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
       left join TBS042 (nolock) on TBS042.TESEMPCOD=TBS0671.TESEMPCOD and TBS042.TESCOD=TBS0671.TESCOD
       join TBS002 (nolock) on TBS002.CLIEMPCOD=TBS067.NFSCLIEMP and TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSDATEMI between @dataDe and @dataAte and
       TBS0671.PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       TBS067.NFSTIP='N' and
       TBS067.NFSCAN='N' and
       TBS067.NFSDEV='N' and
       TBS042.TESCNTVEN = 'S' and
       TBS002.RDLCOD<>1 and
       TBS010.MARCOD between @CodigoDaMarca and case when @CodigoDaMarca=0 then 9999 else @CodigoDaMarca end and
       TBS010.MARNOM between @nomeDaMarca and case when @nomeDaMarca='' then 'Z' else @nomeDaMarca end
 group by TBS0671.PROCOD


-- relatório demais unidades com estoque 2 - loja

select (select rtrim(MARNOM)+' ('+ltrim(str(MARCOD,4))+')' from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'NomeECodigoDaMarca',
       TBS0671.PROCOD as 'CodigoDoProduto',
       isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'') as 'DescricaoDoProduto',
       sum(TBS0671.NFSQTD*TBS0671.NFSQTDEMB) as 'QuantidadeVendida',
       isnull((select ESTQTDCMP from TBS032 (nolock) where TBS032.PROCOD=TBS0671.PROCOD and ESTLOC=1),0) as 'QuantidadeComprada',
       isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'') as 'UnidadeDeMedida',
       avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)) as 'ValorMedioDoItem',
       isnull((select TBS032.ESTQTDATU-TBS032.ESTQTDRES from TBS032 (nolock) where TBS032.PROCOD=TBS0671.PROCOD and ESTLOC=1),0) as 'QuantidadeEstoque1Disponivel',
       isnull((select TBS032.ESTQTDATU-TBS032.ESTQTDRES from TBS032 (nolock) where TBS032.PROCOD=TBS0671.PROCOD and ESTLOC=2),0) as 'QuantidadeEstoque2Disponivel',
       isnull((select PROCODBAR1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),0) as 'CodigoDeBarras1',
       isnull((select PROCODBAR2 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),0) as 'CodigoDeBarras2',
       isnull((select PROLOCFIS from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'') as 'LocalizacaoFisica',
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)) as 'TotalVendido'
  from TBS0671 (nolock)
       left join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       left join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
       left join TBS042 (nolock) on TBS042.TESEMPCOD=TBS0671.TESEMPCOD and TBS042.TESCOD=TBS0671.TESCOD
       join TBS002 (nolock) on TBS002.CLIEMPCOD=TBS067.NFSCLIEMP and TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSDATEMI between @dataDe and @dataAte and
       TBS0671.PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       TBS067.NFSTIP='N' and
       TBS067.NFSCAN='N' and
       TBS067.NFSDEV='N' and
       TBS042.TESCNTVEN = 'S' and
       TBS002.RDLCOD<>1 and
       TBS010.MARCOD between @CodigoDaMarca and case when @CodigoDaMarca=0 then 9999 else @CodigoDaMarca end and
       TBS010.MARNOM between @nomeDaMarca and case when @nomeDaMarca='' then 'Z' else @nomeDaMarca end
 group by TBS0671.PROCOD
