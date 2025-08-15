-- criar link com servidores

if exists(select name from sysobjects where name='SP_CriaLinkServidores' and type='P')
   drop procedure [dbo].[SP_CriaLinkServidores]
go

create procedure [dbo].[SP_CriaLinkServidores] as
   begin
      declare @emp varchar(2)

      select * from master..sysservers where srvname='BA'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'BA', @srvproduct=N'Best Arts', @provider=N'SQLNCLI10', @datasrc=N'192.168.7.5'

      select * from master..sysservers where srvname='BB'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'BB', @srvproduct=N'Best Bag', @provider=N'SQLNCLI10', @datasrc=N'192.168.0.3'
 
      select * from master..sysservers where srvname='CD'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'CD', @srvproduct=N'Tanby CD', @provider=N'SQLNCLI10', @datasrc=N'192.168.10.7'

      select * from master..sysservers where srvname='MI'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'MI', @srvproduct=N'Misaspel', @provider=N'SQLNCLI10', @datasrc=N'192.168.0.2'

      select * from master..sysservers where srvname='PP'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'PP', @srvproduct=N'Papelyna', @provider=N'SQLNCLI10', @datasrc=N'192.168.0.7'

      select * from master..sysservers where srvname='TM'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'TM', @srvproduct=N'Tanby matriz', @provider=N'SQLNCLI10', @datasrc=N'192.168.1.205'

      select * from master..sysservers where srvname='TT'
      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         exec master.dbo.sp_addlinkedserver @server = N'TT', @srvproduct=N'Tanby Taubate', @provider=N'SQLNCLI10', @datasrc=N'192.168.3.205'
   end
