declare @comando varchar(1000)
set @comando = 'bcp "select ''01'' + ''01'' + convert(char(8),getdate(),112) + replace(convert(char(8),getdate(),108),'':'','''') + ''0000'' + ''210'' + ''0001''" queryout c:\integros\temp\registro01.txt -c -T -t","'

exec master..xp_cmdshell @comando

select convert(char(8),getdate(),112)
select replace(convert(char(8),getdate(),108),':','')

---

select * from TBS023 (nolock)

declare @comando varchar(1000)
set @comando = 'bcp "select ''05'' + rtrim(EMPIES) + rtrim(EMPCGC) + ''0000000'' + ''01'' + ''201701'' + ''000000'' + ''01'' + ''1'' + ''0'' + ''000000000000000'' + ''000000000000000'' + ''15387930000117'' + ''0'' + ''000000000000000'' + ''00000000000000000000000000000000'' + ''0000'' + ''0023'' + ''0000'' + ''0000'' + ''0000'' from SIBD.dbo.TBS023 (nolock) where EMPCOD=1" queryout c:\integros\temp\registro05.txt -c -T -t","'

exec master..xp_cmdshell @comando

---

select * from TBS1281 (nolock)
select * from TBS1282 (nolock)

declare @comando varchar(1000)
set @comando = 'bcp "select ''10'' + rtrim(str(LAICFOP,4)) + right(''000000000000000'' + Ltrim(str(LAIVALCON*100,15)),15) + right(''000000000000000'' + Ltrim(str(LAIBASCAL*100,15)),15) + right(''000000000000000'' + Ltrim(str(LAIVALIMP*100,15)),15) + right(''000000000000000'' + Ltrim(str(LAIVALIN*100,15)),15) + right(''000000000000000'' + Ltrim(str((LAIVALCON-LAIBASCAL-LAIVALIN)*100,15)),15) + ''000000000000000'' + ''000000000000000'' + ''000000000000000'' + ''000000000000000'' + ''0014'' from SIBD.dbo.TBS1281 (nolock)" queryout c:\integros\temp\registro14.txt -c -T -t","'

exec master..xp_cmdshell @comando

select LAIVALCON,right('000000000000000' + Ltrim(str(LAIVALCON*100,15)),15) from TBS1281 (nolock)