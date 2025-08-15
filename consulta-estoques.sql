declare
@empresa int, @codigoProduto varchar(20), 
@estoqueNd decimal(10,4), @lojaNd decimal(10,4), @comprasNd decimal(10,4),
@estoqueTt decimal(10,4), @lojaTt decimal(10,4), @comprasTt decimal(10,4),
@estoqueCd decimal(10,4), @lojaCd decimal(10,4), @comprasCd decimal(10,4),
@estoquePy decimal(10,4), @lojaPy decimal(10,4), @comprasPy decimal(10,4),
@estoqueBb decimal(10,4), @lojaBb decimal(10,4), @comprasBb decimal(10,4),
@estoqueMi decimal(10,4), @lojaMi decimal(10,4), @comprasMi decimal(10,4)

select @empresa=0, @codigoProduto='1080067'

--select
exec dbo.SP_WYEST087 @empresa, @codigoProduto, 
@estoqueNd output, @lojaNd output, @comprasNd output,
@estoqueTt output, @lojaTt output, @comprasTt output,
@estoqueCd output, @lojaCd output, @comprasCd output,
@estoquePy output, @lojaPy output, @comprasPy output,
@estoqueBb output, @lojaBb output, @comprasBb output,
@estoqueMi output, @lojaMi output, @comprasMi output


select @empresa, @codigoProduto, 
@estoqueNd, @lojaNd, @comprasNd,
@estoqueTt, @lojaTt, @comprasTt,
@estoqueCd, @lojaCd, @comprasCd,
@estoquePy, @lojaPy, @comprasPy,
@estoqueBb, @lojaBb, @comprasBb,
@estoqueMi, @lojaMi, @comprasMi
