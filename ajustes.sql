select *
  from INV01 with (nolock)
  
select *
  from INV04 with (nolock)
 where documento=20200422

select *
  from INV03 with (nolock)
 where documento=20200422
 order by id desc

select *
  from INV03 with (nolock)
 where dataContagem='20200422'

select *
  into INV03BKPDOC1404
  from INV03 with (nolock)
 where documento=20200414

select *
  from INV03BKPDOC1404 with (nolock)

-- ajuste da hora

select '0' + horaContagem 
       ,*
  from INV03 with (nolock)
 where documento=20200414
       and subString(horaContagem,2,1)=':'

begin tran
update INV03
   set horaContagem = '0' + horaContagem 
 where --documento=20200414
       --and
	   subString(horaContagem,2,1)=':'
commit tran

-- ajuste do minuto

select '0' + horaContagem 
       ,subString(horaContagem,1,3)+'0'+subString(horaContagem,4,4)
  from INV03 with (nolock)
 where documento=20200413
       and subString(horaContagem,5,1)=':'

begin tran
update INV03
   set horaContagem = subString(horaContagem,1,3)+'0'+subString(horaContagem,4,4)
 where --documento=20200414
       --and
	   subString(horaContagem,5,1)=':'
commit tran

-- ajuste do segundo

select '0' + horaContagem 
       ,subString(horaContagem,1,6)+'0'+subString(horaContagem,7,1)
  from INV03 with (nolock)
 where documento=20200413
       and subString(horaContagem,8,1)=''

begin tran
update INV03
   set horaContagem = subString(horaContagem,1,6)+'0'+subString(horaContagem,7,1)
 where --documento=20200414
       --and
	   subString(horaContagem,8,1)=''
commit tran

select *
  from INV05 with (nolock)
 where documento=20200422
 
select *
  from INV03 with (nolock)
 where documento=20200414
 order by dataContagem, Left(horaContagem,2)
 
select marca
  from INV03 with (nolock)
 where id >= 4300
 group by marca
 order by marca
 
select count(*)
  from INV03 with (nolock)
 where id >= 4300  
       and documento=20200414
	   
select count(*)
  from INV03 a with (nolock)
 where documento=20200414
       and not exists(select '' from INV05 b with (nolock) where b.documento=a.documento and b.codigoProduto=a.codigoProduto)

begin tran
update INV03
   set documento=20200415
 where id >= 4300  
       and documento=20200414
commit tran   

select *
  from INV03 with (nolock)
 where documento=20200416

select *
  from INV04 with (nolock)
 where documento=20200422
       and quantidade < 0
 
select *
  into INV04BKPDOC20200422
  from INV04 with (nolock)
 where documento=20200422

drop table INV04BKPDOC20200422

select Left(codigoProduto,4)
       ,marca
	   ,documento
	   ,count(*)
  from INV03 with (nolock)
 where documento = 20200422
  group by Left(codigoProduto,4), marca, documento

select Left(codigoProduto,4)
       ,marca
	   ,documento
	   ,count(*)
  from INV03 with (nolock)
 where documento between 20200413 and 20200416
  group by Left(codigoProduto,4), marca, documento
  order by Left(codigoProduto,4), marca, documento
  
select Left(codigoProduto,4)
  from INV03 with (nolock)
 where documento=20200415
  group by Left(codigoProduto,4)

drop table #INV04

select *
  into #INV04
  from INV04 with (nolock)
 where documento=20200422
       and Left(codigoProduto,4) in(select Left(codigoProduto,4)
                                      from INV03 with (nolock)
                                     where documento=20200422
                                     group by Left(codigoProduto,4))
 order by Left(codigoProduto,4)

select *
  from #INV04
  
select *
  --into INV0420200416
  from INV04 with (nolock)
 where documento=20200416

begin tran   
delete INV04
 where documento=20200422
commit tran

insert into INV04 (localEstoque, codigoProduto, quantidade, documento)
select localEstoque, codigoProduto, quantidade, documento from #INV04

select Left(codigoProduto,4)
	   ,documento
	   ,count(*)
  from INV04 with (nolock)
 where documento=20200417
  group by Left(codigoProduto,4), documento

select *
  from TBS032 with (nolock)
 where ESTLOC=1
       and ESTQTDRES < 0
	   
select *
  from INV04 with (nolock)
 where documento=20200422
       and quantidade <> (select ESTQTDATU 
                            from TBS032 with (nolock)
                           where ESTLOC=localEstoque
                                 and PROCOD=codigoProduto
							     and ESTQTDATU > 0)
	   
select *
  from INV05 with (nolock)
 where documento=20200416
	   
begin tran
delete INV05
 where documento=20200416
commit tran

select *
  from TBS032 with (nolock)
 where ESTLOC=1
       and ESTQTDATU < 0

select *
  from INV03 with (nolock)
 where documento=20200413
       and Left(codigoProduto,4)='0283'

select *
  from INV03 with (nolock)
 where documento=20200414
       and Left(codigoProduto,4)='0283'	   

select dataContagem
       ,horaContagem
       ,codigoProduto
	   ,descricaoProduto
  from INV03 with (nolock)
 where documento=20200414
       and Left(codigoProduto,4)='0283'	   

select dataContagem
       ,horaContagem
       ,codigoProduto
	   ,descricaoProduto
  from INV03 with (nolock)
 where documento=20200413
       and Left(codigoProduto,4)='0283'

-- ajustes dos lançamentos
	   
select right('000' + Ltrim(rtrim(cdprod)),8)
       ,*
  from movcaixagz with (nolock)
 where datamovto >= '20200413'
       and status='01'
	   and cancelado=''
	   --and cupom=27532
	   and not exists(select 'ne'
	                    from TBS010 with (nolock)
					   where PROCOD=right('000' + Ltrim(rtrim(cdprod)),8))

select right('000' + Ltrim(rtrim(cdprod)),8)
       ,*
  from movcaixagz with (nolock)
 where datamovto = '20200420'
       and status='01'
	   and cancelado=''
	   --and cupom=27532
	   and not exists(select 'ne'
	                    from TBS010 with (nolock)
					   where PROCOD=right('000' + Ltrim(rtrim(cdprod)),8))

select datamovto data
       ,right('000' + Ltrim(rtrim(cdprod)),8) codigo
       ,sum(quant) quantidade
	   ,count(*) conta
	   ,convert(varchar(8),datamovto,112)
  --into vendasgz
  from movcaixagz with (nolock)
 where datamovto >= '20200413'
       and status='01'
	   and cancelado=''
 group by datamovto, right('000' + Ltrim(rtrim(cdprod)),8)



select right('000' + Ltrim(rtrim(cdprod)),8)
       ,*
  from movcaixagz with (nolock)
 where datamovto >= '20200413'
       and status='01'
	   and Ltrim(cdprod)='3540029'

select right('000' + Ltrim(rtrim(cdprod)),8)
       ,*
  from movcaixagz with (nolock)
 where datamovto >= '20200413'
       and status='01'
	   and data <> datamovto

select documento
       ,count(*)
  from INV05 with (nolock)
 where documento >= 20200413
 group by documento
 order by documento

select *
  from vendasgz with (nolock)

 -- somas vendas gz total (independente do dia)

select right('000' + Ltrim(rtrim(cdprod)),8) codigo
       ,sum(quant) quantidade
	   ,count(*) conta
  into vendasgz
  from movcaixagz with (nolock)
 where datamovto >= '20200413'
       and status='01'
	   and cancelado=''
 group by right('000' + Ltrim(rtrim(cdprod)),8)

 drop table vendasgz

 -- somatório quantidades contadas no inventário

select codigoProduto codigo
       ,sum(c1) quantidade
	   ,count(*) conta
  into inventario1704
  from INV05 with (nolock)
 where documento >= 20200413
 group by codigoProduto

select *
  from inventario1704 with (nolock)

drop table inventario1704

-- itens vendidos não contados

select *
  into produtos_vendidos_nao_contados_1704
  from vendasgz a with (nolock)
 where not exists(select 'ne'
                    from inventario1704 b with (nolock) 
				   where b.codigo=a.codigo)

select *
  from produtos_vendidos_nao_contados_1704 with (nolock)

-- marcas vendidas, mas não contadas

select Left(tab.codigo,4)
       ,(select MARNOM from TBS014 with (nolock) where MARCOD=convert(smallint,Left(tab.codigo,4)))
  from
  (
    select *
      from vendasgz a with (nolock)
     where not exists(select 'ne'
                        from inventario1704 b with (nolock) 
				       where b.codigo=a.codigo)
  ) tab
 group by Left(tab.codigo,4)

-- tabela para lançamentos dos ajustes

select *
  from TBS032 with (nolock)
 where ESTQTDRES < 0

select T32.ESTLOC
       ,T32.PROCOD
	   ,T32.ESTQTDATU estoque_atual
	   ,isnull(INV.quantidade,0) inventario
	   ,isnull(GZ.quantidade,0) vendas_gz
	   ,0 diferenca
  --into ajuste_inventario_1704
  into #ajuste
  from TBS032 T32 with (nolock)
       inner join inventario1704 INV with (nolock)
	      on INV.codigo=T32.PROCOD
	   Left join vendasgz GZ with (nolock)
	      on GZ.codigo=T32.PROCOD
 where T32.ESTLOC=1
       and Len(T32.PROCOD) <= 8

select *
  --from ajuste_inventario_1704
  from #ajuste

-- diferenças nas quantidades contadas e saldos atuais

--update ajuste_inventario_1704
update #ajuste
   set diferenca=inventario-vendas_gz-estoque_atual

select *
  --from ajuste_inventario_1704
  from #ajuste
 where diferenca = 0

-- produtos com saldos e não contados

select *
  --into produtos_com_saldos_nao_contados
  from TBS032 A with (nolock)
  Left join inventario1704 B with (nolock)
     on A.PROCOD=B.codigo
 where A.ESTLOC=1
       and A.ESTQTDATU <> 0
	   and B.codigo is null

select *
  from produtos_com_saldos_nao_contados with (nolock)

-- cria movimento interno para lançamento dos ajustes

insert into TBS0371
   ( MVIEMPCOD
     ,MVIDOC
     ,MVIITE
     ,PROEMPCOD
     ,PROCOD
     ,MVIPRODES
     ,MVIPROUNI
     ,MVIQTDPED
     ,MVIQTDATD
     ,MVIQTDEMB
     ,MVIPROLOT
     ,MVIPROPESAVEL
     ,MVIPROLOCFIS
     ,MVIQTDCON
     ,MVIQTDRES
     ,MVIPROCOD
   )
--select 0
--       ,9201
--       ,row_number() over(order by INV.PROCOD)
--       ,0
--       ,INV.PROCOD
--       ,(select PRODES from TBS010 with (nolock) where TBS010.PROCOD=INV.PROCOD)
--       ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=INV.PROCOD)

--	   -- entradas
--       --,diferenca
--       --,diferenca

--	   -- saídas
--       ,diferenca * (-1)
--       ,diferenca * (-1)

--       ,1
--       ,''
--       ,(select PROPESAVEL from TBS010 with (nolock) where TBS010.PROCOD=INV.PROCOD)
--       ,''
--       ,0
--       ,0
--       ,''
--  from ajuste_inventario_1704 INV with (nolock)
-- where 
--       --diferenca > 0  -- entradas
--	   diferenca < 0  -- saídas

-- produtos com saldos no estoque e não contados

select 0
       ,9203
       ,row_number() over(order by NC.PROCOD)
       ,0
       ,NC.PROCOD
       ,(select PRODES from TBS010 with (nolock) where TBS010.PROCOD=NC.PROCOD)
       ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=NC.PROCOD)
	   -- saída
       ,NC.ESTQTDATU
       ,NC.ESTQTDATU
	   -- entrada
       --,NC.ESTQTDATU * (-1)
       --,NC.ESTQTDATU * (-1)
       ,1
       ,''
       ,(select PROPESAVEL from TBS010 with (nolock) where TBS010.PROCOD=NC.PROCOD)
       ,''
       ,0
       ,0
       ,''
  from produtos_com_saldos_nao_contados NC with (nolock)
 where
       --NC.ESTQTDATU < 0  -- entradas
	   NC.ESTQTDATU > 0  -- saídas

go

select *
  from TBS037 with (nolock)
 where MVIDOC=9202


select *
  from movcaixagz with (nolock)
 where datamovto >= '20200413'
       and status='01'
	   and cancelado=''

select a.ESTLOC
       ,a.PROCOD
	   ,a.ESTQTDATU est_atual
	   ,isnull((select ESTQTDATU from SIBD11042020.dbo.TBS032 b with (nolock) where b.ESTLOC=a.ESTLOC and b.PROCOD =a.PROCOD),0) est_anterior
	   ,isnull((select ESTQTDRES from SIBD11042020.dbo.TBS032 b with (nolock) where b.ESTLOC=a.ESTLOC and b.PROCOD =a.PROCOD),0) reserva_anterior
	   ,isnull((select sum(quant) from movcaixagz with (nolock) where datamovto >= '20200413' and rtrim(cdprod)=convert(int,PROCOD)),0) vendas_gz
	   ,isnull((select sum(c1) from INV05 with (nolock) where documento >= 20200413 and codigoProduto=PROCOD),0) inventario
   	   ,isnull((select sum(saldoAnterior) from INV05 with (nolock) where documento >= 20200413 and codigoProduto=PROCOD),0) saldo_anterior_inv04
       ,isnull((select sum(saldoEfetivo) from INV05 with (nolock) where documento >= 20200413 and codigoProduto=PROCOD),0) efetivado
  --into #ajuste
  from INV05 a with (nolock)
 where ESTLOC=1
       and Len(a.PROCOD) <= 8
	   and isnull((select sum(c1) from INV05 with (nolock) where documento >= 20200413 and codigoProduto=PROCOD),0) > 0

select codigoProduto codigo
       ,sum(c1) quantidade
	   ,count(*) conta
  from INV05 with (nolock)
 group by codigoProduto

select *
  from INV03 with (nolock)
 where documento >= 20200413
       and codigoProduto='00520025'

select *
  from TBS032 with (nolock)
 where ESTQTDRES <> 0

select *
  from TBS032 with (nolock)
 where ESTLOC=1
       and ESTQTDATU < 0

select *
  from INV03 with (nolock)
 where documento >= 20200413
       and codigoProduto in(select PROCOD
                             from TBS032 with (nolock)
                            where ESTLOC=1
							      and ESTQTDATU < 0)

select count(*)
  from INV05 with (nolock)
 where documento >= 20200413

select codigoProduto
       ,marca
	   ,codigoProduto
	   ,count(*)
  from INV03 with (nolock)
 where documento >= 20200413
       and Left(codigoProduto,4)='0283'
  group by codigoProduto, marca

select codigoProduto
  from INV03 with (nolock)
 where documento between 20200413 and 20200417
  group by codigoProduto
  order by codigoProduto

select A.codigoProduto codigo
       ,sum(quantidade) quantidade
  into seller27itens_faltantes
  from INV03 A with (nolock)
       Left join INV05 B with (nolock)
	      on A.codigoProduto=B.codigoProduto
 where A.documento between 20200413 and 20200417
       and B.codigoProduto is null
  group by A.codigoProduto
  order by A.codigoProduto

select *
  from seller27itens_faltantes with (nolock)

drop table seller27itens_faltantes

select *
  from seller27itens_faltantes A with (nolock)
  inner join vendasgz B with (nolock)
  on A.codigo=B.codigo


-- lançamento dos produtos da Seller, faltantes

begin tran
insert into TBS0371
   ( MVIEMPCOD
     ,MVIDOC
     ,MVIITE
     ,PROEMPCOD
     ,PROCOD
     ,MVIPRODES
     ,MVIPROUNI
     ,MVIQTDPED
     ,MVIQTDATD
     ,MVIQTDEMB
     ,MVIPROLOT
     ,MVIPROPESAVEL
     ,MVIPROLOCFIS
     ,MVIQTDCON
     ,MVIQTDRES
     ,MVIPROCOD
   )
select 0
       ,9204
       ,row_number() over(order by SEL.codigo)
       ,0
       ,SEL.codigo
       ,(select PRODES from TBS010 with (nolock) where TBS010.PROCOD=SEL.codigo)
       ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=SEL.codigo)
       ,quantidade
       ,quantidade
       ,1
       ,''
       ,(select PROPESAVEL from TBS010 with (nolock) where TBS010.PROCOD=SEL.codigo)
       ,''
       ,0
       ,0
       ,''
  from seller27itens_faltantes SEL with (nolock)
 
commit tran

select *
  from TBS032 with (nolock)
 where ESTLOC=1
       and ESTQTDATU > 0
	   and Left(PROCOD,4)='0283'

select PROCOD codigo
       ,PRODES descricao
	   ,ESTQTDATU quantidade
  from TBS032 with (nolock)
 where ESTLOC=1
       and ESTQTDATU > 0
	   and Left(PROCOD,4)='0283'
 order by PRODES

select *
  from inventario1704 with (nolock)
 where Left(codigo,4)='0283'

select *
  from INV05 with (nolock)
 where Left(codigoProduto,4)='0283'

 select *
  from INV03 with (nolock)
 where idColetor='C10-201811'
       and dataContagem='20200414'
 order by horaContagem

select *
  from TBS051 with (nolock)
 where LMEDATHOR >= '20200413'
       and LMEINFALT='R'
	   and LMEUSU='DESENV'
	   and LMEQTDSAL < 0

begin tran
delete TBS051
 where LMEDATHOR >= '20200413'
       and LMEINFALT='R'
	   and LMEUSU='DESENV'
	   and LMEQTDSAL < 0
commit tran

select documento
  from INV03 with (nolock)
 where dataContagem='20200422'
 group by documento

