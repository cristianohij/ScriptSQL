select TBS067.NFSCLICOD,
       TBS067.NFSCLINOM,
       (select CLICGC from TBS002 (nolock) where TBS002.CLICOD = TBS067.NFSCLICOD),
       (select CLINOMFAN from TBS002 (nolock) where TBS002.CLICOD = TBS067.NFSCLICOD),
       sum(dbo.NFSTOTLIQ(TBS067.NFSEMPCOD,TBS067.NFSNUM))
  from TBS067 (nolock)
 where TBS067.NFSDATEMI between '20121201' and '20121231' and
       (
       TBS067.NFSCLINOM Like '%BEST BAG%' or
       TBS067.NFSCLINOM Like '%MISASPEL%' or
       TBS067.NFSCLINOM Like '%PAPELYNA%' or
       TBS067.NFSCLINOM Like '%TANBY%'
       )
 group by TBS067.NFSCLICOD,TBS067.NFSCLINOM

declare @datade char(8),@dataate char(8),@empresa int

set @datade  = '20120101'
set @dataate = '20121231'
set @empresa = 0

select convert(char(7),TBS067.NFSDATEMI,111) as 'mes-ano',
       TBS067.NFSCLICOD as 'cod-cliente',
       TBS067.NFSCLINOM as 'nome-cliente',
       (select TBS002.CLICGC from TBS002 (nolock) where TBS002.CLICOD = TBS067.NFSCLICOD) as 'cnpj-cliente',
       (select TBS002.CLINOMFAN from TBS002 (nolock) where TBS002.CLICOD = TBS067.NFSCLICOD) as 'nome-fantasia',
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) as 'valor-total',
       TBS0671.TESCOD as 'tipo-saida',
       TBS0671.NFSCFOP as 'cfop',
       (select TBS042.TESTXT from TBS042 (nolock) where TBS042.TESCOD = TBS0671.TESCOD) as 'natureza-operacao',
       TBS042.TESCNTVEN as 'contabiliza-vendas',
       TBS0671.NFSMOVEST as 'movimenta-estoque',
       TBS067.NFSTIP as 'tipo-nf'
  from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.NFSEMPCOD = TBS067.NFSEMPCOD and TBS0671.NFSNUM = TBS067.NFSNUM
                        join TBS042 (nolock) on TBS0671.TESEMPCOD = TBS042.TESEMPCOD and TBS0671.TESCOD = TBS042.TESCOD
 where TBS067.NFSEMPCOD = @empresa and
       TBS067.NFSDATEMI between @datade and @dataate and
       (TBS067.NFSTIP = 'L' or TBS067.NFSTIP = 'N') and
       TBS067.NFSCAN <> 'S' and
       (
       TBS067.NFSCLINOM Like '%BEST BAG%' or
       TBS067.NFSCLINOM Like '%MISASPEL%' or
       TBS067.NFSCLINOM Like '%PAPELYNA%' or
       TBS067.NFSCLINOM Like '%TANBY%'
       )
 group by convert(char(7),TBS067.NFSDATEMI,111),TBS067.NFSCLICOD,TBS067.NFSCLINOM,TBS0671.TESCOD,TBS0671.NFSCFOP,TBS042.TESCNTVEN,TBS0671.NFSMOVEST,TBS067.NFSTIP
