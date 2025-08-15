select top 20 Ltrim(PROCOD),Ltrim(PROCOD),subString(PRODES,1,40),
       case when PROCLAFIS = '' then '0' else Ltrim(PROCLAFIS) end,
       case when PROUM1 = '' then 'UN' else PROUM1 end,
       case when PROSTBB = '60' then '0.00' else '18.00' end,
       PROSTBA+PROSTBB,'0.00',
       case when PROSTBB = '60' then 'S' else 'N' end,
       '0','1','','','00','99','01','01','0.0000','0.0000','0.0000','N','N','N','','','','','N','0.0000'
 from TBS010 (nolock)

-- and exists(select '''' from SIBD.dbo.TBS098 TBS098 (nolock) where TBS098.PROCOD = TBS010.PROCOD)

select '|'+ltrim(rtrim(PROCOD))+'|','|'+ltrim(rtrim(PROCOD))+'|','|'+ltrim(rtrim(subString(PRODES,1,40)))+'|',case when PROCLAFIS = '' then '0' else Ltrim(PROCLAFIS) end,case when PROUM1 = '' then '|UN|' else '|'+PROUM1+''|'' end,case when PROSTBB = '60' then '0.00' else '18.00' end,case when PROSTBA<>'' and PROSTBB <>'' then '|'+PROSTBA+PROSTBB+'|' else '|000|' end,'0.00',case when PROSTBB = '60' then '|S|' else '|N|' end,'0','1.000','||','||','00','99','01','01','0.0000','0.0000','0.0000','|N|','|N|','|N|','||','||','||','||','|N|','0.0000' from SIBD.dbo.TBS010 TBS010 (nolock) where len(PROCLAFIS)=8 and isNumeric(PROCLAFIS) = 1 and exists(select '''' from SIBD.dbo.TBS098 TBS098 (nolock) where TBS098.PROCOD = TBS010.PROCOD)" queryout c:\temp\produtos.txt -c -T -t","'

declare @comando varchar(1000)
set @comando = 'bcp "select ''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(subString(PRODES,1,40)))+''|'',case when PROCLAFIS = '''' then ''0'' else Ltrim(PROCLAFIS) end,case when PROUM1 = '''' then ''|UN|'' else ''|''+PROUM1+''|'' end,case when PROSTBB = ''60'' then ''0.00'' else ''18.00'' end,case when PROSTBA<>'''' and PROSTBB <>'''' then ''|''+PROSTBA+PROSTBB+''|'' else ''|000|'' end,''0.00'',case when PROSTBB = ''60'' then ''|S|'' else ''|N|'' end,''0'',''1.000'',''||'',''||'',''00'',''99'',''01'',''01'',''0.0000'',''0.0000'',''0.0000'',''|N|'',''|N|'',''|N|'',''||'',''||'',''||'',''||'',''|N|'',''0.0000'' from SIBD.dbo.TBS010 TBS010 (nolock) where len(PROCLAFIS)=8 and isNumeric(PROCLAFIS) = 1 and exists(select '''' from SIBD.dbo.TBS098 TBS098 (nolock) where TBS098.PROCOD = TBS010.PROCOD)" queryout c:\temp\produtos.txt -c -T -t","'

exec master..xp_cmdshell @comando

-- verificando movimentações
declare @comando varchar(1500)
set @comando = 'bcp "select ''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(subString(PRODES,1,40)))+''|'',case when PROCLAFIS = '''' then ''0'' else Ltrim(PROCLAFIS) end,case when PROUM1 = '''' then ''|UN|'' else ''|''+PROUM1+''|'' end,case when PROSTBB = ''60'' then ''0.00'' else ''18.00'' end,case when PROSTBA<>'''' and PROSTBB <>'''' then ''|''+PROSTBA+PROSTBB+''|'' else ''|000|'' end,''0.00'',case when PROSTBB = ''60'' then ''|S|'' else ''|N|'' end,''0'',''1.000'',''||'',''||'',''00'',''99'',''01'',''01'',''0.0000'',''0.0000'',''0.0000'',''|N|'',''|N|'',''|N|'',''||'',''||'',''||'',''||'',''|N|'',''0.0000'' from SIBD.dbo.TBS010 TBS010 (nolock) where exists(select '''' from SIBD.dbo.TBS098 TBS098 (nolock) where TBS098.PROCOD = TBS010.PROCOD) or exists(select '''' from SIBD.dbo.TBS0671 TBS0671 (nolock) where TBS0671.PROCOD = TBS010.PROCOD) or exists(select '''' from SIBD.dbo.TBS0591 TBS0591 (nolock) where TBS0591.PROCOD = TBS010.PROCOD) or exists(select '''' from SIBD.dbo.MSL002 MSL002 (nolock) where MSL002.M2_PROCOD = TBS010.PROCOD)" queryout c:\temp\produtos.txt -c -T -t","'

exec master..xp_cmdshell @comando


----

/* CRIANDO UM SERVIDOR LINKADO PARA */
/* ACESSAR O ARQUIVO TEXTO */
EXEC sp_addlinkedserver FonteTxt, 'Jet 4.0', 
   'Microsoft.Jet.OLEDB.4.0',
   'c:\temp',
   NULL,
   'Text'
GO

--Set up login mappings.
EXEC sp_addlinkedsrvlogin FonteTxt, FALSE, NULL, Admin, NULL
GO

/* VERIFICANDO O QUE ESTÁ DISPONÍVEL PARA NÓS */
EXEC sp_tables_ex FonteTxt
GO

/* VERIFICANDO OS DADOS DO ARQUIVO TEXTO */
SELECT *
FROM FonteTxt...Teste#txt

/* REMOVENDO O SERVIDOR LINKADO */
sp_dropserver FonteTxt
GO


declare @comando varchar(1000), @banco varchar(15)

set @banco = 'SIBD'

if not exists(select name from sysobjects where name='tabtemp' and type='U')
 begin
	create table tabtemp(CODIGO varchar(15))
 end
else delete tabtemp

/* VERIFICANDO OS DADOS DO ARQUIVO TEXTO */
insert into tabtemp
SELECT distinct case when SUBSTRING(col1, 3,3) = '200'
			then substring(col1, 7, CHARINDEX('|', col1, 7)-CHARINDEX('|', col1, 2)-1)
			else ''
		end as CODIGO
FROM FonteTxt...sped#txt
ORDER by CODIGO

--select * 
--from TBS010 join #tabtemp on PROCOD collate database_default= CODIGO collate database_default

set @comando = 'bcp "select ''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(PROCOD))+''|'',''|''+ltrim(rtrim(subString(PRODES,1,40)))+''|'',case when PROCLAFIS = '''' then ''0'' else Ltrim(PROCLAFIS) end,case when PROUM1 = '''' then ''|UN|'' else ''|''+PROUM1+''|'' end,case when PROSTBB = ''60'' then ''0.00'' else ''18.00'' end,case when PROSTBA<>'''' and PROSTBB <>'''' then ''|''+PROSTBA+PROSTBB+''|'' else ''|000|'' end,''0.00'',case when PROSTBB = ''60'' then ''|S|'' else ''|N|'' end,''0'',''1.000'',''||'',''||'',''00'',''99'',''01'',''01'',''0.0000'',''0.0000'',''0.0000'',''|N|'',''|N|'',''|N|'',''||'',''||'',''||'',''||'',''|N|'',''0.0000'' from '+@banco+'.dbo.TBS010 TBS010 (nolock) join '+@banco+'.dbo.tabtemp on PROCOD collate database_default = CODIGO collate database_default" queryout c:\temp\produtos.txt -c -T -t","'

exec master..xp_cmdshell @comando

/*
-- To allow advanced options to be changed.
EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO
*/

select '|'+ltrim(rtrim(PROCOD))+'|,'+
       '|'+ltrim(rtrim(PROCOD))+'|,'+
       '|'+ltrim(rtrim(subString(replace(replace(PRODES,'"',''),',','.'),1,60)))+'|,'+
       case
          when PROCLAFIS = ''
             then '0,'
             else Ltrim(PROCLAFIS)+','
          end+
       case 
          when PROUM1 = ''
             then '|UN|,'
             else '|'+PROUM1+'|,'
          end+
       case
          when PROSTBB = '60' 
             then '0.00,' 
             else '18.00,'
          end+
       case 
          when PROSTBA<>'' and PROSTBB <>'' 
             then '|'+PROSTBA+PROSTBB+'|,'
             else '|000|,' 
          end+
       '0.00,'+
       case 
          when PROSTBB = '60'
             then '|S|,' 
             else '|N|,' 
          end+
       '0,'+
       '1.000,'+
       '||,'+
       '||,'+
       '00,'+
       '99,'+
       '01,'+
       '01,'+
       '0.0000,'+
       '0.0000,'+
       '0.0000,'+
       '|N|,'+
       '|N|,'+
       '|N|,'+
       '||,'+
       '||,'+
       '||,'+
       '||,'+
       '|N|,'+
       '0.0000'
  from TBS010 (nolock)
 where isNumeric(PROCLAFIS) = 1 and Len(PROCLAFIS)=8

-- com SPED

select '|'+ltrim(rtrim(PROCOD))+'|,'+
       '|'+ltrim(rtrim(PROCOD))+'|,'+
       '|'+ltrim(rtrim(subString(replace(replace(PRODES,'"',''),',','.'),1,40)))+'|,'+
       case
          when PROCLAFIS = ''
             then '0,'
             else Ltrim(PROCLAFIS)+','
          end+
       case 
          when PROUM1 = ''
             then '|UN|,'
             else '|'+PROUM1+'|,'
          end+
       case
          when PROSTBB = '60' 
             then '0.00,' 
             else '18.00,'
          end+
       case 
          when PROSTBA<>'' and PROSTBB <>'' 
             then '|'+PROSTBA+PROSTBB+'|,'
             else '|000|,' 
          end+
       '0.00,'+
       case 
          when PROSTBB = '60'
             then '|S|,' 
             else '|N|,' 
          end+
       '0,'+
       '1.000,'+
       '||,'+
       '||,'+
       '00,'+
       '99,'+
       '01,'+
       '01,'+
       '0.0000,'+
       '0.0000,'+
       '0.0000,'+
       '|N|,'+
       '|N|,'+
       '|N|,'+
       '||,'+
       '||,'+
       '||,'+
       '||,'+
       '|N|,'+
       '0.0000'
  from TBS010 (nolock)
 where exists(select '' from SPED_ES (nolock) where COD_ITEM=PROCOD)
       

