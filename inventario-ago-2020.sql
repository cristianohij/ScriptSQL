select *
  from INV03 with (nolock)
 where documento='20200808'
       and codigoProduto='4520701'

select *
  from INV03 with (nolock)
 where documento='20200806'
       and numeroContagem=3

select *
  from INV05 with (nolock)
 where documento='20200808'
       and codigoProduto='4520701'

select top 1 *
  from INV05 with (nolock)

select *
  from INV03 i3 with (nolock)
 inner join INV05 i5 with (nolock)
    on i3.documento=i5.documento
	   and i3.codigoProduto=i5.codigoProduto
 where i3.documento=20200808
       --and i3.quantidade not in(i5.c1, i5.c2, i5.c3, i5.c4, i5.c5, i5.c6)
	   and (i3.quantidade<>c1
	        or i3.quantidade<>c2
			or i3.quantidade<>c3
			or i3.quantidade<>c4
			or i3.quantidade<>c5
			or i3.quantidade<>c6)
 order by i3.codigoProduto
          ,i3.numeroContagem

select *
  from INV03 i3 with (nolock)
 inner join INV05 i5 with (nolock)
    on i3.documento=i5.documento
	   and i3.codigoProduto=i5.codigoProduto
 where i3.documento=20200808
       and i3.numeroContagem=5
       and i3.quantidade<>i5.c5
 order by i3.codigoProduto
          ,i3.numeroContagem

select *
  from INV03 i3 with (nolock)
 inner join INV05 i5 with (nolock)
    on i3.documento=i5.documento
	   and i3.codigoProduto=i5.codigoProduto
 where i3.documento=20200808
       and i3.codigoProduto='4520701'

select *
  from INV03 with (nolock)
 where documento=20200808
       and Left(localizacao,2)='04'
	   and numeroContagem=3

begin tran
delete INV05
 where documento=20200806
commit tran

select *
  from INV05 with (nolock)
 where documento='20200806'
       and c1 <> saldoAnterior

select *
  from INV04 with (nolock)
 where documento='20200806'
       and quantidade=0
	   and Left(localizacao,2)='08'
 order by codigoProduto

select *
  from INV03 LAN with (nolock)
  Left join INV04 EST with (nolock)
  on EST.documento=LAN.documento
     and EST.codigoProduto=LAN.codigoProduto
 where LAN.documento='20200806'
       and LAN.codigoProduto='0055730'

update INV04
   set localizacao=isnull((select PROLOCFIS from TBS010 with (nolock) where PROCOD=codigoProduto),'')
 where documento=20201026

update INV04
   set localizacao=''
 where documento=20200808
       and localizacao is null

select *
  from INV03 LAN with (nolock)
  right join INV04 EST with (nolock)
  on EST.documento=LAN.documento
     and LAN.codigoProduto=EST.codigoProduto
 where EST.documento='20200806'
       and Left(EST.localizacao,2)='08'
       and LAN.codigoProduto is null



-- comparações

select *
  from INV05 with (nolock)
 where documento=20200808
 order by codigoProduto

select *
  from INV05 with (nolock)
 where documento=20200808
 order by Left(e1,2)

select *
  from INV05 with (nolock)
 where documento=20200808
       and Left(e1,2) not in('04','08','10','11','28')

select *
  from INV05 with (nolock)
 where documento=20200808
       and Left(e1,2)='04'
 order by codigoProduto desc

begin tran
update INV05
   set c3=42
 where documento=20200808
       and codigoProduto='8870003'
commit tran

--begin tran
--update INV03
--   set quantidade=42
-- where documento=20200808
--       and numeroContagem=3
--       and codigoProduto='8870003'
--commit tran

--begin tran
--update INV03
--   set quantidade=42
-- where documento=20200808
--       and numeroContagem=4
--       and codigoProduto='8870003'
--commit tran

select *
  from INV03 with (nolock)
 where documento=20200818
       and Left(endereco,2) not in('02','03')

select count(*) itens_contados
  from INV05 with (nolock)
 where documento=20200806

select count(*)
  from INV05 with (nolock)
 where documento=20201019
       and Left(e1,2)='13'

select count(*) -- c1_ok
  from INV05 with (nolock)
 where documento=20201019
       and c1=saldoAnterior
	   and Left(e1,2)='13'
  --group by codigoProduto

select count(*) -- c1_divergente
  from INV05 with (nolock)
 where documento=20201019
       and c1<>saldoAnterior
	   and Left(e1,2)='13'

select * -- c2_ok
  from INV05 with (nolock)
 where documento=20200921
       and Left(e1,2)='42'
       and c1<>saldoAnterior
	   and (c2=c1 or c2=saldoAnterior)

select * -- c2_divergente
  from INV05 with (nolock)
 where documento=20201019
       and Left(e1,2)='13'
       and c1<>saldoAnterior
	   and c2<>c1
	   and c2<>saldoAnterior

--begin tran
--update INV05
--   set c2=0
-- where documento=20200808
--       and Left(e1,2)='04'
--commit tran

select * -- c3_divergente
  from INV05 with (nolock)
 where documento=20201019
       and Left(e1,2)='13'
       and c1<>saldoAnterior
	   and c2<>c1
	   and c2<>saldoAnterior
	   and c3<>c1
	   and c3<>c2
	   and c3<>saldoAnterior

select * -- c4_divergente
  from INV05 with (nolock)
 where documento=20201019
       and Left(e1,2)='13'
       and c1<>saldoAnterior
	   and c2<>c1
	   and c2<>saldoAnterior
	   and c3<>c1
	   and c3<>c2
	   and c3<>saldoAnterior
	   and c4<>c1
	   and c4<>c2
	   and c4<>c3
	   and c4<>saldoAnterior

select * -- c5_divergente
  from INV05 with (nolock)
 where documento=20200808
       and Left(e1,2)='04'
       and c1<>saldoAnterior
	   and c2<>c1
	   and c2<>saldoAnterior
	   and c3<>c1
	   and c3<>c2
	   and c3<>saldoAnterior
	   and c4<>c1
	   and c4<>c2
	   and c4<>c3
	   and c4<>saldoAnterior
	   and c5<>c1
	   and c5<>c2
	   and c5<>c3
	   and c5<>c4
	   and c5<>saldoAnterior

select *
  from INV05 with (nolock)
 where documento=20201019
       and (    (c1=0 and c2 > 0)
             or (c2=0 and c3 > 0)
	         or (c3=0 and c4 > 0)
	         or (c5=0 and c6 > 0) )


select count(*) c1_igual_saldo
  from INV05 with (nolock)
 where documento=20200808
       and c1=saldoAnterior
	   and Left(e1,2)='28'
  --group by codigoProduto

select count(*) c1_diferente_saldo
  from INV05 with (nolock)
 where documento=20200808
       and c1<>saldoAnterior
	   and Left(e1,2)='28'

select --count(*) c2_diferente_saldo
       *
  from INV05 with (nolock)
 where documento=20200806
       and c1<>saldoAnterior
	   and c2<>c1
       and c2=saldoAnterior
 order by codigoProduto

select --count(*) c2_diferente_saldo
       *
  from INV05 with (nolock)
 where documento=20200806
       --and c1<>saldoAnterior
	   and c1=saldoAnterior
	   --and c2<>c1
	   --and c2 > 0
    --   and c2=saldoAnterior
 order by codigoProduto

select *
  --into INV05BKP
  from INV05 with (nolock)
 where documento=20200806
       --and saldoEfetivo = 0
	   and c1<>saldoAnterior
	   and c2 > 0
	   and (c2=c1 or c2=saldoAnterior)
 order by codigoProduto

-- terceira contagem
select *
  from INV05 with (nolock)
 where documento=20200806
       and saldoEfetivo = 0
	   --and c1<>saldoAnterior
	   and c3 > 0
	   and (c3=c1 or c3=c2 or c3=saldoAnterior)
 order by codigoProduto

select *
  from INV04 with (nolock)
 where documento='20200806'
       and codigoProduto='0051535'

select count(*) itens_contados_3
  from INV05 with (nolock)
 where documento=20200806
       and c3 > 0

begin tran
update INV05
   set lancar=0
       ,saldoEfetivo=0
 where documento=20200806
       and c1<>saldoAnterior
commit tran

begin tran
update INV05
   set lancar=c3
       ,saldoEfetivo=c3
 where documento=20200806
       /* segunda contagem
	   and c1<>saldoAnterior
	   and c2 > 0
	   and (c2=c1 or c2=saldoAnterior) */

       and saldoEfetivo = 0
	   and c3 > 0
	   and (c3=c1 or c3=c2 or c3=saldoAnterior)

commit tran

begin tran
update INV05
   set c2=18
--  from INV05 with (nolock)
 where documento='20200806'
       and codigoProduto='8490112'
commit tran

select T10.PROCOD
       ,PROLOCFIS
       ,ESTQTDATU
	   ,ESTQTDRES
	   ,ESTQTDATU-ESTQTDRES
  from TBS010 T10 with (nolock)
  inner join TBS032 T32 with (nolock)
  on T10.PROCOD=T32.PROCOD
 where Left(T10.PROLOCFIS,2) in('05')	--,'08','10','11','28')
       and T32.ESTLOC=1
	   and ESTQTDATU-ESTQTDRES > 0
 order by T10.PROCOD

select T10.PROCOD
       ,PROLOCFIS
       ,ESTQTDATU
	   ,ESTQTDRES
	   ,ESTQTDATU-ESTQTDRES
  from TBS010 T10 with (nolock)
  inner join TBS032 T32 with (nolock)
  on T10.PROCOD=T32.PROCOD
 where Left(T10.PROLOCFIS,2) in('04','08','10','11','28')
       and T32.ESTLOC=1
	   and ESTQTDRES > 0
 order by T10.PROCOD

select T10.PROCOD
       ,PROLOCFIS
       ,ESTQTDATU
	   ,ESTQTDRES
	   ,ESTQTDATU-ESTQTDRES
  from TBS010 T10 with (nolock)
  inner join TBS032 T32 with (nolock)
  on T10.PROCOD=T32.PROCOD
 where Left(T10.PROLOCFIS,2) in('04','08','10','11','28')
       and T32.ESTLOC=1
	   and ESTQTDATU > 0
 order by T10.PROCOD

select T10.PROCOD
       ,PROLOCFIS
       ,ESTQTDATU
	   ,ESTQTDRES
	   ,ESTQTDATU-ESTQTDRES
  from TBS010 T10 with (nolock)
  inner join TBS032 T32 with (nolock)
  on T10.PROCOD=T32.PROCOD
 where Left(T10.PROLOCFIS,2)='04,''08','10','11','28')
       and T32.ESTLOC=1
	   and ESTQTDATU > 0
 order by T10.PROCOD

select *
  from TBS037 with (nolock)
 where MVIDOC=225587


begin tran
update TBS037
   set MVITRM=0
 where MVIDOC=225587
commit tran  

select *
  from INV05 with (nolock)
 where documento=20200806
       and c1=saldoAnterior
       and not exists(select 'ne' from TBS0371 with (nolock) where MVIDOC=225587 and PROCOD=codigoProduto)

select *
  from INV05 with (nolock)
 where documento=20200808
       and saldoEfetivo = 0

select *
  from INV05 with (nolock)
 where documento=20200808
       and c5 > 0

select *
  from INV05 i with (nolock)
  inner join TBS0371 m with (nolock)
  on i.codigoProduto=m.PROCOD
 where i.documento=20200806
       and m.MVIDOC=225674
	   and m.MVIQTDATD<>i.saldoEfetivo

select *
  from INV05 with (nolock)
 where documento=20200818
       --and saldoEfetivo <= 0
 order by codigoProduto




select *
  from INV02 with (nolock)

delete INV02

DBCC CHECKIDENT ('INV02', RESEED, 0)

insert into INV02
(endereco, ativado)
select Left(PROLOCFIS,2)
       ,'N'
  from TBS010 with (nolock)
  where Left(PROLOCFIS,2)<>''
 group by Left(PROLOCFIS,2)
 order by Left(PROLOCFIS,2)

select endereco as rua
  from INV04 with (nolock)
 order by endereco


select *
  into INV05BKP08082020
  from INV05 with (nolock)

select *
  from INV05BKP08082020 with (nolock)
 where documento=20200808
       and codigoProduto in('0072176','8490480','4520701')

select *
  into IN0520200908
  from INV05 with (nolock)
 where documento=20200908

select *
  from INV05 with (nolock)
 where documento=20200908
       and saldoEfetivo > 0
       and saldoEfetivo in(c1,c2,c3,c4,c5,c6)



