SELECT
    A.job_id,
    C.name AS job_name,
    E.name AS job_category,
    C.[enabled],
    C.[description],
    A.start_execution_date,
    A.last_executed_step_date,
    A.next_scheduled_run_date,
    CONVERT(VARCHAR, CONVERT(VARCHAR, DATEADD(SECOND, ( DATEDIFF(SECOND, A.start_execution_date, GETDATE()) % 86400 ), 0), 114)) AS time_elapsed,
    ISNULL(A.last_executed_step_id, 0) + 1 AS current_executed_step_id,
    D.step_name
FROM
    msdb.dbo.sysjobactivity                 A   WITH(NOLOCK)
    LEFT JOIN msdb.dbo.sysjobhistory        B   WITH(NOLOCK)    ON  A.job_history_id = B.instance_id
    JOIN msdb.dbo.sysjobs                   C   WITH(NOLOCK)    ON  A.job_id = C.job_id
    JOIN msdb.dbo.sysjobsteps               D   WITH(NOLOCK)    ON  A.job_id = D.job_id AND ISNULL(A.last_executed_step_id, 0) + 1 = D.step_id
    JOIN msdb.dbo.syscategories             E   WITH(NOLOCK)    ON  C.category_id = E.category_id
WHERE
    A.session_id = ( SELECT TOP 1 session_id FROM msdb.dbo.syssessions	WITH(NOLOCK) ORDER BY agent_start_date DESC ) 
    AND A.start_execution_date IS NOT NULL 
    AND A.stop_execution_date IS NULL

---


IF (OBJECT_ID('tempdb..#Retorno') IS NOT NULL) DROP TABLE #Retorno
CREATE TABLE #Retorno (
    Job_Id UNIQUEIDENTIFIER,
    Last_Run_Date INT,
    Last_Run_Time INT,
    Next_Run_Date INT,
    Next_Run_Time INT,
    Next_Run_Schedule_ID INT,
    Requested_To_Run INT,
    Request_Source INT,
    Request_Source_ID VARCHAR(MAX),
    Running BIT,
    Current_Step INT,
    Current_Retry_Attempt INT,
    [State] SMALLINT
)	
    
INSERT INTO #Retorno
EXEC master.dbo.xp_sqlagent_enum_jobs 1, ''


IF (OBJECT_ID('tempdb..#Resultado') IS NOT NULL) DROP TABLE #Resultado
SELECT
    Job_Id,
    (CASE WHEN Last_Run_Date > 0 THEN msdb.dbo.agent_datetime(Last_Run_Date, Last_Run_Time) END) AS Dt_Ultima_Execucao,
    (CASE WHEN Next_Run_Date > 0 THEN msdb.dbo.agent_datetime(Next_Run_Date, Next_Run_Time) END) AS Dt_Proxima_Execucao,
    Next_Run_Schedule_ID,
    Requested_To_Run,
    Request_Source,
    Request_Source_ID,
    Running,
    Current_Step,
    Current_Retry_Attempt,
    State
INTO
    #Resultado
FROM
    #Retorno
--WHERE
--    Running = 1 -- Em Execução
    
    
SELECT * FROM #Resultado



---


select convert(datetime, rtrim(run_date))
+ ((run_time/10000 * 3600)
+ ((run_time%10000)/100*60)
+ (run_time%10000)%100) / (86399.9964 ) as run_datetime
, name,run_duration
from msdb..sysjobhistory a,msdb..sysjobs b
where a.job_id=b.job_id and step_id=0
order by run_datetime desc


select * from msdb.dbo.sysjobactivity 

EXEC master.dbo.xp_sqlagent_enum_jobs 1, ''







drop procedure sp_get_SQL_job_execution_status
	go

	create procedure sp_get_SQL_job_execution_status
	(
		@job_name sysname
		, @select_data int =0
		, @execution_status int =null output
	
	)
	as

	set nocount on


	/*
		Is the execution status for the jobs. 
		Value Description 
		0 Returns only those jobs that are not idle or suspended.  
		1 Executing. 
		2 Waiting for thread. 
		3 Between retries. 
		4 Idle. 
		5 Suspended. 
		7 Performing completion actions 

	*/
	
	declare	@job_id UNIQUEIDENTIFIER 
		, @is_sysadmin INT
		, @job_owner   sysname

	select @job_id = job_id from msdb..sysjobs_view where name = @job_name 
	select @is_sysadmin = ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0)
	select @job_owner = SUSER_SNAME()

	CREATE TABLE #xp_results (job_id                UNIQUEIDENTIFIER NOT NULL,
	                            last_run_date         INT              NOT NULL,
	                            last_run_time         INT              NOT NULL,
	                            next_run_date         INT              NOT NULL,
	                            next_run_time         INT              NOT NULL,
	                            next_run_schedule_id  INT              NOT NULL,
	                            requested_to_run      INT              NOT NULL, -- BOOL
	                            request_source        INT              NOT NULL,
	                            request_source_id     sysname          COLLATE database_default NULL,
	                            running               INT              NOT NULL, -- BOOL
	                            current_step          INT              NOT NULL,
	                            current_retry_attempt INT              NOT NULL,
	                            job_state             INT              NOT NULL)


	IF ((@@microsoftversion / 0x01000000) >= 8) -- SQL Server 8.0 or greater
		    INSERT INTO #xp_results
		    EXECUTE master.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @job_owner, @job_id
  	ELSE
		    INSERT INTO #xp_results
		    EXECUTE master.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @job_owner


	--declare @execution_status int
	set @execution_status = (select job_state from #xp_results)

	drop table #xp_results

	if @select_data =1 
		select @job_name as 'job_name', @execution_status as 'execution_status'

	set nocount off


exec sp_get_SQL_job_execution_status 'Saldo Taubaté',1


---

IF EXISTS (SELECT *
FROM	tempdb.dbo.sysobjects
WHERE   id = OBJECT_ID(N'[tempdb].[dbo].[Temp1]')
)
DROP TABLE [tempdb].[dbo].[Temp1]
GO
CREATE TABLE [tempdb].[dbo].[Temp1]
(
job_id uniqueidentifier NOT NULL,
last_run_date nvarchar (20) NOT NULL,
last_run_time nvarchar (20) NOT NULL,
next_run_date nvarchar (20) NOT NULL,
next_run_time nvarchar (20) NOT NULL,
next_run_schedule_id INT NOT NULL,
requested_to_run INT NOT NULL,
request_source INT NOT NULL,
request_source_id sysname
COLLATE database_default NULL,
running INT NOT NULL,
current_step INT NOT NULL,
current_retry_attempt INT NOT NULL,
job_state INT NOT NULL)
DECLARE @job_owner   sysname
DECLARE @is_sysadmin   INT
SET @is_sysadmin   = isnull (is_srvrolemember ('sysadmin'), 0)
SET @job_owner   = suser_sname ()
INSERT INTO [tempdb].[dbo].[Temp1]
 
--EXECUTE sys.xp_sqlagent_enum_jobs @is_sysadmin, @job_owner
EXECUTE master.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @job_owner
UPDATE [tempdb].[dbo].[Temp1]
SET last_run_time	= right ('000000' + last_run_time, 6),
next_run_time	= right ('000000' + next_run_time, 6);
-----
SELECT j.name AS JobName,
j.enabled AS Enabled,
next_run_time,
CASE x.running
WHEN 1
THEN
'Running'
ELSE
CASE h.run_status
WHEN 2 THEN 'Inactive'
WHEN 4 THEN 'Inactive'
ELSE 'Completed'
END
END
AS CurrentStatus,
coalesce (x.current_step, 0) AS CurrentStepNbr,
CASE
WHEN x.last_run_date > 0
THEN
convert (datetime,
substring (x.last_run_date, 1, 4)
+ '-'
+ substring (x.last_run_date, 5, 2)
+ '-'
+ substring (x.last_run_date, 7, 2)
+ ' '
+ substring (x.last_run_time, 1, 2)
+ ':'
+ substring (x.last_run_time, 3, 2)
+ ':'
+ substring (x.last_run_time, 5, 2)
+ '.000',
121
)
ELSE
NULL
END
AS LastRunTime,
CASE h.run_status
WHEN 0 THEN 'Fail'
WHEN 1 THEN 'Success'
WHEN 2 THEN 'Retry'
WHEN 3 THEN 'Cancel'
WHEN 4 THEN 'In progress'
END
AS LastRunOutcome,
h.run_duration,
stuff(stuff(replace(str(run_duration,6,0),' ','0'),3,0,':'),6,0,':'),
CASE
WHEN h.run_duration > 0
THEN
(h.run_duration / 1000000) * (3600 * 24)
+ (h.run_duration / 10000 % 100) * 3600
+ (h.run_duration / 100 % 100) * 60
+ (h.run_duration % 100)
ELSE
NULL
END
AS LastRunDuration
FROM		  [tempdb].[dbo].[Temp1] x
LEFT JOIN
msdb.dbo.sysjobs j
ON x.job_id = j.job_id
LEFT OUTER JOIN
msdb.dbo.syscategories c
ON j.category_id = c.category_id
LEFT OUTER JOIN
msdb.dbo.sysjobhistory h
ON	 x.job_id = h.job_id
AND x.last_run_date = h.run_date
AND x.last_run_time = h.run_time
AND h.step_id = 0
where Enabled=1
--where x.running = 1
order by next_run_time




SET NOCOUNT ON;

SELECT sj.name,
       sh.run_date,
       sh.step_name,
       STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(sh.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') 'run_time'--,
       STUFF(STUFF(STUFF(RIGHT(REPLICATE('0', 8) + CAST(sh.run_duration as varchar(8)), 8), 3, 0, ':'), 6, 0, ':'), 9, 0, ':') 'run_duration (DD:HH:MM:SS)  '
FROM msdb.dbo.sysjobs sj
JOIN msdb.dbo.sysjobhistory sh
ON sj.job_id = sh.job_id


SELECT stuff(stuff(replace(str(run_duration,6,0),' ','0'),3,0,':'),6,0,':') FROM msdb.dbo.sysjobhistory 
