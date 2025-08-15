declare @doc int, @local smallint

set @doc=20181215
set @local=2

-- progresso da contagem 1 em relação a quantidade de itens com saldo atual no estoque

select (select count(*) from INV04 with (nolock) where documento=@doc and localEstoque=@local) as saldoAnterior,
       (select count(distinct codigoProduto) from INV03 with (nolock) where documento=@doc and localEstoque=@local and numeroContagem=1) as contagem1,
       Ltrim(str((select count(distinct codigoProduto) from INV03 with (nolock) where documento=@doc and localEstoque=@local and numeroContagem=1)*100/
                 (select count(*) from INV04 with (nolock) where documento=@doc and localEstoque=@local),3))+'%' as progresso

-- andamento da contagem 2 em relação a contagem 1

select (select count(distinct codigoProduto) from INV03 with (nolock) where documento=@doc and localEstoque=@local and numeroContagem=1) as contagem1,
       (select count(distinct codigoProduto) from INV03 with (nolock) where documento=@doc and localEstoque=@local and numeroContagem=2) as contagem2,
       Ltrim(str((select count(distinct codigoProduto) from INV03 with (nolock) where documento=@doc and localEstoque=@local and numeroContagem=2)*100/
                 (select count(distinct codigoProduto) from INV03 with (nolock) where documento=@doc and localEstoque=@local and numeroContagem=1),3))+'%' as progresso


-- itens coletados por coletor

select idColetor,count(*) qtde_coletas from INV03 with (nolock) where documento=@doc and localEstoque=@local group by idColetor order by idColetor
