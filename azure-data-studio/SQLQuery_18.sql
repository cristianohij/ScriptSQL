USE msdb ;  
GO  
  
EXEC dbo.sp_help_job ;  
GO  

SELECT sj.name
  FROM msdb..sysjobactivity aj
  JOIN msdb..sysjobs sj
    on sj.job_id = aj.job_id
 WHERE aj.stop_execution_date  IS NULL     -- job hasn't stopped running
   AND aj.start_execution_date IS NOT NULL -- job is currently running
   --AND sj.name = '<your Job Name>'
   AND NOT EXISTS( -- make sure this is the most recent run
                   select 1
                     from msdb..sysjobactivity new
                    where new.job_id = aj.job_id
                      and new.start_execution_date > aj.start_execution_date )

SELECT name AS [Job Name]
         ,CONVERT(VARCHAR,DATEADD(S,(run_time/10000)*60*60 /* hours */ 
          +((run_time - (run_time/10000) * 10000)/100) * 60 /* mins */ 
          + (run_time - (run_time/100) * 100)  /* secs */
           ,CONVERT(DATETIME,RTRIM(run_date),113)),100) AS [Time Run]
         ,CASE WHEN enabled=1 THEN 'Enabled' 
               ELSE 'Disabled' 
          END [Job Status]
         ,CASE WHEN SJH.run_status=0 THEN 'Failed'
                     WHEN SJH.run_status=1 THEN 'Succeeded'
                     WHEN SJH.run_status=2 THEN 'Retry'
                     WHEN SJH.run_status=3 THEN 'Cancelled'
               ELSE 'Unknown' 
          END [Job Outcome]
FROM   sysjobhistory SJH 
JOIN   sysjobs SJ 
ON     SJH.job_id=sj.job_id 
WHERE  step_id=0 
AND    DATEADD(S, 
  (run_time/10000)*60*60 /* hours */ 
  +((run_time - (run_time/10000) * 10000)/100) * 60 /* mins */ 
  + (run_time - (run_time/100) * 100)  /* secs */, 
  CONVERT(DATETIME,RTRIM(run_date),113)) >= DATEADD(d,-1,GetDate()) 
ORDER BY name,run_date,run_time 

exec msdb.dbo.sp_help_job @execution_status=1






