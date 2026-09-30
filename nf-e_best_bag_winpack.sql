-- emissão nf-e best bag winpack

select *
  from DWVendas dw with (nolock)
 where dw.[data] >= '20260918' 
       and dw.cancelado = 'N'
       and dw.caixa = 2

select distinct dw.codigoProduto
  from DWVendas dw with (nolock)
 where dw.[data] >= '20260918' 
       and dw.cancelado = 'N'
       and dw.caixa = 2

select dw.codigoProduto as codigo
       ,(select PRODES from TBS010 p with (nolock) where p.PROCOD = dw.codigoProduto) as descricao
       ,sum(dw.quantidade) as quantidade
  from DWVendas dw with (nolock)
 where dw.[data] between '20260918' and '20260922'
       --and dw.cancelado = 'N'
       and dw.caixa = 2
       and dw.codigoProduto = '1080067'
 group by dw.codigoProduto

select dw.*
  from DWVendas dw with (nolock)
 where dw.[data] between '20260918' and '20260922'
       --and dw.cancelado = 'N'
       and dw.caixa = 2
       and dw.codigoProduto = '1080067'

SELECT 
	cdprod AS codbarras,
	ROW_NUMBER() over(ORDER BY descricao) AS item,
	cdprod,
	descricao,
	SUM(quant) as quantidade
FROM movcaixagz
WHERE
	data between '20260918' and '20260922'
	AND status = '01'
	AND cancelado <> 'S'
GROUP BY
cdprod,
descricao
order by
item

SELECT 
    0 AS flag1,
    1 AS flag2,
    t.*
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY dw.codigoProduto) AS num,
        dw.codigoProduto AS codigo,
        p.PRODES AS descricao,
        SUM(dw.quantidade) AS quantidade
    FROM DWVendas dw WITH (NOLOCK)
    LEFT JOIN TBS010 p WITH (NOLOCK) 
        ON p.PROCOD = dw.codigoProduto
    WHERE dw.[data] BETWEEN '20260918' AND '20260923'
      AND dw.cancelado = 'N'
      AND dw.caixa = 2
    GROUP BY 
        dw.codigoProduto,
        p.PRODES
) t
ORDER BY 
    t.num;

SELECT 
    0 AS LIEEMPCOD,
    1 AS LIENUM,
    ROW_NUMBER() OVER (ORDER BY dw.codigoProduto) AS LIEITE,
    0 as PROEMPCOD,
    dw.codigoProduto AS PROCOD,
    p.PRODES AS LIEPRODES,
    p.PROPESAVEL as LIEPROPESAVEL,
    p.PROUM1 as LIEUNI,
    1 as LIEQTDEMB,
    SUM(dw.quantidade) AS LIEQTD,
    2 as LIETABPRE,
    pre.TDPCUSBAS as LIEPRE,
    pre.TDPCUSBAS as LIEPRECUS,
    pre.TDPCUSBAS as LIEPREMIN,
    pre.TDPCUSBAS as LIEPREMAX,
    'N' as LIEPREPRO,
    '' as LIEINFADIPRO
FROM DWVendas dw WITH (NOLOCK)
inner JOIN TBS010 p WITH (NOLOCK) 
    ON p.PROCOD = dw.codigoProduto
inner join TBS031 pre with (nolock)
        on pre.TDPPROCOD = dw.codigoProduto
WHERE dw.[data] BETWEEN '20260918' AND '20260923'
  AND dw.cancelado = 'N'
  AND dw.caixa = 2
GROUP BY 
    dw.codigoProduto,
    p.PRODES
ORDER BY 
    dw.codigoProduto;


select *
  from bb.SIBD2.dbo.TBS001 with (nolock)

insert into bb.SIBD2.dbo.TBS1511
SELECT 
    0 AS LIEEMPCOD,
    1 AS LIENUM,
    ROW_NUMBER() OVER (ORDER BY MAX(p.PRODES)) AS LIEITE,
    0 AS PROEMPCOD,
    mv.cdprod AS PROCOD,
    MAX(p.PRODES) AS LIEPRODES,
    MAX(p.PROPESAVEL) AS LIEPROPESAVEL,
    MAX(p.PROUM1) AS LIEUNI,
    1 AS LIEQTDEMB,
    SUM(mv.quant) AS LIEQTD,
    2 AS LIETABPRE,
    MAX(pre.TDPCUSBAS) * 1.03 AS LIEPRE,
    MAX(pre.TDPCUSBAS) AS LIEPRECUS,
    MAX(pre.TDPCUSBAS) * 1.03 AS LIEPREMIN,
    MAX(pre.TDPCUSBAS) * 1.03 AS LIEPREMAX,
    'N' AS LIEPREPRO,
    '' AS LIEINFADIPRO
    ,(select ESTQTDATU - ESTQTDRES from TBS032 est where est.ESTLOC = 1 and est.PROCOD = mv.cdprod) as atual
--into #vendas_pdv
FROM movcaixagz mv WITH (NOLOCK)
INNER JOIN TBS010 p WITH (NOLOCK) 
    ON p.PROCOD = mv.cdprod
INNER JOIN TBS031 pre WITH (NOLOCK)
    ON pre.TDPPROCOD = mv.cdprod
WHERE mv.[data] BETWEEN '20260930' AND '20260930'
  AND mv.cancelado <> 'S'
  AND mv.[status] = '01'
   --and not exists(select 'nf' from #itens_nf e where e.PROCOD = mv.cdprod)
   --and not exists (select 'ne' from #devolver dev where dev.pro_pdv = mv.cdprod)
   --and exists (select 'ne' from #devolver dev where dev.pro_pdv = mv.cdprod and (dev.saldo is null or dev.saldo > 0))
GROUP BY 
    mv.cdprod
ORDER BY LIEPRODES

drop table #vendas_pdv

begin tran
update TBS043
   set VENCOD = 92
 where ORCNUM = 36817

rollback tran
commit tran

begin tran
update TBS0431
   set LESCOD = 2
 where ORCNUM = 36798

rollback tran
commit tran

select *
  from TBS055 p with (nolock)
 where p.PDVNUM = 88654

select *
  from TBS0551 p with (nolock)
 where p.PDVNUM = 88654

select *
  from TBS058 pr with (nolock)
 where pr.PRPNUM = 88654

select *
  from TBS080 e with (nolock)
 where e.ENFNUM in(121043,121099,121100)

SELECT 
    dw.codigoProduto AS codigo,
    'https://bwipjs-api.metafloor.com/?bcid=code128&text=' + CAST(dw.codigoProduto AS VARCHAR(30)) AS urlImagemCodigoBarras,
    SUM(dw.quantidade) AS quantidade
FROM DWVendas dw WITH (NOLOCK)
WHERE dw.[data] >= '20260918' 
  AND dw.cancelado = 'N'
  AND dw.caixa = 2
GROUP BY dw.codigoProduto

-- gerar lista escolar para depois gerar orçamento

select top 1000 *
  from TBS055 p with (nolock)
 order by PDVNUM desc

select top 1000 *
  from TBS043 o with (nolock)
 where o.ORCLIENUM > 0
 order by o.ORCNUM desc

-- cabeçalho

select *
  from TBS151 l with (nolock)

-- itens

select *
  from TBS1511 l1 with (nolock)

-- log

select *
  from TBS1512 l2 with (nolock)

-- histórico

select *
  from TBS1513 l3 with (nolock)

delete bb.SIBD2.dbo.TBS1511
 where LIENUM = 1

-- verificação

select nf.PROCOD
       ,sum(nf.NFSQTD) as qtde
  into #itens_nf
  from bb.SIBD2.dbo.TBS0671 nf with (nolock)
 where nf.NFSNUM in (121099,121100,121128,121162,121197,121207)
 group by nf.PROCOD

drop table #itens_nf

select *
  from bb.SIBD2.dbo.TBS0671 nf with (nolock)
 where nf.NFSNUM in (121099,121100,121128,121162,121197,121207)

select *
  from TBS1511 l1 with (nolock)

select *
  from #vendas_pdv

SELECT 
    PROCOD, 
    COUNT(*) AS Total
FROM 
    #vendas_pdv
GROUP BY 
    PROCOD
HAVING 
    COUNT(*) > 1;

select *
  from #itens_nf e
 where not exists(select 'nf' from #vendas_pdv v where v.PROCOD = e.PROCOD)

select *
  from #vendas_pdv v
 where not exists(select 'nf' from #itens_nf e where e.PROCOD = v.PROCOD)

select e.PROCOD
       ,sum(e.NFSQTD) as qtde
  into #indevidos
  from bb.SIBD2.dbo.TBS0671 e with (nolock)
 where e.NFSNUM = 121197
       and not exists(select 'nf' from #vendas_pdv v where v.PROCOD = e.PROCOD)
 group by e.PROCOD

select d.PROCOD
  from TBS1431 d with (nolock)
 where d.NDFNUMDOC = 196
       and not exists(select 'ne' from #indevidos v where v.PROCOD = d.PROCOD)

select *
       ,(select PRODES from TBS010 p where p.PROCOD = i.PROCOD)
  from #indevidos i

select *
  from #indevidos v
 where not exists(select 'ne' from TBS1431 d with (nolock) where d.NDFNUMDOC = 196 and d.PROCOD = v.PROCOD)

select *
  from TBS0591 e with (nolock)
 where e.NFENUM = 121197

select *
  from TBS0597 e with (nolock)
 where e.NFENUM = 121197

select PROCOD
       ,LIEQTD
  from #vendas_pdv

select PROCOD
       ,sum(NFEQTD) as NFEQTD
  into #compras
  from TBS0591 e with (nolock)
 where e.NFENUM in (121099,121100,121128,121162,121281) -- 121197, 121207
 group by PROCOD

drop table #compras

select pdv.PROCOD as pro_pdv
       ,pdv.LIEQTD as qtde_pdv
       ,pc.PROCOD as pro_compras
       ,pc.NFEQTD as qtde_compras
       ,pdv.LIEQTD - pc.NFEQTD as saldo
  into #devolver
  from #vendas_pdv pdv
  full join #compras pc
         on pdv.PROCOD = pc.PROCOD

delete #devolver
 where saldo = 0

select *
  from #devolver

select *
  from #devolver dev
 where exists (select 'ne' from TBS0591 ent where ent.NFENUM = 121197 and ent.PROCOD = dev.pro_pdv)

drop table #devolver





