SELECT 
    s.SubscriptionID,
    s.Description,
    c.Name AS ReportName,
    sj.name AS SQLAgentJobName
FROM 
    ReportServer.dbo.Subscriptions s
JOIN 
    ReportServer.dbo.ReportSchedule rs ON s.SubscriptionID = rs.SubscriptionID
JOIN 
    msdb.dbo.sysjobs sj ON CAST(rs.ScheduleID AS VARCHAR(36)) = sj.name
JOIN 
    ReportServer.dbo.Catalog c ON s.Report_OID = c.ItemID
WHERE 
    c.Name LIKE 'Relatório de faturamento NFS x Cupom (Tanby Matriz)'

EXEC msdb.dbo.sp_start_job @job_name = '87A4D7F1-F12D-4ECA-8594-8DC54C0B922B'


