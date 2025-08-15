-- parâmetros
select 
       'insert into TBS025 select ' + ltrim(str(ch,4)) + ', ''' + rtrim(descricao) + ''', ''' + rtrim(t) + ''', ''' + isnull(rtrim(valor),'') + ''', ' +
	   '''' + convert(char(8),getdate(),112) + '''' +
	   ' where not exists(select PARCHV from TBS025 (nolock) where PARCHV=' + ltrim(str(ch,4)) + ')' + char(13) + 'go'
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\Models\integros\docs\parametros.xlsx', 'select * from [Plan1$]')

-- tabelas
select 
       'insert into TBS024 select ''' + rtrim(tabela) + ''', ''' + rtrim(nome) + ''', ''' + rtrim(sequencia) + ''', ''' + isnull(ltrim(str(valor,16)),'0') +
	   ''', ' + rtrim(controle) + rtrim(zeros) + ''', ''' + rtrim(modo) +
	   ' where not exists(select TABNOM from TBS024 (nolock) where TABNOM=''' + rtrim(tabela) + ''')' + char(13) + 'go'
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\Models\integros\docs\tabelas.xlsx', 'select * from [Plan1$]')
