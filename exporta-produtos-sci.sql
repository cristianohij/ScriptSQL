select top 20 Ltrim(PROCOD),Ltrim(PROCOD),subString(PRODES,1,40),
       case when PROCLAFIS = '' then '0' else Ltrim(PROCLAFIS) end,
       case when PROUM1 = '' then 'UN' else PROUM1 end,
       case when PROSTBB = '60' then '0.00' else '18.00' end,
       PROSTBA+PROSTBB,'0.00',
       case when PROSTBB = '60' then 'S' else 'N' end,
       '0','1','','','00','99','01','01','0.0000','0.0000','0.0000','N','N','N','','','','','N','0.0000'
 from TBS010 (nolock)

-- and exists(select '''' from SIBD.dbo.TBS098 TBS098 (nolock) where TBS098.PROCOD = TBS010.PROCOD)

declare @comando varchar(1000)
set @comando = 'bcp "select ''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(subString(PRODES,1,40)))+''|'',case when PROCLAFIS = '''' then ''0'' else Ltrim(PROCLAFIS) end,case when PROUM1 = '''' then ''|UN|'' else ''|''+PROUM1+''|'' end,case when PROSTBB = ''60'' then ''0.00'' else ''18.00'' end,case when PROSTBA<>'''' and PROSTBB <>'''' then ''|''+PROSTBA+PROSTBB+''|'' else ''|000|'' end,''0.00'',case when PROSTBB = ''60'' then ''|S|'' else ''|N|'' end,''0'',''1.000'',''||'',''||'',''00'',''99'',''01'',''01'',''0.0000'',''0.0000'',''0.0000'',''|N|'',''|N|'',''|N|'',''||'',''||'',''||'',''||'',''|N|'',''0.0000'' from SIBD.dbo.TBS010 TBS010 (nolock) where len(PROCLAFIS)=8 and isNumeric(PROCLAFIS) = 1 and exists(select '''' from SIBD.dbo.TBS098 TBS098 (nolock) where TBS098.PROCOD = TBS010.PROCOD)" queryout c:\temp\produtos.txt -c -T -t","'

exec master..xp_cmdshell @comando


-- verificando movimentações
declare @comando varchar(1500)
set @comando = 'bcp "select ''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(subString(PRODES,1,40)))+''|'',case when PROCLAFIS = '''' then ''0'' else Ltrim(PROCLAFIS) end,case when PROUM1 = '''' then ''|UN|'' else ''|''+PROUM1+''|'' end,case when PROSTBB = ''60'' then ''0.00'' else ''18.00'' end,case when PROSTBA<>'''' and PROSTBB <>'''' then ''|''+PROSTBA+PROSTBB+''|'' else ''|000|'' end,''0.00'',case when PROSTBB = ''60'' then ''|S|'' else ''|N|'' end,''0'',''1.000'',''||'',''||'',''00'',''99'',''01'',''01'',''0.0000'',''0.0000'',''0.0000'',''|N|'',''|N|'',''|N|'',''||'',''||'',''||'',''||'',''|N|'',''0.0000'' from SIBD.dbo.TBS010 TBS010 (nolock) where exists(select '''' from SIBD.dbo.TBS098 TBS098 (nolock) where TBS098.PROCOD = TBS010.PROCOD) or exists(select '''' from SIBD.dbo.TBS0671 TBS0671 (nolock) where TBS0671.PROCOD = TBS010.PROCOD) or exists(select '''' from SIBD.dbo.TBS0591 TBS0591 (nolock) where TBS0591.PROCOD = TBS010.PROCOD) or exists(select '''' from SIBD.dbo.MSL002 MSL002 (nolock) where MSL002.M2_PROCOD = TBS010.PROCOD)" queryout c:\temp\produtos.txt -c -T -t","'

exec master..xp_cmdshell @comando

