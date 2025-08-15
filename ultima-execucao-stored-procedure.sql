SELECT
 OBJECT_NAME(m.object_id) AS NomeDoObjeto,
 MAX(qs.last_execution_time) AS UltimaExecucao
FROM sys.sql_modules m
LEFT JOIN (sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st)
 ON m.object_id = st.objectid
 AND st.dbid = DB_ID()
WHERE OBJECT_NAME(m.object_id) = 'SP_GravaSaldoInicial'
GROUP BY OBJECT_NAME(m.object_id);