drop table #tabloja

select distinct codigoProduto as codigo into #tabloja from INV03 with (nolock) where localEstoque=2

select * from #tabloja

drop table #comploja

select *,
       isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=1 and localEstoque=2 and codigoProduto=codigo),0) as c1,
       isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=2 and localEstoque=2 and codigoProduto=codigo),0) as c2
       ,isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=3 and localEstoque=2 and codigoProduto=codigo),0) as c3
       ,isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=4 and localEstoque=2 and codigoProduto=codigo),0) as c4
  into #comploja
  from #tabloja

select * from #comploja

select * from #comploja where c1 = c2

alter table #comploja add lancar decimal(10,3)

update #comploja set lancar=0

update #comploja set lancar=c1 where c1=c2

select * from #comploja where (c3=c1 or c3=c2) and c3 > 0

update #comploja set lancar=c3 where (c3=c1 or c3=c2) and c3 > 0

select * from #comploja where c3=c4 and c3 > 0

update #comploja set lancar=c4 where c3=c4 and c3 > 0

select * from #comploja where (c4=c1 or c4=c2) and c4 > 0

update #comploja set lancar=c4 where (c4=c1 or c4=c2) and c4 > 0

select * from #comploja where lancar=0

drop table #comploja2

select *,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao
  into #comploja2
  from #comploja
  
select * from #comploja2 where lancar=0

select * from #comploja where lancar=0 and c4 > 0

update #comploja set lancar=c4 where lancar=0 and c4 > 0

select * from #comploja2 where descricao Like('%TNT%') and lancar > 0

update #comploja2 set lancar=c1 where descricao Like('%TNT%') and lancar=0

select * from #comploja2 where descricao Like('PLASTICO ADES%')

update #comploja2 set lancar=c1 where descricao Like('PLASTICO ADES%')

-- COMPARAR COM O ESTOQUE
select * from #comploja2 where c1<>c2 and c3+c4=0 and lancar=0

-- BACKUP

select * into comploja from #comploja 

select * into comploja2 from #comploja2

select * from comploja2 where lancar > 0

select * from produto

delete produto

insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,codigo,lancar from comploja2 where lancar > 0

select * from comploja2 where lancar = 0

