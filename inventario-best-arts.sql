-- lançar contagem na INV05
-- doc, contagem, local, rua
exec dbo.LancarInventario 20201019, 4, 1, '13'

-- endereça a contagem
-- doc, local
exec EnderecoContagem 20201019, 1

-- consolidar a contagem, produtos a serem lançados
-- documento, número da contagem, local do estoque, se grava saldo, se recalcula
exec dbo.ConsolidarContagem 20201019, 4, 1, 'N', 'N'

-- zerar quantidade a lançar
begin tran
update INV05
   set lancar=0
 where documento=20200422
commit tran

-- saldo para lançamento
begin tran
update INV05
   set lancar=c1 -- -saldoAnterior
 where documento=20200422
rollback tran
commit tran

begin tran
update INV05
   set saldoEfetivo=lancar
 where documento=20200422
rollback tran
commit tran

-- produtos com divergências
select count(*)
  from INV05 with (nolock)
 where documento=20200422
       and lancar > 0

declare @MVIDOC int

exec dbo.SequencialTabela 'TBS037', @sequencia = @MVIDOC output

-- assinatura: GravaCabecalhoMI (@MVIDOC int, @LOCAL smallint, @TMVCOD int, @CCSCOD int, @MVIOBS varchar(200))

-- movimento de entrada
exec dbo.GravaCabecalhoMI @MVIDOC, 1, 4, 258, 'RETORNO DO SALDO DA 14 NAO HOUVE INVENTARIO'

-- movimento de saída
--exec dbo.GravaCabecalhoMI @MVIDOC, 1, 503, 47, 'INVENTÁRIO'

-- assinatura: GravaItemMI (@MVIDOC int, @LOCAL smallint, @doc int)

exec dbo.GravaItemMI @MVIDOC, 1, 20201026

print 'Documento: ' + Ltrim(str(@MVIDOC,6))

select *
  from TBS037 with (nolock)
 where MVIDOC=225764

select *
  from TBS0371 with (nolock)
 where MVIDOC=225764

-- zerar não encontrados

declare @MVIDOC int

exec dbo.SequencialTabela 'TBS037', @sequencia = @MVIDOC output

-- assinatura: GravaCabecalhoMI (@MVIDOC int, @LOCAL smallint, @TMVCOD int, @CCSCOD int, @MVIOBS varchar(200))

-- movimento de entrada
--exec dbo.GravaCabecalhoMI @MVIDOC, 1, 5, 47, 'PRODUTOS NÃO ENCONTRADOS NO INVENTÁRIO'

-- movimento de saída
exec dbo.GravaCabecalhoMI @MVIDOC, 1, 503, 47, 'PRODUTOS NÃO ENCONTRADOS NO INVENTÁRIO'

-- assinatura: ZerarNaoEncontrados (@MVIDOC int, @LOCAL smallint, @doc int)

exec dbo.ZerarNaoEncontrados @MVIDOC, 1, 20200417

print 'Documento: ' + Ltrim(str(@MVIDOC,6))



-- correções

select PROCOD
       ,MVIPRODES
	   ,MVIPROUNI
	   ,convert(int,MVIQTDPED)
  from TBS0371 with (nolock)
 where MVIDOC in(9176, 9179)
 
select idColetor
       ,count(*)
  from INV03 with (nolock)
 where documento=20200414
 group by idColetor

select TBS010.PROCOD as codigo, TBS010.PRODES as descricao, TBS010.PROUM1 as unidade1, TBS010.PROUMV as menorunidade,
                    TBS010.PROUM1QTD as embalagem1, TBS014.MARNOM as marca, TBS010.PROLOCFIS as localizacao, TBS010.PROSTATUS as status,
                    TBS010.PROSETLOJ1 as setorLoj1, TBS010.PROSETLOJ2 as setorLoj2
                    from TBS010 with (nolock)
                    Left join TBS0103 with (nolock) on TBS0103.CBPPROCOD=TBS010.PROCOD collate database_default
                    inner join TBS014 with (nolock) on TBS014.MARCOD=TBS010.MARCOD
                    where PROCOD='03240837'
                    or TBS0103.CBPCODBAR='03240837'
select PROLOCFIS
       ,*
  from TBS010 with (nolock)
 where PROCOD='01990113'
 

begin tran 
update TBS010
   set PROLOCFIS=''
 where PROCOD='01990113'
commit tran

select PROLOCFIS
       ,*
  from TBS010 with (nolock)
 where PROLOCFIS != ''
       and isnumeric(PROLOCFIS)=0

select PROCOD
       ,PROLOCFIS
	   ,PRODES
	   ,PROCODBAR1
	   ,PROCODBAR2
	   ,PROCODBAR3
	   ,PROCODBAR4
  into BARRAS
  from TBS010 with (nolock)
 where PROLOCFIS != ''
       and isnumeric(PROLOCFIS)=1
	   and Len(PROLOCFIS) > 10

select *
  from BARRAS
  
begin tran
update TBS010
   set PROLOCFIS=''
 where PROLOCFIS != ''
commit tran

-- entradas
select *
  from INV05 with (nolock)
 where documento='20200414'
       and lancar > 0
  
-- saidas
select *
  from INV05 with (nolock)
 where documento='20200414'
       and lancar < 0

select *
  from TBS037 with (nolock)
 where MVIDOC=230009

begin tran
delete TBS0371
 where MVIDOC=919
commit tran

begin tran
update TBS037
   set MVITRM=0
 where MVIDOC=225674
commit tran  

begin tran
update TBS037
   set MVILOCORI=1, MVILOCDES=0
 where MVIDOC=9199
commit tran  
rollback tran

select *
  from INV04 a with (nolock)
       inner join TBS032 b with (nolock)
       on ESTLOC=localEstoque and b.PROCOD=a.codigoProduto
 where a.documento=20200416
       and a.localEstoque=1
       and isnull((select 1
                     from INV05 b with (nolock)
                    where b.documento=a.documento
			              and b.codigoProduto=a.codigoProduto),0) = 0
       and b.ESTQTDATU < 0

begin tran
update INV05
   set lancar=0
 where documento='20200413'
commit tran

begin tran
update INV05
   set lancar=c1-saldoAnterior
 where documento='20200413'
rollback tran
commit tran


-- analises 16/04/2020

declare @codigo varchar(15), @doc int

set @codigo = '00060963'

-- contagem
select *
  from INV03 with (nolock)
 where codigoProduto=@codigo

--set @doc=(select documento from INV03 with (nolock)
 --where codigoProduto=@codigo

-- saldo no estoque
select *
  from INV04 with (nolock)
 where codigoProduto=@codigo
       and documento=20200413

-- saldo a serem lançados	   
select *
  from INV05 with (nolock)
 where codigoProduto=@codigo
       and documento=20200413

-- movimentos internos
select *
  from TBS0371 with (nolock)
 where MVIDOC >= 9172
       and PROCOD=@codigo
	    
-- saldo atual após contagem 
select *
  from TBS032 with (nolock) 
 where ESTLOC=1
       and PROCOD=@codigo



select *
  from TBS032 with (nolock)
 where PROCOD='00730056'
 
select *
  from movcaixagz
 where datamovto >= '20200413'
       and status='01'
	   
select *
  from movcaixagz
 where datamovto >= '20200413'
       and status='01'

drop table #ajuste

select a.ESTLOC
       ,a.PROCOD
	   ,a.ESTQTDATU est_atual
	   ,isnull((select ESTQTDATU from SIBD11042020.dbo.TBS032 b with (nolock) where b.ESTLOC=a.ESTLOC and b.PROCOD =a.PROCOD),0) est_anterior
	   ,isnull((select ESTQTDRES from SIBD11042020.dbo.TBS032 b with (nolock) where b.ESTLOC=a.ESTLOC and b.PROCOD =a.PROCOD),0) reserva_anterior
	   ,isnull((select sum(quant) from movcaixagz with (nolock) where datamovto >= '20200413' and rtrim(cdprod)=convert(int,PROCOD)),0) vendas_gz
	   ,isnull((select sum(c1) from INV05 with (nolock) where documento >= 20200413 and codigoProduto=PROCOD),0) inventario
   	   ,isnull((select sum(saldoAnterior) from INV05 with (nolock) where documento >= 20200413 and codigoProduto=PROCOD),0) saldo_anterior_inv04
       ,isnull((select sum(saldoEfetivo) from INV05 with (nolock) where documento >= 20200413 and codigoProduto=PROCOD),0) efetivado
  into #ajuste
  from TBS032 a with (nolock)
 where ESTLOC=1
       and Len(a.PROCOD) <= 8
	   and isnull((select sum(c1) from INV05 with (nolock) where documento >= 20200413 and codigoProduto=PROCOD),0) > 0
	   
--	   and ESTQTDATU != ( --(select ESTQTDATU from SIBD11042020.dbo.TBS032 b with (nolock) where b.ESTLOC=a.ESTLOC and b.PROCOD =a.PROCOD)
	                      --isnull((select sum(c1) from INV05 with (nolock) where documento >= 20200413 and codigoProduto=PROCOD),0)
	                      ---
	                      --isnull((select sum(quant) from movcaixagz with (nolock) where datamovto >= '20200413' and cdprod=convert(int,PROCOD)),0)
						--)

drop table #lancar
go

select *
       ,inventario-vendas_gz saldo_correto
	   ,(inventario-vendas_gz)-est_atual diferenca
  into #lancar
  from #ajuste

select *
--  into lancar_correcao
  from #lancar
 where diferenca <> 0
       and PROCOD in(select PROCOD
                       from TBS032 with (nolock)
                      where ESTLOC=1
                            and ESTQTDATU < 0)

select PROCOD
  from TBS032 with (nolock)
 where ESTLOC=1
       and ESTQTDATU < 0
	   and PROCOD not in(select PROCOD
                           from #lancar
                          where diferenca <> 0)

select *
--  into lancar_correcao
  from #lancar
 where PROCOD='00260161'

select *
--  into lancar_correcao
  from #lancar
 where diferenca <> 0
       and Left(PROCOD,4) in(select Left(codigoProduto,4)
                               from INV03 with (nolock)
                              where documento between 20200413 and 20200416
                              group by Left(codigoProduto,4))


INSERT INTO [dbo].[TBS0371]
           ([MVIEMPCOD]
           ,[MVIDOC]
           ,[MVIITE]
           ,[PROEMPCOD]
           ,[PROCOD]
           ,[MVIPRODES]
           ,[MVIPROUNI]
           ,[MVIQTDPED]
           ,[MVIQTDATD]
           ,[MVIQTDEMB]
           ,[MVIPROLOT]
           ,[MVIPROPESAVEL]
           ,[MVIPROLOCFIS]
           ,[MVIQTDCON]
           ,[MVIQTDRES]
           ,[MVIPROCOD])
     select 0
            ,9190
            ,row_number() over(order by #lancar.PROCOD)
            ,0
            ,PROCOD
            ,(select PRODES from TBS010 with (nolock) where TBS010.PROCOD=#lancar.PROCOD)
            ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=#lancar.PROCOD)
            ,diferenca
            ,diferenca
            ,1
            ,''
            ,(select PROPESAVEL from TBS010 with (nolock) where TBS010.PROCOD=#lancar.PROCOD)
            ,''
            ,0
            ,0
            ,''
	   from #lancar
      where diferenca < 0
	  
GO

begin tran
update TBS0371
   set MVIQTDPED=MVIQTDPED*(-1), MVIQTDATD=MVIQTDATD*(-1)
 where MVIDOC=9190
commit tran

select *
  from TBS0371 with (nolock)
 where MVIDOC=9190
 order by MVIITE 
 						
select documento
       ,codigoProduto
       ,count(*)
  from INV03 with (nolock)
 where dataContagem >= '20200413'
 group by documento, codigoProduto
 having count(*) > 1
 
select *
  from INV03 a with (nolock)
 where a.dataContagem >= '20200413'
       and isnull((select count(*)
	                 from INV03 b with (nolock)
					where b.documento <> a.documento
                          and b.dataContagem >= a.dataContagem
					      and b.localEstoque=a.localEstoque
						  and b.codigoProduto=a.codigoProduto),0) > 1
 
select documento
       ,codigoProduto
       ,count(*)
  from INV05 with (nolock)
 where documento >= 20200413
 group by documento, codigoProduto
 having count(*) > 1 

select *
  from movcaixagz
 where datamovto >= '20200415'
       and status='01'
 order by hora desc	   




