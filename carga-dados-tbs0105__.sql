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

-- CFOP de entradas

select NFECFOP
       ,(select COPDES from TBS041 t3 with (nolock)
         where ('1.'+t3.COPCOD=t1.NFECFOP or '2.'+t3.COPCOD=t1.NFECFOP)
               and t3.COPTIP='E') as descri
  from TBS0591 t1 (nolock)
 inner join TBS059 t2 (nolock)
       on t2.SERCOD=t1.SERCOD and t2.NFETIP=t1.NFETIP and t2.NFECOD=t1.NFECOD and t2.NFENUM=t1.NFENUM
 where t2.NFEDATEFE >= '20170101'
       and t2.NFEDATEFE <> '17530101'
       and t2.NFECAN<>'S'
 group by t1.NFECFOP
 order by t1.NFECFOP

-- backup

drop table TBS0105BKP

select *
  into TBS0105BKP
  from TBS0105 with (nolock)

select *
  from TBS0105BKP with (nolock)

-- recriada a tabela no CD

-- drop table TBS0105

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


-- análise das notas de entrada

select NFENUM
       ,NFEDARENUM
       ,NFEDARECB44
       ,NFEDARECB48
       ,NFEDAREPIX
       ,NFEDAREDATEMI
       ,NFEDAREDATVEN
       ,NFEDAREVALOR
       ,*
  from TBS059 with (nolock)
 where NFEDARENUM <> ''   -- is null
       and NFEDATEFE <> '17530101'
 order by NFEDATEFE desc

begin tran
update TBS059
   set NFEDARENUM=''
 where NFEDARENUM='0'

rollback tran
commit tran

begin tran
update TBS059
   set NFEDARENUM=''
 where NFEDARENUM is null

rollback tran
commit tran

begin tran
update TBS059
   set NFEDARECB44=''
 where NFEDARECB44 is null

rollback tran
commit tran

begin tran
update TBS059
   set NFEDARECB48=''
 where NFEDARECB48 is null

rollback tran
commit tran

begin tran
update TBS059
   set NFEDAREPIX=''
 where NFEDAREPIX is null

rollback tran
commit tran

begin tran
update TBS059
   set NFEDAREDATEMI='17530101'
 where NFEDAREDATEMI is null

rollback tran
commit tran

begin tran
update TBS059
   set NFEDAREDATVEN='17530101'
 where NFEDAREDATVEN is null

rollback tran
commit tran

begin tran
update TBS059
   set NFEDAREVALOR=0
 where NFEDAREVALOR is null

rollback tran
commit tran

begin tran
update TBS059
   set NFEGARE=''
 where NFEGARE is null

rollback tran
commit tran

begin tran
update TBS059
   set NFEDAREUSUEMI=''
 where NFEDAREUSUEMI is null

rollback tran
commit tran

select NFEGARE
       ,NFEDARENUM
       ,NFEDARECB44
       ,NFEDARECB48
       ,NFEDAREPIX
       ,NFEDAREDATEMI
       ,NFEDAREDATVEN
       ,NFEDAREVALOR
       ,*
  from TBS059 with (nolock)
 where NFEGARE <> 'S'
       and NFEDARENUM <> ''

begin tran
update TBS059
   set NFEGARE='S'
 where NFEGARE <> 'S'
       and NFEDARENUM <> ''

rollback tran
commit tran

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
        i.NFEGAREVALICMSST,
        i.NFETOTOPEITE,
        i.NFEBASICMSST,
        i.NFEVALICMSST,

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
    WHERE c.NFEDATEFE >= '20191001'
        --AND c.NFEGARE='S'
        AND (c.NFEDARENUM <> '' or NFEGARE='S')
        --AND TRY_CAST(c.NFEDARENUM as float) > 0
        AND c.NFETIP = 'N'
        AND c.NFECAN <> 'S'
        AND i.NFECFOP IN ('1.102','1.403','1.407','1.551','1.556','1.917','2.102','2.403','2.556')
        AND c.NFECOD NOT IN (SELECT codigo FROM #grupo)
        AND i.NFEPROFOR <> ''
        --and c.NFENUM=194222
)
SELECT
    isnull(NFEEMPCOD,0) as NFEEMPCOD,
    isnull(CNPJ,'') as CNPJ,
    isnull(NFEPROFOR,'') as NFEPROFOR,                                              -- produto fornecedor
    isnull(NFENCMXML,'') as NFENCMXML,                                              -- NCM da NF
    isnull(NFECESTXML,'') as NFECESTXML,                                            -- CEST da NF
    isnull(NFECSTXML,'') as  NFECSTXML,                                             -- CST/CSOSN da NF
    isnull(NFEPERICMSXML,0) as NFEPERICMSXML,                                       -- ICMS próprio da NF
    isnull(NFEPERICMSSTXML,0) as NFEPERICMSSTXML,                                   -- ICMS-ST da NF
    isnull(NFEPERMVASTXML,0) as  NFEPERMVASTXML,                                    -- MVA da NF
    isnull(NFEREDBASICMS,0) as NFEREDBASICMS,                                       -- redução da BC do ICMS
    isnull(NFEPERRBISTXML,0) as NFEPERRBISTXML,                                     -- redução da BC do ICMS-ST
    isnull(NFEPERIPI,0) as NFEPERIPI,                                               -- IPI
    isnull(NFENCMXML,'') as NCM_alterado,                                           -- NCM alterado
    isnull(NFECESTXML,'') AS CEST_alterado,                                         -- CEST alterado
    isnull(NFECSTXML,'') As CST_CSOSN_alterado,                                     -- CST/CSOSN alterado
    isnull(NFEPERICMSXML,0) AS ICMS_proprio_alterado,                               -- ICMS próprio alterado
    isnull(NFEGAREICMSINT,0) as NFEGAREICMSINT,                                     -- ICMS interno alterado
    isnull(NFEGAREICMSST,0) as NFEGAREICMSST,                                       -- ICMS-ST alterado
    isnull(NFEGARENCMMVA,0) as NFEGARENCMMVA,                                       -- MVA original alterado
    -- MVA ajustado alterado
    isnull(iif(NFEGAREVALICMSST > 0, dbo.fn_CalcularMVA_Ajustado(iif(NFEGARENCMMVA > 0, NFEGARENCMMVA, NFEPERMVASTXML), NFEPERICMSXML, NFEGAREICMSINT),0),0) as MVA_ajustado,
    isnull(iif(NFEGAREREDBC > 0, NFEGAREREDBC, NFEREDBASICMS),0) AS red_bc_icms,    -- redução da BC do ICMS alterado
    isnull(iif(NFEGAREREDBST > 0, NFEGAREREDBST, NFEPERRBISTXML),0) AS red_bc_st,   -- redução da BC do ICMS-ST alterado
    isnull(NFEPERIPI,0) AS IPI_alterado,                                            -- IPI
    isnull(NFENUM,0) as NFENUM,                                                     -- número da NF
    isnull(NFESERDOC,'') as NFESERDOC,                                              -- série da NF
    isnull(NFEDES,'') as NFEDES,                                                    -- descrição do produto
    isnull(NFECFOPXML,'') as NFECFOPXML,                                            -- CFOP da operação
    isnull(NFEGAREVALICMSST,0) as NFEGAREVALICMSST,
    isnull(NFETOTOPEITE,0) as NFETOTOPEITE,
    isnull(NFEBASICMSST,0) as NFEBASICMSST,
    isnull(NFEVALICMSST,0) as NFEVALICMSST

    --NFEITE
INTO #produtos
FROM 
    ProdutosOrdenados
WHERE 
    rn = 1;

select NFEPERICMSSTXML
       ,NFEPERMVASTXML
       ,NFEPERICMSXML
       ,NFEGAREICMSINT
       ,NFEGAREICMSST
       ,NFEGARENCMMVA
       ,MVA_ajustado
       ,NFEGAREVALICMSST
       ,NFEVALICMSST
       ,NFENUM
       ,NFESERDOC
       ,*
  from #produtos

select VNFTRIBST
       ,VNFVALICMSST
       ,*
  from TBS0105 with (nolock)

-- insert na TBS0105

delete TBS0105

INSERT INTO TBS0105 (
    VNFPROEMP           --  1 empresa
    ,VNFFORCNPJ         --  2 cnpj do fornecedor
    ,VNFPROFOR          --  3 código do produto do fornecedor
    ,VNFSEQ             --  4 sequência do produto na tabela
    ,VNFNCMORI          --  5 NCM destacado na NF
    ,VNFCESTORI         --  6 CEST destacado na NF
    ,VNFCSTCSOSNORI     --  7 CST/CSOSN destacado na NF
    ,VNFICMSPROORI      --  8 ICMS próprio da operação
    ,VNFICMSSTORI       --  9 ICMS-ST destacado na NF
    ,VNFMVAORI          -- 10 MVA destacado na NF
    ,VNFREDICMSORI      -- 11 redução da BC do ICMS destacado na NF
    ,VNFREDICMSSTORI    -- 12 redução da BC do ICMS-ST destacado na NF
    ,VNFIPIORI          -- 13 IPI destacado na NF
    ,VNFNCMALT          -- 14 NCM alterado
    ,VNFCESTALT         -- 15 CEST alterado
    --,VNFCSTCSOSNALT     -- CST/CSOSN alterado - não alterar
    --,VNFICMSPROALT      -- ICMS próprio alterado - não alterar
    ,VNFICMSINTALT      -- 16 ICMS interno alterado
    ,VNFICMSSTALT       -- 17 ICMS ST alterado
    ,VNFMVAORIALT       -- 18 MVA original alterado
    ,VNFMVAOPEALT       -- 19 MVA ajustado
    --,VNFREDICMSALT      -- redução da BC do ICMS - não alterar
    ,VNFREDICMSSTALT    -- 20 redução da BC do ICMS-ST alterado
    -- ,VNFIPIALT          -- IPI - não alterar
    ,VNFNUMDOC          -- 21 número da NF
    ,VNFSERDOC          -- 22 série da NF
    ,VNFPRODES          -- 23 descrição do produto
    ,VNFCFOP            -- 24 CFOP da operação
    ,VNFSITGUIA         -- 25 situação da guia: (A)lterada, (C)ancelada, (E)nviada, (N)ova e (P)aga

    ,VNFTRIBST          -- 26 se tributa ICMS-ST
    ,VNFVALITEMNF       -- 27 valor do item na NF
    ,VNFBASICMSST       -- 28 valor da BC do ICMS-ST
    ,VNFVALICMSST       -- 29 valor do ICMS-ST
    --,VNFICMSSTRES       -- 30 valor do ICMS-ST a restituir
    ,VNFICMSSTPAG       -- 30 valor do ICMS-ST a pagar
    --,VNFVALITECALC      -- 31 valor do item calculado com ICMS-ST


)
SELECT 
    ISNULL(NFEEMPCOD, 0),                             --  1
    ISNULL(CNPJ, ''),                                 --  2
    ISNULL(NFEPROFOR, ''),                            --  3
    ROW_NUMBER() OVER (PARTITION BY CNPJ ORDER BY (SELECT NULL)), -- 4 Sequencial por CNPJ 
    ISNULL(NFENCMXML, ''),                            --  5
    ISNULL(NFECESTXML, ''),                           --  6
    ISNULL(NFECSTXML, ''),                            --  7
    ISNULL(NFEPERICMSXML, 0),                         --  8
    ISNULL(NFEPERICMSSTXML, 0),                       --  9
    ISNULL(NFEPERMVASTXML, 0),                        -- 10
    ISNULL(NFEREDBASICMS, 0),                         -- 11
    ISNULL(NFEPERRBISTXML, 0),                        -- 12
    ISNULL(NFEPERIPI, 0),                             -- 13
    ISNULL(NCM_alterado, ''),                         -- 14
    ISNULL(CEST_alterado, ''),                        -- 15
    --ISNULL(CST_CSOSN_alterado, ''),
    --ISNULL(ICMS_proprio_alterado, 0),     
    ISNULL(NFEGAREICMSINT, 0),                        -- 16
    ISNULL(NFEGAREICMSST, 0),                         -- 17
    ISNULL(NFEGARENCMMVA, 0),                         -- 18
    ISNULL(MVA_ajustado, 0),                          -- 19
    --ISNULL(red_bc_icms, 0),
    ISNULL(red_bc_st, 0),                             -- 20
    --ISNULL(IPI_alterado, 0),
    ISNULL(NFENUM, 0),                                -- 21
    ISNULL(NFESERDOC, 0),                             -- 22
    ISNULL(NFEDES, ''),                               -- 23
    ISNULL(REPLACE(NFECFOPXML, '.', ''), ''),         -- 24
    'E', -- 25 enviada

    isnull(iif(NFEGAREVALICMSST + NFEVALICMSST > 0 , 'S', 'N'),'N')   -- 26
    ,isnull(NFETOTOPEITE,0)                           -- 27
    ,isnull(NFEBASICMSST,0)                           -- 28
    ,isnull(NFEGAREVALICMSST,0)                       -- 29
    ,isnull(NFEGAREVALICMSST,0)                       -- 30

FROM #produtos P
WHERE NOT EXISTS (
    SELECT 1 
    FROM TBS0105 WITH (NOLOCK)
    WHERE VNFPROEMP = P.NFEEMPCOD 
    AND VNFFORCNPJ = P.CNPJ 
    AND VNFPROFOR = P.NFEPROFOR
    --AND VNFSEQ = P.NFEITE
);

select VNFTRIBST
       ,VNFNCMORI
       ,VNFNCMALT
       ,VNFCESTORI
       ,VNFCESTALT
       ,VNFCSTCSOSNORI
       ,VNFICMSPROORI
       ,VNFICMSSTORI
       ,VNFICMSSTALT
       ,VNFICMSINTALT
       ,VNFMVAORI
       ,VNFMVAORIALT
       ,VNFMVAOPEALT
       ,VNFBASICMSST
       ,VNFVALICMSST
       ,VNFNUMDOC
       ,VNFSERDOC
       ,VNFPROFOR
       ,VNFPRODES
       ,VNFCFOP
       ,VNFSITGUIA
       ,*
  from TBS0105 with (nolock)

select *
  from TBS0105 with (nolock)
 order by VNFPROEMP, VNFFORCNPJ, VNFPROFOR, VNFSEQ desc

-- ajuste dos dados da TBS0105

select *
  from TBS0105 with (nolock)
 where VNFFORCNPJ=''

begin tran
delete TBS0105
 where VNFFORCNPJ=''

rollback tran
commit tran

-- PPB fornecedor "port distribuidora"

select *
  from TBS0105 with (nolock)
 where VNFFORCNPJ='45341029000175'

/* ??
update TBS0105
   set VNFCSTCSOSNORI='400'
 where VNFPROEMP=0
       and VNFFORCNPJ='08228010000433'
       and VNFPROFOR='22558'

update TBS0105
   set VNFCFOP='6102'
 where VNFPROEMP=0
       and VNFFORCNPJ='08228010000433'
       and VNFPROFOR='22558'

update TBS0105
   set VNFICMSPROORI=12
 where VNFPROEMP=0
       and VNFFORCNPJ='08228010000433'
       and VNFPROFOR='22558'
*/

-- se operação tributação com ICMS-ST

select v.VNFCESTALT
       ,c.CESTMVACOD
       ,v.VNFTRIBST
       ,c.CESTOPEINT
       ,*
  from TBS0105 v with (nolock)
 inner join TBS154 c with (nolock)
    on v.VNFCESTALT=c.CESTMVACOD

begin tran
update TBS0105
   set VNFTRIBST=c.CESTOPEINT
  from TBS0105 v with (nolock)
 inner join TBS154 c with (nolock)
    on v.VNFCESTALT=c.CESTMVACOD

rollback tran
commit tran

-- mva ajustado

select VNFMVAORI
       ,VNFMVAOPEALT
       ,*
  from TBS0105 with (nolock)
 where VNFMVAORI > 0
       and VNFMVAOPEALT = 0

/* nenhum registro encontrador
begin tran
update TBS0105
   set VNFMVAOPEALT=VNFMVAORI
 where VNFMVAORI > 0
       and VNFMVAOPEALT = 0

rollback tran
commit tran
*/

-- alíquota icms-st

select *
  from TBS0105 with (nolock)
 where VNFICMSSTALT=0
       and VNFICMSSTORI > 0

begin tran
update TBS0105
   set VNFICMSSTALT=VNFICMSSTORI
 where VNFICMSSTALT=0
       and VNFICMSSTORI > 0

rollback tran
commit tran

-- alíquota MVA do CEST

select top(100)
       *
  from TBS154 with (nolock)
 where CESTOPEINT='S'

select VNFMVAORI as MVA_nota_fiscal
       ,VNFMVAORIALT as MVA_alterado
       ,CESTMVAPOR as MVA_tabela_CEST
       ,VNFCESTORI as CEST_nota_fiscal
       ,VNFCESTALT as CEST_alterado
       ,CESTMVACOD as CEST_tabela
       ,VNFNCMORI as NCM_nota_fiscal
       ,VNFNCMALT as NCM_alterado
  from TBS0105 pro with (nolock)
 inner join TBS154 cest with (nolock)
    on pro.VNFCESTALT=cest.CESTMVACOD
 where CESTOPEINT='S'
       and VNFMVAORIALT <> CESTMVAPOR

begin tran
update TBS0105
   set VNFMVAORIALT=CESTMVAPOR
  from TBS0105 pro with (nolock)
 inner join TBS154 cest with (nolock)
    on pro.VNFCESTALT=cest.CESTMVACOD
 where CESTOPEINT='S'
       and VNFMVAORIALT <> CESTMVAPOR

rollback tran
commit tran

-- ICMS interno

select *
  from TBS0105 with (nolock)
 where VNFICMSINTALT=0

begin tran
update TBS0105
   set VNFICMSINTALT=18
 where VNFICMSINTALT=0

rollback tran
commit tran

-- ICMS próprio da operação

-- empresas do simples nacional, não destacam a alíquota própria do ICMS
-- não é possível calcular a alíquota por não ter o índice do MVA ajustado

select VNFBASICMSST
      ,VNFCSTCSOSNORI as CST_CSOSN
       ,VNFICMSPROORI as ICMS_proprio
       ,*
  from TBS0105 with (nolock)
 where VNFICMSPROORI=0

begin tran
update TBS0105
   set VNFICMSPROORI=12
 where VNFNUMDOC=22
       and VNFSERDOC='2'

rollback tran
commit tran

begin tran
update TBS0105
   set VNFMVAOPEALT=51.01
       ,VNFBASICMSST=2755.86
 where VNFNUMDOC=22
       and VNFSERDOC='2'
       and VNFICMSPROORI=0

rollback tran
commit tran

select --VNFBASICMSST
       --,VNFCSTCSOSNORI --as CST_CSOSN
       --,VNFICMSPROORI --as ICMS_proprio
       --,VNFICMSPROALT
       --,
       *
  from TBS0105 with (nolock)
 where VNFNUMDOC=194222   -- 22
       and VNFSERDOC='1'  -- '2'

select *
  from TBS154 with (nolock)
  where CESTMVACOD='1900400'

-- CSTMVAPO = 44.58

begin tran
update TBS154
   set CESTMVAPOR=44.58 -- 40.71 -- 44.58 da tabela
 where CESTMVACOD='1900400'

rollback tran
commit tran

begin tran
delete TBS0105 
 where VNFNUMDOC=22
       and VNFSERDOC='2'

rollback tran
commit tran

SELECT 
    VNFMVAORIALT,
    VNFMVAOPEALT,
    VNFICMSINTALT,
    ROUND(
        1 - (
            (1 + (VNFMVAOPEALT / 100.0)) * (1 - (VNFICMSINTALT / 100.0))
          ) / (1 + (VNFMVAORIALT / 100.0)) * 100
    , 2) AS ALQ_INTER_CALCULADA
FROM TBS0105
WHERE VNFMVAORIALT > 0
  AND VNFMVAOPEALT > 0
  AND VNFICMSINTALT > 0
  --and VNFICMSPROORI=0
  and VNFNUMDOC=22
  and VNFSERDOC='2'

-- função para o cálculo da alíquota própria do ICMS

CREATE FUNCTION dbo.fn_CalculaAlqInter
(
    @mva_original DECIMAL(10,4),
    @mva_ajustada DECIMAL(10,4),
    @alq_intra    DECIMAL(10,4)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @alq_inter DECIMAL(10,2)

    IF @mva_original IS NULL OR @mva_ajustada IS NULL OR @alq_intra IS NULL
    BEGIN
        RETURN NULL
    END

    SET @alq_inter = ROUND(
        (1 - ((1 + (@mva_ajustada / 100.0)) * (1 - (@alq_intra / 100.0)) / (1 + (@mva_original / 100.0)))) * 100,
        2
    )

    RETURN @alq_inter
END

-- como usar

SELECT 
    CODIGO,
    dbo.fn_CalculaAlqInter(VNFMVAORIALT, VNFMVAOPEALT, VNFICMSINTALT) AS ALQ_INTER_CALCULADA
FROM TBS0105
WHERE VNFMVAORIALT IS NOT NULL
  AND VNFMVAOPEALT IS NOT NULL
  AND VNFICMSINTALT IS NOT NULL;

select dbo.fn_CalculaAlqInter(40.71, 51.01, 18) AS ALQ_INTER_CALCULADA

select VNFMVAORIALT
       ,VNFMVAOPEALT
       ,VNFICMSINTALT
       ,round(1 - ((1 + (VNFMVAOPEALT / 100.0)) * (1 - (VNFICMSINTALT / 100.0)) ) / (1 + (VNFMVAORIALT / 100.0)) * 100, 2) AS ALQ_INTER_CALCULADA
       ,dbo.fn_CalculaAlqInter(VNFMVAORIALT, VNFMVAOPEALT, VNFICMSINTALT) AS ALQ_INTER_CALCULADA_OUTRA
  from TBS0105 with (nolock)
 where VNFNUMDOC=22
       and VNFSERDOC='2'

-- cálculo da MVA ajustada

select VNFMVAORIALT as MVA_original_alterado
       ,VNFICMSPROORI as ICMS_proprio
       ,VNFICMSINTALT as ICMS_interno
       ,VNFMVAORI as MVA_nota_fiscal
       ,VNFMVAOPEALT as MVA_ajustado
  from TBS0105 with (nolock)
 where VNFMVAORIALT > 0

begin tran
update TBS0105
   set VNFMVAOPEALT=dbo.fn_CalcularMVA_Ajustado(VNFMVAORIALT, VNFICMSPROORI, VNFICMSINTALT)
 where VNFMVAORIALT > 0

rollback tran
commit tran

-- redução da base de cálculo do ICMS

select *
  from TBS0105 with (nolock)
 where VNFREDICMSORI > 0
       and VNFREDICMSALT = 0

-- redução da base de cálculo do ICMS-ST

select *
  from TBS0105 with (nolock)
 where VNFREDICMSSTORI > 0
       and VNFREDICMSSTALT = 0

select *
  from TBS0105 with (nolock)
 where VNFNCMALT='82141000'

select *
  from TBS0105 with (nolock)
 where VNFMVAORIALT > 0
       and VNFTRIBST=''

-- primeiro

select *
  from TBS0105 with (nolock)
 where VNFMVAORIALT > 0
       and VNFTRIBST=''

begin tran
update TBS0105
   set VNFTRIBST='S'
 where VNFMVAORIALT > 0
       and VNFTRIBST = ''

rollback tran
commit tran

-- segundo

select *
  from TBS0105 with (nolock)
 where VNFTRIBST=''

begin tran
update TBS0105
   set VNFTRIBST='N'
 where VNFTRIBST=''

rollback tran
commit tran

-- CEST código 0000000

select *
  from TBS0105 with (nolock)
 where VNFCESTORI='0000000'

begin tran
update TBS0105
   set VNFCESTORI=''
 where VNFCESTORI='0000000'

rollback tran
commit tran

select *
  from TBS0105 with (nolock)
 where VNFCESTALT='0000000'

begin tran
update TBS0105
   set VNFCESTALT=''
 where VNFCESTALT='0000000'

rollback tran
commit tran

-- lista final

select *
  from TBS0105 with (nolock)

-- lista duplicados na TBS1542

select *
  from TBS1542 with (nolock)

select CESTMVACOD
       ,upper(CESTNCMDES)
       ,count(*)
  from TBS1542 with (nolock)
 group by CESTMVACOD
       ,upper(CESTNCMDES)
having count(*) > 1

drop table TBS1542BKP

select *
  into TBS1542BKP
  from TBS1542 with (nolock)

select *
  from TBS1542BKP with (nolock)

begin tran
delete TBS1542

rollback tran
commit tran



-- carga de dados na TBS156

select *
  into TBS156BKP
  from TBS156 with (nolock)

begin tran
delete TBS156 

rollback tran
commit tran

select *
  from TBS156 with (nolock)

insert into TBS156
select 0 as empresa
       ,NFECHAACE
       ,NFENUM
       ,NFESERDOC
       ,NFEDATEMI
       ,'' as hora_emissao_nf
       ,DBO.NFETOTOPE(NFEEMPCOD, NFETIP, NFENUM, NFECOD, SEREMPCOD, SERCOD)
       ,NFEDAREVALOR
       ,cast(NFEDAREDATEMI as date)
       ,convert(char(8), cast(NFEDAREDATEMI as time))
       ,NFEDAREUSUEMI
       ,NFEDARECB44
       ,NFEDARECB48
       ,NFEDARENUM
       ,NFEDAREPIX
       ,NFEDAREDATVEN
       ,NFENOM
       ,subString(NFECHAACE,7,14)
       ,'E' as situacao
       ,'' as cod_receita
       ,NFEESTORI
       ,'S' as gerada_impressa
       ,0 as mnicipio
       ,'17530101' as data_pagamento
       ,'' as cod_servico
       ,'17530101' as data_cancelamento
       ,'' as usuario_cancelou

  from TBS059 with (nolock)
 where NFEDATEFE >= '20230101'
       and (NFEDARENUM <> '' or NFEGARE='S')
       and NFECAN = 'N'
       and NFETIP = 'N'
       and NFECOD NOT IN (SELECT codigo FROM #grupo)
       and NFEDAREVALOR > 0

select *
  from TBS003 with (nolock)

-- contas a pagar

select *
  from TBS057 with (nolock)
 where FORCOD = 3766
       and CPADATBAI <> '17530101'
       and dbo.CPAVALSDO(CPAEMPCOD, PFXEMPCOD, FOREMPCOD, PFXCOD, CPATIT, CPAPAR, FORCOD) = 0

begin tran
update TBS156
   set VICDATPAG = CPADATBAI
       ,VICSITGUIA = 'P'
  from TBS156 with (nolock)
 inner join TBS057 with (nolock)
    on VICNUMNF=CPATIT
 where CPAEMPCOD=0
       and FORCOD = 3766
       and CPADATBAI <> '17530101'
       and dbo.CPAVALSDO(CPAEMPCOD, PFXEMPCOD, FOREMPCOD, PFXCOD, CPATIT, CPAPAR, FORCOD) = 0

rollback tran
commit tran



