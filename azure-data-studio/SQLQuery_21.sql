select *
  from TBS004 with (nolock)
 where GVECOD=2

select *
  from TBS080 with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFSIT=6
       and ENFVENCOD in(select VENCOD
                          from TBS004 with (nolock)
                         where GVECOD=2)
       and SNESER=1

select ENFVENCOD
       ,sum(ENFVALTOT)
  from TBS080 with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFSIT=6
       and ENFVENCOD in(select VENCOD
                          from TBS004 with (nolock)
                         where GVECOD=2)
       and SNESER=1
 group by ENFVENCOD

select ENFVENCOD
       ,sum(ENFVALTOT)
  from TBS080 with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFSIT=6
       and ENFVENCOD not in(select VENCOD
                              from TBS004 with (nolock)
                             where GVECOD=2)
       and SNESER=3
 --group by ENFVENCOD
GROUP BY ROLLUP(ENFVENCOD)
 
select sum(ENFVALTOT)
  from TBS080 with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFSIT=6
       and ENFVENCOD not in(select VENCOD
                          from TBS004 with (nolock)
                         where GVECOD=2)
       and SNESER=3

select *
  from TBS059 with (nolock)
 where NFENUM=9965  

select *
  from TBS059 with (nolock)
 where NFEDATEFE between '20220501' and '20220531'
       and NFECAN='N'
       and NFETIP='D'
	   and NFENUM=9965  

select *
  from TBS0596
 where NFENUM=9965

 NFSTOTLIQ(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint)

-- notas do televendas na loja

select ENFVENCOD
       ,sum(ENFVALTOT)
  from TBS080 with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFSIT in (6)
       and ENFVENCOD not in(select VENCOD
                              from TBS004 with (nolock)
                             where GVECOD=2)
       and SNESER=3
 --group by ENFVENCOD
GROUP BY ROLLUP(ENFVENCOD)


SELECT * FROM TBS045PDCINC

SELECT top(100) * 
FROM SIBD.dbo.TBS045AUX (nolock)
order by PDCINC desc

select *
  from TMP022 with (nolock)
 where T22_REGISTRO=2766

begin tran 
update TMP022
   set T22_APLICATIVO=1
 where T22_REGISTRO=2766

rollback tran
commit tran

SELECT A.NAME, A.TYPE, B.TEXT
  FROM SYSOBJECTS  A (nolock)
  JOIN SYSCOMMENTS B (nolock) 
    ON A.ID = B.ID
WHERE B.TEXT LIKE '%PDCINC%'  --- Informação a ser procurada no corpo da procedure, funcao ou view
  AND A.TYPE = 'P'                     --- Tipo de objeto a ser localizado no caso procedure
 ORDER BY A.NAME

USE [CLR]
GO

CREATE PROCEDURE [dbo].[stpBusca_String_Job] ( @String VARCHAR(100) )
AS BEGIN

	SELECT
		[sJOB].[name] AS [JobName] ,
		CASE [sJOB].[enabled]
		  WHEN 1 THEN 'Yes'
		  WHEN 0 THEN 'No'
		END AS [IsEnabled] ,
		[sJOB].[date_created] AS [JobCreatedOn] ,
		[sJOB].[date_modified] AS [JobLastModifiedOn] ,
		[sJSTP].[step_id] AS [StepNo] ,
		[sJSTP].[step_name] AS [StepName] ,
		[sDBP].[name] AS [JobOwner] ,
		[sCAT].[name] AS [JobCategory] ,
		[sJOB].[description] AS [JobDescription] ,
		CASE [sJSTP].[subsystem]
		  WHEN 'ActiveScripting' THEN 'ActiveX Script'
		  WHEN 'CmdExec' THEN 'Operating system (CmdExec)'
		  WHEN 'PowerShell' THEN 'PowerShell'
		  WHEN 'Distribution' THEN 'Replication Distributor'
		  WHEN 'Merge' THEN 'Replication Merge'
		  WHEN 'QueueReader' THEN 'Replication Queue Reader'
		  WHEN 'Snapshot' THEN 'Replication Snapshot'
		  WHEN 'LogReader' THEN 'Replication Transaction-Log Reader'
		  WHEN 'ANALYSISCOMMAND' THEN 'SQL Server Analysis Services Command'
		  WHEN 'ANALYSISQUERY' THEN 'SQL Server Analysis Services Query'
		  WHEN 'SSIS' THEN 'SQL Server Integration Services Package'
		  WHEN 'TSQL' THEN 'Transact-SQL script (T-SQL)'
		  ELSE sJSTP.subsystem
		END AS [StepType] ,
		[sPROX].[name] AS [RunAs] ,
		[sJSTP].[database_name] AS [Database] ,
		[sJSTP].[command] AS [ExecutableCommand] ,
		CASE [sJSTP].[on_success_action]
		  WHEN 1 THEN 'Quit the job reporting success'
		  WHEN 2 THEN 'Quit the job reporting failure'
		  WHEN 3 THEN 'Go to the next step'
		  WHEN 4 THEN 'Go to Step: ' + QUOTENAME(CAST([sJSTP].[on_success_step_id] AS VARCHAR(3))) + ' ' + [sOSSTP].[step_name]
		END AS [OnSuccessAction] ,
		[sJSTP].[retry_attempts] AS [RetryAttempts] ,
		[sJSTP].[retry_interval] AS [RetryInterval (Minutes)] ,
		CASE [sJSTP].[on_fail_action]
		  WHEN 1 THEN 'Quit the job reporting success'
		  WHEN 2 THEN 'Quit the job reporting failure'
		  WHEN 3 THEN 'Go to the next step'
		  WHEN 4 THEN 'Go to Step: ' + QUOTENAME(CAST([sJSTP].[on_fail_step_id] AS VARCHAR(3))) + ' ' + [sOFSTP].[step_name]
		END AS [OnFailureAction],
		CASE
			WHEN [sSCH].[schedule_uid] IS NULL THEN 'No'
			ELSE 'Yes'
		  END AS [IsScheduled],
		[sSCH].[name] AS [JobScheduleName],
		CASE [sJOB].[delete_level]
			WHEN 0 THEN 'Never'
			WHEN 1 THEN 'On Success'
			WHEN 2 THEN 'On Failure'
			WHEN 3 THEN 'On Completion'
		  END AS [JobDeletionCriterion]
	FROM
		[msdb].[dbo].[sysjobsteps] AS [sJSTP]
		INNER JOIN [msdb].[dbo].[sysjobs] AS [sJOB] ON [sJSTP].[job_id] = [sJOB].[job_id]
		LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOSSTP] ON [sJSTP].[job_id] = [sOSSTP].[job_id] AND [sJSTP].[on_success_step_id] = [sOSSTP].[step_id]
		LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOFSTP] ON [sJSTP].[job_id] = [sOFSTP].[job_id] AND [sJSTP].[on_fail_step_id] = [sOFSTP].[step_id]
		LEFT JOIN [msdb].[dbo].[sysproxies] AS [sPROX] ON [sJSTP].[proxy_id] = [sPROX].[proxy_id]
		LEFT JOIN [msdb].[dbo].[syscategories] AS [sCAT] ON [sJOB].[category_id] = [sCAT].[category_id]
		LEFT JOIN [msdb].[sys].[database_principals] AS [sDBP] ON [sJOB].[owner_sid] = [sDBP].[sid]
		LEFT JOIN [msdb].[dbo].[sysjobschedules] AS [sJOBSCH] ON [sJOB].[job_id] = [sJOBSCH].[job_id]
		LEFT JOIN [msdb].[dbo].[sysschedules] AS [sSCH] ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id]
	WHERE
		[sJSTP].[command] LIKE '%' + @String + '%'
		OR [sJOB].[name] LIKE '%' + @String + '%'
	ORDER BY
		[JobName] ,
		[StepNo]
		
END

EXEC dbo.stpBusca_String_Job 'movcaixagz' -- Imprime na tela uma lista com todos os jobs ou steps que contenham a palavra 'Importa' no nome ou código-fonte do step.


SELECT  name, parent_id, create_date, modify_date, is_instead_of_trigger  
FROM sys.triggers  
WHERE type = 'TR'

SELECT object_id, type, type_desc, is_trigger_event, event_group_type, event_group_type_desc   
FROM sys.events  
WHERE object_id = OBJECT_ID('trg_baixaTBS0451'); 

SELECT OBJECT_NAME(referencing_id) AS referencing_entity_name,   
    o.type_desc AS referencing_desciption,   
    COALESCE(COL_NAME(referencing_id, referencing_minor_id), '(n/a)') AS referencing_minor_id,   
    referencing_class_desc, referenced_class_desc,   
    referenced_server_name, referenced_database_name, referenced_schema_name,   
    referenced_entity_name,   
    COALESCE(COL_NAME(referenced_id, referenced_minor_id), '(n/a)') AS referenced_column_name,   
    is_caller_dependent, is_ambiguous  
FROM sys.sql_expression_dependencies AS sed  
INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id  
WHERE referencing_id = OBJECT_ID(N'trg_baixaTBS0451')

select *
  from TBS067 with (nolock)
 where NFSNUM=57740

select *
  from movcaixagz 
 where numeronf=0

select *
  from TBS0674 with (nolock)
 where NFSNUM=57740





