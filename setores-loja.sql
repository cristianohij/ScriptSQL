select *
  from INV03 a with (nolock)
       Left join INV03 b with (nolock)
       on a.codigoProduto=b.codigoProduto
 where a.endereco='E-08'
       and b.endereco!='E-08'
 order by a.codigoProduto

select count(*) from INV03 with (nolock) where endereco='Z'

select count(*) from INV03 with (nolock) where endereco='E-07'

select *
  from INV03 a with (nolock)
 where endereco='E-08'
       and exists(select '' from INV03 b with (nolock) where b.endereco='E-07' and b.codigoProduto=a.codigoProduto)

select * into INV03BKPTROCAZ from INV03 with (nolock)

begin tran
update INV03 set endereco='E-08' where endereco='Z'
commit tran

select distinct PROSETLOJ1 from TBS010 with (nolock)

select * from INV03 with (nolock) where codigoProduto='5410422'

select *
  from INV03 with (nolock)
 where endereco!='E-08'
       and codigoProduto in
(
select a.codigoProduto
  from INV03 a with (nolock)
       Left join INV03 b with (nolock)
       on a.codigoProduto=b.codigoProduto
 where a.endereco='E-08'
       and b.endereco='E-07'
)

begin tran
delete INV03
  from INV03 with (nolock)
 where endereco!='E-08'
       and codigoProduto in
(
select a.codigoProduto
  from INV03 a with (nolock)
       Left join INV03 b with (nolock)
       on a.codigoProduto=b.codigoProduto
 where a.endereco='E-08'
       and b.endereco='E-07'
)

commit tran

select distinct endereco from INV03 with (nolock) order by endereco


select PROSETLOJ1,PROSETLOJ2,PROCOD,PRODES
  from TBS010 with (nolock)
 where PROSETLOJ1!='' -- or PROSETLOJ2!=''
       and exists(select '' from INV03 with (nolock) where replace(endereco,'-','')=PROSETLOJ1 and codigoProduto=PROCOD)
 order by PROSETLOJ1

select e1,e2,codigoProduto
  from INV05 with (nolock)
 where not exists(select '' from TBS010 with (nolock) where PROCOD=codigoProduto and PROSETLOJ1=replace(e1,'-',''))
 order by codigoProduto

select distinct documento from INV03 with (nolock)

select count(*) from INV03 with (nolock)
union
select count(*) from TBS010 with (nolock) where PROSETLOJ1 != ''

select count(*) from TBS032 with (nolock) where ESTLOC=2 and ESTQTDATU > 0

select count(*) from TBS032 with (nolock) where ESTLOC=2 and ESTQTDATU != 0

select *
  from INV03 a with (nolock)
 where endereco='D-01'
       and exists(select '' from INV03 b with (nolock) where b.endereco='Y' and b.codigoProduto=a.codigoProduto)

select *
  from INV03 a with (nolock)
       Left join INV03 b with (nolock)
       on a.codigoProduto=b.codigoProduto
 where a.endereco='D-01'
       and b.endereco='Y'
 order by a.codigoProduto

select * into INV03_14_12_18 from INV03 with (nolock)

begin tran
delete INV03
  from INV03 a with (nolock)
 where endereco='D-01'
       and exists(select '' from INV03 b with (nolock) where b.endereco='Y' and b.codigoProduto=a.codigoProduto)

rollback tran
commit tran

select * from INV03 with (nolock) where endereco='D-01' -- 1.502 - 350 = 1.152

select * from INV03 with (nolock) where endereco='Y' -- 353

select * from INV03 with (nolock) where endereco='D-02' -- 228 + 353 = 581

begin tran
update INV03 set endereco='D-02' where endereco='Y'
commit tran

select * into INV02_14_12_18 from INV02 with (nolock)

select * from INV01 with (nolock)
select * from INV02 with (nolock)
select * from INV03 with (nolock)
select * from INV04 with (nolock)
select * from INV05 with (nolock)
select * from INV06 with (nolock)

select * from INV05 with (nolock) where e2 + e3 + e4 + e5 != ''

select codigoProduto,e1,e2,(select PRODES from TBS010 with (nolock) where PROCOD=codigoProduto) from INV05 with (nolock) where e2 + e3 + e4 + e5 != ''

select count(*) from INV05 with (nolock) where e1 != '' -- 6.358
select count(*) from INV05 with (nolock) where e2 != '' -- 24

begin tran
update TBS010 set PROSETLOJ1=(select replace(e1,'-','') from INV05 with (nolock) where codigoProduto=PROCOD)
select count(*)
  from TBS010 with (nolock)
 where PROSETLOJ1 = ''
       and PROCOD in(select codigoProduto from INV05 with (nolock) where codigoProduto=PROCOD)
--       and exists(select '' from INV05 with (nolock) where codigoProduto=PROCOD and e1 != '')

rollback tran
commit tran

drop table #end2

select --PROSETLOJ1,isnull(e1,''),isnull(e2,''),PROCOD
       PROCOD codigo
       ,replace(e2,'-','') endereco
  into #end2
  from TBS010 with (nolock)
       Left join INV05 with (nolock)
       on codigoProduto=PROCOD
 where --replace(e1,'-','') = PROSETLOJ1
       PROSETLOJ1 != ''
       and e2 != ''
       and PROSETLOJ2=''
--       and e1+e2 != ''
-- order by PROCOD
 order by e2 desc

select * from #end2

begin tran
update TBS010 set PROSETLOJ2=(select endereco from #end2 where codigo=PROCOD)
 where PROCOD in(select codigo from #end2)
       and PROSETLOJ2=''

rollback tran
commit tran

select PROSETLOJ1,PROSETLOJ2,* from TBS010 with (nolock) where PROSETLOJ1 != ''

select count(*) from INV05 with (nolock)
select count(*) from TBS010 with (nolock) where PROSETLOJ1 != ''

select distinct PROSETLOJ1 from TBS010 with (nolock) order by PROSETLOJ1

select distinct endereco from INV03 with (nolock) order by endereco

select distinct e1 from INV05 with (nolock) order by e1

select PROSETLOJ1,PROSETLOJ2,PROCOD,PRODES
  from TBS010 with (nolock)
 where PROSETLOJ1 != '' and PROSETLOJ2 != ''
 order by PROSETLOJ1, PRODES

select codigoProduto from INV03 with (nolock) group by codigoProduto having count(*) = 1


select *
  from INV03 with (nolock)
 where endereco Like('R%')

select endereco
       ,count(*)
  from INV03 with (nolock)
 where endereco Like('R%')
 group by endereco
 order by endereco

