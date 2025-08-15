-- local dos arquivos do banco de dados
sp_helpfile

-- lista usuário conectados ao banco
select * from master.sys.sysprocesses WHERE dbid = DB_ID ('SIBD')

-- fecha as conexões ativas no banco de dados

-- atenção: antes de colocar o banco em estado offline, verifique se o usuário que está usando para logar SQL Server tem permissões para logar em outro banco de dados,

alter database SIBD set offline with rollback immediate

-- após mover o arquivo MDF ou LDF, execute a seguinte query
-- essa query fala para o SQL alterar a localização do banco SIBD
-- em NAME deve-se informar o nome lógico do arquivo (sp_helpfile)

 USE MASTER
 GO
alter database SIBD
modify file (name = '...AdventureWorks_Log', filename = 'D:\LogsSQLServer\AdventureWorks_Log.ldf')
go

