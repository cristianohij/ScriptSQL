declare @periodoDe char(8), @periodoAte char(8)

set @periodoDe  = '20150101'
set @periodoAte = '20150131'

select D.GRUCOD, D.GRUDES, round(sum((NFSPRE * NFSQTD) - ((NFSPRE *
NFSQTD) * NFSPDDITE / 100) + ((NFSPRE * NFSQTD) * NFSFREITE / 100) +
((NFSPRE * NFSQTD) * NFSSEGITE / 100) + ((NFSPRE * NFSQTD) * NFSDESITE /
100)),2)
from TBS0671 B(nolock)
join TBS067 A(nolock) on B.NFSNUM = A.NFSNUM and B.SNESER = A.SNESER join
TBS010 C(nolock) on B.PROCOD = C.PROCOD join TBS012 D(nolock) on C.GRUCOD =
D.GRUCOD join TBS042 E(nolock) on B.TESCOD = E.TESCOD where NFSDATEMI
between @periodoDe and @periodoAte and NFSTIP = 'N' and NFSCAN = 'N' and
TESCNTVEN = 'S'
group by D.GRUCOD, D.GRUDES


declare @dataDe char(8),
        @dataAte char(8),
        @codigoDoGrupo smallint,
        @nomeDoGrupo char(20),
        @codigoDoSubgrupo smallint,
        @nomeDoSubgrupo char(20),
        @produtoDe char(15),
        @produtoAte char(15),
        @codigoDaMarca smallint,
        @nomeDaMarca char(30),
        @grupo char(20)

set @grupo=''

set @dataDe='20150301'
set @dataAte='20150331'

set @codigoDoGrupo=0
set @codigoDoSubgrupo=0

set @nomeDoGrupo='ESCRITORIO'
set @nomeDoSubgrupo=''

set @produtoDe=''
set @produtoAte='Z'

set @codigoDaMarca=0
set @nomeDaMarca=''

select rtrim(GRUDES)+' ('+Ltrim(str(TBS012.GRUCOD,3))+')' as 'grupo',
       rtrim(SUBGRUDES)+' ('+Ltrim(str(TBS0121.SUBGRUCOD,3))+')' as 'subGrupo',
       rtrim(TBS010.MARNOM)+' ('+Ltrim(str(MARCOD,4))+')' as 'MarcaDoProduto',
       TBS0671.PROCOD as 'CodigoDoProduto',
       TBS0671.NFSPRODES as 'DescricaoDoProduto',
       NFSUNI as 'UnidadeDeMedida',
       NFSQTD as 'QuantidadeVendida',
       dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE) as 'ValorDoItem',
       dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE) as 'ValorTotal'
  from TBS0671 (nolock) join TBS010 (nolock) on TBS0671.PROCOD=TBS010.PROCOD
                        join TBS012 (nolock) on TBS012.GRUCOD=TBS010.GRUCOD
                        join TBS0121 (nolock) on TBS0121.GRUEMPCOD=TBS012.GRUEMPCOD and TBS0121.GRUCOD=TBS012.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD
                        join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and
                                                TBS067.NFSNUM=TBS0671.NFSNUM
                        join TBS042 (nolock) on TBS042.TESEMPCOD=TBS0671.TESEMPCOD and TBS042.TESCOD=TBS0671.TESCOD
                        join TBS002 (nolock) on TBS002.CLIEMPCOD=TBS067.NFSCLIEMP and TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSDATEMI between @dataDe and @dataAte and
       NFSTIP='N' and
       NFSCAN='N' and
       NFSDEV='N' and
       TESCNTVEN = 'S' and
       RDLCOD<>1 and
       TBS012.GRUCOD>=@codigoDoGrupo and
       --GRUDES Like case when @nomeDoGrupo='' then '[0-Z]%' else @nomeDoGrupo end and
       GRUDES Like case when @grupo<>'' then '[0-Z]%' else @grupo end and
       --TBS0121.SUBGRUCOD>=@codigoDoSubgrupo and
       --TBS0121.SUBGRUDES Like case when @nomeDoSubgrupo='' then '[0-Z]%' else @nomeDoSubgrupo end and
       TBS0671.PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       TBS010.MARCOD>=@codigoDaMarca and
       TBS010.MARNOM Like case when @nomeDaMarca='' then '[0-Z]%' else @nomeDaMarca end


-- funcionando

select rtrim(GRUDES)+' ('+Ltrim(str(TBS012.GRUCOD,3))+')' as 'grupo',
       rtrim(SUBGRUDES)+' ('+Ltrim(str(TBS0121.SUBGRUCOD,3))+')' as 'subGrupo',
       rtrim(TBS010.MARNOM)+' ('+Ltrim(str(MARCOD,4))+')' as 'MarcaDoProduto',
       Ltrim(str(TBS0671.SNESER,3))+'/'+Ltrim(str(TBS0671.NFSNUM,6)) as 'SerieENumeroDaNF',
       TBS0671.PROCOD as 'CodigoDoProduto',
       TBS0671.NFSPRODES as 'DescricaoDoProduto',
       NFSUNI as 'UnidadeDeMedida',
       NFSQTD as 'QuantidadeVendida',
       dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE) as 'ValorDoItem',
       dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE) as 'ValorTotal'
  from TBS0671 (nolock) join TBS010 (nolock) on TBS0671.PROCOD=TBS010.PROCOD
                        join TBS012 (nolock) on TBS012.GRUCOD=TBS010.GRUCOD
                        join TBS0121 (nolock) on TBS0121.GRUEMPCOD=TBS012.GRUEMPCOD and TBS0121.GRUCOD=TBS012.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD
                        join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and
                                                TBS067.NFSNUM=TBS0671.NFSNUM
                        join TBS042 (nolock) on TBS042.TESEMPCOD=TBS0671.TESEMPCOD and TBS042.TESCOD=TBS0671.TESCOD
                        join TBS002 (nolock) on TBS002.CLIEMPCOD=TBS067.NFSCLIEMP and TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSDATEMI between @dataDe and @dataAte and
       NFSTIP='N' and
       NFSCAN='N' and
       NFSDEV='N' and
       TESCNTVEN = 'S' and
       RDLCOD<>1 and
       TBS012.GRUCOD>=@codigoDoGrupo and
       TBS0121.SUBGRUCOD>=@codigoDoSubgrupo and
       TBS0671.PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       TBS010.MARCOD>=@codigoDaMarca and
       TBS010.MARNOM Like case when @nomeDaMarca='' then '[0-Z]%' else @nomeDaMarca end