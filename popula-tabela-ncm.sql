-- insere dados, exceto, a descrição que não coube no script SQL
select 'insert into TBS092 (NCMCOD,NCMEX,NCMDATCAD,NCMALINAC,NCMALIIMP,NCMFONTAB,NCMVER,NCMCHV,NCMVIGFIN,NCMVIGINI) select ''' + NCMCOD + ''', ''' + NCMEX + ''', ''' + convert(char(8),getdate(),112) + ''', ' +
       ltrim(str(NCMALINAC,5,2))  + ', ' + ltrim(str(NCMALIIMP,5,2)) + ', ''' + rtrim(NCMFONTAB) + ''',' + '''' + rtrim(NCMVER) + ''', ''' + rtrim(NCMCHV) + ''', ''' +
       convert(char(8),NCMVIGFIN,112) + ''', ''' + convert(char(8),NCMVIGINI,112) + '''' + char(13) + 'go'
  from TBS092 (nolock)

-- atualiza a descrição
select 'update TBS092 set NCMDES=''' + rtrim(subString(NCMDES,1,192)) + ''' from TBS092 where NCMCOD=''' + NCMCOD + '''' from TBS092 (nolock)