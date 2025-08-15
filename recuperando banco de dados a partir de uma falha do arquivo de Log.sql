-- muda para o banco de dados master
use master

-- permite o update no banco master
sp_configure 'allow updates' ,1
reconfigure with override

-- muda o status do banco de dados indicado para o modo de emergencia
update sysdatabases set status = 32768 where name = 'SIBD'

-- reconstroi o arquivo de Log do banco de dados especificado
dbcc rebuild_log('SIBD' ,'C:\Arquivos de programas\Microsoft SQL Server\MSSQL\Data\SIBD_Log.ldf')

-- volta o banco de dados ao modo de uso normal
use SIBD

sp_dboption 'SIBD' ,'dbo use only' ,false

-- mais detalhes consulte o documento: "Recuperando Banco de Dados a partir de uma falha do arquivo de Log.pdf"