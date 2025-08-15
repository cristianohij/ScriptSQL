USE msdb;
GO

SELECT job.job_id, job.name AS 'Nome do Trabalho', job.enabled, job.description AS 'Descrição',
       CONVERT(DATETIME, RTRIM(jobSchedules.next_run_date)) + 
       CONVERT(DATETIME, STUFF(STUFF(RIGHT('000000' + RTRIM(jobSchedules.next_run_time), 6), 5, 0, ':'), 3, 0, ':'), 120) AS 'Próxima Execução',
       job.date_created, job.date_modified
FROM msdb.dbo.sysjobs job
JOIN msdb.dbo.sysjobschedules jobSchedules ON job.job_id = jobSchedules.job_id
WHERE CONVERT(TIME, STUFF(STUFF(RIGHT('000000' + RTRIM(jobSchedules.next_run_time), 6), 5, 0, ':'), 3, 0, ':')) BETWEEN '10:00' AND '11:30'
ORDER BY job.name;



USE msdb;
GO

DECLARE @JobName NVARCHAR(128);
DECLARE jobCursor CURSOR FOR
    SELECT job.name
    FROM msdb.dbo.sysjobs job
    JOIN msdb.dbo.sysjobschedules jobSchedules ON job.job_id = jobSchedules.job_id
    WHERE CONVERT(TIME, STUFF(STUFF(RIGHT('000000' + RTRIM(jobSchedules.next_run_time), 6), 5, 0, ':'), 3, 0, ':')) BETWEEN '10:00' AND '11:30'
    AND job.description LIKE 'Este trabalho pertence a um processo do servidor de relatório%'
    ORDER BY job.name;

OPEN jobCursor;
FETCH NEXT FROM jobCursor INTO @JobName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Iniciar o trabalho
    EXEC msdb.dbo.sp_start_job @JobName;

    FETCH NEXT FROM jobCursor INTO @JobName;
END

CLOSE jobCursor;
DEALLOCATE jobCursor;
