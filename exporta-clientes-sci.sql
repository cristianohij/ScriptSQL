--if object_id('tempdb..#CLIENTE') is not null
--   begin
--      drop table #CLIENTE
--   end

if object_id('CLISCI') is not null
   begin
      drop table CLISCI
   end

create table CLISCI (registro varchar(8000))

insert into CLISCI
select --top 50 
       ltrim(str(CLICOD,6)) +
       ',' +
       case CLITIPPES when 'J' then '0' else '1' end +
       ',' +
       '|' +
       case CLITIPPES when 'J' then rtrim(CLICGC) else rtrim(CLICPF) end +
       '|' +
       ',' +
       '|' +
       case when CLINOMFAN<>'' then rtrim(subString(CLINOMFAN,1,14)) else rtrim(subString(CLINOM,1,14)) end +
       '|' +
       ',' +
       '|' +
       rtrim(subString(CLINOM,1,40)) +
       '|' +
       ',' +
       '|' +
       rtrim(subString(CLIEND,1,40)) +
       '|' +
       ',' +
       '|' +
       '|' +
       ',' +
       '|' +
       rtrim(CLIBAI) +
       '|' +
       ',' +
       '|' +
       subString(CLICEP,1,5)+subString(CLICEP,7,3) +
       '|' +
       ',' +
       subString(str(MUNCOD,7),3,5) +
       ',' +
       '|' +
       (select rtrim(subString(MUNNOM,1,30)) from TBS003 as TBS003 (nolock) where TBS003.MUNCOD=TBS002.MUNCOD) +
       '|' +
       ',' +
       '|' +
       UFESIG +
       '|' +
       ',' +
       '|' +
       ltrim(rtrim(CLITEL)) +
       '|' +
       ',' +
       '|' +
       ltrim(rtrim(CLIFAX)) +
       '|' +
       ',' +
       '|' +
       case CLITIPPES when 'J' then rtrim(CLIIES) else '' end +
       '|' +
       ',' +
       '|' +
       '|' +
       ',' +
       '|' +
       convert(char(8),CLIDATCAD,112) +
       '|' +
       ',' +
       '|' +
       rtrim(CLIIMU) +
       '|' +
       ',' +
       '|' +
       rtrim(subString(CLIEMAIL,1,41)) +
       '|' +
       ',' +
       '0' +
       ',' +
       '|' +
       case CLISUFRAMA when 0 then '' else ltrim(str(CLISUFRAMA,9)) end +
       '|' +
       ',' +
       '|' +
       '|' +
       ',' +
       '|' +
       --case CLICRT when 3 then '2' else '1' end +
       '2' +
       '|' --as 'registro'
       --into #CLIENTE
  from TBS002 as TBS002 (nolock)

-- select * from SIBD.dbo.CLISCI
--select * from #CLIENTE

declare @comando varchar(8000)

--set @comando = 'bcp "select ''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(subString(PRODES,1,40)))+''|'',case when PROCLAFIS = '''' then ''0'' else Ltrim(PROCLAFIS) end,case when PROUM1 = '''' then ''|UN|'' else ''|''+PROUM1+''|'' end,case when PROSTBB = ''60'' then ''0.00'' else ''18.00'' end,case when PROSTBA<>'''' and PROSTBB <>'''' then ''|''+PROSTBA+PROSTBB+''|'' else ''|000|'' end,''0.00'',case when PROSTBB = ''60'' then ''|S|'' else ''|N|'' end,''0'',''1.000'',''||'',''||'',''00'',''99'',''01'',''01'',''0.0000'',''0.0000'',''0.0000'',''|N|'',''|N|'',''|N|'',''||'',''||'',''||'',''||'',''|N|'',''0.0000'' from '+@banco+'.dbo.TBS010 TBS010 (nolock) join '+@banco+'.dbo.tabtemp on PROCOD collate database_default = CODIGO collate database_default" queryout c:\temp\produtos.txt -c -T -t","'

--exec master..xp_cmdshell @comando

set @comando = 'bcp "select * from SIBD.dbo.CLISCI" queryout c:\temp\clientes.txt -c -T -t","'

exec master..xp_cmdshell @comando

--select * from CLISCI

