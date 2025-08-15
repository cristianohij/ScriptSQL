select * from TBS010 (nolock) where PROSTATUS='I' order by PROCOD

select * from TBS032 (nolock)

select top 1 * from TBS034 (nolock)

select * from TBS032 (nolock) where PROCOD='0010001'

begin tran
delete TBS032 where ESTLOC=7 and PROCOD='0010001'
rollback tran
commit tran

begin tran
insert into TBS032 (ESTLOC,PROCOD,ESTDATCAD,PRODES,FORCOD,MARCOD,PROSTATUS)
select LESCOD,PROCOD,convert(date,getdate()),PRODES,FORCOD,MARCOD,PROSTATUS
  from TBS010 (nolock), TBS034 (nolock)
 where --PROCOD='0010001' and
       not exists(select '' from TBS032 (nolock) where TBS032.ESTLOC=TBS034.LESCOD and TBS032.PROCOD=TBS010.PROCOD)
 order by PROCOD,LESCOD
commit tran 


select LESCOD,count(*)
  from TBS010 (nolock), TBS034 (nolock)
 where --PROCOD='0010001' and
       not exists(select '' from TBS032 (nolock) where TBS032.ESTLOC=TBS034.LESCOD and TBS032.PROCOD=TBS010.PROCOD)
 group by LESCOD



---


exec XP_FIXEDDRIVES

    SELECT Name AS Nome
    ,run_Requested_Date AS DataExecucao
    ,DATEDIFF(mi,run_Requested_Date
    ,GETDATE()) AS Duracao_Minutos
    FROM msdb..sysjobactivity A INNER JOIN
    msdb..sysjobs B ON A.job_id = B.job_id
    WHERE start_Execution_Date IS NOT NULL AND stop_execution_date IS NULL


    DECLARE @Ontem INT
    DECLARE @OntemHorario INT
    SET @OntemHorario= CAST((RIGHT('0'+CONVERT(VARCHAR(2), (DATEPART(HOUR,DATEADD(HOUR,-1, GETDATE())))), 2) +RIGHT('0'+CONVERT(VARCHAR(2), (DATEPART(MINUTE,GETDATE()))), 2)+RIGHT('0'+CONVERT(VARCHAR(2), (DATEPART(SECOND,GETDATE()))), 2)) AS INT)
    SET @Ontem = CAST(CONVERT (VARCHAR(8),(DATEADD (DAY, -1, GETDATE())),112) AS INT)
    CREATE TABLE #HistoricoJobs( Cod INT identity(1,1)
    ,IDInstancia INT
    ,IDJob VARCHAR(255)
    ,NomeJob VARCHAR(255)
    ,IDStep INT
    ,NomeStep VARCHAR(255)
    ,IDSqlMensagem INT
    ,SqlSeverity INT
    ,SqlMensangem VARCHAR(3990)
    ,IDStatusExecucao INT
    ,DataExecucao VARCHAR(20)
    ,HorarioExecucao VARCHAR(20)
    ,DuracaoExecucao INT
    ,EmailOperador VARCHAR(100)
    ,NetSenderOperador VARCHAR(100)
    ,PagerOperador VARCHAR(100)
    ,TentativasRealizadAS INT
    ,NomeServidor VARCHAR(100))
    INSERT INTO #HistoricoJobs
    EXEC Msdb.dbo.SP_HELP_JOBHISTORY NULL,NULL,NULL,NULL,NULL,@Ontem,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'FULL'
    SELECT NomeJob
    ,CASE
    WHEN IDStatusExecucao = 0 THEN 'Failed'
    WHEN IDStatusExecucao = 1 THEN 'Succeeded'
    WHEN IDStatusExecucao = 2 THEN 'Retry (step only)'
    WHEN IDStatusExecucao = 3 THEN 'Canceled'
    WHEN IDStatusExecucao = 4 THEN 'In-progress message'
    WHEN IDStatusExecucao = 5 THEN 'Unknown' END Status
    ,CAST(DataExecucao + ' ' + RIGHT('00' + SUBSTRING(HorarioExecucao,(LEN(HorarioExecucao)-5),2) ,2)+ ':' +
    RIGHT('00' + SUBSTRING(HorarioExecucao,(LEN(HorarioExecucao)-3),2) ,2)+ ':' +
    RIGHT('00' + SUBSTRING(HorarioExecucao,(LEN(HorarioExecucao)-1),2) ,2) AS VARCHAR) Dt_Execucao
    ,RIGHT('00' + SUBSTRING(cast(DuracaoExecucao AS VARCHAR),(LEN(DuracaoExecucao)-5),2) ,2)+ ':' +
    RIGHT('00' + SUBSTRING(cast(DuracaoExecucao AS VARCHAR),(LEN(DuracaoExecucao)-3),2) ,2)+ ':' +
    RIGHT('00' + SUBSTRING(cast(DuracaoExecucao AS VARCHAR),(LEN(DuracaoExecucao)-1),2) ,2) DuracaoExecucao
    ,SqlMensangem
    FROM #HistoricoJobs
    WHERE ((DataExecucao >=@Ontem AND HorarioExecucao >= @OntemHorario) OR DataExecucao >@Ontem)
    AND IDStep = 0
    AND IDStatusExecucao <> 1
    ORDER BY Dt_Execucao
    DROP TABLE #HistoricoJobs
