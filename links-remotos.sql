declare @servidor varchar(15), @comando varchar(300), @usuario varchar(10)

set @servidor='filial2'
set @usuario='si'

set @comando = 'exec sp_droplinkedsrvlogin N'''+@servidor+''', N'''+@usuario+''''

print @comando

-- elimina um login remoto
--exec sp_droplinkedsrvlogin 'ba',NULL,'si'
execute @comando

-- não consegui automatizar acima


-- elimina um login remoto
exec sp_droplinkedsrvlogin 'PP', 'sa'
go

-- remove o link
exec sp_dropserver @server='PP'
go

-- acima não funcionou

-- link para servidor remoto
exec master.dbo.sp_addlinkedserver @server = N'tt', @srvproduct=N'Tanby Taubaté', @provider=N'SQLNCLI10', @datasrc=N'192.168.3.205'
go

-- adiciona um login remoto
exec sp_addlinkedsrvlogin 'tt', 'false', null, 'si', '123'
go

-- habilita rpc
exec sp_serveroption @server='tt', @optname='rpc', @optvalue='true'
go

exec sp_serveroption @server='tt', @optname='rpc out', @optvalue='true'
go
