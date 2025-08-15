select top 1 * from BA.SIBD.dbo.produto

select count(*) from produto where produtoQtde > 0

select produtoCodigo, count(produtoCodigo) from produto group by produtoCodigo having count(produtoCodigo) > 1

select * from produto where produtoQtde > 0

delete produto

-- alimenta a tabela de produtos para a contagem

--insert into BA.SIBD.dbo.produto
insert into produto
select --top 100
       '1' as usuarioNome,
       --convert(int,Left(PROLOCFIS,2)) as produtoLote,
       1 as produtoLote,
       TBS010.PROCOD as produtoCodigo,
       GETDATE() as produtoDataLote,
       TBS010.PROCODBAR1 as produtoCodigoBarras,
       replace(TBS010.PRODES,'''','') as produtoDescricao,
       0 as produtoQtde,
       isnull((select replace(MARNOM,'''','') from TBS014 (nolock) where TBS014.MARCOD=TBS010.MARCOD),'') as produtoMarca,
       TBS010.PROUM1 + case when PROUM1QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM1QTD,6)) + ' ' + TBS010.PROUMV else '' end as produtoEmbalagem,
       null as produtoDataHora,
       null as produtoZerado,
       0 as produtoColetas,
       TBS010.PROUM2 + case when TBS010.PROUM2QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM2QTD,6)) else '' end as produtoEmbalagem2,
       TBS010.PROUM3 + case when TBS010.PROUM3QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM3QTD,6)) else '' end as produtoEmbalagem3,
       TBS010.PROUM4 + case when TBS010.PROUM4QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM4QTD,6)) else '' end as produtoEmbalagem4,
       0 as produtoQtde2,
       0 as produtoQtde3,
       0 as produtoQtde4,
       TBS010.PROCODBAR2 as produtoCodigoBarras2,
       TBS010.PROCODBAR3 as produtoCodigoBarras3,
       TBS010.PROCODBAR4 as produtoCodigoBarras4,
       'S' as produtoContagemUnitaria
--  from BA.SIBD.dbo.TBS010 --(nolock)
  from TBS010 (nolock)
-- where Left(PROLOCFIS,2) in('29') -- por localização do estoque
-- where (select top 1 1 from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)>='20160701' order by LMEDATHOR desc) > 0
 where (select top 1 1 from TBS051 (nolock) where TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)>='20170701' and LMELOCEST in(1,2) order by LMEDATHOR desc) > 0 or
       (select top 1 1 from TBS032 (nolock) where TBS032.ESTLOC in(1,2) and TBS032.PROCOD=TBS010.PROCOD and TBS032.ESTQTDATU > 0 order by TBS032.ESTLOC,TBS032.PROCOD) > 0
-- where MARCOD in(1116,174,832,376,1857,926,528,681,1709,11,394)
--   where MARCOD in(648,1707,1655,1892,1813,2226,2221,2223,2228,2227,1117,1390,1357,1698,1143) -- ,130) era 1301
--   where MARCOD in(1301,788,730,2225,2220,357,1536,1893,1120,1891,1648,690,452,172,2440)
-- where MARCOD in(6,482,21,1582,1535,1605)
-- where MARCOD in(880)
-- where MARCOD in(26)

select * from produto where produtoQtde > 0

select top 10 * from TBS010 (nolock)

-- criar o insert de dados para o coletor

set nocount on

select 'insert into produto select ''' + usuarioNome + ''',' + Ltrim(str(produtoLote,4)) + ',''' + rtrim(produtoCodigo) + ''',''' + rtrim(convert(char(10),produtoDataLote,112)) + ''',''' + rtrim(produtoCodigoBarras) + ''',''' + rtrim(produtoDescricao) + ''',' + Ltrim(str(produtoQtde,9)) + ',''' + rtrim(produtoMarca) + ''',''' + rtrim(produtoEmbalagem) + ''',' + case when produtoDataHora is NULL then 'NULL' else convert(char(10),produtoDataHora,112) end + ',' + case when produtoZerado is NULL then 'NULL' else convert(char(10),produtoZerado,112) end + ',' + Ltrim(str(produtoColetas,9)) + ',''' + rtrim(produtoEmbalagem2) + ''',''' + rtrim(produtoEmbalagem3) + ''',''' + rtrim(produtoEmbalagem4) + ''',' + Ltrim(str(produtoQtde2,9)) + ',' + Ltrim(str(produtoQtde3,9)) + ',' + Ltrim(str(produtoQtde4,9)) + ',''' + rtrim(produtoCodigoBarras2) + ''',''' + rtrim(produtoCodigoBarras3) + ''',''' + rtrim(produtoCodigoBarras4) + ''',''' + rtrim(produtoContagemUnitaria) + ''';'
  from produto

print 'go'

-- abrir tabela "inventario.sdf" (tabela do sql server compact), no sql server studio
-- colar o resultado do script anterior


select * from TBS010 with (nolock) where PROSETLOJ1<>''

select PROSETLOJ1,count(*) from TBS010 with (nolock) where PROSETLOJ1<>'' group by PROSETLOJ1

select * from produto where produtoQtde > 0

select PROCOD,produtoCodigo,PROSETLOJ1

begin tran
update TBS010 set PROSETLOJ1='C01'
  from TBS010 with (nolock)
       inner join produto on produtoCodigo=PROCOD
commit tran

select PROSETLOJ1,count(*) from TBS010 with (nolock) where PROSETLOJ1<>'' group by PROSETLOJ1 order by PROSETLOJ1

