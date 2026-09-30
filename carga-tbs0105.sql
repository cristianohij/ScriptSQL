select *
  from TBS0101 with (nolock)
 where PROFORPRO in('2905','2900','2893','3711','2879')

select *
  from TBS0105 with (nolock)
 where VNFPROCOD in('100944','104940','103109','113510')

select *
  from TBS0591 with (nolock)
 where NFENUM=1222943
       and NFECOD=1837

select top(100) *
  from TBS006 with (nolock)

-- backup tbs0105

select * -- 32.486 registros
  into TBS0105BKP
  from TBS0105 with (nolock)

select *
  from TBS0105 with (nolock)

-- códigos dos clientes "grupo"
if object_id('tempdb.dbo.#grupo') is not null
    begin
    	drop table #grupo
    end

create table #grupo (codigo int)

insert into #grupo
exec usp_ClientesGrupo 1

select *
  from #grupo

delete TBS0105

INSERT INTO TBS0105 (VNFPROEMP, VNFSEQ, VNFPROCOD, VNFFORCNPJ, VNFPRODES)
SELECT 
    0,
    ROW_NUMBER() OVER (ORDER BY T1.PROFORCOD) AS VNFSEQ,
    T1.PROFORCOD AS VNFPROCOD,
    CASE 
        WHEN T2.FORTIPPES = 'J' THEN T2.FORCGC
        ELSE T2.FORCPF
    END AS VNFFORCNPJ,
    T1.PROFORDES
FROM TBS0101 AS T1 WITH (NOLOCK)
INNER JOIN TBS006 AS T2
    ON T1.PROFORCOD = T2.FORCOD
where T2.FORCOD not in(select codigo from #grupo);

select *
  from TBS0105 with (nolock)

select *
  from TBS0101 with (nolock)

select count(*)
  from TBS0105 with (nolock) -- 56254

select distinct
       VNFFORCNPJ
       ,VNFPROCOD
  from TBS0105 with (nolock) -- 56254

select *
  from TBS0101 with (nolock)
 where PROFORPRO='2556'

select *
  from TBS006 f with (nolock)
 inner join TBS059 e with (nolock)
    on e.NFECOD=f.FORCOD
 where f.FORCGC=''
       and f.FORCPF=''
	   and e.NFETIP='N'
       and year(e.NFEDATEFE) >= 2015

exec sp_help 'TBS0105'

-- Remover constraints default existentes (se necessário)
-- Verificar e remover antes de recriar defaults

ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFPROEMP DEFAULT 0 FOR VNFPROEMP;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFFORCNPJ DEFAULT '' FOR VNFFORCNPJ;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFPROCOD DEFAULT '' FOR VNFPROFOR;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFSEQ DEFAULT 1 FOR VNFSEQ;

ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFNCMORI DEFAULT '' FOR VNFNCMORI;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFCESTORI DEFAULT '' FOR VNFCESTORI;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFCSTCSOSNORI DEFAULT '' FOR VNFCSTCSOSNORI;

ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFICMSPROORI DEFAULT 0 FOR VNFICMSPROORI;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFICMSINTORI DEFAULT 0 FOR VNFICMSINTORI;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFICMSSTORI DEFAULT 0 FOR VNFICMSSTORI;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFMVAORI DEFAULT 0 FOR VNFMVAORI;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFREDICMSORI DEFAULT 0 FOR VNFREDICMSORI;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFREDICMSSTORI DEFAULT 0 FOR VNFREDICMSSTORI;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFIPIORI DEFAULT 0 FOR VNFIPIORI;

ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFNCMALT DEFAULT '' FOR VNFNCMALT;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFCESTALT DEFAULT '' FOR VNFCESTALT;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFCSTCSOSNALT DEFAULT '' FOR VNFCSTCSOSNALT;

ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFICMSPROALT DEFAULT 0 FOR VNFICMSPROALT;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFICMSINTALT DEFAULT 0 FOR VNFICMSINTALT;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFICMSSTALT DEFAULT 0 FOR VNFICMSSTALT;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFMVAORIALT DEFAULT 0 FOR VNFMVAORIALT;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFMVAOPEALT DEFAULT 0 FOR VNFMVAOPEALT;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFREDICMSALT DEFAULT 0 FOR VNFREDICMSALT;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFREDICMSSTALT DEFAULT 0 FOR VNFREDICMSSTALT;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFIPIALT DEFAULT 0 FOR VNFIPIALT;

ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFNUMDOC DEFAULT 0 FOR VNFNUMDOC;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFSERDOC DEFAULT 0 FOR VNFSERDOC;
ALTER TABLE TBS0105 ADD CONSTRAINT DF_TBS0105_VNFPRODES DEFAULT '' FOR VNFPRODES;

SELECT FORCOD, COUNT(*) AS Quantidade
FROM TBS006
GROUP BY FORCOD
HAVING COUNT(*) > 1;

SELECT DISTINCT
    0,
    ROW_NUMBER() OVER (ORDER BY T1.PROFORCOD) AS VNFSEQ,
    T1.PROFORCOD AS VNFPROCOD,
    CASE 
        WHEN T2.FORTIPPES = 'J' THEN T2.FORCGC
        ELSE T2.FORCPF
    END AS VNFFORCNPJ,
    T1.PROFORDES
FROM TBS0101 AS T1 WITH (NOLOCK)
INNER JOIN TBS006 AS T2
    ON T1.PROFORCOD = T2.FORCOD
WHERE T2.FORCOD NOT IN (SELECT codigo FROM #grupo);

SELECT PROFORCOD, PROFORPRO, COUNT(*) AS Quantidade
FROM TBS0101 WITH (NOLOCK)
GROUP BY PROFORCOD, PROFORPRO
HAVING COUNT(*) > 1;

select *
  from TBS0101 with (nolock)
 where PROFORCOD=1890
       and PROFORPRO='1'

select i.PROCOD as codigo
       ,max(c.NFEDATEFE) as Efetivacao
  into #ultimas_entrada
  from TBS0591 i with (nolock)
 inner join TBS059 c (nolock)
       on i.SERCOD=c.SERCOD and i.NFETIP=c.NFETIP and i.NFECOD=c.NFECOD and i.NFENUM=c.NFENUM
 where c.NFETIP ='N'
       and c.NFECAN <> 'S'
       and i.NFECFOP in ('1.102','1.403','2.102','2.403')
       and c.NFECOD not in (select codigo from #grupo)
 group by i.PROCOD

select c.NFEDATEFE
       ,i.NFEPROFOR
       ,i.NFENCMXML
       ,i.NFEPROFOR
       ,c.NFECHAACE
       ,i.NFECESTXML
       ,i.NFECSTXML
       ,i.NFEPERICMSXML
       ,i.NFEPERICMSSTXML
       ,i.NFEPERICMSXML
       ,i.NFEPERMVASTXML
  from TBS0591 i with (nolock)
  Left join TBS059 c (nolock)
       on i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SERCOD=c.SERCOD
 where c.NFETIP ='N'
       and c.NFECAN <> 'S'
       and i.NFECFOP in ('1.102','1.403','2.102','2.403')
       and c.NFECOD not in (select codigo from #grupo)
       and i.NFEPROFOR <> ''




-- função para o cálculo do ajuste do MVA

IF OBJECT_ID('dbo.fn_CalcularMVA_Ajustado', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_CalcularMVA_Ajustado;
GO

CREATE FUNCTION dbo.fn_CalcularMVA_Ajustado
(
    @MVA_Original DECIMAL(10, 4),         -- MVA Original em percentual (ex: 40 para 40%)
    @Aliquota_Interestadual DECIMAL(10,4),-- Alíquota interestadual em percentual (ex: 12 para 12%)
    @Aliquota_Interna DECIMAL(10,4)       -- Alíquota interna em percentual (ex: 18 para 18%)
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @MVA_Ajustado DECIMAL(10,4)

    -- Cálculo do MVA Ajustado
    SET @MVA_Ajustado = 
        ((1 + (@MVA_Original / 100.0)) 
        * ((1 - (@Aliquota_Interestadual / 100.0)) / (1 - (@Aliquota_Interna / 100.0)))
        - 1) * 100.0

    -- Se o MVA Ajustado for negativo, retorna o MVA Original
    IF @MVA_Ajustado < 0
        SET @MVA_Ajustado = @MVA_Original

    RETURN @MVA_Ajustado
END
GO

-- teste

SELECT dbo.fn_CalcularMVA_Ajustado(29, 12, 12) AS MVA_Ajustado;

select *
  from TBS0105 with (nolock)

delete TBS0105

exec sp_help 'TBS0105'

-- inclusão de dados
/*
INSERT INTO TBS0105 (
    VNFPROEMP
    ,VNFFORCNPJ
    ,VNFPROFOR
    ,VNFSEQ
    ,VNFNCMORI
    ,VNFCESTORI
    ,VNFCSTCSOSNORI
    ,VNFICMSPROORI
    ,VNFICMSSTORI
    ,VNFMVAORI
    ,VNFREDICMSORI
    ,VNFREDICMSSTORI
    ,VNFIPIORI
    ,VNFNCMALT
    ,VNFCESTALT
    ,VNFCSTCSOSNALT
    ,VNFICMSPROALT
    ,VNFICMSINTALT
    ,VNFICMSSTALT
    ,VNFMVAORIALT
    ,VNFMVAOPEALT
    ,VNFREDICMSALT
    ,VNFREDICMSSTALT
    ,VNFIPIALT
    ,VNFNUMDOC
    ,VNFSERDOC
    ,VNFPRODES
    ,VNFCFOP
)
SELECT isnull(NFEEMPCOD,0)
       ,isnull(CNPJ,'')
       ,isnull(NFEPROFOR,'')
       --,isnull(NFEITE,0)
       ROW_NUMBER() ...
       ,isnull(NFENCMXML,'')
       ,isnull(NFECESTXML,'')
       ,isnull(NFECSTXML,'')
       ,isnull(NFEPERICMSXML,0)
       ,isnull(NFEPERICMSSTXML,0)
       ,isnull(NFEPERMVASTXML,0)
       ,isnull(NFEREDBASICMS,0)
       ,isnull(NFEPERRBISTXML,0)
       ,isnull(NFEPERIPI,0)
       ,isnull(NCM_alterado,'')
       ,isnull(CEST_alterado,'')
       ,isnull(CST_CSOSN_alterado,'')
       ,isnull(ICMS_proprio_alterado,0)
       ,isnull(NFEGAREICMSINT,0)
       ,isnull(NFEGAREICMSST,0)
       ,isnull(NFEGARENCMMVA,0)
       ,isnull(MVA_ajustado,0)
       ,isnull(red_bc_icms,0)
       ,isnull(red_bc_st,0)
       ,isnull(IPI_alterado,0)
       ,isnull(NFENUM,0)
       ,isnull(NFESERDOC,0)
       ,isnull(NFEDES,'')
       ,isnull(replace(NFECFOPXML,'.',''),'')
  from #produtos
WHERE NOT EXISTS (
    SELECT 1 FROM TBS0105 with (nolock)
    WHERE VNFPROEMP=NFEEMPCOD AND VNFFORCNPJ=CNPJ AND VNFPROFOR=NFEPROFOR AND VNFSEQ = NFEITE
);
*/

select VNFFORCNPJ
       ,count(distinct VNFPROFOR)
  from TBS0105 with (nolock)
 group by VNFFORCNPJ

drop table TBS0105


select count(*)
  from TBS0105 with (nolock)
 where VNFFORCNPJ=''

select *
  from TBS0105 with (nolock)
 where VNFFORCNPJ=''

select top(100)
       *
  from TBS0101 with (nolock)

select *
  from TBS0101 with (nolock)
 where PROFORCOD=0

ALTER TABLE [TBS0105]
ADD [VNFTRIBST] CHAR(1)     NULL

update TBS0105
  set VNFTRIBST=''
  


-- lista de produtos da entrada de notas fiscais para carregamento da TBS0105

-- backup
select *
  into TBS0105BKP
  from TBS0105 with (nolock)

-- códigos dos fornecedores "grupo"
if object_id('tempdb.dbo.#grupo') is not null
    begin
    	drop table #grupo
    end

create table #grupo (codigo int)

insert into #grupo
exec usp_FornecedoresGrupo 1

select *
  from #grupo

select *
  from TBS006 with (nolock)

-- últimos produtos recebidos

if object_id('tempdb.dbo.#produtos') is not null
    begin
    	drop table #produtos
    end;

-- monta a tabela de produtos recebidos
-- captura o último produto recebido do fornecedor

with ProdutosOrdenados as (
    select 
        --c.NFEDATEFE,
        i.NFEPROFOR,
        i.NFENCMXML,
        c.NFECHAACE,
        --iif(c.NFECHAACE='' or c.NFECHAACE is null, f.FORCGC, SUBSTRING(c.NFECHAACE,7,14)) CNPJ,
        
        case 
            when c.NFECHAACE = '' OR c.NFECHAACE IS NULL THEN f.FORCGC 
            else SUBSTRING(c.NFECHAACE,7,14)
        end as CNPJ,
        
        i.NFECESTXML,
        i.NFECSTXML,
        i.NFECFOPXML,
        i.NFEPERICMSXML,
        i.NFEPERICMSSTXML,
        i.NFEPERMVASTXML,
        i.NFEREDBASICMS,
        i.NFEPERRBISTXML,
        i.NFEPERIPI,
        --i.NFEGARENCMMVA,
        i.NFEGAREICMSINT,
        i.NFEGAREICMSST,
        i.NFEGARENCMMVA,
        i.NFEGAREREDBC,
        i.NFEGAREREDBST,
        c.NFENUM,
        c.NFESERDOC,
        i.NFEDES,
        --i.NFEITE,
        c.NFEEMPCOD,
        row_number() over (PARTITION BY SUBSTRING(c.NFECHAACE,7,14), i.NFEPROFOR ORDER BY c.NFEDATEFE DESC) AS rn
    FROM 
        TBS0591 i WITH (NOLOCK)
    LEFT JOIN 
        TBS059 c WITH (NOLOCK)
        ON i.NFETIP = c.NFETIP
       AND i.NFENUM = c.NFENUM
       AND i.NFECOD = c.NFECOD
       AND i.SERCOD = c.SERCOD
    inner join TBS006 f with (nolock)
       on f.FORCOD=c.NFECOD
    WHERE 
        c.NFETIP = 'N'
        AND c.NFECAN <> 'S'
        AND i.NFECFOP IN ('1.102','1.403','2.102','2.403')
        AND c.NFECOD NOT IN (SELECT codigo FROM #grupo)
        AND i.NFEPROFOR <> ''
        --and c.NFENUM=155932
)
SELECT
    NFEEMPCOD,
    --NFEDATEFE,
    CNPJ,
    NFEPROFOR,            -- produto fornecedor
    --NFEITE,               -- item da NF
    NFENCMXML,            -- NCM da NF
    isnull(NFECESTXML,'') as NFECESTXML,           -- CEST da NF
    --NFECHAACE,
    isnull(NFECSTXML,'') as  NFECSTXML,           -- CST/CSOSN da NF
    NFEPERICMSXML,        -- ICMS próprio da NF
    NFEPERICMSSTXML,      -- ICMS-ST da NF
    isnull(NFEPERMVASTXML,0) as  NFEPERMVASTXML,      -- MVA da NF
    NFEREDBASICMS,        -- redução da BC do ICMS
    NFEPERRBISTXML,       -- redução da BC do ICMS-ST
    NFEPERIPI,            -- IPI
    NFENCMXML AS NCM_alterado,              -- NCM alterado
    isnull(NFECESTXML,'') AS CEST_alterado,            -- CEST alterado
    isnull(NFECSTXML,'') As CST_CSOSN_alterado,        -- CST/CSOSN alterado
    NFEPERICMSXML AS ICMS_proprio_alterado,    -- ICMS próprio alterado
    NFEGAREICMSINT,       -- ICMS interno alterado
    NFEGAREICMSST,        -- ICMS-ST alterado
    NFEGARENCMMVA,        -- MVA original alterado
    isnull(dbo.fn_CalcularMVA_Ajustado(iif(NFEGARENCMMVA > 0, NFEGARENCMMVA, NFEPERMVASTXML), NFEPERICMSXML, NFEGAREICMSINT),0) AS MVA_ajustado,    -- MVA ajustado alterado
    iif(NFEGAREREDBC > 0, NFEGAREREDBC, NFEREDBASICMS) AS red_bc_icms,    -- redução da BC do ICMS alterado
    iif(NFEGAREREDBST > 0, NFEGAREREDBST, NFEPERRBISTXML) AS red_bc_st,             -- redução da BC do ICMS-ST alterado
    NFEPERIPI AS IPI_alterado,      -- IPI
    NFENUM,               -- número da NF
    NFESERDOC,            -- série da NF
    NFEDES,               -- descrição do produto
    NFECFOPXML            -- CFOP da operação

    --NFEITE
INTO #produtos
FROM 
    ProdutosOrdenados
WHERE 
    rn = 1;

select *
  from #produtos

-- insert na TBS0105

delete TBS0105

INSERT INTO TBS0105 (
    VNFPROEMP
    ,VNFFORCNPJ
    ,VNFPROFOR
    ,VNFSEQ
    ,VNFNCMORI
    ,VNFCESTORI
    ,VNFCSTCSOSNORI
    ,VNFICMSPROORI
    ,VNFICMSSTORI
    ,VNFMVAORI
    ,VNFREDICMSORI
    ,VNFREDICMSSTORI
    ,VNFIPIORI
    ,VNFNCMALT
    ,VNFCESTALT
    ,VNFCSTCSOSNALT
    ,VNFICMSPROALT
    ,VNFICMSINTALT
    ,VNFICMSSTALT
    ,VNFMVAORIALT
    ,VNFMVAOPEALT
    ,VNFREDICMSALT
    ,VNFREDICMSSTALT
    ,VNFIPIALT
    ,VNFNUMDOC
    ,VNFSERDOC
    ,VNFPRODES
    ,VNFCFOP
)
SELECT 
    ISNULL(NFEEMPCOD, 0),
    ISNULL(CNPJ, ''),
    ISNULL(NFEPROFOR, ''),
    ROW_NUMBER() OVER (PARTITION BY CNPJ ORDER BY (SELECT NULL)), -- Sequencial por CNPJ
    ISNULL(NFENCMXML, ''),
    ISNULL(NFECESTXML, ''),
    ISNULL(NFECSTXML, ''),
    ISNULL(NFEPERICMSXML, 0),
    ISNULL(NFEPERICMSSTXML, 0),
    ISNULL(NFEPERMVASTXML, 0),
    ISNULL(NFEREDBASICMS, 0),
    ISNULL(NFEPERRBISTXML, 0),
    ISNULL(NFEPERIPI, 0),
    ISNULL(NCM_alterado, ''),
    ISNULL(CEST_alterado, ''),
    ISNULL(CST_CSOSN_alterado, ''),
    ISNULL(ICMS_proprio_alterado, 0),
    ISNULL(NFEGAREICMSINT, 0),
    ISNULL(NFEGAREICMSST, 0),
    ISNULL(NFEGARENCMMVA, 0),
    ISNULL(MVA_ajustado, 0),
    ISNULL(red_bc_icms, 0),
    ISNULL(red_bc_st, 0),
    ISNULL(IPI_alterado, 0),
    ISNULL(NFENUM, 0),
    ISNULL(NFESERDOC, 0),
    ISNULL(NFEDES, ''),
    ISNULL(REPLACE(NFECFOPXML, '.', ''), '')
FROM #produtos P
WHERE NOT EXISTS (
    SELECT 1 
    FROM TBS0105 WITH (NOLOCK)
    WHERE VNFPROEMP = P.NFEEMPCOD 
    AND VNFFORCNPJ = P.CNPJ 
    AND VNFPROFOR = P.NFEPROFOR
    --AND VNFSEQ = P.NFEITE
);


select *
  from TBS0105 with (nolock)

select *
  from TBS0105 with (nolock)
 order by VNFPROEMP, VNFFORCNPJ, VNFPROFOR, VNFSEQ desc


-- 

-- últimos produtos recebidos

if object_id('tempdb.dbo.#produtos') is not null
    begin
    	drop table #produtos
    end;

-- monta a tabela de produtos recebidos
-- captura o último produto recebido do fornecedor

with ProdutosOrdenados as (
    select 
        c.NFETIP
        ,c.NFENUM
        ,c.NFECOD
        ,c.NFEDATEFE
        ,i.PROCOD
        ,row_number() over (PARTITION BY i.PROCOD ORDER BY c.NFEDATEFE DESC) AS rn
    FROM 
        TBS0591 i WITH (NOLOCK)
    LEFT JOIN 
        TBS059 c WITH (NOLOCK)
        ON i.NFETIP = c.NFETIP
       AND i.NFENUM = c.NFENUM
       AND i.NFECOD = c.NFECOD
       AND i.SERCOD = c.SERCOD
    WHERE 
        c.NFETIP = 'N'
        AND c.NFECAN <> 'S'
        AND i.NFECFOP IN ('1.102','1.403','2.102','2.403')
        AND c.NFECOD NOT IN (SELECT codigo FROM #grupo)
)
SELECT *
    /*NFEEMPCOD,
    --NFEDATEFE,
    CNPJ,
    NFEPROFOR,            -- produto fornecedor
    --NFEITE,               -- item da NF
    NFENCMXML,            -- NCM da NF
    isnull(NFECESTXML,'') as NFECESTXML,           -- CEST da NF
    --NFECHAACE,
    isnull(NFECSTXML,'') as  NFECSTXML,           -- CST/CSOSN da NF
    NFEPERICMSXML,        -- ICMS próprio da NF
    NFEPERICMSSTXML,      -- ICMS-ST da NF
    isnull(NFEPERMVASTXML,0) as  NFEPERMVASTXML,      -- MVA da NF
    NFEREDBASICMS,        -- redução da BC do ICMS
    NFEPERRBISTXML,       -- redução da BC do ICMS-ST
    NFEPERIPI,            -- IPI
    NFENCMXML AS NCM_alterado,              -- NCM alterado
    isnull(NFECESTXML,'') AS CEST_alterado,            -- CEST alterado
    isnull(NFECSTXML,'') As CST_CSOSN_alterado,        -- CST/CSOSN alterado
    NFEPERICMSXML AS ICMS_proprio_alterado,    -- ICMS próprio alterado
    NFEGAREICMSINT,       -- ICMS interno alterado
    NFEGAREICMSST,        -- ICMS-ST alterado
    NFEGARENCMMVA,        -- MVA original alterado
    isnull(dbo.fn_CalcularMVA_Ajustado(iif(NFEGARENCMMVA > 0, NFEGARENCMMVA, NFEPERMVASTXML), NFEPERICMSXML, NFEGAREICMSINT),0) AS MVA_ajustado,    -- MVA ajustado alterado
    iif(NFEGAREREDBC > 0, NFEGAREREDBC, NFEREDBASICMS) AS red_bc_icms,    -- redução da BC do ICMS alterado
    iif(NFEGAREREDBST > 0, NFEGAREREDBST, NFEPERRBISTXML) AS red_bc_st,             -- redução da BC do ICMS-ST alterado
    NFEPERIPI AS IPI_alterado,      -- IPI
    NFENUM,               -- número da NF
    NFESERDOC,            -- série da NF
    NFEDES,               -- descrição do produto
    NFECFOPXML            -- CFOP da operação

    --NFEITE*/
INTO #produtos
FROM 
    ProdutosOrdenados
WHERE 
    rn = 1;

select *
  from #produtos

-- checa duplicidades

select PROCOD
       ,count(*)
  from #produtos
 group by PROCOD
having count(*) > 1

