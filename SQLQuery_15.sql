CREATE FUNCTION dbo.SplitString
(
    @string NVARCHAR(MAX),
    @delimiter CHAR(1)
)
RETURNS @output TABLE(
    Item NVARCHAR(MAX)
)
BEGIN
    DECLARE @start INT, @end INT
    SET @start = 1
    IF SUBSTRING(@string, LEN(@string) - 1, LEN(@string)) <> @delimiter
    BEGIN
        SET @string = @string + @delimiter
    END
    WHILE CHARINDEX(@delimiter, @string, @start) > 0
    BEGIN
        SET @end = CHARINDEX(@delimiter, @string, @start)
        INSERT INTO @output (Item) VALUES(SUBSTRING(@string, @start, @end - @start))
        SET @start = @end + 1
    END
    RETURN
END

-- Explodir a Coluna NCM
;WITH NCM_EXPLODED AS (
    SELECT
        CESTMVACOD as CEST
        ,LTRIM(RTRIM(S.Item)) as NCM
        ,CESTMVADES as descricao
        ,CESTMVASEG as segmento
    FROM
        TBS154 WITH (NOLOCK)
    CROSS APPLY dbo.SplitString(CESTMVANCM, ' ') S
)

select *
  from NCM_EXPLODED

select *
  from TBS154 with (nolock)

select PROCLAFIS
       ,PROCEST
  from TBS010 with (nolock)
 where PROCOD='1640054'

drop table TBS154BKP

select *
  into TBS154BKP
  from TBS154 with (nolock)

delete TBS154 

select *
  from TBS154 with (nolock)

select *
  from TBS1541 with (nolock)

select *
  from TBS1542 with (nolock)

update TBS154
   set CESTMVATABVER=73

select *
  from TBS1541 with (nolock)
 where CESTMVANCM Like ('90251990')

drop table #NCM_unicos

select CESTMVANCM as NCM
  into #NCM_unicos
  from TBS1541 with (nolock)
 where Len(Ltrim(CESTMVANCM))=8
 group by CESTMVANCM
having count(*) = 1

select *
  from #NCM_unicos

drop table #CEST_unicos

select CESTMVACOD CEST
  into #CEST_unicos
  from TBS1541 with (nolock)
 where CESTMVANCM in (select NCM from #NCM_unicos)
 group by CESTMVACOD
having count(*)=1

select *
  from #CEST_unicos

select *
  from TBS154 with (nolock)
 where CESTMVACOD in (select CEST from #CEST_unicos)

select *
  from TBS154 a with (nolock)
 inner join TBS1541 b with (nolock) on b.CESTMVACOD=a.CESTMVACOD
 inner join #CEST_unicos c on c.CEST=a.CESTMVACOD
 inner join #NCM_unicos d on d.NCM=b.CESTMVANCM
 where a.CESTMVAPOR > 0

select CESTMVACOD
       ,count(*)
  from TBS154 with (nolock)
 group by CESTMVACOD
having count(*) > 1

select *
  from TBS1541 with (nolock)
 where CESTMVACOD='1702200'

select *
  from TBS1541 with (nolock)
 where CESTMVANCM='32041300'

select top(1) *
  from TBS154 with (nolock)

select top(1) *
  from TBS1541 with (nolock)

select top(1) *
  from TBS1542 with (nolock)

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TBS154';

drop table #tabela_final

select a.CESTMVACOD,
       a.CESTMVAPOR,
       case  
        WHEN CESTUFAC IS NULL OR CESTUFAC = '' OR CESTUFAC = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFAC,
    CASE 
        WHEN CESTUFAL IS NULL OR CESTUFAL = '' OR CESTUFAL = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFAL,
    CASE 
        WHEN CESTUFAM IS NULL OR CESTUFAM = '' OR CESTUFAM = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFAM,
    CASE 
        WHEN CESTUFAP IS NULL OR CESTUFAP = '' OR CESTUFAP = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFAP,
    CASE 
        WHEN CESTUFBA IS NULL OR CESTUFBA = '' OR CESTUFBA = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFBA,
    CASE 
        WHEN CESTUFCE IS NULL OR CESTUFCE = '' OR CESTUFCE = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFCE,
    CASE 
        WHEN CESTUFDF IS NULL OR CESTUFDF = '' OR CESTUFDF = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFDF,
    CASE 
        WHEN CESTUFES IS NULL OR CESTUFES = '' OR CESTUFES = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFES,
    CASE 
        WHEN CESTUFGO IS NULL OR CESTUFGO = '' OR CESTUFGO = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFGO,
    CASE 
        WHEN CESTUFMA IS NULL OR CESTUFMA = '' OR CESTUFMA = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFMA,
    CASE 
        WHEN CESTUFMG IS NULL OR CESTUFMG = '' OR CESTUFMG = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFMG,
    CASE 
        WHEN CESTUFMS IS NULL OR CESTUFMS = '' OR CESTUFMS = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFMS,
    CASE 
        WHEN CESTUFMT IS NULL OR CESTUFMT = '' OR CESTUFMT = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFMT,
    CASE 
        WHEN CESTUFPA IS NULL OR CESTUFPA = '' OR CESTUFPA = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFPA,
    CASE 
        WHEN CESTUFPB IS NULL OR CESTUFPB = '' OR CESTUFPB = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFPB,
    CASE 
        WHEN CESTUFPE IS NULL OR CESTUFPE = '' OR CESTUFPE = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFPE,
    CASE 
        WHEN CESTUFPI IS NULL OR CESTUFPI = '' OR CESTUFPI = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFPI,
    CASE 
        WHEN CESTUFPR IS NULL OR CESTUFPR = '' OR CESTUFPR = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFPR,
    CASE 
        WHEN CESTUFRJ IS NULL OR CESTUFRJ = '' OR CESTUFRJ = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFRJ,
    CASE 
        WHEN CESTUFRN IS NULL OR CESTUFRN = '' OR CESTUFRN = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFRN,
    CASE 
        WHEN CESTUFRO IS NULL OR CESTUFRO = '' OR CESTUFRO = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFRO,
    CASE 
        WHEN CESTUFRR IS NULL OR CESTUFRR = '' OR CESTUFRR = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFRR,
    CASE 
        WHEN CESTUFRS IS NULL OR CESTUFRS = '' OR CESTUFRS = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFRS,
    CASE 
        WHEN CESTUFSC IS NULL OR CESTUFSC = '' OR CESTUFSC = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFSC,
    CASE 
        WHEN CESTUFSE IS NULL OR CESTUFSE = '' OR CESTUFSE = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFSE,
    CASE 
        WHEN CESTUFSP IS NULL OR CESTUFSP = '' OR CESTUFSP = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFSP,
    CASE 
        WHEN CESTUFTO IS NULL OR CESTUFTO = '' OR CESTUFTO = '-' THEN 0 
        ELSE CESTMVAPOR 
    END AS CESTUFTO,
    b.CESTMVANCM
into #tabela_final
FROM TBS154 a WITH (NOLOCK)
 inner join TBS1541 b with (nolock) on b.CESTMVACOD=a.CESTMVACOD
 inner join #CEST_unicos c on c.CEST=a.CESTMVACOD
 inner join #NCM_unicos d on d.NCM=b.CESTMVANCM
 where a.CESTMVAPOR > 0

select *
  from #tabela_final

select *
  from TBS0921 a with (nolock)
 inner join #tabela_final b on b.CESTMVANCM=a.NCMCOD
 where UFESIG='SP'
       and NCMMVA <> b.CESTMVAPOR

select count(*)
  from TBS0921 with (nolock)
 where UFESIG='SP'
       and NCMMVA = 0

select a.NCMCOD
       ,b.CESTMVAPOR
  from TBS0921 a with (nolock)
 inner join #tabela_final b on b.CESTMVANCM=a.NCMCOD
 where UFESIG='SP'
       and NCMMVA <> b.CESTMVAPOR

select a.NCMCOD
       ,b.CESTMVAPOR
  from TBS0921 a with (nolock)
 inner join #tabela_final b on b.CESTMVANCM=a.NCMCOD
 where UFESIG='SP'
       --and NCMMVA <> b.CESTMVAPOR
       and a.NCMCOD is null

select a.NCMCOD
       ,b.CESTMVAPOR
  from TBS0921 a with (nolock)
  right join #tabela_final b on b.CESTMVANCM=a.NCMCOD
 where UFESIG='SP'
       --and NCMMVA <> b.CESTMVAPOR
       and a.NCMCOD is null

select *
  from #tabela_final
 where not exists (select 'ne' from TBS092 with (nolock) where NCMCOD=CESTMVANCM)

select *
  from #tabela_final a
 inner join TBS1542 b with (nolock)
    on b.CESTMVACOD=a.CESTMVACOD
 where not exists (select 'ne' from TBS0921 with (nolock) where NCMCOD=a.CESTMVANCM)

select *
  from #tabela_final
 where not exists (select 'ne' from TBS0921 with (nolock) where NCMCOD=CESTMVANCM)

INSERT INTO TBS0921 (NCMCOD, UFESIG, NCMMVA)
SELECT ncm.CESTMVANCM, 'SP', ncm.CESTMVAPOR
FROM #tabela_final ncm
WHERE NOT EXISTS (
    SELECT 1 
    FROM TBS0921 tbs
    WHERE tbs.NCMCOD = ncm.CESTMVANCM
);

UPDATE tbs0921
SET tbs0921.NCMEX = tbs092.NCMEX
FROM TBS0921 tbs0921
INNER JOIN TBS092 tbs092
    ON tbs0921.NCMCOD = tbs092.NCMCOD
    --AND tbs0921.UFESIG = tbs092.UFESIG  -- Certifique-se de ajustar se houver mais critérios de união
WHERE tbs0921.NCMEX = '';  -- Verifica se o NCMEX de TBS0921 está vazio

select *
  from TBS154 with (nolock)
 where CESTMVACOD='1702200'

select top(1) *
  from TBS0921 with (nolock)

select *
  from TBS0921 with (nolock)
 where NCMCOD='15079011'

select *
  from TBS0921 with (nolock)
 where NCMUFORI is null

update TBS0921
   set NCMUFORI=''
 where NCMUFORI is null

select *
  from TBS0921 with (nolock)
 where UFESIG='SP'

select *
  from TBS092 with (nolock)

-- produtos

select pro.PROCLAFIS as NCM_produto
       ,pro.PROIVA as MVA_produto
       ,ncm.CESTMVANCM as NCM_fiscal
       ,ncm.CESTMVAPOR as MVA_fiscal
  from TBS010 pro with (nolock)
 inner join #tabela_final ncm on ncm.CESTMVANCM=pro.PROCLAFIS
 where pro.PROIVA <> ncm.CESTMVAPOR

select PROCOD
       ,PROCLAFIS
       ,PROIVA
  into TBS010_NCM
  from TBS010 with (nolock)

UPDATE pro
SET pro.PROIVA = ncm.CESTMVAPOR
FROM TBS010 pro
INNER JOIN #tabela_final ncm
    ON ncm.CESTMVANCM = pro.PROCLAFIS
WHERE pro.PROIVA <> ncm.CESTMVAPOR;

select top(1) *
  from TBS015 with (nolock)

-- cest

select pro.PROCOD as codigo
       ,pro.PROCLAFIS as NCM_produto
       ,pro.PROIVA as MVA_produto
       ,pro.PROCEST as CEST_produto
       ,ncm.CESTMVANCM as NCM_fiscal
       ,ncm.CESTMVAPOR as MVA_fiscal
       ,ncm.CESTMVACOD as CEST_fiscal
  from TBS010 pro with (nolock)
 inner join #tabela_final ncm on ncm.CESTMVANCM=pro.PROCLAFIS
 where pro.PROCEST <> ncm.CESTMVACOD

UPDATE pro
SET pro.PROCEST = ncm.CESTMVACOD
FROM TBS010 pro
INNER JOIN #tabela_final ncm
    ON ncm.CESTMVANCM = pro.PROCLAFIS
WHERE pro.PROCEST <> ncm.CESTMVACOD;

select top(1) *
  from TBS092 with (nolock)

exec sp_help 'TBS092'

select NCMEX
       ,count(*)
  from TBS092 with (nolock)
 group by NCMEX

select NCMCOD
       ,count(*)
  from TBS092 with (nolock)
 group by NCMCOD
having count(*) > 1





