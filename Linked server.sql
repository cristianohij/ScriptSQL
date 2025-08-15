exec sp_dropserver 'bb'

exec sp_addlinkedserver @server ='PAPELYNA',
                        @srvproduct ='SQLOLEDB',
                        @provider ='SQLOLEDB',
                        @datasrc ='192.168.0.7',
                        @location ='192.168.0.7',
                        @provstr =NULL,
                        @catalog =NULL

select * from master..sysservers
 where datasource='192.168.10.7'

select * from TANBYT.SIBD.dbo.TBS001 (nolock)
select top 1 * from TANBYT.SIBD.dbo.TBS032 (nolock)

-- sql server 2008 para 2000

sp_addlinkedserver 
    @server='bo',
    @srvproduct = 'SQLSERVER',
    @provider = 'MSDASQL',
    @datasrc = NULL,
    @location = null,
    @provstr = 'DRIVER={SQL Server Native Client 10.0};SERVER=192.168.7.5;',
    @catalog = NULL 
 go
    
 sp_addlinkedsrvlogin
    @rmtsrvname='ba',
    @useself='false',
    @rmtuser='si',
    @rmtpassword='123'
 go 
 
 select * from BA.SIBD.dbo.TBS001


-- sql server 2008

-- �ltimo link feito com BB
-- sql server 2008

EXEC master.dbo.sp_addlinkedserver
@server = N'pp',
@srvproduct=N'SQLOLEDB',
@provider=N'SQLOLEDB',
@datasrc=N'192.168.0.7',
@location = N'192.168.0.7'
go


EXEC master.dbo.sp_addlinkedserver
@server = N'bb',
@srvproduct=N'Best Bag',
@provider=N'SQLNCLI11',
@datasrc=N'192.168.0.3'
go

sp_addlinkedsrvlogin [ @rmtsrvname = ] 'rmtsrvname' 
     [ , [ @useself = ] 'TRUE' | 'FALSE' | NULL ] 
     [ , [ @locallogin = ] 'locallogin' ] 
     [ , [ @rmtuser = ] 'rmtuser' ] 
     [ , [ @rmtpassword = ] 'rmtpassword' ] 

EXEC sp_addlinkedsrvlogin 'Accounts'
EXEC sp_addlinkedsrvlogin 'Accounts', 'false', 'Domain\Mary', 'MaryP', 'd89q3w4u'

-- adiciona um login remoto
exec sp_addlinkedsrvlogin 'pp', 'false', null, 'integros', 'int3gro5@15387'

-- elimina um login remoto
exec sp_droplinkedsrvlogin 'bb',NULL,'si'

EXEC sp_droplinkedsrvlogin 'bb', 'integros'

-- configurar SQL Server para RPC
exec sp_serveroption @server='cd', @optname='RPC', @optvalue='TRUE'
exec sp_serveroption @server='cd', @optname='rpc out', @optvalue='TRUE'



-- habilitar ad hoc
exec sp_configure 'Ad Hoc Distributed Queries',1

-- for�ar para que as altera��es tenham efeito imediato
reconfigure with override

exec sp_configure 'show advanced options', 1;
RECONFIGURE;
exec sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO



-- link para arquivo texto
--Create a linked server.
EXEC sp_addlinkedserver FonteTxt, N'Jet 4.0', 
   N'Microsoft.Jet.OLEDB.4.0',
   N'c:\temp',
   NULL,
   N'Text';
GO

--Set up login mappings.
EXEC sp_addlinkedsrvlogin FonteTxt, FALSE, sa, t@nbyn3lson;
GO

--List the tables in the linked server.
EXEC sp_tables_ex FonteTxt;
GO

--Query one of the tables: file1#txt
--using a four-part name. 
SELECT * 
FROM txtsrv...[file1#txt];


exec sp_configure 'show advanced options',1
go
reconfigure with override
go
exec sp_configure 'Ad Hoc Distributed Queries',1
go
reconfigure with override
go