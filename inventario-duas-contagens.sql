select * from produto with (nolock)

select top 1 * from TBS051 with (nolock)

select * from INV01 with (nolock)
select * from INV02 with (nolock)
select * from INV03 with (nolock)

select MARCOD,* from TBS010 with (nolock) where isnumeric(PROCOD)=1

select PROLOCFIS from TBS010 with (nolock) where PROLOCFIS<>''

select Left(PROLOCFIS,2) from TBS010 with (nolock) where PROLOCFIS<>'' group by Left(PROLOCFIS,2) order by Left(PROLOCFIS,2)


--

select * from master..sysservers 

select * from invcd01 

select produtoLote,count(*) from invcd01 with (nolock) group by produtoLote

select * from EST181110 with (nolock)

-- união contagem 1 + 2
select count(*) from invcd01
select count(*) from invcd02
select count(*) from invcd03

drop table #tab

select produtoCodigo into #tab from invcd01 with (nolock)
union
select produtoCodigo from invcd02 with (nolock)
union 
select produtoCodigo from invcd03 with (nolock)

select * from #tab

drop table #comp

select *,
       isnull((select ESTQTDATU from EST181110 with (nolock) where PROCOD=produtoCodigo collate database_default),0) as estoque,
       isnull((select round(sum(produtoQtde),3) from invcd01 with (nolock) where invcd01.produtoCodigo=#tab.produtoCodigo),0) as contagem1,
       isnull((select round(sum(produtoQtde),3) from invcd02 with (nolock) where invcd02.produtoCodigo=#tab.produtoCodigo),0) as contagem2,
       isnull((select round(sum(produtoQtde),3) from invcd03 with (nolock) where invcd03.produtoCodigo=#tab.produtoCodigo),0) as contagem3,
       isnull((select 'S' from invcd03 with (nolock) where invcd03.produtoCodigo=#tab.produtoCodigo),'N') as conta3
  into #comp
  from #tab

update #comp set estoque=round(estoque,3),contagem1=round(contagem1,3),contagem2=round(contagem2,3),contagem3=round(contagem3,3)

select * from #comp where produtoCodigo='4250354'

-- pelo menos 1 número diferente
select * from #comp where not(estoque=contagem1 and contagem1=contagem2)

select * from #comp where not(estoque<>contagem1 and estoque<>contagem2 and contagem1<>contagem2)

select * from #comp where estoque<>contagem1 or estoque<>contagem2 or contagem1<>contagem2 and not(estoque<>contagem1 and estoque<>contagem2 and contagem1<>contagem2)

select * from #comp where not(estoque<>contagem1 or contagem1<>contagem2)

select * from #comp where not(estoque-contagem1=0 and contagem1-contagem2=0)

select * from #comp where estoque<>contagem1 and not

-- duas contagens iguais, mas diferentes do saldo do sistema
select lancado181113.produtoQtde,produto.produtoQtde,* from #comp
         full join lancado181113 on lancado181113.produtoCodigo=#comp.produtoCodigo
         full join produto on produto.produtoCodigo=#comp.produtoCodigo
where contagem1=contagem2 and contagem1<>estoque

select lancado181113.produtoQtde,produto.produtoQtde,* from #comp
         full join lancado181113 on lancado181113.produtoCodigo=#comp.produtoCodigo
         full join produto on produto.produtoCodigo=#comp.produtoCodigo
where contagem1=contagem2 and contagem1<>estoque
      and lancado181113.produtoQtde is null and produto.produtoQtde is null

select #comp.produtoCodigo,* from #comp
 where contagem1=contagem2 and contagem1<>estoque
       and #comp.produtoCodigo not in(select #comp.produtoCodigo
                                        from #comp
                                             full join lancado181113 on lancado181113.produtoCodigo=#comp.produtoCodigo
                                             full join produto on produto.produtoCodigo=#comp.produtoCodigo
                                       where contagem1=contagem2) -- and contagem1<>estoque)


select * from produto where not exists(select '' from lancado181113 where lancado181113.produtoCodigo=produto.produtoCodigo)

-- primeira e segunda contagens divergentes
select * from #comp where contagem1<>contagem2

-- três valores diferentes
select * from #comp where not(estoque=contagem1 or estoque=contagem2 or contagem1=contagem2)
select * from #comp where not(estoque=contagem1 and estoque=contagem2 and contagem1=contagem2)

select * into #comp2 from #comp where not(estoque=contagem1 and estoque=contagem2 and contagem1=contagem2)

select * from #comp2 where not(estoque=contagem1 and estoque=contagem2 and contagem1=contagem2)

select * into #comp3 from #comp2 where not(estoque=contagem1)

select * into #comp3 from #comp2 where not(estoque=contagem1)

select * from #comp2

drop table #comp3
select * from #comp3

select * from #comp where (estoque<>contagem1 or estoque<>contagem2 or contagem1<>contagem2)

select * from #comp where saldoEstoque<>contagem1 and saldoEstoque<>contagem2 and contagem1<>contagem2

select * from invcd01 where produtoCodigo in(select produtoCodigo from invcd01 group by produtoCodigo having count(*) > 1) order by produtoCodigo

select * from #comp where produtoCodigo='12230013'

select produtoCodigo,
       (select PRODES from TBS010 with (nolock) where PROCOD=produtoCodigo collate database_default),
       (select MARNOM from TBS010 with (nolock) where PROCOD=produtoCodigo collate database_default)
  from #comp where not(saldoEstoque=contagem1 and contagem1=contagem2)
  
--  
select produtoCodigo,estoque,contagem1,contagem2,
       case estoque-contagem1 when 0 then 1 else 0 end est_cont1,
       case estoque-contagem2 when 0 then 1 else 0 end est_cont2,
       case contagem1-contagem2 when 0 then 1 else 0 end cont1_cont2
  into #comp4
  from #comp

--
select --produtoCodigo,estoque,contagem1,contagem2,
       *,
       case estoque-contagem1 when 0 then 1 else 0 end est_cont1,
       case estoque-contagem2 when 0 then 1 else 0 end est_cont2,
       case estoque-contagem3 when 0 then 1 else 0 end est_cont3,
       case contagem1-contagem2 when 0 then 1 else 0 end cont1_cont2,
       case contagem1-contagem3 when 0 then 1 else 0 end cont1_cont3,
       case contagem2-contagem3 when 0 then 1 else 0 end cont2_cont3
  into #comp4
  from #comp

select * from #comp4 where (est_cont1+est_cont2+cont1_cont2 = 0) or (est_cont1+est_cont2+cont1_cont2 = 1)

-- nenhum valor igual
select * from #comp4 where est_cont1+est_cont2+cont1_cont2 = 0
                           --and exists(select '' from produto where produto.produtoCodigo=#comp4.produtoCodigo)
                           --and exists(select '' from invcd03 where invcd03.produtoCodigo=#comp4.produtoCodigo)
                           and not exists(select '' from invcd03 where invcd03.produtoCodigo=#comp4.produtoCodigo)

-- nem mesmo a terceira contagem
select * from #comp4 where est_cont1+est_cont2+est_cont3+cont1_cont2+cont1_cont3+cont2_cont3 = 0

-- nenhum valor igual, mas a terceira contagem confere com um dos valores
select * from #comp4 where est_cont1+est_cont2+cont1_cont2 = 0 and est_cont1+est_cont2+est_cont3+cont1_cont2+cont1_cont3+cont2_cont3 = 1
                           
-- dois valores iguais
select * from #comp4 where est_cont1+est_cont2+cont1_cont2 = 1
                     --and exists(select '' from produto where produto.produtoCodigo=#comp4.produtoCodigo)
                     --and exists(select '' from invcd03 where invcd03.produtoCodigo=#comp4.produtoCodigo)
                     --and not exists(select '' from invcd03 where invcd03.produtoCodigo=#comp4.produtoCodigo)
                     and not exists(select '' from produto where produto.produtoCodigo=#comp4.produtoCodigo)

-- dois valores iguais, e a tereceira contagem confere com um dos valores
select * from #comp4
 where est_cont1+est_cont2+cont1_cont2 = 1 and est_cont1+est_cont2+est_cont3+cont1_cont2+cont1_cont3+cont2_cont3 = 3
       and not exists(select '' from produto where produto.produtoCodigo=#comp4.produtoCodigo)

-- todas os valore iguais
select * from #comp4 where est_cont1+est_cont2+cont1_cont2 = 3

select * from #comp4 where est_cont1+est_cont2+cont1_cont2 <> 3 and est_cont1+est_cont2+est_cont3+cont1_cont2+cont1_cont3+cont2_cont3 = 3

select * from #comp4 where est_cont1+est_cont2+est_cont3+cont1_cont2+cont1_cont3+cont2_cont3 = 2

-- produtos fracionados
select produtoQtde,floor(produtoQtde),round(produtoQtde-floor(produtoQtde),3),* from invcd01 where produtoQtde-floor(produtoQtde) > 0 order by produtoCodigo

select produtoQtde,floor(produtoQtde),round(produtoQtde-floor(produtoQtde),3),* from invcd02 where produtoQtde-floor(produtoQtde) > 0 order by produtoCodigo

select * from #comp
 where produtoCodigo in(select produtoCodigo from invcd01 where produtoQtde-floor(produtoQtde) > 0)
 
 select * from invcd01
 where produtoCodigo in(select produtoCodigo from invcd01 where produtoQtde-floor(produtoQtde) > 0)

select * from produto

-- insere todos os valores que deram certo
insert into produto (produtoCodigo,produtoQtde) select produtoCodigo,estoque from #comp4 where est_cont1+est_cont2+cont1_cont2 = 3

-- insere os valores que deram certo com a terceira contagem
insert into produto (produtoCodigo,produtoQtde)
   select produtoCodigo,contagem3 from #comp4 where est_cont1+est_cont2+cont1_cont2 = 0 and est_cont1+est_cont2+est_cont3+cont1_cont2+cont1_cont3+cont2_cont3 = 1

-- dois valores iguais e a terceira contagem confere com um dos valores
insert into produto (produtoCodigo,produtoQtde)
  select produtoCodigo,contagem3 from #comp4
   where est_cont1+est_cont2+cont1_cont2 = 1 and est_cont1+est_cont2+est_cont3+cont1_cont2+cont1_cont3+cont2_cont3 = 3
       and not exists(select '' from produto where produto.produtoCodigo=#comp4.produtoCodigo)

select produtoCodigo from produto group by produtoCodigo having count(*) > 1

select * from #comp4 where not exists(select '' from produto where produto.produtoCodigo=#comp4.produtoCodigo)

-- com 3a contagem
select * from #comp4
 where not exists(select '' from produto where produto.produtoCodigo=#comp4.produtoCodigo)
       and exists(select '' from invcd03 where invcd03.produtoCodigo=#comp4.produtoCodigo)

-- sem 3a contagem
select * from #comp4
 where not exists(select '' from produto where produto.produtoCodigo=#comp4.produtoCodigo)
       and not exists(select '' from invcd03 where invcd03.produtoCodigo=#comp4.produtoCodigo)

-- contagem1 = contagem2
select * from #comp4
 where not exists(select '' from produto where produto.produtoCodigo=#comp4.produtoCodigo)
       and not exists(select '' from invcd03 where invcd03.produtoCodigo=#comp4.produtoCodigo)
       and contagem1=contagem2

-- insert
insert into produto (produtoCodigo,produtoQtde)
select produtoCodigo,contagem2 from #comp4
 where not exists(select '' from lancado181113 where lancado181113.produtoCodigo=#comp4.produtoCodigo)
       and not exists(select '' from invcd03 where invcd03.produtoCodigo=#comp4.produtoCodigo)
       and contagem1=contagem2

select * into lancado181113 from produto where produtoQtde > 0



-- não precisava recontar
select * from EST181110 where PROCOD='7653271'
select * from invcd01 where produtoCodigo='7653271'
select * from invcd02 where produtoCodigo='7653271'
select * from invcd03 where produtoCodigo='7653271'

select * from EST181110 where PROCOD='9940476'
select * from invcd01 where produtoCodigo='9940476'
select * from invcd02 where produtoCodigo='9940476'
select * from invcd03 where produtoCodigo='9940476'

-- nenhuma valor igual, nem a contagem 3

produtoCodigo estoque               contagem1              contagem2              contagem3              est_cont1   est_cont2   cont1_cont2
------------- --------------------- ---------------------- ---------------------- ---------------------- ----------- ----------- -----------
7653259       73,016                72,385                 62,175                 72985                  0           0           0
7880823       984,00                1008                   576                    144                    0           0           0

(2 linha(s) afetadas)

-- produto lançados
select produtoCodigo into #lancados from lancado181113
union
select produtoCodigo from produto

select * from #comp where not exists(select '' from #lancados where #lancados.produtoCodigo=#comp.produtoCodigo)

-- contagem1 = contagem2 e não lançados
insert into produto (produtoCodigo,produtoQtde)
--select *
select produtoCodigo,contagem1
  from #comp
 where contagem1=contagem2
       and not exists(select '' from #lancados where #lancados.produtoCodigo=#comp.produtoCodigo)

-- 4 itens

-- estoque = contagem1 e não lançados
insert into produto (produtoCodigo,produtoQtde)
--select *
select produtoCodigo,estoque
  from #comp
 where estoque=contagem1
       and not exists(select '' from #lancados where #lancados.produtoCodigo=#comp.produtoCodigo)

-- 8 itens

-- estoque = contagem2 e não lançados
insert into produto (produtoCodigo,produtoQtde)
--select *
select produtoCodigo,estoque
  from #comp
 where estoque=contagem2
       and not exists(select '' from #lancados where #lancados.produtoCodigo=#comp.produtoCodigo)

-- 19 itens

select * into lancado181113_2 from produto

-- últimos lançamentos

delete produto

select * from produto

select * from produto where produtoCodigo in(select produtoCodigo from produto group by produtoCodigo having count(*) > 1) order by produtoCodigo

select produtoCodigo,produtoQtde from produto

select * from produto where (select ESTQTDATU from TBS032 with (nolock) where ESTLOC=1 and PROCOD=produtoCodigo collate database_default) > 0

select * from produto where produtoQtde = 0

select produtoCodigo,produtoQtde,ESTQTDATU
  from produto
       inner join TBS032 with (nolock) on PROCOD=produtoCodigo collate database_default
 where ESTLOC=1

-- últimos produto lançados
drop table #lancados2

select produtoCodigo into #lancados2 from lancado181113
union
select produtoCodigo from lancado181113_2
union
select produtoCodigo from produto

select * from produto where not exists(select '' from #lancados2 where #lancados2.produtoCodigo=produto.produtoCodigo)

select * from #lancados2

select *,
       isnull((select ESTQTDATU from EST181110 with (nolock) where PROCOD=produtoCodigo collate database_default),0) as estoque,
       isnull((select round(sum(produtoQtde),3) from invcd01 with (nolock) where invcd01.produtoCodigo=#lancados2.produtoCodigo),0) as contagem1,
       isnull((select round(sum(produtoQtde),3) from invcd02 with (nolock) where invcd02.produtoCodigo=#lancados2.produtoCodigo),0) as contagem2,
       isnull((select round(sum(produtoQtde),3) from invcd03 with (nolock) where invcd03.produtoCodigo=#lancados2.produtoCodigo),0) as contagem3,
       isnull((select 'S' from invcd03 with (nolock) where invcd03.produtoCodigo=#lancados2.produtoCodigo),'N') as conta3
  into #compfinal
  from #lancados2

select * from #compfinal where estoque<>contagem1 and estoque<>contagem2

select '' as 'SALDO',PROCOD,(select PRODES from TBS010 with (nolock) where TBS010.PROCOD=EST181110.PROCOD) PRODES,ESTQTDATU
  from EST181110 where PROCOD in('0121770','12230006','1090054')
select '' as 'CONTAGEM-1',produtoCodigo,produtoDescricao,produtoQtde,produtoDataLote from invcd01 where produtoCodigo in('0121770','12230006','1090054')
select '' as 'CONTAGEM-2',produtoCodigo,produtoDescricao,produtoQtde,produtoDataLote from invcd02 where produtoCodigo in('0121770','12230006','1090054')
select '' as 'CONTAGEM-3',produtoCodigo,produtoDescricao,produtoQtde,produtoDataLote from invcd03 where produtoCodigo in('0121770','12230006','1090054')

select * into lancado181113_3 from produto

select * from lancado181113 where produtoQtde=0

select * from lancado181113_2 where produtoQtde=0

select * from lancado181113_3 where produtoQtde=0

delete lancado181113_3 where produtoQtde=0

--

select * from #comp4

-- total de itens contados
-- primeira contagem

select count(*) from #comp where contagem1 > 0

-- segunda contagem

select count(*) from #comp where contagem2 > 0

-- qtde itens que foram para terceira contagem

select count(*) from #comp4 where conta3='S'

-- todas os valore iguais
select * from #comp4 where est_cont1+est_cont2+cont1_cont2 = 3

-- primeira contagem igual ao saldo em estoque
select * from #comp4 where estoque=contagem1

-- primeira e segunda contagem iguais
select * from #comp4 where contagem1=contagem2

-- itens da terceira contagem que conferem com a primeira contagem
select * from #comp4 where conta3='S' and contagem1=contagem3

-- itens da terceira contagem que conferem com a segunda contagem
select * from #comp4 where conta3='S' and contagem2=contagem3


-- taubaté 17/11/18

drop table #tab

select distinct codigoProduto as codigo into #tab from INV03 with (nolock) where localEstoque=1

select * from #tab

select top 1 * from INV03 with (nolock)

drop table #comp

select *,
       isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=1 and localEstoque=1 and codigoProduto=codigo),0) as c1,
       isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=2 and localEstoque=1 and codigoProduto=codigo),0) as c2,
       isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=3 and localEstoque=1 and codigoProduto=codigo),0) as c3,
       isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=4 and localEstoque=1 and codigoProduto=codigo),0) as c4
  into #comp
  from #tab

select distinct codigoProduto as codigo, endereco into #tab2 from INV03 with (nolock)

drop table #comp2

select *,
       isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=1 and codigoProduto=codigo and INV03.endereco=#tab2.endereco),0) as c1,
       isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=2 and codigoProduto=codigo and INV03.endereco=#tab2.endereco),0) as c2
  into #comp2
  from #tab2

select * from #comp2 where c1 <> c2 and 

select codigo,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca,
       replicate(' ',20) as e1,
       replicate(' ',20) as e2,
       replicate(' ',20) as e3,
       replicate(' ',20) as e4
  into #recont
  from #comp where c1 <> c2

select numeroContagem,localEstoque,count(*) from INV03 with (nolock) group by numeroContagem,localEstoque order by localEstoque,numeroContagem

select idColetor,count(*)
  from INV03 with (nolock)
 where numeroContagem=1 and localEstoque=2
 group by idColetor

select * from #recont order by e1,e2,e3

select * from INV03 with (nolock)

select *,       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca
 from #comp where c1 <> c2

select *,       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca
 from #comp where c1 <> c2 and (c3 <> c1 and c3 <> c2) 

drop table lancar_e1

select * into lancar_e1 from #comp

select * from lancar_e1 where c3 > 0

alter table lancar_e1 add lancar decimal(10,3)

update lancar_e1 set lancar=0 where lancar is null

update lancar_e2 set lancar=c1 where c1=c2

alter table lancar_e1 add c4 decimal(10,3)

update lancar_e1 set c4=0 where c4 is null

alter table lancar_e1 add conta3 char(1)

alter table lancar_e1 drop column conta3

select * from lancar_e1 where c3 > 0

update lancar_e1 set conta3='N' where conta3 is null

select * from lancar_e1 with (nolock) where exists(select '' from INV03 with (nolock) where )

begin tran
insert into INV03
   (numeroContagem,idColetor,localEstoque,dataContagem,horaContagem,codigoProduto,descricaoProduto,marca)
select 3,'FOLHA',1,'20181117','16:00:00',codigo,descricao,marca
  from #recont order by e1,e2,e3
commit tran

select * from INV03 with (nolock) where numeroContagem=3 and idColetor='FOLHA' and localEstoque=1

update #recont set e1=(select endereco from #endereco where codigo=codigoProduto and Row#=1)

update #recont set e2=(select endereco from #endereco where codigo=codigoProduto and Row#=2)

update #recont set e3=(select endereco from #endereco where codigo=codigoProduto and Row#=3)

update #recont set e4=(select endereco from #endereco where codigo=codigoProduto and Row#=4)

update #recont set e1='' where e1 is null
update #recont set e2='' where e2 is null
update #recont set e3='' where e3 is null
update #recont set e4='' where e4 is null

SELECT 
  ROW_NUMBER() OVER(ORDER BY codigoProduto,endereco) AS Row#,
  *
FROM INV03 


SELECT codigoProduto,endereco,
  ROW_NUMBER() OVER(partition by codigoProduto ORDER BY codigoProduto,endereco) AS Row#
  into #endereco
FROM INV03 where localEstoque=2
group by codigoProduto,endereco

select * from #endereco

select * from #comp2 where codigo='0040118'

select * from #comp where codigo='0050058'

select quantidade,* from INV03 with (nolock) where codigoProduto in(select codigo from #comp where c1 <> c2) order by codigoProduto,numeroContagem


select distinct codigoProduto,endereco into #dup from INV03 with (nolock)

select * from #dup where codigoProduto in(select codigoProduto from #dup group by codigoProduto having count(*) > 1) order by codigoProduto

select quantidade,* from INV03 with (nolock)
 where numeroContagem=2 and codigoProduto in(select codigoProduto from INV03 with (nolock) where numeroContagem=2 group by codigoProduto having count(*) > 1) order by codigoProduto


select ano,
       produto,
       (select PRODES from TBS010 (nolock) where PROCOD=produto),
       (select PROUM1 from TBS010 (nolock) where PROCOD=produto),
       coalesce([1], 0) as Jan,
       coalesce([2], 0) as Fev,
       coalesce([3], 0) as Mar,
       coalesce([4], 0) as Abr,
       coalesce([5], 0) as Mai,
       coalesce([6], 0) as Jun,
       coalesce([7], 0) as Jul,
       coalesce([8], 0) as Ago,
       coalesce([9], 0) as 'Set',
       coalesce([10], 0) as 'Out',
       coalesce([11], 0) as Nov,
       coalesce([12], 0) as Dez

from
(
  select ano,produto,mes,custo
    from CUSTOAQUISICAO (nolock)
   where empresa='MG'
) d

pivot (max(custo)

 for mes in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) piv


select * from INV02 with (nolock)

SELECT * 
FROM INV03
PIVOT (
    max(id)
    FOR endereco IN
    (select endereco from INV02 with (nolock))
) AS pvt
where numeroContagem=1
ORDER BY codigoProduto


declare @SQLStr varchar(500)

SET @SQLStr='SELECT codigo, endereco,  '
+@SQLStr
+' FROM (SELECT P.codigoProduto, GP.endereco '+
'         FROM INV03 P, INV02 GP '+
        ' WHERE P.endereco = GP.endereco '+
        ' GROUP BY P.codigoProduto, GP.endereco '+      
'         ) sq PIVOT (SUM(id) FOR endereco IN('
+@SQLStr+')) AS pt'
PRINT 'xx'+@SQLStr
EXEC(@SQLStr)



---

SELECT 
  ROW_NUMBER() OVER(ORDER BY codigoProduto,endereco) AS Row#,
  *
FROM INV03 


--

select top 5000 * from TBS049 with (nolock) order by MDSLAN desc

select top 5000 * from TBS049 with (nolock) where MDSLAN <= '20181115' order by MDSLAN desc

select PROCOD,sum(MDSQTD)
  from TBS049 with (nolock)
 where LESCOD=1 and convert(date,MDSLAN,112)='20181117' and MDSUSU='INTEGROS' and MDSTIP='S'
 group by PROCOD

select PROCOD,sum(MDSQTD)
  from TBS049 with (nolock)
 where LESCOD=2 and convert(date,MDSLAN,112)='20181117' and MDSUSU='INTEGROS' -- and MDSTIP='S' e 'E'
 group by PROCOD


select * from INV03 with (nolock)
select * from #comp
 where codigo in('0050253','0073571','11420006','4250311','6592147','7040733')
order by descricaoProduto

select * from INV03 with (nolock) where codigoProduto='7041825'


-- 18/11/18

select numeroContagem from INV03 with (nolock) where localEstoque=1 group by numeroContagem

select * from INV03 with (nolock) where localEstoque=1 and numeroContagem=3

select * from lancar_e1

-- marcar itens da terceira coleta

update lancar_e1 set conta3='S' where codigo='18440002'
update lancar_e1 set conta3='S' where codigo='7653255'
update lancar_e1 set conta3='S' where codigo='13710009'
update lancar_e1 set conta3='S' where codigo='0280285'
update lancar_e1 set conta3='S' where codigo='10300058'
update lancar_e1 set conta3='S' where codigo='8478633'
update lancar_e1 set conta3='S' where codigo='2130371'
update lancar_e1 set conta3='S' where codigo='2540061'
update lancar_e1 set conta3='S' where codigo='0054046'
update lancar_e1 set conta3='S' where codigo='0050121'
update lancar_e1 set conta3='S' where codigo='0050130'
update lancar_e1 set conta3='S' where codigo='12300013'
update lancar_e1 set conta3='S' where codigo='8130036'
update lancar_e1 set conta3='S' where codigo='7900771'
update lancar_e1 set conta3='S' where codigo='7900774'
update lancar_e1 set conta3='S' where codigo='15440017'
update lancar_e1 set conta3='S' where codigo='18800005'
update lancar_e1 set conta3='S' where codigo='18060004'
update lancar_e1 set conta3='S' where codigo='7640004'
update lancar_e1 set conta3='S' where codigo='8130032'
update lancar_e1 set conta3='S' where codigo='7601018'
update lancar_e1 set conta3='S' where codigo='7600062'
update lancar_e1 set conta3='S' where codigo='7600259'
update lancar_e1 set conta3='S' where codigo='3794718'
update lancar_e1 set conta3='S' where codigo='7780051'
update lancar_e1 set conta3='S' where codigo='13670035'
update lancar_e1 set conta3='S' where codigo='0055702'
update lancar_e1 set conta3='S' where codigo='0055823'
update lancar_e1 set conta3='S' where codigo='0411272'
update lancar_e1 set conta3='S' where codigo='0411345'
update lancar_e1 set conta3='S' where codigo='7880948'
update lancar_e1 set conta3='S' where codigo='7880949'
update lancar_e1 set conta3='S' where codigo='7600046'
update lancar_e1 set conta3='S' where codigo='18990240'
update lancar_e1 set conta3='S' where codigo='0122581'
update lancar_e1 set conta3='S' where codigo='0122602'
update lancar_e1 set conta3='S' where codigo='10840016'
update lancar_e1 set conta3='S' where codigo='16530075'
update lancar_e1 set conta3='S' where codigo='18990011'
update lancar_e1 set conta3='S' where codigo='5510392'
update lancar_e1 set conta3='S' where codigo='7887817'
update lancar_e1 set conta3='S' where codigo='7887833'
update lancar_e1 set conta3='S' where codigo='7888457'
update lancar_e1 set conta3='S' where codigo='8478993'
update lancar_e1 set conta3='S' where codigo='8479014'
update lancar_e1 set conta3='S' where codigo='16310036'
update lancar_e1 set conta3='S' where codigo='0090008'
update lancar_e1 set conta3='S' where codigo='0110086'
update lancar_e1 set conta3='S' where codigo='0110311'
update lancar_e1 set conta3='S' where codigo='18870002'
update lancar_e1 set conta3='S' where codigo='18870003'
update lancar_e1 set conta3='S' where codigo='16530084'
update lancar_e1 set conta3='S' where codigo='16310001'
update lancar_e1 set conta3='S' where codigo='16310029'
update lancar_e1 set conta3='S' where codigo='7570046'
update lancar_e1 set conta3='S' where codigo='3940608'
update lancar_e1 set conta3='S' where codigo='7041935'
update lancar_e1 set conta3='S' where codigo='7041983'
update lancar_e1 set conta3='S' where codigo='7041831'
update lancar_e1 set conta3='S' where codigo='7041933'
update lancar_e1 set conta3='S' where codigo='7041945'
update lancar_e1 set conta3='S' where codigo='7041946'
update lancar_e1 set conta3='S' where codigo='7041947'
update lancar_e1 set conta3='S' where codigo='6890002'
update lancar_e1 set conta3='S' where codigo='7040008'
update lancar_e1 set conta3='S' where codigo='7041829'
update lancar_e1 set conta3='S' where codigo='8060384'
update lancar_e1 set conta3='S' where codigo='16530095'
update lancar_e1 set conta3='S' where codigo='1440030'
update lancar_e1 set conta3='S' where codigo='1440187'
update lancar_e1 set conta3='S' where codigo='1448130'
update lancar_e1 set conta3='S' where codigo='16870001'
update lancar_e1 set conta3='S' where codigo='7041830'
update lancar_e1 set conta3='S' where codigo='8130021'
update lancar_e1 set conta3='S' where codigo='7850029'
update lancar_e1 set conta3='S' where codigo='4250311'
update lancar_e1 set conta3='S' where codigo='4250320'
update lancar_e1 set conta3='S' where codigo='7602384'
update lancar_e1 set conta3='S' where codigo='17590002'
update lancar_e1 set conta3='S' where codigo='17590003'
update lancar_e1 set conta3='S' where codigo='10820494'
update lancar_e1 set conta3='S' where codigo='0052566'
update lancar_e1 set conta3='S' where codigo='11420006'
update lancar_e1 set conta3='S' where codigo='12340040'
update lancar_e1 set conta3='S' where codigo='16620001'
update lancar_e1 set conta3='S' where codigo='2890001'
update lancar_e1 set conta3='S' where codigo='2890002'
update lancar_e1 set conta3='S' where codigo='2890003'
update lancar_e1 set conta3='S' where codigo='2890004'
update lancar_e1 set conta3='S' where codigo='2890007'
update lancar_e1 set conta3='S' where codigo='2890008'
update lancar_e1 set conta3='S' where codigo='2890009'
update lancar_e1 set conta3='S' where codigo='6150006'
update lancar_e1 set conta3='S' where codigo='7040733'
update lancar_e1 set conta3='S' where codigo='3661460'
update lancar_e1 set conta3='S' where codigo='3669674'
update lancar_e1 set conta3='S' where codigo='8740073'
update lancar_e1 set conta3='S' where codigo='0054622'
update lancar_e1 set conta3='S' where codigo='0074887'
update lancar_e1 set conta3='S' where codigo='14520004'
update lancar_e1 set conta3='S' where codigo='0073571'
update lancar_e1 set conta3='S' where codigo='3794713'
update lancar_e1 set conta3='S' where codigo='3251251'
update lancar_e1 set conta3='S' where codigo='3251261'
update lancar_e1 set conta3='S' where codigo='4290245'
update lancar_e1 set conta3='S' where codigo='4290246'
update lancar_e1 set conta3='S' where codigo='6591949'
update lancar_e1 set conta3='S' where codigo='6592147'
update lancar_e1 set conta3='S' where codigo='6592155'
update lancar_e1 set conta3='S' where codigo='6594069'
update lancar_e1 set conta3='S' where codigo='9030054'
update lancar_e1 set conta3='S' where codigo='9030055'
update lancar_e1 set conta3='S' where codigo='9030056'
update lancar_e1 set conta3='S' where codigo='9030057'
update lancar_e1 set conta3='S' where codigo='9030058'
update lancar_e1 set conta3='S' where codigo='7880078'
update lancar_e1 set conta3='S' where codigo='0072141'
update lancar_e1 set conta3='S' where codigo='0073016'
update lancar_e1 set conta3='S' where codigo='0051594'
update lancar_e1 set conta3='S' where codigo='0051659'
update lancar_e1 set conta3='S' where codigo='0630196'
update lancar_e1 set conta3='S' where codigo='0630208'
update lancar_e1 set conta3='S' where codigo='7960070'
update lancar_e1 set conta3='S' where codigo='4140455'
update lancar_e1 set conta3='S' where codigo='6597073'
update lancar_e1 set conta3='S' where codigo='6597079'
update lancar_e1 set conta3='S' where codigo='7303441'
update lancar_e1 set conta3='S' where codigo='7600055'
update lancar_e1 set conta3='S' where codigo='7600283'
update lancar_e1 set conta3='S' where codigo='0630156'
update lancar_e1 set conta3='S' where codigo='10650060'
update lancar_e1 set conta3='S' where codigo='0052027'
update lancar_e1 set conta3='S' where codigo='0052931'
update lancar_e1 set conta3='S' where codigo='0053848'
update lancar_e1 set conta3='S' where codigo='0050253'
update lancar_e1 set conta3='S' where codigo='0050261'
update lancar_e1 set conta3='S' where codigo='0055581'
update lancar_e1 set conta3='S' where codigo='1580010'
update lancar_e1 set conta3='S' where codigo='1580021'
update lancar_e1 set conta3='S' where codigo='3250933'
update lancar_e1 set conta3='S' where codigo='0410012'
update lancar_e1 set conta3='S' where codigo='8735607'
update lancar_e1 set conta3='S' where codigo='5250249'
update lancar_e1 set conta3='S' where codigo='6130023'
update lancar_e1 set conta3='S' where codigo='6130267'
update lancar_e1 set conta3='S' where codigo='6130601'
update lancar_e1 set conta3='S' where codigo='8479034'
update lancar_e1 set conta3='S' where codigo='0090859'

-- itens que foram para contagem 3

select * from lancar_e1 where conta3='S'

-- itens que bateram as contagens 1 e 2

select * from lancar_e1 where c1=c2


select * from lancar_e1 where lancar=0

-- registra a quantidade da terceira contagem para lançamento no estoque

begin tran
update lancar_e1 set lancar=c3 where conta3='S' 
commit tran

select * from lancar_e1 where conta3='S'

select codigo,c1,c2,c3,lancar,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default),
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default),
       (select PROUM1 + ' C/' + Ltrim(str(PROUM1QTD,10)) from TBS010 with (nolock) where PROCOD=codigo collate database_default)
 from lancar_e1 where conta3='S'

select * from lancar_e1 where c4 > 0

-- itens da 4a contagem


alter table lancar_e1 add conta4 char(1)

insert into INV03
   (numeroContagem,idColetor,localEstoque,dataContagem,horaContagem,codigoProduto,descricaoProduto,marca,quantidade)
select 4,'FOLHA',1,'20181117','17:00:00','0050253','PASTA CATAL 0.12 50PLAST 4COLCH C/VISOR 124','ACP',18

insert into INV03
   (numeroContagem,idColetor,localEstoque,dataContagem,horaContagem,codigoProduto,descricaoProduto,marca,quantidade)
select 4,'FOLHA',1,'20181117','17:00:00','0073571','PRANCHETA A4 MDF PRENDEDOR PLASTICO CLIP 117','ACRIMET',49

insert into INV03
   (numeroContagem,idColetor,localEstoque,dataContagem,horaContagem,codigoProduto,descricaoProduto,marca,quantidade)
select 4,'FOLHA',1,'20181117','17:00:00','11420006','SACO DE LIXO PT 020L REFORCADO 5KG','GOLDEN PLASTIC',27

insert into INV03
   (numeroContagem,idColetor,localEstoque,dataContagem,horaContagem,codigoProduto,descricaoProduto,marca,quantidade)
select 4,'FOLHA',1,'20181117','17:00:00','4250311','PLACA EPS 005MM','ISOPOR',310

insert into INV03
   (numeroContagem,idColetor,localEstoque,dataContagem,horaContagem,codigoProduto,descricaoProduto,marca,quantidade)
select 4,'FOLHA',1,'20181117','17:00:00','6592147','PASTA NOVAONDA OFICIO 20MM 202 AZ 33X25','POLIBRAS',61

insert into INV03
   (numeroContagem,idColetor,localEstoque,dataContagem,horaContagem,codigoProduto,descricaoProduto,marca,quantidade)
select 4,'FOLHA',1,'20181117','17:00:00','7040733','COPO PLAST CRISTAL 60ML MILANO 8571','PRAFESTA',19

select * from lancar_e1 where codigo in('0050253','0073571','11420006','4250311','6592147','7040733')

begin tran
update lancar_e1 set conta4='N' where conta4 is null
commit tran

select * from lancar_e1 where lancar = 0

select codigo,lancar,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default),
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default)
 from lancar_e1 where lancar=0

select * from lancar_e1 where lancar > 0

select * from lancar_e1 where lancar > 0 and (c3 > 0 or c4 > 0)

-- grava produto para lançamento no estoque 1

delete produto

-- insere produtos para lançamento no estoque

insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,codigo,lancar from lancar_e1 where lancar > 0

-- 

select * from INV03 with (nolock) where localEstoque=2 and codigoProduto='4520609'

select codigoProduto as codigo,
       descricaoProduto as descricao,
       embalagem,
       marca
       --,'____________' as quantidade
  from INV03 with (nolock)
 where localEstoque=2 and endereco=58 order by descricaoid

-- loja taubaté

drop table #tabloja

select distinct codigoProduto as codigo into #tabloja from INV03 with (nolock) where localEstoque=2

select * from #tabloja

drop table #comploja

select *,
       isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=1 and localEstoque=2 and codigoProduto=codigo),0) as c1,
       isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=2 and localEstoque=2 and codigoProduto=codigo),0) as c2
       ,isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=3 and localEstoque=2 and codigoProduto=codigo),0) as c3
--       ,isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=4 and localEstoque=1 and codigoProduto=codigo),0) as c4
  into #comploja
  from #tabloja

select codigo,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca,
       replicate(' ',20) as e1,
       replicate(' ',20) as e2,
       replicate(' ',20) as e3,
       replicate(' ',20) as e4
  into #recontloja
  from #comploja where c1 <> c2 and c2 > 0 

select *,       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca
 from #comploja where c1 <> c2 and c2 > 0

select (select count(*) from INV03 with (nolock) where localEstoque=2 and numeroContagem=1) as contagem1,
       (select count(*) from INV03 with (nolock) where localEstoque=2 and numeroContagem=2) as contagem2,
       Ltrim(str((select count(*) from INV03 with (nolock) where localEstoque=2 and numeroContagem=2)*100/
                 (select count(*) from INV03 with (nolock) where localEstoque=2 and numeroContagem=1),3))+'%' as progresso

alter table #comploja add conta3 char(1)
alter table #comploja add conta3 char(1)

update #recontloja set e1=(select endereco from #enderecoloja where codigo=codigoProduto and Row#=1)

update #recontloja set e2=(select endereco from #enderecoloja where codigo=codigoProduto and Row#=2)

update #recontloja set e3=(select endereco from #enderecoloja where codigo=codigoProduto and Row#=3)

update #recontloja set e4=(select endereco from #enderecoloja where codigo=codigoProduto and Row#=4)

select * from #recontloja order by e1,e2,e3

begin tran
update #recontloja set e1=right('00'+rtrim(e1),2)
commit tran

update #recontloja set e2=right('00'+rtrim(e2),2)

update #recontloja set e3=right('00'+rtrim(e3),2)

update #recontloja set e4=right('00'+rtrim(e4),2)

update #recontloja set e1='' where e1='00'
update #recontloja set e2='' where e2='00'
update #recontloja set e3='' where e3='00'
update #recontloja set e4='' where e4='00'

drop table #enderecoloja

SELECT codigoProduto,endereco,
  ROW_NUMBER() OVER(partition by codigoProduto ORDER BY codigoProduto,endereco) AS Row#
  into #enderecoloja
FROM INV03 
where localEstoque=2
group by codigoProduto,endereco

update #recontloja set e1='' where e1 is null
update #recontloja set e2='' where e2 is null
update #recontloja set e3='' where e3 is null
update #recontloja set e4='' where e4 is null

select * from #comploja

update #comploja set conta3='N'

select * from #comploja where conta3='S' and c1=c2

select * from #comploja where conta3='S' and c1=c2

select * from #comploja where conta3='S' and c3 > 0

begin tran
update #comploja set conta3='N' where conta3='S' and c1=c2
commit tran

-- COMPARAÇÃO FINAL
select *,       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca
 from #comploja where c1 <> c2 and (c3 <> c1 and c3 <> c2) --and conta3='S'

select *,       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca
 from #comploja where c1 <> c2 and (c3 <> c1 and c3 <> c2) and c3=0

select *,       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca
 from #comploja where c1 = c2

select *,       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca
 from #comploja where c3 = c1 or c3 = c2

select * from #comploja where c1 + c2 = 0

select * from #comploja where c1 <> c2 and c3 = 0

select codigo,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca,
       replicate(' ',20) as e1,
       replicate(' ',20) as e2,
       replicate(' ',20) as e3,
       replicate(' ',20) as e4
  into #recontloja2
  from #comploja where c1 <> c2 and (c3 <> c1 and c3 <> c2)

update #recontloja2 set e1=(select endereco from #enderecoloja where codigo=codigoProduto and Row#=1)

update #recontloja2 set e2=(select endereco from #enderecoloja where codigo=codigoProduto and Row#=2)

update #recontloja2 set e3=(select endereco from #enderecoloja where codigo=codigoProduto and Row#=3)

update #recontloja2 set e4=(select endereco from #enderecoloja where codigo=codigoProduto and Row#=4)

update #recontloja2 set e1='' where e1 is null
update #recontloja2 set e2='' where e2 is null
update #recontloja2 set e3='' where e3 is null
update #recontloja2 set e4='' where e4 is null

update #recontloja2 set e1=right('00'+rtrim(e1),2) where e1<>''

update #recontloja2 set e2=right('00'+rtrim(e2),2) where e2<>''

update #recontloja2 set e3=right('00'+rtrim(e3),2) where e3<>''

update #recontloja2 set e4=right('00'+rtrim(e4),2) where e4<>''

update #recontloja set e1='' where e1='00'
update #recontloja set e2='' where e2='00'
update #recontloja set e3='' where e3='00'
update #recontloja set e4='' where e4='00'

select * from #recontloja2 order by e1,e2,e3

select *,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao,
       (select MARNOM from TBS010 with (nolock) where PROCOD=codigo collate database_default) as marca
 into #temp 
 from #comploja

select * from #temp where descricao Like('%TNT%') or descricao Like('%CONTACT%')

select * from #temp where descricao Like('PLASTICO ADES%')

select * from #comploja where 

select * from #recontloja2 order by descricao



select * into lancar_e2 from #comploja

alter table lancar_e2 add lancar decimal(10,3)

update lancar_e2 set lancar=0 where lancar is null

begin tran
update lancar_e2 set lancar=c3 where (c3=c1 or c3=c2) and c3 > 0
commit tran
rollback tran

alter table lancar_e2 add c4 decimal(10,3)

update lancar_e2 set c4=0 where c4 is null

alter table lancar_e2 add conta4 char(1)

alter table lancar_e1 drop column conta3

select * from lancar_e1 where c3 > 0

update lancar_e1 set conta3='N' where conta3 is null

select * from lancar_e1 with (nolock) where exists(select '' from INV03 with (nolock) where )

select * from lancar_e2 where lancar > 0

alter table lancar_e2 add descricao char(60)

update lancar_e2 set descricao=(select PRODES from TBS010 with (nolock) where PROCOD=codigo)

select * from lancar_e2 where descricao Like('PLASTICO ADES%')

update lancar_e2 set lancar=c1 where descricao Like('%TNT%')

select * from lancar_e2 where lancar=0 and c3 > 0 and exists(select '' from #recontloja2 where #recontloja2.codigo=lancar_e2.codigo)

select * from #comploja where c1

update lancar_e2 set lancar=106 where codigo='4720051'

select * from lancar_e2 where codigo='6480250'

delete lancar_e2  where codigo in('6480250','3635560','4680022','18990132')

select * from TBS010 with (nolock) where PROCOD='10770027'

insert into lancar_e2 select '10770027',0,0,1,'S',1,'ETIQUETA PRECO P6 UNIVERSAL LISA BRANCA PR077629-004'

select * from lancar_e2 where descricao Like('%CONTACT%')

alter table lancar_e2 add conta4 char(1)

update lancar_e2 set conta4='N'

select * from #comploja where codigo='18020001'
select * from #comploja where codigo='24380072'
select * from #comploja where codigo='13520028'
select * from #comploja where codigo='2814127'
select * from #comploja where codigo='2814073'
select * from #comploja where codigo='2814129'
select * from #comploja where codigo='2814071'
select * from #comploja where codigo='6591930'


update #comploja set conta3='S' where codigo='4250664'
update #comploja set conta3='S' where codigo='4250060'
update #comploja set conta3='S' where codigo='3794288'
update #comploja set conta3='S' where codigo='3793656'
update #comploja set conta3='S' where codigo='3790258'
update #comploja set conta3='S' where codigo='3791157'
update #comploja set conta3='S' where codigo='3790169'
update #comploja set conta3='S' where codigo='3794369'
update #comploja set conta3='S' where codigo='3792846'
update #comploja set conta3='S' where codigo='23880003'
update #comploja set conta3='S' where codigo='3790088'
update #comploja set conta3='S' where codigo='24310001'
update #comploja set conta3='S' where codigo='3791025'
update #comploja set conta3='S' where codigo='3791092'
update #comploja set conta3='S' where codigo='3790150'
update #comploja set conta3='S' where codigo='3794245'
update #comploja set conta3='S' where codigo='3790096'
update #comploja set conta3='S' where codigo='3794202'
update #comploja set conta3='S' where codigo='3790479'
update #comploja set conta3='S' where codigo='3790592'
update #comploja set conta3='S' where codigo='3794732'
update #comploja set conta3='S' where codigo='3793796'
update #comploja set conta3='S' where codigo='3794670'
update #comploja set conta3='S' where codigo='3790460'
update #comploja set conta3='S' where codigo='3794181'
update #comploja set conta3='S' where codigo='3794199'
update #comploja set conta3='S' where codigo='3791173'
update #comploja set conta3='S' where codigo='7280041'
update #comploja set conta3='S' where codigo='3794229'
update #comploja set conta3='S' where codigo='3794598'
update #comploja set conta3='S' where codigo='3794631'
update #comploja set conta3='S' where codigo='3792854'
update #comploja set conta3='S' where codigo='7041954'
update #comploja set conta3='S' where codigo='7040003'
update #comploja set conta3='S' where codigo='7041927'
update #comploja set conta3='S' where codigo='1360001'
update #comploja set conta3='S' where codigo='7040504'
update #comploja set conta3='S' where codigo='7040113'
update #comploja set conta3='S' where codigo='7040038'
update #comploja set conta3='S' where codigo='14000008'
update #comploja set conta3='S' where codigo='9870226'
update #comploja set conta3='S' where codigo='7041928'
update #comploja set conta3='S' where codigo='7040288'
update #comploja set conta3='S' where codigo='18880001'
update #comploja set conta3='S' where codigo='4040010'
update #comploja set conta3='S' where codigo='8130043'
update #comploja set conta3='S' where codigo='8687145'
update #comploja set conta3='S' where codigo='7041949'
update #comploja set conta3='S' where codigo='7041994'
update #comploja set conta3='S' where codigo='7040296'
update #comploja set conta3='S' where codigo='9870075'
update #comploja set conta3='S' where codigo='18880005'
update #comploja set conta3='S' where codigo='0327186'
update #comploja set conta3='S' where codigo='8740061'
update #comploja set conta3='S' where codigo='10650031'
update #comploja set conta3='S' where codigo='3320032'
update #comploja set conta3='S' where codigo='8740006'
update #comploja set conta3='S' where codigo='14060055'
update #comploja set conta3='S' where codigo='14060019'
update #comploja set conta3='S' where codigo='14060015'
update #comploja set conta3='S' where codigo='2000040'
update #comploja set conta3='S' where codigo='5260361'
update #comploja set conta3='S' where codigo='2000016'
update #comploja set conta3='S' where codigo='0054598'
update #comploja set conta3='S' where codigo='0054866'
update #comploja set conta3='S' where codigo='5380900'
update #comploja set conta3='S' where codigo='9160047'
update #comploja set conta3='S' where codigo='9160046'
update #comploja set conta3='S' where codigo='5260329'
update #comploja set conta3='S' where codigo='9160048'
update #comploja set conta3='S' where codigo='7290601'
update #comploja set conta3='S' where codigo='0632074'
update #comploja set conta3='S' where codigo='0054776'
update #comploja set conta3='S' where codigo='5380286'
update #comploja set conta3='S' where codigo='8490593'
update #comploja set conta3='S' where codigo='0630479'
update #comploja set conta3='S' where codigo='5260310'
update #comploja set conta3='S' where codigo='0050130'
update #comploja set conta3='S' where codigo='0631944'
update #comploja set conta3='S' where codigo='18230031'
update #comploja set conta3='S' where codigo='1100033'
update #comploja set conta3='S' where codigo='7300140'
update #comploja set conta3='S' where codigo='7301480'
update #comploja set conta3='S' where codigo='0049686'
update #comploja set conta3='S' where codigo='4340051'
update #comploja set conta3='S' where codigo='0049685'
update #comploja set conta3='S' where codigo='15110106'
update #comploja set conta3='S' where codigo='15110002'
update #comploja set conta3='S' where codigo='0419836'
update #comploja set conta3='S' where codigo='15110005'
update #comploja set conta3='S' where codigo='14060080'
update #comploja set conta3='S' where codigo='14060069'
update #comploja set conta3='S' where codigo='0419830'
update #comploja set conta3='S' where codigo='0419819'
update #comploja set conta3='S' where codigo='0419825'
update #comploja set conta3='S' where codigo='14060078'
update #comploja set conta3='S' where codigo='15110008'
update #comploja set conta3='S' where codigo='11060012'
update #comploja set conta3='S' where codigo='23640008'
update #comploja set conta3='S' where codigo='0419843'
update #comploja set conta3='S' where codigo='14060067'
update #comploja set conta3='S' where codigo='23640001'
update #comploja set conta3='S' where codigo='11066880'
update #comploja set conta3='S' where codigo='0411370'
update #comploja set conta3='S' where codigo='0413372'
update #comploja set conta3='S' where codigo='6130666'
update #comploja set conta3='S' where codigo='6130570'
update #comploja set conta3='S' where codigo='24670012'
update #comploja set conta3='S' where codigo='6130022'
update #comploja set conta3='S' where codigo='24670020'
update #comploja set conta3='S' where codigo='6130599'
update #comploja set conta3='S' where codigo='6130665'
update #comploja set conta3='S' where codigo='10330001'
update #comploja set conta3='S' where codigo='6800013'
update #comploja set conta3='S' where codigo='25270005'
update #comploja set conta3='S' where codigo='7653270'
update #comploja set conta3='S' where codigo='25270002'
update #comploja set conta3='S' where codigo='10420006'
update #comploja set conta3='S' where codigo='10820016'
update #comploja set conta3='S' where codigo='11490009'
update #comploja set conta3='S' where codigo='1440217'
update #comploja set conta3='S' where codigo='0055583'
update #comploja set conta3='S' where codigo='1440003'
update #comploja set conta3='S' where codigo='0632138'
update #comploja set conta3='S' where codigo='0631916'
update #comploja set conta3='S' where codigo='5260604'
update #comploja set conta3='S' where codigo='0054744'
update #comploja set conta3='S' where codigo='3570193'
update #comploja set conta3='S' where codigo='3570169'
update #comploja set conta3='S' where codigo='3571564'
update #comploja set conta3='S' where codigo='3570177'
update #comploja set conta3='S' where codigo='3570223'
update #comploja set conta3='S' where codigo='3571319'
update #comploja set conta3='S' where codigo='3570215'
update #comploja set conta3='S' where codigo='6592171'
update #comploja set conta3='S' where codigo='0630252'
update #comploja set conta3='S' where codigo='0054624'
update #comploja set conta3='S' where codigo='0054800'
update #comploja set conta3='S' where codigo='0051683'
update #comploja set conta3='S' where codigo='0630262'
update #comploja set conta3='S' where codigo='0630238'
update #comploja set conta3='S' where codigo='6592082'
update #comploja set conta3='S' where codigo='0055712'
update #comploja set conta3='S' where codigo='8479010'
update #comploja set conta3='S' where codigo='8478868'
update #comploja set conta3='S' where codigo='0090836'
update #comploja set conta3='S' where codigo='0090638'
update #comploja set conta3='S' where codigo='8478821'
update #comploja set conta3='S' where codigo='0090646'
update #comploja set conta3='S' where codigo='0630490'
update #comploja set conta3='S' where codigo='10290005'
update #comploja set conta3='S' where codigo='3793559'
update #comploja set conta3='S' where codigo='7881690'
update #comploja set conta3='S' where codigo='0419720'
update #comploja set conta3='S' where codigo='0410067'
update #comploja set conta3='S' where codigo='6430430'
update #comploja set conta3='S' where codigo='0410107'
update #comploja set conta3='S' where codigo='0410058'
update #comploja set conta3='S' where codigo='9650073'
update #comploja set conta3='S' where codigo='23860014'
update #comploja set conta3='S' where codigo='3251352'
update #comploja set conta3='S' where codigo='3571467'
update #comploja set conta3='S' where codigo='8508194'
update #comploja set conta3='S' where codigo='0419712'
update #comploja set conta3='S' where codigo='7650019'
update #comploja set conta3='S' where codigo='7653258'
update #comploja set conta3='S' where codigo='0413364'
update #comploja set conta3='S' where codigo='8501718'
update #comploja set conta3='S' where codigo='1532529'
update #comploja set conta3='S' where codigo='8507759'
update #comploja set conta3='S' where codigo='8508321'
update #comploja set conta3='S' where codigo='8500452'
update #comploja set conta3='S' where codigo='0050440'
update #comploja set conta3='S' where codigo='4820762'
update #comploja set conta3='S' where codigo='0050441'
update #comploja set conta3='S' where codigo='7881333'
update #comploja set conta3='S' where codigo='4520042'
update #comploja set conta3='S' where codigo='4520012'
update #comploja set conta3='S' where codigo='7881352'
update #comploja set conta3='S' where codigo='4520040'
update #comploja set conta3='S' where codigo='5220257'
update #comploja set conta3='S' where codigo='7881568'
update #comploja set conta3='S' where codigo='7881606'
update #comploja set conta3='S' where codigo='7881290'
update #comploja set conta3='S' where codigo='0125032'
update #comploja set conta3='S' where codigo='0125041'
update #comploja set conta3='S' where codigo='0124991'
update #comploja set conta3='S' where codigo='0125059'
update #comploja set conta3='S' where codigo='1534467'
update #comploja set conta3='S' where codigo='1530055'
update #comploja set conta3='S' where codigo='0128990'
update #comploja set conta3='S' where codigo='0124966'
update #comploja set conta3='S' where codigo='0122939'
update #comploja set conta3='S' where codigo='0125067'
update #comploja set conta3='S' where codigo='1535085'
update #comploja set conta3='S' where codigo='0124974'
update #comploja set conta3='S' where codigo='10300088'
update #comploja set conta3='S' where codigo='1530803'
update #comploja set conta3='S' where codigo='1530805'
update #comploja set conta3='S' where codigo='0419931'
update #comploja set conta3='S' where codigo='0630320'
update #comploja set conta3='S' where codigo='0632120'
update #comploja set conta3='S' where codigo='99980228'
update #comploja set conta3='S' where codigo='4680154'
update #comploja set conta3='S' where codigo='20961906'
update #comploja set conta3='S' where codigo='1750401'
update #comploja set conta3='S' where codigo='4680499'
update #comploja set conta3='S' where codigo='4040023'
update #comploja set conta3='S' where codigo='4680448'
update #comploja set conta3='S' where codigo='8414394'
update #comploja set conta3='S' where codigo='4680430'
update #comploja set conta3='S' where codigo='4680537'
update #comploja set conta3='S' where codigo='4680516'
update #comploja set conta3='S' where codigo='5411928'
update #comploja set conta3='S' where codigo='5411877'
update #comploja set conta3='S' where codigo='5411854'
update #comploja set conta3='S' where codigo='5411851'
update #comploja set conta3='S' where codigo='4680518'
update #comploja set conta3='S' where codigo='8414335'
update #comploja set conta3='S' where codigo='18990156'
update #comploja set conta3='S' where codigo='4680219'
update #comploja set conta3='S' where codigo='3574205'
update #comploja set conta3='S' where codigo='3574209'
update #comploja set conta3='S' where codigo='3573923'
update #comploja set conta3='S' where codigo='3574207'
update #comploja set conta3='S' where codigo='0061697'
update #comploja set conta3='S' where codigo='3574210'
update #comploja set conta3='S' where codigo='3573761'
update #comploja set conta3='S' where codigo='0061960'
update #comploja set conta3='S' where codigo='3570681'
update #comploja set conta3='S' where codigo='3573818'
update #comploja set conta3='S' where codigo='3570916'
update #comploja set conta3='S' where codigo='0060666'
update #comploja set conta3='S' where codigo='0063983'
update #comploja set conta3='S' where codigo='3573788'
update #comploja set conta3='S' where codigo='13610015'
update #comploja set conta3='S' where codigo='0060723'
update #comploja set conta3='S' where codigo='0060524'
update #comploja set conta3='S' where codigo='3574208'
update #comploja set conta3='S' where codigo='0060275'
update #comploja set conta3='S' where codigo='7881250'
update #comploja set conta3='S' where codigo='0060052'
update #comploja set conta3='S' where codigo='0061496'
update #comploja set conta3='S' where codigo='7570046'
update #comploja set conta3='S' where codigo='8478252'
update #comploja set conta3='S' where codigo='7880823'
update #comploja set conta3='S' where codigo='10993551'
update #comploja set conta3='S' where codigo='3940012'
update #comploja set conta3='S' where codigo='4381858'
update #comploja set conta3='S' where codigo='4382117'
update #comploja set conta3='S' where codigo='1160182'
update #comploja set conta3='S' where codigo='1160181'
update #comploja set conta3='S' where codigo='6535544'
update #comploja set conta3='S' where codigo='6530478'
update #comploja set conta3='S' where codigo='6530508'
update #comploja set conta3='S' where codigo='1640089'
update #comploja set conta3='S' where codigo='25510048'
update #comploja set conta3='S' where codigo='25930013'
update #comploja set conta3='S' where codigo='14690018'
update #comploja set conta3='S' where codigo='10000002'
update #comploja set conta3='S' where codigo='2540061'
update #comploja set conta3='S' where codigo='25510041'

update lancar_e2 set c3=0

update #comploja set c3=7 where codigo='4250664' and c3=0
update #comploja set c3=76 where codigo='16530081' and c3=0
update #comploja set c3=15 where codigo='7881350' and c3=0
update #comploja set c3=42 where codigo='7885890' and c3=0
update #comploja set c3=139 where codigo='0120015' and c3=0
update #comploja set c3=46 where codigo='4520173' and c3=0
update #comploja set c3=103 where codigo='7885946' and c3=0
update #comploja set c3=4 where codigo='8502609' and c3=0
update #comploja set c3=11 where codigo='8502510' and c3=0
update #comploja set c3=7 where codigo='8502625' and c3=0
update #comploja set c3=23 where codigo='3791025' and c3=0
update #comploja set c3=82 where codigo='3794631' and c3=0
update #comploja set c3=4 where codigo='3791173' and c3=0
update #comploja set c3=18 where codigo='3794732' and c3=0
update #comploja set c3=9 where codigo='3790479' and c3=0
update #comploja set c3=29 where codigo='3790096' and c3=0
update #comploja set c3=5 where codigo='23880003' and c3=0
update #comploja set c3=77 where codigo='3790088' and c3=0
update #comploja set c3=9 where codigo='7040288' and c3=0
update #comploja set c3=2 where codigo='8460027' and c3=0
update #comploja set c3=89 where codigo='18990083' and c3=0
update #comploja set c3=19 where codigo='0072192' and c3=0
update #comploja set c3=42 where codigo='7602494' and c3=0
update #comploja set c3=50 where codigo='7880993' and c3=0
update #comploja set c3=2 where codigo='3660354' and c3=0
update #comploja set c3=3 where codigo='6461654' and c3=0
update #comploja set c3=4 where codigo='6461379' and c3=0
update #comploja set c3=1 where codigo='5380900' and c3=0
update #comploja set c3=5 where codigo='7600062' and c3=0
update #comploja set c3=20 where codigo='18230031' and c3=0
update #comploja set c3=43 where codigo='7900538' and c3=0
update #comploja set c3=21 where codigo='0040193' and c3=0
update #comploja set c3=20 where codigo='10490015' and c3=0
update #comploja set c3=17 where codigo='7880427' and c3=0
update #comploja set c3=24 where codigo='7900627' and c3=0
update #comploja set c3=1 where codigo='7600643' and c3=0
update #comploja set c3=9 where codigo='23740010' and c3=0
update #comploja set c3=1 where codigo='8490414' and c3=0
update #comploja set c3=8 where codigo='18990011' and c3=0
update #comploja set c3=16 where codigo='0041602' and c3=0
update #comploja set c3=10 where codigo='2531380' and c3=0
update #comploja set c3=3 where codigo='10770002' and c3=0
update #comploja set c3=10 where codigo='0040584' and c3=0
update #comploja set c3=53 where codigo='7900782' and c3=0
update #comploja set c3=17 where codigo='0040169' and c3=0
update #comploja set c3=7 where codigo='10490002' and c3=0
update #comploja set c3=4 where codigo='0040142' and c3=0
update #comploja set c3=5 where codigo='0040304' and c3=0
update #comploja set c3=14.191 where codigo='16310031' and c3=0
update #comploja set c3=15 where codigo='0040185' and c3=0
update #comploja set c3=5 where codigo='6550118' and c3=0
update #comploja set c3=2 where codigo='7900771' and c3=0
update #comploja set c3=6 where codigo='8348659' and c3=0
update #comploja set c3=10 where codigo='1561120' and c3=0
update #comploja set c3=4 where codigo='23740011' and c3=0
update #comploja set c3=7 where codigo='0040541' and c3=0
update #comploja set c3=10 where codigo='2531437' and c3=0
update #comploja set c3=6 where codigo='8490465' and c3=0
update #comploja set c3=3 where codigo='3257030' and c3=0
update #comploja set c3=4 where codigo='0074637' and c3=0
update #comploja set c3=4 where codigo='8021031' and c3=0
update #comploja set c3=43 where codigo='8490522' and c3=0
update #comploja set c3=38 where codigo='3250892' and c3=0
update #comploja set c3=2 where codigo='0074638' and c3=0
update #comploja set c3=4 where codigo='0074900' and c3=0
update #comploja set c3=8 where codigo='8479005' and c3=0
update #comploja set c3=2 where codigo='8479002' and c3=0
update #comploja set c3=4 where codigo='7300137' and c3=0
update #comploja set c3=9 where codigo='0042223' and c3=0
update #comploja set c3=11 where codigo='10840107' and c3=0
update #comploja set c3=11 where codigo='10840211' and c3=0
update #comploja set c3=3 where codigo='1560948' and c3=0
update #comploja set c3=10 where codigo='0040001' and c3=0
update #comploja set c3=9 where codigo='5510635' and c3=0
update #comploja set c3=8 where codigo='5510597' and c3=0
update #comploja set c3=14 where codigo='10840206' and c3=0
update #comploja set c3=7 where codigo='8130016' and c3=0
update #comploja set c3=4 where codigo='8740017' and c3=0
update #comploja set c3=2 where codigo='4140127' and c3=0
update #comploja set c3=8 where codigo='4140019' and c3=0
update #comploja set c3=3 where codigo='8130022' and c3=0
update #comploja set c3=458 where codigo='2130350' and c3=0
update #comploja set c3=10 where codigo='0419819' and c3=0
update #comploja set c3=10 where codigo='14060069' and c3=0
update #comploja set c3=84 where codigo='0419830' and c3=0
update #comploja set c3=38 where codigo='0419825' and c3=0
update #comploja set c3=174 where codigo='2540010' and c3=0
update #comploja set c3=122 where codigo='4720028' and c3=0
update #comploja set c3=264 where codigo='4720055' and c3=0
update #comploja set c3=3 where codigo='7010290' and c3=0
update #comploja set c3=3 where codigo='3252038' and c3=0
update #comploja set c3=4 where codigo='0041327' and c3=0
update #comploja set c3=3 where codigo='0041335' and c3=0
update #comploja set c3=2 where codigo='13670035' and c3=0
update #comploja set c3=3 where codigo='6530421' and c3=0
update #comploja set c3=17 where codigo='13670043' and c3=0
update #comploja set c3=87 where codigo='0411370' and c3=0
update #comploja set c3=234 where codigo='0413372' and c3=0
update #comploja set c3=4 where codigo='2860071' and c3=0
update #comploja set c3=1 where codigo='11450003' and c3=0
update #comploja set c3=5 where codigo='15700002' and c3=0
update #comploja set c3=1 where codigo='7653270' and c3=0
update #comploja set c3=204 where codigo='25270002' and c3=0
update #comploja set c3=23 where codigo='23740002' and c3=0
update #comploja set c3=43 where codigo='3570193' and c3=0
update #comploja set c3=52 where codigo='3570169' and c3=0
update #comploja set c3=27 where codigo='3571319' and c3=0
update #comploja set c3=52 where codigo='3570215' and c3=0
update #comploja set c3=53 where codigo='3570223' and c3=0
update #comploja set c3=32 where codigo='3571564' and c3=0
update #comploja set c3=0 where codigo='3570177' and c3=0
update #comploja set c3=51 where codigo='0054800' and c3=0
update #comploja set c3=13 where codigo='0054624' and c3=0
update #comploja set c3=6 where codigo='0054321' and c3=0
update #comploja set c3=4 where codigo='0630461' and c3=0
update #comploja set c3=3 where codigo='3250470' and c3=0
update #comploja set c3=8 where codigo='20961529' and c3=0
update #comploja set c3=2 where codigo='18250005' and c3=0
update #comploja set c3=19 where codigo='3252009' and c3=0
update #comploja set c3=18 where codigo='3251490' and c3=0
update #comploja set c3=11 where codigo='8423431' and c3=0
update #comploja set c3=3 where codigo='9160009' and c3=0
update #comploja set c3=33 where codigo='3250706' and c3=0
update #comploja set c3=30 where codigo='3250965' and c3=0
update #comploja set c3=26 where codigo='3251190' and c3=0
update #comploja set c3=5 where codigo='3794706' and c3=0
update #comploja set c3=8 where codigo='3251751' and c3=0
update #comploja set c3=30 where codigo='3794709' and c3=0
update #comploja set c3=36 where codigo='3794708' and c3=0
update #comploja set c3=2 where codigo='3252056' and c3=0
update #comploja set c3=2 where codigo='3252057' and c3=0
update #comploja set c3=25 where codigo='3254488' and c3=0
update #comploja set c3=27 where codigo='3254453' and c3=0
update #comploja set c3=1 where codigo='3250216' and c3=0
update #comploja set c3=27 where codigo='8420122' and c3=0
update #comploja set c3=8 where codigo='3251210' and c3=0
update #comploja set c3=4 where codigo='7450079' and c3=0
update #comploja set c3=10 where codigo='3794754' and c3=0
update #comploja set c3=1 where codigo='23860018' and c3=0
update #comploja set c3=16 where codigo='3250912' and c3=0
update #comploja set c3=234 where codigo='3794730' and c3=0
update #comploja set c3=7 where codigo='3252031' and c3=0
update #comploja set c3=8 where codigo='3251927' and c3=0
update #comploja set c3=4 where codigo='0410067' and c3=0
update #comploja set c3=2 where codigo='6430996' and c3=0
update #comploja set c3=16 where codigo='9650058' and c3=0
update #comploja set c3=8 where codigo='0050077' and c3=0
update #comploja set c3=50 where codigo='9650002' and c3=0
update #comploja set c3=5 where codigo='0050082' and c3=0
update #comploja set c3=78 where codigo='9650001' and c3=0
update #comploja set c3=2 where codigo='14950109' and c3=0
update #comploja set c3=7 where codigo='10881133' and c3=0
update #comploja set c3=2 where codigo='8711089' and c3=0
update #comploja set c3=5 where codigo='4220031' and c3=0
update #comploja set c3=8 where codigo='9650079' and c3=0
update #comploja set c3=1 where codigo='14950183' and c3=0
update #comploja set c3=5 where codigo='0050081' and c3=0
update #comploja set c3=21 where codigo='9650006' and c3=0
update #comploja set c3=2 where codigo='26290026' and c3=0
update #comploja set c3=2 where codigo='26290029' and c3=0
update #comploja set c3=5 where codigo='11970004' and c3=0
update #comploja set c3=2 where codigo='26290030' and c3=0
update #comploja set c3=127 where codigo='18990078' and c3=0
update #comploja set c3=8 where codigo='4520072' and c3=0
update #comploja set c3=4 where codigo='16980073' and c3=0
update #comploja set c3=71 where codigo='16530015' and c3=0
update #comploja set c3=17 where codigo='6523000' and c3=0
update #comploja set c3=257 where codigo='7881374' and c3=0
update #comploja set c3=200 where codigo='1082604' and c3=0
update #comploja set c3=506 where codigo='4520347' and c3=0
update #comploja set c3=15 where codigo='7881607' and c3=0
update #comploja set c3=15 where codigo='7881605' and c3=0
update #comploja set c3=143 where codigo='7881314' and c3=0
update #comploja set c3=206 where codigo='7881317' and c3=0
update #comploja set c3=29 where codigo='7881315' and c3=0
update #comploja set c3=45 where codigo='6522718' and c3=0
update #comploja set c3=71 where codigo='1080062' and c3=0
update #comploja set c3=56 where codigo='6522984' and c3=0
update #comploja set c3=38 where codigo='6522990' and c3=0
update #comploja set c3=255 where codigo='1081552' and c3=0
update #comploja set c3=264 where codigo='1721002' and c3=0
update #comploja set c3=70 where codigo='7882271' and c3=0
update #comploja set c3=16 where codigo='6522904' and c3=0
update #comploja set c3=60 where codigo='8490566' and c3=0
update #comploja set c3=184 where codigo='6522173' and c3=0
update #comploja set c3=19 where codigo='4520097' and c3=0
update #comploja set c3=19 where codigo='4520485' and c3=0
update #comploja set c3=43 where codigo='4520486' and c3=0
update #comploja set c3=44 where codigo='7881377' and c3=0
update #comploja set c3=23 where codigo='4520101' and c3=0
update #comploja set c3=142 where codigo='7885903' and c3=0
update #comploja set c3=22 where codigo='4520092' and c3=0
update #comploja set c3=23 where codigo='6521096' and c3=0
update #comploja set c3=9 where codigo='7881591' and c3=0
update #comploja set c3=97 where codigo='16530131' and c3=0
update #comploja set c3=13 where codigo='16530132' and c3=0
update #comploja set c3=225 where codigo='6520367' and c3=0
update #comploja set c3=18 where codigo='6522930' and c3=0
update #comploja set c3=10 where codigo='7881135' and c3=0
update #comploja set c3=104 where codigo='6522925' and c3=0
update #comploja set c3=95 where codigo='6520952' and c3=0
update #comploja set c3=1 where codigo='7881196' and c3=0
update #comploja set c3=8 where codigo='7889461' and c3=0
update #comploja set c3=3 where codigo='7889453' and c3=0
update #comploja set c3=223 where codigo='7887671' and c3=0
update #comploja set c3=2 where codigo='7881501' and c3=0
update #comploja set c3=62 where codigo='4520285' and c3=0
update #comploja set c3=79 where codigo='7910045' and c3=0
update #comploja set c3=13 where codigo='7880366' and c3=0
update #comploja set c3=284 where codigo='7880221' and c3=0
update #comploja set c3=143 where codigo='4170067' and c3=0
update #comploja set c3=31 where codigo='7881402' and c3=0
update #comploja set c3=53 where codigo='4520062' and c3=0
update #comploja set c3=75 where codigo='7880614' and c3=0
update #comploja set c3=134 where codigo='4520625' and c3=0
update #comploja set c3=125 where codigo='0413364' and c3=0
update #comploja set c3=290 where codigo='7650019' and c3=0
update #comploja set c3=74 where codigo='3571467' and c3=0
update #comploja set c3=100 where codigo='1210041' and c3=0
update #comploja set c3=100 where codigo='1210050' and c3=0
update #comploja set c3=58 where codigo='4520015' and c3=0
update #comploja set c3=63 where codigo='4520040' and c3=0
update #comploja set c3=412 where codigo='0124991' and c3=0
update #comploja set c3=1097 where codigo='0125059' and c3=0
update #comploja set c3=325 where codigo='0125067' and c3=0
update #comploja set c3=769 where codigo='0128990' and c3=0
update #comploja set c3=417 where codigo='0419931' and c3=0
update #comploja set c3=120 where codigo='0124974' and c3=0
update #comploja set c3=37 where codigo='6520944' and c3=0
update #comploja set c3=149 where codigo='0632120' and c3=0
update #comploja set c3=40 where codigo='4210034' and c3=0
update #comploja set c3=16 where codigo='4150067' and c3=0
update #comploja set c3=37 where codigo='4210247' and c3=0
update #comploja set c3=9 where codigo='4150072' and c3=0
update #comploja set c3=31 where codigo='4210042' and c3=0
update #comploja set c3=25 where codigo='4150031' and c3=0
update #comploja set c3=3 where codigo='5412018' and c3=0
update #comploja set c3=9 where codigo='5412002' and c3=0
update #comploja set c3=17 where codigo='5410142' and c3=0
update #comploja set c3=4 where codigo='5411855' and c3=0
update #comploja set c3=13 where codigo='5411923' and c3=0
update #comploja set c3=11 where codigo='5412009' and c3=0
update #comploja set c3=33 where codigo='5412019' and c3=0
update #comploja set c3=6 where codigo='5410012' and c3=0
update #comploja set c3=49 where codigo='5412095' and c3=0
update #comploja set c3=57 where codigo='5410016' and c3=0
update #comploja set c3=83 where codigo='5410096' and c3=0
update #comploja set c3=15 where codigo='8414238' and c3=0
update #comploja set c3=64 where codigo='8412162' and c3=0
update #comploja set c3=52 where codigo='8412200' and c3=0
update #comploja set c3=10 where codigo='8414165' and c3=0
update #comploja set c3=212 where codigo='9940474' and c3=0
update #comploja set c3=34 where codigo='18990159' and c3=0
update #comploja set c3=6 where codigo='8414408' and c3=0
update #comploja set c3=2 where codigo='8414173' and c3=0
update #comploja set c3=25 where codigo='8412170' and c3=0
update #comploja set c3=17 where codigo='3760138' and c3=0
update #comploja set c3=9 where codigo='8412243' and c3=0
update #comploja set c3=30 where codigo='8414211' and c3=0
update #comploja set c3=35 where codigo='3574208' and c3=0
update #comploja set c3=4 where codigo='0060232' and c3=0
update #comploja set c3=8 where codigo='4290201' and c3=0
update #comploja set c3=14 where codigo='7881373' and c3=0
update #comploja set c3=47 where codigo='4525526' and c3=0
update #comploja set c3=59 where codigo='16530017' and c3=0
update #comploja set c3=3 where codigo='0069775' and c3=0
update #comploja set c3=25 where codigo='7880212' and c3=0
update #comploja set c3=4 where codigo='0060672' and c3=0
update #comploja set c3=52 where codigo='0060186' and c3=0
update #comploja set c3=2 where codigo='0060048' and c3=0
update #comploja set c3=6 where codigo='0060024' and c3=0
update #comploja set c3=45 where codigo='4520635' and c3=0
update #comploja set c3=227 where codigo='24190001' and c3=0
update #comploja set c3=100 where codigo='8410056' and c3=0
update #comploja set c3=2 where codigo='4529685' and c3=0
update #comploja set c3=90 where codigo='3940012' and c3=0
update #comploja set c3=62 where codigo='0060052' and c3=0
update #comploja set c3=1 where codigo='1160002' and c3=0
update #comploja set c3=60 where codigo='4382117' and c3=0
update #comploja set c3=29 where codigo='3251222' and c3=0
update #comploja set c3=2 where codigo='8421263' and c3=0
update #comploja set c3=31 where codigo='3794802' and c3=0
update #comploja set c3=3 where codigo='10300246' and c3=0
update #comploja set c3=4 where codigo='10300233' and c3=0
update #comploja set c3=6 where codigo='3251092' and c3=0
update #comploja set c3=7 where codigo='3250481' and c3=0
update #comploja set c3=20 where codigo='8420636' and c3=0
update #comploja set c3=5 where codigo='8420021' and c3=0
update #comploja set c3=21 where codigo='18160100' and c3=0
update #comploja set c3=2 where codigo='6532578' and c3=0
update #comploja set c3=14 where codigo='1641123' and c3=0
update #comploja set c3=8 where codigo='6530508' and c3=0
update #comploja set c3=8 where codigo='24380071' and c3=0
update #comploja set c3=13 where codigo='18020001' and c3=0
update #comploja set c3=5 where codigo='24380072' and c3=0
update #comploja set c3=2 where codigo='13520028' and c3=0
update #comploja set c3=3 where codigo='2814127' and c3=0
update #comploja set c3=5 where codigo='2814073' and c3=0
update #comploja set c3=7 where codigo='2814129' and c3=0
update #comploja set c3=6 where codigo='2814071' and c3=0
update #comploja set c3=4 where codigo='6591930' and c3=0

select * from lancar_e2 where c1=c2 and lancar=0

update lancar_e2 set lancar=1 where codigo='10770027'

select * from lancar_e2 where codigo='4720051'

select * from lancar_e2 where lancar=0 and exists(select * from #recontloja2 where #recontloja2.codigo=lancar_e2.codigo) and conta3='N'

select * from lancar_e2 where lancar=c1 or lancar=c2 or lancar=c3 and lancar > 0

select *,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao

 from #comploja where c3<>c1 and c3<>c2 and c3 > 0 and exists(select '' from #recontloja2 where #recontloja2.codigo=#comploja.codigo)

select *,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigo collate database_default) as descricao

select PROCOD,MDSPRODES,MDSUNI,MDSQTD into saldoloja from TBS049 with (nolock)
 where MDSTIP='S' and LESCOD=2 and MDSOBS='SALDO ZERADO PARA INVENTARIO' and MDSUSU='INTEGROS' and convert(date,MDSLAN,112)='20181117' --and LOG51 >= 1290489
order by LOG51

alter table comploja2 add estant decimal(10,3)

update comploja2 set estant=0

update comploja2 set estant=(select MDSQTD from saldoloja where PROCOD=codigo)

select * from comploja2 where estant is null

update comploja2 set estant=0 where estant is null

select estant,* from comploja2 where lancar=0 and (estant=c1 or estant=c2 or estant=c3 or estant=c4)

select estant,* from comploja2 where lancar=0 and estant=c1

select estant,* from comploja2 where lancar=0 and estant=c2

alter table comploja2 add ajuste char(1)

update comploja2 set ajuste='N' where ajuste is null

rollback tran

begin tran
update comploja2 set lancar=c1,ajuste='S' where lancar=0 and estant=c1
commit tran

begin tran
update comploja2 set lancar=c2,ajuste='S' where lancar=0 and estant=c2
commit tran

select estant,* from comploja2 where ajuste='S' and lancar=0

select estant,lancar,* from comploja2 where ajuste='S' and lancar = 0

begin tran
update comploja2 set lancar=0 where ajuste='S'
commit tran

begin tran
update comploja2 set ajuste='N' where ajuste='S' and lancar = 0
commit tran

select estant,lancar,* from comploja2 where ajuste='S'

select * from produto

delete produto

begin tran
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,codigo,lancar from comploja2 where ajuste='S'
commit tran

alter table comploja2 add e1 varchar(20)
alter table comploja2 add e2 varchar(20)
alter table comploja2 add e3 varchar(20)
alter table comploja2 add e4 varchar(20)

update comploja2 set e1='',e2='',e3='',e4=''

update comploja2 set e1=(select endereco from #endereco where codigo=codigoProduto and Row#=1)

update comploja2 set e2=(select endereco from #endereco where codigo=codigoProduto and Row#=2)

update comploja2 set e3=(select endereco from #endereco where codigo=codigoProduto and Row#=3)

update comploja2 set e4=(select endereco from #endereco where codigo=codigoProduto and Row#=4)


-- ajustes 19/11/18 lista 80 itens

select * from comploja2

alter table comploja2 add c5 decimal(10,3)

alter table comploja2 add ajuste5 char(1)

update comploja2 set c5=0

select numeroContagem from INV03 where localEstoque=2 group by numeroContagem order by numeroContagem

-- insere itens da planilha

select * from produto with (nolock)

delete produto

insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'6480250',52
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7041858',1
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'11920012',5.5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'9070044',22.5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'9070940',24
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'9070052',31
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'9070303',14.5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'9070150',47
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'9070168',32.5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'9071295',42.5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'9070214',46.5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'10910643',11.5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'10910646',13
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'10910649',6
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'16620001',7.5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0072273',45
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0072141',8
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0072176',21
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'6461742',2
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7900769',1
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7880426',3
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7880411',4
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'1561049',12
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'2531461',1
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7600259',2
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'3634187',7
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'3635560',3
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'3634102',11
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0930016',5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7300138',15
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7300136',17
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'8479003',7
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'10840201',3
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'10840054',5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'6130601',2
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'11490010',2
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'3251188',1
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'6522987',18
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'6523001',5
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7910739',8
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7881178',1
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7880292',14
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7880240',13
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'7881483',1
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0061133',20
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0061135',12
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0061130',11
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0061137',9
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0061128',14
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'4290012',10
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'4170121',29
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'4528921',21
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'16530092',48
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'4680308',2
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'5412096',35
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0064769',18
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0066230',3
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0066273',37
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0060355',16
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0066320',22
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0066249',24
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0061670',16
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0062715',33
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'0060489',16
insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,'25510037',2



select * from INV03 where localEstoque=2 and numeroContagem=5

-----


update #comploja set c3=7 where codigo='4250664'
update #comploja set c3=76 where codigo='16530081'
update #comploja set c3=15 where codigo='7881350'
update #comploja set c3=42 where codigo='7885890'
update #comploja set c3=139 where codigo='0120015'
update #comploja set c3=46 where codigo='4520173'
update #comploja set c3=103 where codigo='7885946'
update #comploja set c3=4 where codigo='8502609'
update #comploja set c3=11 where codigo='8502510'
update #comploja set c3=7 where codigo='8502625'
update #comploja set c3=23 where codigo='3791025'
update #comploja set c3=82 where codigo='3794631'
update #comploja set c3=4 where codigo='3791173'
update #comploja set c3=18 where codigo='3794732'
update #comploja set c3=9 where codigo='3790479'
update #comploja set c3=29 where codigo='3790096'
update #comploja set c3=5 where codigo='23880003'
update #comploja set c3=77 where codigo='3790088'
update #comploja set c3=9 where codigo='7040288'
update #comploja set c3=2 where codigo='8460027'
update #comploja set c3=89 where codigo='18990083'
update #comploja set c3=19 where codigo='0072192'
update #comploja set c3=42 where codigo='7602494'
update #comploja set c3=50 where codigo='7880993'
update #comploja set c3=2 where codigo='3660354'
update #comploja set c3=3 where codigo='6461654'
update #comploja set c3=4 where codigo='6461379'
update #comploja set c3=1 where codigo='5380900'
update #comploja set c3=5 where codigo='7600062'
update #comploja set c3=20 where codigo='18230031'
update #comploja set c3=43 where codigo='7900538'
update #comploja set c3=21 where codigo='0040193'
update #comploja set c3=20 where codigo='10490015'
update #comploja set c3=17 where codigo='7880427'
update #comploja set c3=24 where codigo='7900627'
update #comploja set c3=1 where codigo='7600643'
update #comploja set c3=9 where codigo='23740010'
update #comploja set c3=1 where codigo='8490414'
update #comploja set c3=8 where codigo='18990011'
update #comploja set c3=16 where codigo='0041602'
update #comploja set c3=10 where codigo='2531380'
update #comploja set c3=3 where codigo='10770002'
update #comploja set c3=10 where codigo='0040584'
update #comploja set c3=53 where codigo='7900782'
update #comploja set c3=17 where codigo='0040169'
update #comploja set c3=7 where codigo='10490002'
update #comploja set c3=4 where codigo='0040142'
update #comploja set c3=5 where codigo='0040304'
update #comploja set c3=14.191 where codigo='16310031'
update #comploja set c3=15 where codigo='0040185'
update #comploja set c3=5 where codigo='6550118'
update #comploja set c3=2 where codigo='7900771'
update #comploja set c3=6 where codigo='8348659'
update #comploja set c3=10 where codigo='1561120'
update #comploja set c3=4 where codigo='23740011'
update #comploja set c3=7 where codigo='0040541'
update #comploja set c3=10 where codigo='2531437'
update #comploja set c3=6 where codigo='8490465'
update #comploja set c3=3 where codigo='3257030'
update #comploja set c3=4 where codigo='0074637'
update #comploja set c3=4 where codigo='8021031'
update #comploja set c3=43 where codigo='8490522'
update #comploja set c3=38 where codigo='3250892'
update #comploja set c3=2 where codigo='0074638'
update #comploja set c3=4 where codigo='0074900'
update #comploja set c3=8 where codigo='8479005'
update #comploja set c3=2 where codigo='8479002'
update #comploja set c3=4 where codigo='7300137'
update #comploja set c3=9 where codigo='0042223'
update #comploja set c3=11 where codigo='10840107'
update #comploja set c3=11 where codigo='10840211'
update #comploja set c3=3 where codigo='1560948'
update #comploja set c3=10 where codigo='0040001'
update #comploja set c3=9 where codigo='5510635'
update #comploja set c3=8 where codigo='5510597'
update #comploja set c3=14 where codigo='10840206'
update #comploja set c3=7 where codigo='8130016'
update #comploja set c3=4 where codigo='8740017'
update #comploja set c3=2 where codigo='4140127'
update #comploja set c3=8 where codigo='4140019'
update #comploja set c3=3 where codigo='8130022'
update #comploja set c3=458 where codigo='2130350'
update #comploja set c3=10 where codigo='0419819'
update #comploja set c3=10 where codigo='14060069'
update #comploja set c3=84 where codigo='0419830'
update #comploja set c3=38 where codigo='0419825'
update #comploja set c3=174 where codigo='2540010'
update #comploja set c3=122 where codigo='4720028'
update #comploja set c3=264 where codigo='4720055'
update #comploja set c3=3 where codigo='7010290'
update #comploja set c3=3 where codigo='3252038'
update #comploja set c3=4 where codigo='0041327'
update #comploja set c3=3 where codigo='0041335'
update #comploja set c3=2 where codigo='13670035'
update #comploja set c3=3 where codigo='6530421'
update #comploja set c3=17 where codigo='13670043'
update #comploja set c3=87 where codigo='0411370'
update #comploja set c3=234 where codigo='0413372'
update #comploja set c3=4 where codigo='2860071'
update #comploja set c3=1 where codigo='11450003'
update #comploja set c3=5 where codigo='15700002'
update #comploja set c3=1 where codigo='7653270'
update #comploja set c3=204 where codigo='25270002'
update #comploja set c3=23 where codigo='23740002'
update #comploja set c3=43 where codigo='3570193'
update #comploja set c3=52 where codigo='3570169'
update #comploja set c3=27 where codigo='3571319'
update #comploja set c3=52 where codigo='3570215'
update #comploja set c3=53 where codigo='3570223'
update #comploja set c3=32 where codigo='3571564'
update #comploja set c3=0 where codigo='3570177'
update #comploja set c3=51 where codigo='0054800'
update #comploja set c3=13 where codigo='0054624'
update #comploja set c3=6 where codigo='0054321'
update #comploja set c3=4 where codigo='0630461'
update #comploja set c3=3 where codigo='3250470'
update #comploja set c3=8 where codigo='20961529'
update #comploja set c3=2 where codigo='18250005'
update #comploja set c3=19 where codigo='3252009'
update #comploja set c3=18 where codigo='3251490'
update #comploja set c3=11 where codigo='8423431'
update #comploja set c3=3 where codigo='9160009'
update #comploja set c3=33 where codigo='3250706'
update #comploja set c3=30 where codigo='3250965'
update #comploja set c3=26 where codigo='3251190'
update #comploja set c3=5 where codigo='3794706'
update #comploja set c3=8 where codigo='3251751'
update #comploja set c3=30 where codigo='3794709'
update #comploja set c3=36 where codigo='3794708'
update #comploja set c3=2 where codigo='3252056'
update #comploja set c3=2 where codigo='3252057'
update #comploja set c3=25 where codigo='3254488'
update #comploja set c3=27 where codigo='3254453'
update #comploja set c3=1 where codigo='3250216'
update #comploja set c3=27 where codigo='8420122'
update #comploja set c3=8 where codigo='3251210'
update #comploja set c3=4 where codigo='7450079'
update #comploja set c3=10 where codigo='3794754'
update #comploja set c3=1 where codigo='23860018'
update #comploja set c3=16 where codigo='3250912'
update #comploja set c3=234 where codigo='3794730'
update #comploja set c3=7 where codigo='3252031'
update #comploja set c3=8 where codigo='3251927'
update #comploja set c3=4 where codigo='0410067'
update #comploja set c3=2 where codigo='6430996'
update #comploja set c3=16 where codigo='9650058'
update #comploja set c3=8 where codigo='0050077'
update #comploja set c3=50 where codigo='9650002'
update #comploja set c3=5 where codigo='0050082'
update #comploja set c3=78 where codigo='9650001'
update #comploja set c3=2 where codigo='14950109'
update #comploja set c3=7 where codigo='10881133'
update #comploja set c3=2 where codigo='8711089'
update #comploja set c3=5 where codigo='4220031'
update #comploja set c3=8 where codigo='9650079'
update #comploja set c3=1 where codigo='14950183'
update #comploja set c3=5 where codigo='0050081'
update #comploja set c3=21 where codigo='9650006'
update #comploja set c3=2 where codigo='26290026'
update #comploja set c3=2 where codigo='26290029'
update #comploja set c3=5 where codigo='11970004'
update #comploja set c3=2 where codigo='26290030'
update #comploja set c3=127 where codigo='18990078'
update #comploja set c3=8 where codigo='4520072'
update #comploja set c3=4 where codigo='16980073'
update #comploja set c3=71 where codigo='16530015'
update #comploja set c3=17 where codigo='6523000'
update #comploja set c3=257 where codigo='7881374'
update #comploja set c3=200 where codigo='1082604'
update #comploja set c3=506 where codigo='4520347'
update #comploja set c3=15 where codigo='7881607'
update #comploja set c3=15 where codigo='7881605'
update #comploja set c3=143 where codigo='7881314'
update #comploja set c3=206 where codigo='7881317'
update #comploja set c3=29 where codigo='7881315'
update #comploja set c3=45 where codigo='6522718'
update #comploja set c3=71 where codigo='1080062'
update #comploja set c3=56 where codigo='6522984'
update #comploja set c3=38 where codigo='6522990'
update #comploja set c3=255 where codigo='1081552'
update #comploja set c3=264 where codigo='1721002'
update #comploja set c3=70 where codigo='7882271'
update #comploja set c3=16 where codigo='6522904'
update #comploja set c3=60 where codigo='8490566'
update #comploja set c3=184 where codigo='6522173'
update #comploja set c3=19 where codigo='4520097'
update #comploja set c3=19 where codigo='4520485'
update #comploja set c3=43 where codigo='4520486'
update #comploja set c3=44 where codigo='7881377'
update #comploja set c3=23 where codigo='4520101'
update #comploja set c3=142 where codigo='7885903'
update #comploja set c3=22 where codigo='4520092'
update #comploja set c3=23 where codigo='6521096'
update #comploja set c3=9 where codigo='7881591'
update #comploja set c3=97 where codigo='16530131'
update #comploja set c3=13 where codigo='16530132'
update #comploja set c3=225 where codigo='6520367'
update #comploja set c3=18 where codigo='6522930'
update #comploja set c3=10 where codigo='7881135'
update #comploja set c3=104 where codigo='6522925'
update #comploja set c3=95 where codigo='6520952'
update #comploja set c3=1 where codigo='7881196'
update #comploja set c3=8 where codigo='7889461'
update #comploja set c3=3 where codigo='7889453'
update #comploja set c3=223 where codigo='7887671'
update #comploja set c3=2 where codigo='7881501'
update #comploja set c3=62 where codigo='4520285'
update #comploja set c3=79 where codigo='7910045'
update #comploja set c3=13 where codigo='7880366'
update #comploja set c3=284 where codigo='7880221'
update #comploja set c3=143 where codigo='4170067'
update #comploja set c3=31 where codigo='7881402'
update #comploja set c3=53 where codigo='4520062'
update #comploja set c3=75 where codigo='7880614'
update #comploja set c3=134 where codigo='4520625'
update #comploja set c3=125 where codigo='0413364'
update #comploja set c3=290 where codigo='7650019'
update #comploja set c3=74 where codigo='3571467'
update #comploja set c3=100 where codigo='1210041'
update #comploja set c3=100 where codigo='1210050'
update #comploja set c3=58 where codigo='4520015'
update #comploja set c3=63 where codigo='4520040'
update #comploja set c3=412 where codigo='0124991'
update #comploja set c3=1097 where codigo='0125059'
update #comploja set c3=325 where codigo='0125067'
update #comploja set c3=769 where codigo='0128990'
update #comploja set c3=417 where codigo='0419931'
update #comploja set c3=120 where codigo='0124974'
update #comploja set c3=37 where codigo='6520944'
update #comploja set c3=149 where codigo='0632120'
update #comploja set c3=40 where codigo='4210034'
update #comploja set c3=16 where codigo='4150067'
update #comploja set c3=37 where codigo='4210247'
update #comploja set c3=9 where codigo='4150072'
update #comploja set c3=31 where codigo='4210042'
update #comploja set c3=25 where codigo='4150031'
update #comploja set c3=3 where codigo='5412018'
update #comploja set c3=9 where codigo='5412002'
update #comploja set c3=17 where codigo='5410142'
update #comploja set c3=4 where codigo='5411855'
update #comploja set c3=13 where codigo='5411923'
update #comploja set c3=11 where codigo='5412009'
update #comploja set c3=33 where codigo='5412019'
update #comploja set c3=6 where codigo='5410012'
update #comploja set c3=49 where codigo='5412095'
update #comploja set c3=57 where codigo='5410016'
update #comploja set c3=83 where codigo='5410096'
update #comploja set c3=15 where codigo='8414238'
update #comploja set c3=64 where codigo='8412162'
update #comploja set c3=52 where codigo='8412200'
update #comploja set c3=10 where codigo='8414165'
update #comploja set c3=212 where codigo='9940474'
update #comploja set c3=34 where codigo='18990159'
update #comploja set c3=6 where codigo='8414408'
update #comploja set c3=2 where codigo='8414173'
update #comploja set c3=25 where codigo='8412170'
update #comploja set c3=17 where codigo='3760138'
update #comploja set c3=9 where codigo='8412243'
update #comploja set c3=30 where codigo='8414211'
update #comploja set c3=35 where codigo='3574208'
update #comploja set c3=4 where codigo='0060232'
update #comploja set c3=8 where codigo='4290201'
update #comploja set c3=14 where codigo='7881373'
update #comploja set c3=47 where codigo='4525526'
update #comploja set c3=59 where codigo='16530017'
update #comploja set c3=3 where codigo='0069775'
update #comploja set c3=25 where codigo='7880212'
update #comploja set c3=4 where codigo='0060672'
update #comploja set c3=52 where codigo='0060186'
update #comploja set c3=2 where codigo='0060048'
update #comploja set c3=6 where codigo='0060024'
update #comploja set c3=45 where codigo='4520635'
update #comploja set c3=227 where codigo='24190001'
update #comploja set c3=100 where codigo='8410056'
update #comploja set c3=2 where codigo='4529685'
update #comploja set c3=90 where codigo='3940012'
update #comploja set c3=62 where codigo='0060052'
update #comploja set c3=1 where codigo='1160002'
update #comploja set c3=60 where codigo='4382117'
update #comploja set c3=29 where codigo='3251222'
update #comploja set c3=2 where codigo='8421263'
update #comploja set c3=31 where codigo='3794802'
update #comploja set c3=3 where codigo='10300246'
update #comploja set c3=4 where codigo='10300233'
update #comploja set c3=6 where codigo='3251092'
update #comploja set c3=7 where codigo='3250481'
update #comploja set c3=20 where codigo='8420636'
update #comploja set c3=5 where codigo='8420021'
update #comploja set c3=21 where codigo='18160100'
update #comploja set c3=2 where codigo='6532578'
update #comploja set c3=14 where codigo='1641123'
update #comploja set c3=8 where codigo='6530508'
update #comploja set c3=8 where codigo='24380071'
update #comploja set c3=13 where codigo='18020001'
update #comploja set c3=5 where codigo='24380072'
update #comploja set c3=2 where codigo='13520028'
update #comploja set c3=3 where codigo='2814127'
update #comploja set c3=5 where codigo='2814073'
update #comploja set c3=7 where codigo='2814129'
update #comploja set c3=6 where codigo='2814071'
update #comploja set c3=4 where codigo='6591930'


-- 

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

select * into lancado_tanby_loja_estoque_2 from produto

delete produto

insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoQtde) select '',0,codigo,lancar from comploja2 where lancar > 0

update comploja2 set e1=right('00'+rtrim(e1),2)

update comploja2 set e2=right('00'+rtrim(e2),2)

update comploja2 set e3=right('00'+rtrim(e3),2)

update comploja2 set e4=right('00'+rtrim(e4),2)

update comploja2 set e1='' where e1='00'
update comploja2 set e2='' where e2='00'
update comploja2 set e3='' where e3='00'
update comploja2 set e4='' where e4='00'


select * from comploja2
 where lancar = 0 order by e1,descricao

select * from comploja2
 where lancar = 0 and
codigo in('0632120',
'0413364',
'8490566',
'0419825',
'7600062',
'0419830',
'18230031',
'0411370',
'24190001',
'18990078',
'0413372',
'7653270',
'0125059',
'6522990',
'14060069',
'0419819',
'4520173',
'1590948',
'1081552',
'7882271',
'3791173',
'25270002',
'0069775',
'4210034',
'0050077',
'3790479',
'9650058',
'10490015',
'5412018',
'3794732',
'16530132',
'6520944',
'4382117',
'4210247',
'0124974',
'0410067',
'1080062',
'6522925',
'3571319',
'6430996',
'7040288',
'0419931',
'7881607',
'16530017',
'7881591',
'0128990',
'0125067',
'3794730',
'7900782',
'7880366',
'3791025',
'4720055',
'4520635',
'4250320',
'3790479',
'3790460',
'4210476',
'6480799',
'6482041',
'7305460',
'0051764',
'0631994',
'0070255',
'7881625')


