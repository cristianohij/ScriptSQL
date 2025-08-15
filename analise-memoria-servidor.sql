select counter_name ,cntr_value,cast((cntr_value/1024.0)/1024.0 as numeric(8,2)) as Gb
from sys.dm_os_performance_counters
where counter_name like '%server_memory%';

SELECT cntr_value AS 'Page Life Expectancy'
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Page life expectancy'

SELECT  type, SUM(single_pages_kb)/1024. AS [SPA Mem, MB],SUM(Multi_pages_kb)/1024. AS [MPA Mem,MB] FROM sys.dm_os_memory_clerks
GROUP BY type
HAVING  SUM(single_pages_kb) + sum(Multi_pages_kb)  > 40000
ORDER BY SUM(single_pages_kb) DESC

SELECT  SUM(single_pages_kb)/1024. AS [SPA Mem, KB],SUM(Multi_pages_kb)/1024. AS [MPA Mem, KB] FROM sys.dm_os_memory_clerks

sp_configure 'min server memory (MB)'
go
sp_configure 'max server memory (MB)';

SELECT
CASE WHEN database_id = 32767 THEN 'ResourceDB' ELSE DB_NAME(database_id) END AS DatabaseName,
COUNT(*) AS cached_pages,
(COUNT(*) * 8.0) / 1024 AS MBsInBufferPool
FROM
sys.dm_os_buffer_descriptors
GROUP BY
database_id
ORDER BY
MBsInBufferPool DESC
GO