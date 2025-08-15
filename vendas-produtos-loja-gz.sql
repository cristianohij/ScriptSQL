declare @dataDe varchar(8),@dataAte varchar(8),@produtoDe varchar(15),@produtoAte varchar(15),@codigoDaMarca smallint,@nomeDaMarca varchar(30)

set @dataDe='20150519'
set @dataAte='20150519'

set @produtoDe=''
set @produtoAte=''

set @codigoDaMarca=0
set @nomeDaMarca=''

select (select rtrim(MARNOM)+' ('+ltrim(str(MARCOD,4))+')' from TBS010 (nolock) where TBS010.PROCOD=MSL002.M2_PROCOD) as 'NomeECodigoDaMarca',
       MSL002.M2_PROCOD as 'CodigoDoProduto',
       isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=MSL002.M2_PROCOD),'') as 'DescricaoDoProduto',
       sum(MSL002.M2_QTD) as 'QuantidadeVendida',
       isnull((select ESTQTDCMP from TBS032 (nolock) where TBS032.PROCOD=MSL002.M2_PROCOD and ESTLOC=1),0) as 'QuantidadeComprada',
       isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=MSL002.M2_PROCOD),'') as 'UnidadeDeMedida',
       avg(MSL002.M2_VALTOT-MSL002.M2_ABT) as 'ValorMedioDoItem',
       isnull((select TBS032.ESTQTDATU-TBS032.ESTQTDRES from TBS032 (nolock) where TBS032.PROCOD=MSL002.M2_PROCOD and ESTLOC=2),0) as 'QuantidadeDisponivel',
       isnull((select PROCODBAR1 from TBS010 (nolock) where TBS010.PROCOD=MSL002.M2_PROCOD),0) as 'CodigoDeBarras1',
       isnull((select PROCODBAR2 from TBS010 (nolock) where TBS010.PROCOD=MSL002.M2_PROCOD),0) as 'CodigoDeBarras2',
       isnull((select PROLOCFIS from TBS010 (nolock) where TBS010.PROCOD=MSL002.M2_PROCOD),'') as 'LocalizacaoFisica',
       sum(MSL002.M2_VALTOT-MSL002.M2_ABT) as 'TotalVendido'
  from MSL002 (nolock)
       left join TBS010 (nolock) on TBS010.PROCOD=MSL002.M2_PROCOD
 where MSL002.M2_DAT between @dataDe and @dataAte and
       MSL002.M2_PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       MSL002.M2_TIPREG='01' and
       MSL002.M2_REGCAN='F' and
       TBS010.MARCOD between @codigoDaMarca and case when @codigoDaMarca=0 then 9999 else @codigoDaMarca end and
       TBS010.MARNOM between @nomeDaMarca and case when @nomeDaMarca='' then 'Z' else @nomeDaMarca end
 group by MSL002.M2_PROCOD
