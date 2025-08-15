!!sqlcmd -S . -d curso -E -Q "set nocount on; select * from TBS001" -o "c:\tmp\amigos.csv" -W -s"," -h-1

-- Utilizando queryout, pode-se exportar o resultado de uma query
EXEC master.dbo.xp_cmdshell 'bcp "SELECT UFESIG,UFENOM FROM SIBD.dbo.TBS010 with (nolock)" queryout "C:\integros\temp\teste.csv" -c -t; -T'

select top 10 PROCOD,str(PROICMSINT,2) from TBS010 with (nolock) where PROICMSINT > 0

select PROCOD,PROREDBASICMS from TBS010 with (nolock) where PROREDBASICMS > 0

select PROREDBASICMS from TBS010 with (nolock) group by PROREDBASICMS