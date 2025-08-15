drop procedure SP_GravaProdutoGZ
go

create procedure SP_GravaProdutoGZ @stringSQL varchar(500) as
begin
	declare @querySQL varchar(1000)

	set @querySQL  = 'insert into estoque (cdprod,descricao,descpdv,formula,unidade,termvenda,descpadrao,variavel,alterapre,multiplica,tributa,multiplos,embfechada,complement,sointeiro,st,situacao,multiatac,embfecatac,cfiscal,embfecesp,bloqvenda,solsenha,ippt,iat,ultatu,tipoitem,cargatrib,csosn,entregavel,chaveibpt,cstpis,aliqpis,cstcofins,aliqcofins,cest,precocusto)'
	set @querySQL += ' select ' + @stringSQL + ';'

	print @querySQL
	--EXECUTE(@querySQL) at MYSQLGZTEST
end

declare @x varchar(500)
set @x = '0018718,''.'',''.'',''N'',''UN'',0.000,''A'',''N'',''N'',''N'',1,1.000,''N'',''N'',''S'',''160'',''A'',0.000,''S'','''',''S'',''N'',''N'',''T'',''A'',''2020-04-03'',0,0.00,'''',''N'','''',''01'',1.65,''01'',7.60,'''',0.000'
--print @x

execute SP_GravaProdutoGZ '0018718,''.'',''.'',''N'',''UN'',0.000,''A'',''N'',''N'',''N'',1,1.000,''N'',''N'',''S'',''160'',''A'',0.000,''S'','''',''S'',''N'',''N'',''T'',''A'',''2020-04-03'',0,0.00,'''',''N'','''',''01'',1.65,''01'',7.60,'''',0.000'




drop type teste

create type DTproduto
	as table
	(
		id int identity(1,1)
		,CODIGO varchar(15) default ''
	);
go

declare @teste as DTproduto

insert into @teste select '1640054'
insert into @teste select '1080067'
insert into @teste select '8470030'

select *
  from @teste


drop function teste
go

CREATE FUNCTION testeTable()
RETURNS @tab TABLE
(codigo varchar(15), barras varchar(15), embalagem smallmoney, preco smallmoney)  
AS
begin
insert into @tab select '1640054', '123456789012', 10, 20.8
return
end
go

select * from  dbo.testeTable()  


select top 10 *
  from TBS031 with (nolock)


declare @dataDe date, @dataAte date, @hoje date, @marca int, @produtoDe varchar(15), @produtoAte varchar(15), @descricao varchar(60)

select @dataDe='01/04/2020', @dataAte='24/04/2020'

set @hoje='06/05/2020'

--select T10.PROCOD
--       ,T31.TDPDATATU
--	   ,T31.TDPVALPROI
--	   ,T31.TDPVALPROF
--  from TBS010 T10 with (nolock)
--       inner join TBS031 T31 with (nolock)
--	   on T31.TDPPROCOD=T10.PROCOD
-- where ((T31.TDPDATATU between @datade and @dataate)
--         or (T31.TDPVALPROI between DateAdd(d, DateDiff(d,0,@hoje) -3, 0) and @hoje)
--	     or (T31.TDPVALPROF between DateAdd(d, DateDiff(d,0,@hoje) -3, 0) and @hoje))

select T10.PROCOD as CodigoProduto
       ,T31.TDPDATATU DataHoraAtualizacao
	   ,T31.TDPVALPROI ValidadeInicial
	   ,T31.TDPVALPROF ValidadeFinal
	   ,(select preco1 from PrecoLoja(0,T10.PROCOD))
  from TBS010 T10 with (nolock)
       inner join TBS031 T31 with (nolock)
       on T31.TDPPROCOD=T10.PROCOD
 where (( T31.TDPDATATU >= @dataDe and T31.TDPDATATU <= @dataAte)
          or (T31.TDPVALPROI between DateAdd(d, DateDiff(d,0,@hoje) -3, 0) and @hoje)
		  or (T31.TDPVALPROF between DateAdd(d, DateDiff(d, 0, @hoje) - 3, 0) and @hoje))
	   
		  --and T10.MARCOD = @marca

SELECT DATEDIFF ( DAY , '02/01/2004' , 1)

select dateadd(DATEDIFF(day, '2020-04-10',3))

select getdate()-3

DECLARE @dia    INT;
DECLARE @inicio DATE;
DECLARE @fim    DATE;

SET @dia = 26;

SET @inicio = DATEADD(DAY, @dia, EOMONTH(GETDATE(), -2));
SET @fim = DATEADD(DAY, -1, DATEADD(MONTH, 1, @inicio));

select @inicio, @fim

select DateAdd(d, DateDiff(d,0,'20200603') -3, 0)


select top 1 *
  from TBS0103 with (nolock)
 where CBPDATALT between '20200101' and '20200522'
