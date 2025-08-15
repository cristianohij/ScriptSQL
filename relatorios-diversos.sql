select top 1 * from TBS067 (nolock)
select top 1 * from TBS003 (nolock)

-- vendas por UF e município

select --NFSCLICOD as 'CodigoDoCliente',
       NFSCLINOM as 'NomeDoCliente',
       (select MUNNOM from TBS003 (nolock) where TBS003.MUNCOD=TBS002.MUNCOD) as 'Municipio',
       TBS067.UFESIG as 'UF',
       (select PROUVDDAT from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'DataDaUltimaCompra',
       (select PROUVDVAL from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'ValorDaUltimaCompra',
       (select CLIACUATR/CLIQTDBAI from TBS002 (nolock) where  TBS002.CLIEMPCOD=TBS067.NFSCLIEMP and TBS002.CLICOD=TBS067.NFSCLICOD) as 'MediaDeAtrasos',
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)) as 'ValorTotalComprado'
  from TBS067 (nolock) left join TBS0671 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       left join TBS042 (nolock) on TBS042.TESEMPCOD=TBS0671.TESEMPCOD and TBS042.TESCOD=TBS0671.TESCOD
       join TBS002 (nolock) on TBS002.CLIEMPCOD=TBS067.NFSCLIEMP and TBS002.CLICOD=TBS067.NFSCLICOD
 group by TBS067.UFESIG,NFSCLINOM
