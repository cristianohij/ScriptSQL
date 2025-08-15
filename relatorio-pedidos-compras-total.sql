declare @dataDe char(8),@dataAte char(8),@nomeDoFornecedor char(50),@nomeDoComprador char(30)

set @dataDe='20150101'
set @dataAte='20150510'

set @nomeDoFornecedor=''
set @nomeDoComprador=''

select subString(convert(char(8),PDCDATCAD,112),1,4) as 'AnoDaEmissao',
       subString(convert(char(8),PDCDATCAD,112),5,2) as 'MesDaEmissao',
       subString(convert(char(8),PDCDATCAD,112),7,2) as 'DiaDaEmissao',
       PDCNUM as 'NumeroDoPedido',
       rtrim(FORNOM)+' ('+ltrim(str(TBS006.FORCOD,5))+')' as 'NomeECodigoDoFornecedor',
       isnull(rtrim(COMNOM)+' ('+ltrim(str(TBS045.COMCOD,3))+')','') as 'NomeECodigoDoComprador',
       dbo.PDCTOTLIQ(PDCEMPCOD,PDCNUM) as 'TotalDoProduto',
       dbo.PDCTOTBRU(PDCEMPCOD,PDCNUM) as 'TotalDoPedido',
       dbo.PDCTOTENT(PDCEMPCOD,PDCNUM) as 'TotalJaEntregue',
       dbo.PDCTOTRES(PDCEMPCOD,PDCNUM) as 'TotalResiduo',
       dbo.PDCTOTIPI(PDCEMPCOD,PDCNUM) as 'TotalDoIPI',
       dbo.PDCTOTST(PDCEMPCOD,PDCNUM) as 'TotalDaST',
       PDCVALFRETOT as 'TotalDoFrete',
       PDCVALSEGTOT as 'TotalDoSeguro',
       PDCVALOUTTOT as 'TotalDeOutrasDespesas',
       dbo.PDCVDDTOT(PDCEMPCOD,PDCNUM) as 'TotalDoDesconto'
  from TBS045 (nolock) right join TBS006 (nolock) on TBS006.FOREMPCOD=TBS045.FOREMPCOD and TBS006.FORCOD=TBS045.FORCOD
                       left join TBS046 (nolock) on TBS046.COMEMPCOD=TBS045.COMEMPCOD and TBS046.COMCOD=TBS045.COMCOD
 where PDCDATCAD between @dataDe and @dataAte and
       FORNOM between @nomeDoFornecedor and case when @nomeDoFornecedor='' then 'Z' else @nomeDoFornecedor end
