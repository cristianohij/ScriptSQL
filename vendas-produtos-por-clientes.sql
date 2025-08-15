declare @dataDe char(8),@dataAte char(8),@produtoDe char(15),@produtoAte char(15),@nomeDaMarca char(30)

set @dataDe='20150401'
set @dataAte='20150423'

set @produtoDe=''
set @produtoAte='Z'

set @nomeDaMarca=''

--select rtrim(NFSCLINOM)+' ('+ltrim(str(NFSCLICOD,5))+')' as 'NomeECodigoDoCliente',
--       NFSDATEMI as 'DataDaEmissao',
--       TBS067.SNESER as 'SerieDaNF',
--       TBS067.NFSNUM as 'NumeroDaNF',
--       PROCOD as 'CodigoDoProduto',
--       NFSPRODES as 'DescricaoDoProduto',
--       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'UnidadeDeMedida',
--       (select rtrim(MARNOM)+' ('+ltrim(str(MARCOD,4))+')' from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'MarcaDoProduto',
--       NFSQTD*NFSQTDEMB as 'Quantidade',
--       dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE) as 'ValorTotal'
--  from TBS0671 (nolock) right join TBS067 (nolock)
--       on TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.SNEEMPCOD=TBS067.SNEEMPCOD and TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
-- where NFSDATEMI between @dataDe and @dataAte and
--       PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
--       NFSTIP='N' and
--       NFSCAN='S' and
--       NFSDEV='N' 
-- order by 'MarcaDoProduto'

-- filtrando por marca

select rtrim(NFSCLINOM)+' ('+ltrim(str(NFSCLICOD,5))+')' as 'NomeECodigoDoCliente',
       NFSDATEMI as 'DataDaEmissao',
       TBS067.SNESER as 'SerieDaNF',
       TBS067.NFSNUM as 'NumeroDaNF',
       TBS0671.PROCOD as 'CodigoDoProduto',
       NFSPRODES as 'DescricaoDoProduto',
       PROUM1 as 'UnidadeDeMedida',
       rtrim(MARNOM)+' ('+ltrim(str(MARCOD,4))+')' as 'MarcaDoProduto',
       NFSQTD*NFSQTDEMB as 'Quantidade',
       dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE) as 'ValorTotal'
  from TBS0671 (nolock)
       right join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       right join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
 where NFSDATEMI between @dataDe and @dataAte and
       TBS0671.PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       --NFSTIP='N' and
       NFSCAN='S' and
       NFSDEV='N' and
       MARNOM between @nomeDaMarca and case when @nomeDaMarca='' then 'Z' else @nomeDaMarca end
 order by 'MarcaDoProduto'
