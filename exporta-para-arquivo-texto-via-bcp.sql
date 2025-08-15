-- Utilizando queryout, pode-se exportar o resultado de uma query
EXEC master.dbo.xp_cmdshell 'bcp "SELECT CLICOD, CLINOM FROM SIBD.dbo.TBS002 with (nolock)" queryout "c:\integros\temp\clientes.txt" -c -t; -T'
 -Slocalhost\SQL2014'

-- Utilizando out, pode-se exportar um objeto
EXEC master.dbo.xp_cmdshell 'bcp msdb.sys.tables out "C:\Temp\bcp_out.csv" -c -t, -T -Slocalhost\SQL2014'

