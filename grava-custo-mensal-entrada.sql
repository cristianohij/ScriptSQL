-- 2a. a ser executada

if exists(select name from sysobjects where name='SP_CustoMensal' and type='P')
   drop procedure [dbo].[SP_CustoMensal]
go

create procedure [dbo].[SP_CustoMensal] @anomes char(6) as -- @dataDe as date, @dataAte as date as
   begin
      set nocount on

      -- códigos dos fornecedores do grupo

      if object_id('tempdb.dbo.#grupo') is not null
         begin
    	      drop table #grupo
         end

      create table #grupo (codigo int)

      insert into #grupo
      exec usp_FornecedoresGrupo 1
  
	   declare @msg varchar(1000)

      set @msg = 'Processa ano/mes: ' + @anomes
      raiserror (@msg, 0, 1) with nowait

      set @msg = 'Tabela temporário de entradas - ' + convert(NVARCHAR, getdate(), 8)
      raiserror (@msg, 0, 1) with nowait

      select str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2) anomes
             ,PROCOD codigo

             -- qtde compra na menor unidade * preço unitário (sem alguns impostos)
             ,sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) -- valor total do mês
             /
             case sum(NFEQTD * NFEQTDEMB) when 0 then 1 else sum(NFEQTD * NFEQTDEMB) end as custo -- qtde total do mês

             ,isnull(sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)),0) as valor
             ,isnull(sum(NFEQTD * NFEQTDEMB),0) as qtde -- qtde total do m�s
             ,str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2)+'01' data
             ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROEMPCOD=0 and TBS010.PROCOD=TBS0591.PROCOD) uni
             ,(select PROUM1QTD from TBS010 with (nolock) where TBS010.PROEMPCOD=0 and TBS010.PROCOD=TBS0591.PROCOD) qemb

        into #TMP
        from TBS0591 (nolock)
			 inner join TBS059 (nolock) on TBS059.NFEEMPCOD=TBS0591.NFEEMPCOD and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
			 --inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

       where --TBS059.NFEDATEFE between @dataDe and @dataAte
	         TBS0591.NFEEMPCOD=0
             and convert(char(6),TBS059.NFEDATEFE,112) = @anomes
             and TBS0591.NFETIP='N'
             and TBS059.NFECAN<>'S'
             --and FORCGC not in('05118717000156','05118717000237','52080207000117','44125185000136','41952080000162','65069593000198','65069593000279','65069593000350')
             and TBS0591.NFECOD not in (select codigo from #grupo)
             and right(NFECFOP,3) in('102','403','121','202','411')
       group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),PROCOD

      set @msg = 'Update em SALDOINICIAL - ' + convert(NVARCHAR, getdate(), 8)
      raiserror (@msg, 0, 1) with nowait

      update SALDOINICIAL
	     set SALDOINICIAL.QTDENTRADA=#TMP.qtde
		     ,SALDOINICIAL.VALENTRADA=#TMP.valor
			 ,SALDOINICIAL.CUSTO=#TMP.custo
        from SALDOINICIAL with (nolock)
             inner join #TMP
             on SALDOINICIAL.ANOMES=#TMP.anomes and SALDOINICIAL.CODIGO=#TMP.codigo

      set @msg = 'Insert em SALDOINICIAL - ' + convert(NVARCHAR, getdate(), 8)
      raiserror (@msg, 0, 1) with nowait

      insert into SALDOINICIAL 
      select #TMP.data
             ,#TMP.anomes
             ,#TMP.codigo
             ,#TMP.uni
             ,#TMP.qemb
             ,#TMP.qtde
             ,#TMP.valor
             ,#TMP.custo
             ,0 E1
             ,0 E2
             ,0 E3
             ,0 E4
             ,0 E5
             ,0 E6
             ,0 E7
             ,0 E8
             ,0 E9
			 ,'' EMPRESA
        from #TMP
       where not exists(select ''
                          from SALDOINICIAL with (nolock) 
                         where SALDOINICIAL.ANOMES=#TMP.anomes and SALDOINICIAL.CODIGO=#TMP.codigo)

--      select * from #TMP
   end

-- versão otimizada pelo chatGPT

-- Aqui você sempre filtra por NFEEMPCOD e NFETIP, e precisa do join em (NFEEMPCOD, NFETIP, NFECOD, SERCOD, NFENUM)

CREATE INDEX IX_TBS0591_FiltroJoin
    ON TBS0591 (NFEEMPCOD, NFETIP, NFECOD, SERCOD, NFENUM)
    INCLUDE (PROCOD, NFEQTD, NFEQTDEMB, NFEITE, SEREMPCOD, NFECFOP);

-- E também participa no join pelo par (NFEEMPCOD, NFETIP, NFECOD, SERCOD, NFENUM)

CREATE INDEX IX_TBS059_FiltroJoin
    ON TBS059 (NFEDATEFE, NFECAN, NFEEMPCOD, NFETIP, NFECOD, SERCOD, NFENUM);

-- Aqui basta um índice simples:

CREATE INDEX IX_TBS010_PROCOD
    ON TBS010 (PROEMPCOD, PROCOD)
    INCLUDE (PROUM1, PROUM1QTD);


IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'SP_CustoMensal' AND type = 'P')
    DROP PROCEDURE [dbo].[SP_CustoMensal];
GO

CREATE PROCEDURE [dbo].[SP_CustoMensal]
    @anomes CHAR(6)  -- formato 'YYYYMM'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE 
        @msg         VARCHAR(1000),
        @ano         INT,
        @mes         INT,
        @dtIni       DATE,
        @dtFim       DATE,
        @dataChar8   CHAR(8);

    -- Validação básica do parâmetro
    IF (@anomes IS NULL OR LEN(@anomes) <> 6 OR ISNUMERIC(@anomes) = 0)
    BEGIN
        RAISERROR('Parâmetro @anomes inválido. Use YYYYMM.', 16, 1);
        RETURN;
    END

    -- Deriva datas do período
    SET @ano = CAST(LEFT(@anomes, 4) AS INT);
    SET @mes = CAST(SUBSTRING(@anomes, 5, 2) AS INT);

    IF (@mes NOT BETWEEN 1 AND 12)
    BEGIN
        RAISERROR('Parâmetro @anomes com mês inválido. Use YYYYMM.', 16, 1);
        RETURN;
    END

    SET @dtIni = DATEFROMPARTS(@ano, @mes, 1);
    SET @dtFim = DATEADD(MONTH, 1, @dtIni);
    SET @dataChar8 = CONVERT(CHAR(8), @dtIni, 112);  -- 'YYYYMMDD' (sempre dia 01)

    -- LOG
    SET @msg = 'Processa ano/mes: ' + @anomes;
    PRINT @msg;

    BEGIN TRY
        ---------------------------------------------------------------------
        -- 1) Tabela temporária de fornecedores do grupo
        ---------------------------------------------------------------------
        IF OBJECT_ID('tempdb..#grupo') IS NOT NULL
            DROP TABLE #grupo;

        CREATE TABLE #grupo (codigo INT NOT NULL PRIMARY KEY);

        INSERT INTO #grupo (codigo)
        EXEC dbo.usp_FornecedoresGrupo 1;

        PRINT 'Tabela temporária #grupo carregada: ' + CONVERT(VARCHAR(8), @@ROWCOUNT) + ' códigos.';

        ---------------------------------------------------------------------
        -- 2) Tabela temporária de entradas do mês (#TMP)
        ---------------------------------------------------------------------
        PRINT 'Gerando #TMP - ' + CONVERT(NVARCHAR(8), GETDATE(), 8);

        IF OBJECT_ID('tempdb..#TMP') IS NOT NULL
            DROP TABLE #TMP;

        SELECT
            @anomes                             AS anomes,            -- CHAR(6) 'YYYYMM'
            T59_1.PROCOD                        AS codigo,
            -- custo = (soma valor total) / (soma quantidade), protegendo divisão por zero
            SUM(T59_1.NFEQTD * T59_1.NFEQTDEMB * dbo.NFECUSAQU(
                    T59_1.NFEEMPCOD, T59_1.NFETIP, T59_1.NFENUM,
                    T59_1.NFECOD,    T59_1.SEREMPCOD, T59_1.SERCOD, T59_1.NFEITE
                ))
                / NULLIF(SUM(T59_1.NFEQTD * T59_1.NFEQTDEMB), 0)     AS custo,
            ISNULL(SUM(T59_1.NFEQTD * T59_1.NFEQTDEMB * dbo.NFECUSAQU(
                    T59_1.NFEEMPCOD, T59_1.NFETIP, T59_1.NFENUM,
                    T59_1.NFECOD,    T59_1.SEREMPCOD, T59_1.SERCOD, T59_1.NFEITE
                )), 0)                                               AS valor,
            ISNULL(SUM(T59_1.NFEQTD * T59_1.NFEQTDEMB), 0)           AS qtde,
            @dataChar8                          AS data,              -- CHAR(8) 'YYYYMM01'
            T10.PROUM1                          AS uni,
            T10.PROUM1QTD                       AS qemb
        INTO #TMP
        FROM TBS0591 AS T59_1 WITH (NOLOCK)
        INNER JOIN TBS059  AS T59   WITH (NOLOCK)
            ON  T59.NFEEMPCOD = T59_1.NFEEMPCOD
            AND T59.SERCOD    = T59_1.SERCOD
            AND T59.NFETIP    = T59_1.NFETIP
            AND T59.NFECOD    = T59_1.NFECOD
            AND T59.NFENUM    = T59_1.NFENUM
        LEFT JOIN TBS010 AS T10 WITH (NOLOCK)
            ON  T10.PROEMPCOD = 0
            AND T10.PROCOD    = T59_1.PROCOD
        WHERE
                T59_1.NFEEMPCOD = 0
            AND T59.NFEDATEFE  >= @dtIni        -- sargável (usa índice)
            AND T59.NFEDATEFE  <  @dtFim        -- sargável (usa índice)
            AND T59_1.NFETIP   = 'N'
            AND T59.NFECAN     <> 'S'
            AND NOT EXISTS (SELECT 1 FROM #grupo g WHERE g.codigo = T59_1.NFECOD)
            AND RIGHT(T59_1.NFECFOP, 3) IN ('102','403','121','202','411')
        GROUP BY
            T59_1.PROCOD,
            T10.PROUM1,
            T10.PROUM1QTD;

        PRINT '#TMP gerada: ' + CONVERT(VARCHAR(12), @@ROWCOUNT) + ' linhas.';

        ---------------------------------------------------------------------
        -- 3) Upsert em SALDOINICIAL (UPDATE + INSERT faltantes)
        ---------------------------------------------------------------------
        PRINT 'Update em SALDOINICIAL - ' + CONVERT(NVARCHAR(8), GETDATE(), 8);

        UPDATE SI
            SET SI.QTDENTRADA = T.qtde,
                SI.VALENTRADA = T.valor,
                SI.CUSTO      = T.custo
        FROM SALDOINICIAL AS SI WITH (NOLOCK)
        INNER JOIN #TMP AS T
            ON  SI.ANOMES = T.anomes
            AND SI.CODIGO = T.codigo;

        PRINT 'Update concluído. Linhas afetadas: ' + CONVERT(VARCHAR(12), @@ROWCOUNT) + '.';

        PRINT 'Insert em SALDOINICIAL - ' + CONVERT(NVARCHAR(8), GETDATE(), 8);

        INSERT INTO SALDOINICIAL
            ([DATA], ANOMES, CODIGO, UNI, QEMBALAGEM, QTDENTRADA, VALENTRADA, CUSTO,
             E1, E2, E3, E4, E5, E6, E7, E8, E9, EMPRESA)
        SELECT
             T.data, T.anomes, T.codigo, T.uni, T.qemb,
             T.qtde, T.valor,  T.custo,
             0, 0, 0, 0, 0, 0, 0, 0, 0,
             ''  AS EMPRESA
        FROM #TMP AS T
        WHERE NOT EXISTS (
            SELECT 1
            FROM SALDOINICIAL AS SI WITH (NOLOCK)
            WHERE SI.ANOMES = T.anomes
              AND SI.CODIGO = T.codigo
        );

        PRINT 'Insert concluído. Linhas inseridas: ' + CONVERT(VARCHAR(12), @@ROWCOUNT) + '.';

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        -- Apenas relança o erro original
        THROW;
    END CATCH
END
GO

select *
  into SALDOINICIAL_BKP
  from SALDOINICIAL with (nolock)

truncate table SALDOINICIAL

select min(ANOMES)
  from SALDOINICIAL_BKP with (nolock)

select min(ANOMES)
  from SALDOINICIAL with (nolock)

select count(*)
  from SALDOINICIAL_BKP with (nolock)

select *
  from SALDOINICIAL_BKP with (nolock)
 where CODIGO = '16280026'

select count(*)
  from SALDOINICIAL with (nolock)

select *
  from SALDOINICIAL with (nolock)
 where CODIGO = '16280026'

select *
  from SALDOINICIAL with (nolock)
 where CODIGO = '27290006'


select *
  from SALDOINICIAL with (nolock)
 where CUSTO > 0
 
select *
  from SALDOINICIAL with (nolock)
 order by [DATA]

select a.*
       ,b.*
  from SALDOINICIAL_BKP a with (nolock)
  full outer join SALDOINICIAL b with (nolock)
    on a.ANOMES = b.ANOMES
       and a.CODIGO = b.CODIGO
       and a.EMPRESA = b.EMPRESA
 where a.EMPRESA = ''
       --and b.EMPRESA = '' 
       and (
         a.ANOMES is null
       or a.CODIGO is NULL
       or b.ANOMES is null
       or b.CODIGO is null )

select *
  from SALDOINICIAL_BKP with (nolock)
 where E1 + E2 + E3 + E4 + E5 + E6 + E7 + E8 + E9 = 0
       and CODIGO = '16280026'

select *
  from SALDOINICIAL with (nolock)
 where E1 + E2 + E3 + E4 + E5 + E6 + E7 + E8 + E9 = 0
       and CODIGO = '16280026'

-- fim versão otimizada pelo chatGPT


exec SP_CustoMensal '202104'

-- mes fechado

declare @datai date, @dataf date, @comando varchar(50)

select @datai='20250901', @dataf='20250901'

while @datai <= @dataf
   begin
      -- n�o foi poss�vel rodar passando a vari�vel @datai diretamente como par�metro

      set @comando='exec SP_CustoMensal ''' + convert(char(6),@datai,112) + ''''
      execute(@comando)
--print @datai
      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
   end


SELECT 'bb' AS origem,
       COUNT(*) AS registros,
       SUM(CASE WHEN CUSTO > 0 THEN 1 ELSE 0 END) AS custo_maior_0,
       SUM(CASE WHEN CUSTO = 0 THEN 1 ELSE 0 END) AS custo_igual_0
  FROM bb.SIBD2.dbo.SALDOINICIAL WITH (NOLOCK)

UNION ALL

SELECT 'mi',
       COUNT(*) AS registros,
       SUM(CASE WHEN CUSTO > 0 THEN 1 ELSE 0 END),
       SUM(CASE WHEN CUSTO = 0 THEN 1 ELSE 0 END)
  FROM mi.SIBD3.dbo.SALDOINICIAL WITH (NOLOCK)

UNION ALL

SELECT 'py',
       COUNT(*) AS registros,
       SUM(CASE WHEN CUSTO > 0 THEN 1 ELSE 0 END),
       SUM(CASE WHEN CUSTO = 0 THEN 1 ELSE 0 END)
  FROM pp.SIBD.dbo.SALDOINICIAL WITH (NOLOCK)

UNION ALL

SELECT 'tc',
       COUNT(*) AS registros,
       SUM(CASE WHEN CUSTO > 0 THEN 1 ELSE 0 END),
       SUM(CASE WHEN CUSTO = 0 THEN 1 ELSE 0 END)
  FROM cd.SIBD.dbo.SALDOINICIAL WITH (NOLOCK)

UNION ALL

SELECT 'tm',
       COUNT(*) AS registros,
       SUM(CASE WHEN CUSTO > 0 THEN 1 ELSE 0 END),
       SUM(CASE WHEN CUSTO = 0 THEN 1 ELSE 0 END)
  FROM dbo.SALDOINICIAL WITH (NOLOCK)

UNION ALL

SELECT 'tt',
       COUNT(*) AS registros,
       SUM(CASE WHEN CUSTO > 0 THEN 1 ELSE 0 END),
       SUM(CASE WHEN CUSTO = 0 THEN 1 ELSE 0 END)
  FROM tt.SIBD.dbo.SALDOINICIAL WITH (NOLOCK);

select count(*)
  from SALDOINICIAL with (nolock)
 where ANOMES = '202410'
       and CUSTO > 0

select min([DATA])
  from SALDOINICIAL with (nolock)

select ANOMES
       ,count(*)
  from SALDOINICIAL with (nolock)
 where ANOMES >= '202401'
       and CUSTO > 0
 group by ANOMES

select dbo.NFECUSAQU(0, 'N', 1918, 3641, 0, 'NFC', 1)

select dbo.NFECUSAQU(0, 'N', 154095, 2385, 0, 'NFC', 1)



-- 

declare @anomes char(6)	   
	   declare @msg varchar(1000)

set @anomes = '202507'

      set @msg = 'Processa ano/mes: ' + @anomes
      raiserror (@msg, 0, 1) with nowait

      set @msg = 'Tabela temporário de entradas - ' + convert(NVARCHAR, getdate(), 8)
      raiserror (@msg, 0, 1) with nowait

      select str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2) anomes
             ,PROCOD codigo

             -- qtde compra na menor unidade * pre�o unit�rio (sem alguns impostos)
             ,sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) -- valor total do m�s
             /
             case sum(NFEQTD * NFEQTDEMB) when 0 then 1 else sum(NFEQTD * NFEQTDEMB) end as custo -- qtde total do m�s

             ,isnull(sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)),0) as valor
             ,isnull(sum(NFEQTD * NFEQTDEMB),0) as qtde -- qtde total do m�s
             ,str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2)+'01' data
             ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROEMPCOD=0 and TBS010.PROCOD=TBS0591.PROCOD) uni
             ,(select PROUM1QTD from TBS010 with (nolock) where TBS010.PROEMPCOD=0 and TBS010.PROCOD=TBS0591.PROCOD) qemb

        into #TMP
        from TBS0591 (nolock)
			 inner join TBS059 (nolock) on TBS059.NFEEMPCOD=TBS0591.NFEEMPCOD and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
			 inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

       where --TBS059.NFEDATEFE between @dataDe and @dataAte
	         TBS0591.NFEEMPCOD=0
             and convert(char(6),TBS059.NFEDATEFE,112) = @anomes
             and TBS0591.NFETIP='N'
             and TBS059.NFECAN<>'S'
             and FORCGC not in('05118717000156','05118717000237','52080207000117','44125185000136','41952080000162','65069593000198','65069593000279','65069593000350')
             and right(NFECFOP,3) in('102','403','121','202','411')
       group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),PROCOD

select *
  from #TMP
 where codigo = '16280026'

select *
  from TBS0591 with (nolock)
 where NFENUM=1918
       and NFECOD=3641

select *
  from SALDODIARIO with (nolock)
 where PROCOD = '16280026'

select *
  from SALDODIARIO with (nolock)
 where ESTQTDATU is null
 
begin tran
update SALDODIARIO
   set ESTQTDATU = 0
 where ESTQTDATU is null
   
rollback tran
commit tran

begin tran
update SALDODIARIO
   set ESTQTDRES = 0
 where ESTQTDRES is null
   
rollback tran
commit tran

begin tran
update SALDODIARIO
   set ESTQTDPEN = 0
 where ESTQTDPEN is null
   
rollback tran
commit tran

begin tran
update SALDODIARIO
   set ESTQTDCMP = 0
 where ESTQTDCMP is null
   
rollback tran
commit tran

select *
  from SALDODIARIO with (nolock)
 where ESTQTDATU = 0


--

exec sp_help 'SALDODIARIO'

-- Opção 1 – Usando ROW_NUMBER()
-- Aqui, o ROW_NUMBER() vai numerar os registros de cada ESTLOC + PROCOD, ordenando pela data mais recente (ESTDATSAL DESC), e você pega apenas o primeiro (rn = 1).

WITH UltimoSaldo AS (
    SELECT 
        ESTDATSAL,
        PROEMPCOD,
        ESTLOC,
        PROCOD,
        ESTQTDATU,
        ESTQTDRES,
        ESTQTDPEN,
        ESTQTDCMP,
        PRODES,
        PROSTATUS,
        ESTDATALT,
        ROW_NUMBER() OVER (
            PARTITION BY ESTLOC, PROCOD
            ORDER BY ESTDATSAL DESC
        ) AS rn
    FROM SALDODIARIO
)
SELECT *
FROM UltimoSaldo
WHERE rn = 1;

-- Opção 2 – Usando JOIN com MAX(ESTDATSAL)
-- Aqui, primeiro encontra a maior data de cada produto em cada local, e depois faz o join para pegar os dados completos.

SELECT s.*
FROM SALDODIARIO s
INNER JOIN (
    SELECT ESTLOC, PROCOD, MAX(ESTDATSAL) AS UltData
    FROM SALDODIARIO
    GROUP BY ESTLOC, PROCOD
) AS m
    ON s.ESTLOC = m.ESTLOC
   AND s.PROCOD = m.PROCOD
   AND s.ESTDATSAL = m.UltData;

-- Quer que eu já adapte a query para também trazer o saldo atual (ESTQTDATU) total por produto, somando todos os locais

WITH UltimoSaldo AS (
    SELECT 
        ESTDATSAL,
        PROEMPCOD,
        ESTLOC,
        PROCOD,
        ESTQTDATU,
        ESTQTDRES,
        ESTQTDPEN,
        ESTQTDCMP,
        PRODES,
        PROSTATUS,
        ESTDATALT,
        ROW_NUMBER() OVER (
            PARTITION BY ESTLOC, PROCOD
            ORDER BY ESTDATSAL DESC
        ) AS rn
    FROM SALDODIARIO
)
, SaldosTotais AS (
    SELECT PROCOD, SUM(ESTQTDATU) AS TotalSaldo
    FROM UltimoSaldo
    WHERE rn = 1
    GROUP BY PROCOD
)
SELECT 
    u.ESTDATSAL,
    u.PROEMPCOD,
    u.ESTLOC,
    u.PROCOD,
    u.ESTQTDATU,
    u.ESTQTDRES,
    u.ESTQTDPEN,
    u.ESTQTDCMP,
    u.PRODES,
    u.PROSTATUS,
    u.ESTDATALT,
    t.TotalSaldo
FROM UltimoSaldo u
INNER JOIN SaldosTotais t
    ON u.PROCOD = t.PROCOD
WHERE u.rn = 1
ORDER BY u.PROCOD, u.ESTLOC;

-- Opção 1 (com ROW_NUMBER())
-- Aqui, para cada ESTLOC + PROCOD + AnoMês, ele pega o último dia do mês.

WITH UltimoSaldo AS (
    SELECT 
        ESTDATSAL,
        PROEMPCOD,
        ESTLOC,
        PROCOD,
        ESTQTDATU,
        ESTQTDRES,
        ESTQTDPEN,
        ESTQTDCMP,
        PRODES,
        PROSTATUS,
        ESTDATALT,
        ROW_NUMBER() OVER (
            PARTITION BY ESTLOC, PROCOD, CONVERT(CHAR(6), ESTDATSAL, 112)
            ORDER BY ESTDATSAL DESC
        ) AS rn
    FROM SALDODIARIO
)
SELECT *
FROM UltimoSaldo
WHERE rn = 1
ORDER BY PROCOD, ESTLOC, ESTDATSAL;

-- Opção 2 (com MAX(ESTDATSAL))
-- essa versão agrupa por produto + local + AnoMês, pega a maior data daquele mês, e retorna o registro correspondente.

SELECT s.*
FROM SALDODIARIO s
INNER JOIN (
    SELECT 
        ESTLOC, 
        PROCOD, 
        CONVERT(CHAR(6), ESTDATSAL, 112) AS AnoMes,
        MAX(ESTDATSAL) AS UltimaDataMes
    FROM SALDODIARIO
    GROUP BY ESTLOC, PROCOD, CONVERT(CHAR(6), ESTDATSAL, 112)
) AS m
    ON s.ESTLOC = m.ESTLOC
   AND s.PROCOD = m.PROCOD
   AND CONVERT(CHAR(6), s.ESTDATSAL, 112) = m.AnoMes
   AND s.ESTDATSAL = m.UltimaDataMes
   where s.PROCOD = '16280026'
ORDER BY s.PROCOD, s.ESTLOC, s.ESTDATSAL;
