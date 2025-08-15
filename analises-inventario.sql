select * from TBS032 with (nolock) where ESTLOC=1 and ESTQTDATU < 0

select * from INV01 with (nolock) where localEstoque=2

select top 1 * from INV03 with (nolock)

select * from INV03 with (nolock)
 where documento=20181215 and localEstoque=2 and codigoProduto='0051942'

--select top 1 * from INV05 with (nolock)

select * from INV05 with (nolock)
 where documento=20181215 and localEstoque=2 and codigoProduto='0051942'

--select top 1 * from INV04 with (nolock)

select * from INV04 with (nolock) where documento=20181215 and localEstoque=2 and codigoProduto='0051942'

select *
  from INV04 with (nolock)
 where documento=20181215 and localEstoque=2
       and exists(select '' from TBS032 with (nolock) where ESTLOC=localEstoque and PROCOD=codigoProduto and ESTQTDATU < 0)
       and not exists(select '' from INV03 with (nolock) where INV03.documento=INV04.documento and INV03.localEstoque=INV04.localEstoque
       and INV03.codigoProduto=INV04.codigoProduto)

select documento,count(*) from INV05 with (nolock) group by documento

