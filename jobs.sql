-- listar trabalhos ativos

SELECT 
    j.job_id, 
    j.name AS NomeDoJob, 
    j.enabled AS Ativo,
    s.name AS Proprietario
FROM msdb.dbo.sysjobs j
INNER JOIN sys.syslogins s ON j.owner_sid = s.sid
WHERE j.enabled = 1 -- Filtra apenas os jobs ativos
ORDER BY j.name;


-- jobs rodando

SELECT  
    j.job_id,  
    j.name AS NomeDoJob,  
    a.start_execution_date AS DataInicio,  
    DATEDIFF(SECOND, a.start_execution_date, GETDATE()) AS SegundosEmExecucao,  
    s.session_id AS SessionID  
FROM msdb.dbo.sysjobs j  
INNER JOIN msdb.dbo.sysjobactivity a ON j.job_id = a.job_id  
LEFT JOIN sys.dm_exec_sessions s ON a.session_id = s.session_id  
WHERE a.start_execution_date IS NOT NULL  
AND a.stop_execution_date IS NULL  
ORDER BY a.start_execution_date DESC;

-- histórico de execuções de jobs

SELECT  
    j.name AS NomeDoJob,  
    h.instance_id AS IDExecucao,  
    h.run_date AS DataExecucao,  
    STUFF(STUFF(RIGHT('000000' + CAST(h.run_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':') AS HoraExecucao,  
    h.run_duration AS DuracaoEmMinutos,  
    CASE h.run_status  
        WHEN 0 THEN 'Falha'  
        WHEN 1 THEN 'Sucesso'  
        WHEN 2 THEN 'Reiniciado'  
        WHEN 3 THEN 'Cancelado'  
        WHEN 4 THEN 'Em andamento'  
    END AS StatusExecucao,  
    h.message AS Mensagem  
FROM msdb.dbo.sysjobhistory h  
INNER JOIN msdb.dbo.sysjobs j ON h.job_id = j.job_id  
--WHERE j.name = 'atualizar produtos (WinPack)'  
ORDER BY h.run_date DESC, h.run_time DESC;

-- id do job

SELECT job_id, name FROM msdb.dbo.sysjobs WHERE name = 'BackupDiario';



-- execução do job

EXEC msdb.dbo.sp_start_job @job_name = 'atualizar produtos (WinPack)';

-- execução pelo id

EXEC msdb.dbo.sp_start_job @job_id = 'ID_DO_JOB';

-- acompanhar o job em execução

SELECT * FROM msdb.dbo.sysjobactivity WHERE session_id = @@SPID;


EXEC msdb.dbo.sp_start_job @job_name = 'Carga Geral de Produtos Para Sistema GZ'