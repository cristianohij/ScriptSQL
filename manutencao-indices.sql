select top 50
       ix.name,
       ix.type_desc,
       vwy.partition_number,
       vw.user_seeks,
       vw.last_user_seek,
       vw.user_scans,
       vw.last_user_scan,
       vw.user_lookups,
       vw.user_updates as 'Total_User_Escrita',
       (vw.user_scans + vw.user_seeks + vw.user_lookups) as 'Total_User_Leitura',
       vw.user_updates - (vw.user_scans + vw.user_seeks + vw.user_lookups) as 'Dif_Read_Write',
       ix.allow_row_locks,
       vwx.row_lock_count,
       row_lock_wait_count,
       row_lock_wait_in_ms,
       ix.allow_page_locks,
       vwx.page_lock_count,
       page_lock_wait_count,
       page_lock_wait_in_ms,
       ix.fill_factor,
       ix.is_padded,
       vwy.avg_fragmentation_in_percent,
       vwy.avg_page_space_used_in_percent,
       ps.in_row_used_page_count as Total_Pagina_Usada,
       ps.in_row_reserved_page_count as Total_Pagina_Reservada,
       convert(real,ps.in_row_used_page_count) * 8192 / 1024 / 1024 as Total_Indice_Usado_MB,
       convert(real,ps.in_row_reserved_page_count) * 8192 / 1024 / 1024 as Total_Indice_Reservado_MB,
       page_io_latch_wait_count,
       page_io_latch_wait_in_ms
  from sys.dm_db_index_usage_stats vw
          join sys.indexes ix
             on ix.index_id = vw.index_id and ix.object_id = vw.object_id
          join sys.dm_db_index_operational_stats(db_id('SIBD'), OBJECT_ID(N'TBS002'), NULL, NULL) vwx
             on vwx.index_id = ix.index_id and ix.object_id = vwx.object_id
          join sys.dm_db_index_physical_stats(db_id('SIBD'), OBJECT_ID(N'TBS002'), NULL, NULL , 'SAMPLED') vwy
             on vwy.index_id = ix.index_id and ix.object_id = vwy.object_id and vwy.partition_number = vwx.partition_number
          join sys.dm_db_partition_stats PS
             on ps.index_id = vw.index_id and ps.object_id = vw.object_id
 where vw.database_id = db_id('SIBD') AND object_name(vw.object_id) = 'TBS002'
 order by user_seeks desc, user_scans desc
 

-- REBUILD: Reconstrói todos
-- REORGANIZE: Remove a fragmentação apenas

-- Recomendação: Devemos usar REBUILD quando a fragmentação do índice estiver acima de 40% e utilizar REORGANIZE quando a fragmentação estiver entre 10% a 40%
 
SELECT a.index_id,
       name,
       avg_fragmentation_in_percent,
       fragment_count,avg_fragment_size_in_pages
  FROM sys.dm_db_index_physical_stats (DB_ID(N'SIBD'), OBJECT_ID(N'TBS001'), NULL, NULL, NULL) AS a
       JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id;


SELECT getdate(), @@servername,  db_name(db_id()), object_name(B.Object_id), B.Name,  avg_fragmentation_in_percent,page_Count,fill_factor
FROM sys.dm_db_index_physical_stats(db_id(),null,null,null,null) A
join sys.indexes B on a.object_id = B.Object_id and A.index_id = B.index_id
ORDER BY object_name(B.Object_id), B.index_id

declare @Dt_Referencia datetime
set @Dt_Referencia = cast(floor(cast( getdate() as float)) as datetime)

SELECT Nm_Servidor, Nm_Database, Nm_Tabela, Nm_Indice, Avg_Fragmentation_In_Percent, Page_Count, Fill_Factor
FROM Hitorico_Fragmentacao_Indice (nolock)
WHERE Avg_Fragmentation_In_Percent > 5
AND page_count > 1000
AND Dt_Referencia >= @Dt_Referencia


-- Listagem 3. Tabelas que mais seriam beneficiadas com novos índices

SELECT TOP 15 AVG((avg_total_user_cost * avg_user_impact * (user_seeks + user_scans))) as Impacto,mid.object_id,
              mid.statement as Tabela
  FROM sys.dm_db_missing_index_group_stats AS migs
       JOIN sys.dm_db_missing_index_groups AS mig ON migs.group_handle = mig.index_group_handle JOIN sys.dm_db_missing_index_details AS mid
       ON mig.index_handle = mid.index_handle and database_id = db_id('SIBD') GROUP BY mid.object_id, mid.statement ORDER BY Impacto DESC;
       
-- Listagem 4. Top 15 índices, sugeridos pelo SGBD.

SELECT --TOP 15
       (avg_total_user_cost * avg_user_impact * (user_seeks + user_scans)) as Impacto,
       migs.group_handle,
       mid.index_handle,
       migs.user_seeks,
       migs.user_scans,
       mid.object_id,
       mid.statement,
       mid.equality_columns,
       mid.inequality_columns,
       mid.included_columns
  FROM sys.dm_db_missing_index_group_stats AS migs
       JOIN sys.dm_db_missing_index_groups AS mig ON migs.group_handle = mig.index_group_handle JOIN sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle and database_id = db_id('SIBD') -- and mid.object_id = object_id('tabela') — se desejar ver apenas para uma tabela específica
 order by statement;      

-- Listagem 5. Índices nunca utilizados pelo SGBD.

select tb.name as Table_Name,
       ix.name as Index_Name,
       ix.type_desc,
       leaf_insert_count,
       leaf_delete_count,
       leaf_update_count,
       nonleaf_insert_count,
       nonleaf_delete_count,
       nonleaf_update_count
  from sys.dm_db_index_usage_stats vw join sys.objects tb on tb.object_id = vw.object_id join sys.indexes ix on ix.index_id = vw.index_id and ix.object_id = tb.object_id
       join sys.dm_db_index_operational_stats(db_id('SIBD'), Null, NULL, NULL) vwx on vwx.object_id = tb.object_id and vwx.index_id = ix.index_id where vw.database_id = db_id('SIBD')
       and vw.user_seeks = 0 and vw.user_scans = 0 and vw.user_lookups = 0 and vw.system_seeks = 0 and vw.system_scans = 0
       and vw.system_lookups = 0 Order By leaf_insert_count desc, tb.name asc, ix.name asc

-- Listagem 6. Avaliando índices.

select ix.name,
       ix.type_desc,
       vwy.partition_number,
       vw.user_seeks,
       vw.last_user_seek,
       vw.user_scans,
       vw.last_user_scan,
       vw.user_lookups,
       vw.user_updates as 'Total_User_Escrita',
       (vw.user_scans + vw.user_seeks + vw.user_lookups) as 'Total_User_Leitura',
       vw.user_updates - (vw.user_scans + vw.user_seeks + vw.user_lookups) as 'Dif_Read_Write',
       ix.allow_row_locks,
       vwx.row_lock_count,
       row_lock_wait_count,
       row_lock_wait_in_ms,
       ix.allow_page_locks,
       vwx.page_lock_count,
       page_lock_wait_count,
       page_lock_wait_in_ms,
       ix.fill_factor,
       ix.is_padded,
       vwy.avg_fragmentation_in_percent,
       vwy.avg_page_space_used_in_percent,
       ps.in_row_used_page_count as Total_Pagina_Usada,
       ps.in_row_reserved_page_count as Total_Pagina_Reservada,
       convert(real,ps.in_row_used_page_count) * 8192 / 1024 / 1024 as Total_Indice_Usado_MB,
       convert(real,ps.in_row_reserved_page_count) * 8192 / 1024 / 1024 as Total_Indice_Reservado_MB,
       page_io_latch_wait_count,
       page_io_latch_wait_in_ms
  from sys.dm_db_index_usage_stats vw
       join sys.indexes ix on ix.index_id = vw.index_id and ix.object_id = vw.object_id
       join sys.dm_db_index_operational_stats(db_id('SIBD'), OBJECT_ID(N'TBS002'), NULL, NULL) vwx on vwx.index_id = ix.index_id and ix.object_id = vwx.object_id
       join sys.dm_db_index_physical_stats(db_id('SIBD'), OBJECT_ID(N'TBS002'), NULL, NULL , 'SAMPLED') vwy
       on vwy.index_id = ix.index_id and ix.object_id = vwy.object_id and vwy.partition_number = vwx.partition_number
       join sys.dm_db_partition_stats PS on ps.index_id = vw.index_id and ps.object_id = vw.object_id
 where vw.database_id = db_id('SIBD') AND object_name(vw.object_id) = 'Log'
 order by user_seeks desc, user_scans desc

-- Listagem 7. Tabelas com maior quantidade de índices

select x.id, x.table_name, x.Total_index, count(*) as Total_column
from sys.columns cl join
(select ix.object_id as id, tb.name as table_name, count(ix.object_id) as Total_index
from sys.indexes ix join sys.objects tb on tb.object_id = ix.object_id and tb.type = 'u'
group by ix.object_id, tb.name) x on x.id = cl.object_id
group by id, table_name, Total_index
order by 3 desc

-- Listagem 8. Consultas que mais consomem processamento do servidor

SELECT --TOP 10
(total_worker_time/execution_count) / 1000 AS [Avg CPU Time ms], SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset
WHEN -1 THEN DATALENGTH(st.text)ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2) + 1) AS statement_text,
execution_count,last_execution_time,
last_worker_time / 1000 as last_worker_time,
min_worker_time / 1000 as min_worker_time,
max_worker_time / 1000 as max_worker_time,
total_physical_reads,last_physical_reads,
min_physical_reads, max_physical_reads,
total_logical_writes,last_logical_writes,
min_logical_writes, max_logical_writes, query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_text_query_plan(qs.plan_handle, DEFAULT, DEFAULT) AS qp
ORDER BY 1 DESC;



-- Identificando a fragmentação dos índices

SELECT
    OBJECT_NAME(B.object_id) AS TableName,
    B.name AS IndexName,
    A.index_type_desc AS IndexType,
    A.avg_fragmentation_in_percent
FROM
    sys.dm_db_index_physical_stats(DB_ID('SIBD'), NULL, NULL, NULL, 'LIMITED')	A
    INNER JOIN sys.indexes							B	WITH(NOLOCK) ON B.object_id = A.object_id AND B.index_id = A.index_id
WHERE
    A.avg_fragmentation_in_percent > 30
    AND OBJECT_NAME(B.object_id) NOT LIKE '[_]%'
    AND A.index_type_desc != 'HEAP'
ORDER BY
    A.avg_fragmentation_in_percent DESC
    

-- Verificar a utilização dos índices

SELECT
    ObjectName = OBJECT_SCHEMA_NAME(idx.object_id) + '.' + OBJECT_NAME(idx.object_id),
    IndexName = idx.name,
    IndexType = CASE WHEN is_unique = 1 THEN 'UNIQUE ' ELSE '' END + idx.type_desc,
    User_Seeks = us.user_seeks,
    User_Scans = us.user_scans,
    User_Lookups = us.user_lookups,
    User_Updates = us.user_updates
FROM
    sys.indexes idx
    LEFT JOIN sys.dm_db_index_usage_stats us ON idx.object_id = us.object_id AND idx.index_id = us.index_id AND us.database_id = DB_ID('sibd')
WHERE
    OBJECT_SCHEMA_NAME(idx.object_id) != 'sys'
ORDER BY
    us.user_seeks + us.user_scans + us.user_lookups DESC
    

-- Ajudando a identificar o melhor candidato a índice clustered

SELECT
    TableName = OBJECT_NAME(idx.object_id),
    NonUsefulClusteredIndex = idx.name,
    ShouldBeClustered = nc.nonclusteredname,
    Clustered_User_Seeks = c.user_seeks,
    NonClustered_User_Seeks = nc.user_seeks,
    Clustered_User_Lookups = c.user_lookups,
    DatabaseName = DB_NAME(c.database_id)
FROM
    sys.indexes idx
    LEFT JOIN sys.dm_db_index_usage_stats c ON idx.object_id = c.object_id AND idx.index_id = c.index_id
    JOIN (
           SELECT
                idx.object_id,
                nonclusteredname = idx.name,
                ius.user_seeks
           FROM
                sys.indexes idx
                JOIN sys.dm_db_index_usage_stats ius ON idx.object_id = ius.object_id AND idx.index_id = ius.index_id
           WHERE
                idx.type_desc = 'nonclustered' AND ius.user_seeks = (
                                                                  SELECT
                                                                    MAX(user_seeks)
                                                                  FROM
                                                                    sys.dm_db_index_usage_stats
                                                                  WHERE
                                                                    object_id = ius.object_id AND type_desc = 'nonclustered'
                                                                )
           GROUP BY
                idx.object_id,
                idx.name,
                ius.user_seeks
         ) nc ON nc.object_id = idx.object_id
WHERE
    idx.type_desc IN ( 'clustered', 'heap' )
    AND nc.user_seeks > ( c.user_seeks * 1.50 ) -- 150%
    AND nc.user_seeks >= ( c.user_lookups * 0.75 ) -- 75%
ORDER BY
    nc.user_seeks DESC