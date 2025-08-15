declare @ProdutoDe varchar(15),@ProdutoAte varchar(15),@CodigoDaMarca smallint,@NomeDaMarca varchar(30)

set @ProdutoDe='0074605'
set @ProdutoAte='0074605'

set @CodigoDaMarca=0
set @NomeDaMarca=''

select rtrim(MARNOM)+' ('+ltrim(str(MARCOD,4)) as 'MarcaDoProduto',
       PROCOD as 'CodigoDoProduto',
       PRODES as 'DescricaoDoProduto',
       PROCODBAR1 as 'CodigoBarras1'
  from TBS010 (nolock)
 where PROCOD between @ProdutoDe and case when @ProdutoAte='' then 'Z' else @ProdutoAte end and
       MARCOD between @CodigoDaMarca and case when @CodigoDaMarca=0 then 9999 else @CodigoDaMarca end and
       MARNOM between @NomeDaMarca and case when @NomeDaMarca='' then 'Z' else @NomeDaMarca end
