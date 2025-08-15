DROP VIEW vw_frequencia_produto;

create view vw_frequencia_produto AS
select LEFT(CONVERT(VARCHAR(7), c.NFSDATEMI, 120), 7) as periodo
       ,d.PROCOD as produto
       ,count(*) as frequencia
       ,sum(d.NFSQTD*d.NFSQTDEMB) as quantidade
       ,sum(dbo.NFSTOTITEST(d.NFSEMPCOD, d.NFSNUM, d.SNEEMPCOD, d.SNESER, d.NFSITE)) as valor
  from TBS0671 d with (nolock)
 inner join TBS067 c with (nolock)
    on c.SNESER=d.SNESER and c.NFSNUM=d.NFSNUM
 inner join TBS080 e with (nolock)
    on e.SNESER=c.SNESER and e.ENFNUM=c.NFSNUM
 where c.NFSCAN='N'
       and c.NFSDATEMI between '20240101' and '20240930'
       and e.ENFSIT=6
       and c.NFSTIP='N'
       --and c.NFSCLINOM Like ('TANBY%')
       and (c.NFSCLINOM Like ('BEST BAG%') or c.NFSCLINOM Like ('MISASPEL%') or c.NFSCLINOM Like ('%PAPELYNA%'))
 group by LEFT(CONVERT(VARCHAR(7), c.NFSDATEMI, 120), 7), d.PROCOD

select top(1) *
  from TBS080 with (nolock)

select *
  into cd_pro_transf
  from cd.SIBD.dbo.vw_frequencia_produto
union
select *
  from mi.SIBD3.dbo.vw_frequencia_produto
union
select *
  from pp.SIBD.dbo.vw_frequencia_produto

select *
  from sp_pro_transf with (nolock)

select *
  from cd_pro_transf with (nolock)

exec sp_help 'cd_pro_transf'

SELECT 
    ISNULL(sp.periodo COLLATE Latin1_General_CI_AS, cd.periodo COLLATE Latin1_General_CI_AS) AS periodo,
    ISNULL(sp.produto COLLATE Latin1_General_CI_AS, cd.produto COLLATE Latin1_General_CI_AS) AS produto,
    tbs.PRODES AS descricao_produto,  -- Exibe a descrição do produto
    tbs.PROUM1 AS unidade,
    ISNULL(sp.frequencia, 0) AS sp_frequencia,
    ISNULL(sp.quantidade, 0) AS sp_quantidade,
    ISNULL(sp.valor, 0) AS sp_valor,
    ISNULL(cd.frequencia, 0) AS cd_frequencia,
    ISNULL(cd.quantidade, 0) AS cd_quantidade,
    ISNULL(cd.valor, 0) AS cd_valor
FROM sp_pro_transf sp
FULL OUTER JOIN cd_pro_transf cd
    ON sp.periodo COLLATE Latin1_General_CI_AS = cd.periodo COLLATE Latin1_General_CI_AS
    AND sp.produto COLLATE Latin1_General_CI_AS = cd.produto COLLATE Latin1_General_CI_AS
LEFT JOIN TBS010 tbs
    ON ISNULL(sp.produto COLLATE Latin1_General_CI_AS, cd.produto COLLATE Latin1_General_CI_AS) = tbs.PROCOD COLLATE Latin1_General_CI_AS
ORDER BY ISNULL(sp.periodo COLLATE Latin1_General_CI_AS, cd.periodo COLLATE Latin1_General_CI_AS),
         ISNULL(sp.produto COLLATE Latin1_General_CI_AS, cd.produto COLLATE Latin1_General_CI_AS);









