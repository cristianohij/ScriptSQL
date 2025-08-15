select parent_node_id, scheduler_id, cpu_id, status, scheduler_address
  from sys.dm_os_schedulers
  order by scheduler_id

Select * from sys.dm_os_tasks

Select t.task_address, s.text
  From sys.dm_os_tasks as t inner join sys.dm_exec_requests as r
  on t.task_address = r.task_address
  Cross apply sys.dm_exec_sql_text (r.plan_handle) as s
  where r.plan_handle is not null

WITH Waits AS 
  ( 
  SELECT 
  wait_type, 
  wait_time_ms / 1000. AS wait_time_s, 
  100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct, 
  ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn 
  FROM sys.dm_os_wait_stats 
  WHERE wait_type 
  NOT IN 
  ('CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 
  'SLEEP_TASK', 'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 
  'CLR_AUTO_EVENT', 'CLR_MANUAL_EVENT') 
  ) -- Filtro para elimitar Waits irrelevantes para essa analise 
  SELECT W1.wait_type, 
  CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s, 
  CAST(W1.pct AS DECIMAL(12, 2)) AS pct, 
  CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct 
  FROM Waits AS W1 
  INNER JOIN Waits AS W2 ON W2.rn <= W1.rn 
  GROUP BY W1.rn, 
  W1.wait_type, 
  W1.wait_time_s, 
  W1.pct 
  HAVING SUM(W2.pct) - W1.pct < 95; -- Limite de porcentagem

SELECT 
  a.scheduler_id ,
  b.session_id,
   (SELECT TOP 1 SUBSTRING(s2.text,statement_start_offset / 2+1 , 
        ( (CASE WHEN statement_end_offset = -1 
           THEN (LEN(CONVERT(nvarchar(max),s2.text)) * 2) 
           ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement
  FROM sys.dm_os_schedulers a 
  INNER JOIN sys.dm_os_tasks b on a.active_worker_address = b.worker_address
  INNER JOIN sys.dm_exec_requests c on b.task_address = c.task_address
  CROSS APPLY sys.dm_exec_sql_text(c.sql_handle) AS s2 