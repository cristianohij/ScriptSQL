-- manutenção de tabelas no sql server

-- 1. Verificar tamanho da tabela

--exec sp_spaceused 'SALDODIARIO';
exec sp_spaceused 'SALDOINICIAL';

-- 2. Conferir índices existentes

--exec sp_helpindex 'SALDODIARIO';
exec sp_helpindex 'SALDOINICIAL';

-- criar índice clusterizado

-- Cria índice clusterizado na tabela

CREATE CLUSTERED INDEX CIX_SALDODIARIO_EST 
ON dbo.SALDODIARIO (ESTDATSAL, ESTLOC, PROCOD);

-- 3. Detectar índices fragmentados

/*  >30% fragmentação → ALTER INDEX REBUILD.
    5% a 30% → ALTER INDEX REORGANIZE. */

SELECT 
    dbschemas.[name] as 'Schema',
    dbtables.[name] as 'Table',
    dbindexes.[name] as 'Index',
    indexstats.avg_fragmentation_in_percent,
    indexstats.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID('SALDODIARIO'), NULL, NULL, 'LIMITED') AS indexstats
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
    AND indexstats.index_id = dbindexes.index_id
WHERE dbtables.[name] = 'SALDODIARIO'
ORDER BY indexstats.avg_fragmentation_in_percent DESC;

-- 4. Verificar estatísticas desatualizadas

--EXEC sp_autostats 'SALDODIARIO';
EXEC sp_autostats 'SALDOINICIAL';

-- ou

DBCC SHOW_STATISTICS ('SALDODIARIO', NomeDoIndice);

-- Estatísticas velhas podem fazer o otimizador escolher planos ruins.
-- Atualizar:

UPDATE STATISTICS SALDODIARIO WITH FULLSCAN;

-- 5. Procurar índices não utilizados ou faltantes

-- Índices que nunca são usados só deixam UPDATE/INSERT/DELETE mais lentos.
-- Índices com muitos updates e poucos seeks/scans podem ser candidatos à exclusão.

SELECT 
    OBJECT_NAME(dm_ius.[object_id]) AS TableName,
    i.name AS IndexName,
    i.index_id,
    dm_ius.user_seeks,
    dm_ius.user_scans,
    dm_ius.user_lookups,
    dm_ius.user_updates
FROM sys.dm_db_index_usage_stats dm_ius
INNER JOIN sys.indexes i 
    ON i.[object_id] = dm_ius.[object_id]
    AND i.index_id = dm_ius.index_id
WHERE OBJECTPROPERTY(dm_ius.[object_id], 'IsUserTable') = 1
  AND OBJECT_NAME(dm_ius.[object_id]) = 'SALDODIARIO'
ORDER BY (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC;

-- E para sugerir índices que poderiam ajudar:

SELECT 
    mid.statement AS TableName,
    migs.unique_compiles,
    migs.user_seeks,
    migs.avg_total_user_cost,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns
FROM sys.dm_db_missing_index_group_stats migs
JOIN sys.dm_db_missing_index_groups mig ON migs.group_handle = mig.index_group_handle
JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE mid.database_id = DB_ID()
  --AND mid.statement LIKE '%SALDODIARIO%';
  AND mid.statement LIKE '%SALDOINICIAL%';

-- 6. Conferir bloqueios e concorrência

/*
Se houver muitos bloqueios, pode ser necessário:
- Índices melhores (para reduzir lock escalation).
- Particionamento de tabela se for muito grande.
- Row versioning (READ_COMMITTED_SNAPSHOT).
*/

SELECT 
    request_session_id, resource_type, resource_description, request_mode, request_status
FROM sys.dm_tran_locks
WHERE resource_associated_entity_id = OBJECT_ID('SALDODIARIO');

-- 7. Manutenção preventiva

-- Boa prática em tabelas críticas:

ALTER INDEX ALL ON SALDODIARIO REBUILD WITH (FILLFACTOR = 90, ONLINE = ON);
UPDATE STATISTICS SALDODIARIO WITH FULLSCAN;

/*
Resumindo:
- Veja se há índices faltando ou fragmentados.
- Atualize as estatísticas.
- Monitore uso de índices para eliminar os que só atrapalham.
- Avalie bloqueios e concorrência.
- Se a tabela for muito grande, considere particionamento.
*/


-- ajustes

exec sp_help 'dbo.SALDOINICIAL';

SELECT COLUMN_NAME, IS_NULLABLE, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SALDOINICIAL';

-- Garantir que os campos não tenham NULL

ALTER TABLE dbo.SALDOINICIAL
ALTER COLUMN DATA DATE NOT NULL;

ALTER TABLE dbo.SALDOINICIAL
ALTER COLUMN EMPRESA char(2) NOT NULL;

ALTER TABLE dbo.SALDOINICIAL
ALTER COLUMN CODIGO varchar(10) NOT NULL;

-- Definir uma chave primária

ALTER TABLE dbo.SALDOINICIAL
ADD CONSTRAINT PK_SALDOINICIAL
PRIMARY KEY CLUSTERED ([DATA], EMPRESA, CODIGO);


-- criação da tabela SALDOINICIAL

drop table SALDOINICIAL
GO

CREATE TABLE dbo.SALDOINICIAL
(
    [DATA]      DATE        NOT NULL,
    ANOMES      VARCHAR(6)  DEFAULT(''),
    CODIGO      VARCHAR(10) NOT NULL,
    UNI         CHAR(2)     DEFAULT(''),
    QEMBALAGEM  DECIMAL(10,4) DEFAULT(0),
    QTDENTRADA  DECIMAL(10,4) DEFAULT(0),
    VALENTRADA  DECIMAL(10,4) DEFAULT(0),
    CUSTO       DECIMAL(16,6) DEFAULT(0),
    E1          DECIMAL(16,4) DEFAULT(0),
    E2          DECIMAL(16,4) DEFAULT(0),
    E3          DECIMAL(16,4) DEFAULT(0),
    E4          DECIMAL(16,4) DEFAULT(0),
    E5          DECIMAL(16,4) DEFAULT(0),
    E6          DECIMAL(16,4) DEFAULT(0),
    E7          DECIMAL(16,4) DEFAULT(0),
    E8          DECIMAL(16,4) DEFAULT(0),
    E9          DECIMAL(16,4) DEFAULT(0),
    EMPRESA     CHAR(2)     NOT NULL,

    CONSTRAINT PK_SALDOINICIAL PRIMARY KEY CLUSTERED ([DATA], EMPRESA, CODIGO)
);
GO

-- Índices adicionais
CREATE INDEX IX_SALDOINICIAL_CODIGO_DATA 
    ON dbo.SALDOINICIAL (CODIGO, DATA);

CREATE INDEX IX_SALDOINICIAL_ANOMES_CODIGO 
    ON dbo.SALDOINICIAL (ANOMES, CODIGO);
GO

-- ajustes

-- Primeiro soltar a constraint DEFAULT existente
ALTER TABLE dbo.SALDOINICIAL 
DROP CONSTRAINT DF_SALDOINICIAL_UNI;

ALTER TABLE dbo.SALDOINICIAL 
DROP CONSTRAINT DF_SALDOINICIAL_QEMBALAGEM;

-- Alterar a coluna para aceitar NULL
ALTER TABLE dbo.SALDOINICIAL
ALTER COLUMN UNI CHAR(2) COLLATE Latin1_General_BIN NULL;

-- Recriar a constraint DEFAULT
ALTER TABLE dbo.SALDOINICIAL
ADD CONSTRAINT DF_SALDOINICIAL_UNI DEFAULT('') FOR UNI;
