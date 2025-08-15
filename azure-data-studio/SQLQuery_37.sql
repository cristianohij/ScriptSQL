with cte as (
SELECT session_id, t.text
FROM sys.dm_exec_connections c
CROSS APPLY sys.dm_exec_sql_text (c.most_recent_sql_handle) t
where text like 'FETCH API_CURSOR%')
SELECT distinct c.session_id, c.properties, c.creation_time, c.is_open, t.[text]
FROM cte 
cross apply sys.dm_exec_cursors (session_id) c
CROSS APPLY sys.dm_exec_sql_text (c.sql_handle) t