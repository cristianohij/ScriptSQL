create table pro(dt datetime)

select * from pro

delete pro

drop procedure [dbo].[SP_ATUALIZAR_PRODUTOS]

-- empresa: 1=tanby taubate; 2=tanby deposito
-- opcao: 1=fornecedor; 2=marca; 3=unidade; 4=protudo; 5=preco

--create procedure SP_ATUALIZAR_PRODUTOS @empresa as smallint, @opcao as smallint as -- , @res as smallint OUTPUT as
create procedure SP_ATUALIZAR_PRODUTOS @opcao as smallint as
   begin
      set nocount on

--      set @res = 0

--      insert into pro values(getdate())

      select * from master..sysservers where srvname='filial1'

      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         begin
            exec master.dbo.sp_addlinkedserver @server = N'filial1', @srvproduct=N'Tanby Taubate', @provider=N'SQLNCLI10', @datasrc=N'192.168.3.205'

            -- adiciona um login remoto
            exec sp_addlinkedsrvlogin 'filial1', 'false', null, 'si', '123'

            -- habilita rpc
            exec sp_serveroption @server='filial1', @optname='rpc', @optvalue='true'
            exec sp_serveroption @server='filial1', @optname='rpc out', @optvalue='true'
         end

      select * from master..sysservers where srvname='filial2'

      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         begin
            exec master.dbo.sp_addlinkedserver @server = N'filial2', @srvproduct=N'Tanby Deposito', @provider=N'SQLNCLI10', @datasrc=N'192.168.10.7'

            -- adiciona um login remoto
            exec sp_addlinkedsrvlogin 'filial2', 'false', null, 'si', '123'

            -- habilita rpc
            exec sp_serveroption @server='filial2', @optname='rpc', @optvalue='true'
            exec sp_serveroption @server='filial2', @optname='rpc out', @optvalue='true'
         end

      if @opcao = 1
         if @empresa = 1
            begin
               exec filial1.msdb.dbo.sp_start_job N'atualizar fornecedores'
--               set @res = @res + 1
            end
         else
            begin
               exec filial2.msdb.dbo.sp_start_job N'atualizar fornecedores'
--               set @res = @res + 1
            end

      if @opcao = 2
         if @empresa = 1
            exec filial1.msdb.dbo.sp_start_job N'atualizar marcas'
         else
            exec filial2.msdb.dbo.sp_start_job N'atualizar marcas'

      if @opcao = 3
         if @empresa = 1
            exec filial1.msdb.dbo.sp_start_job N'atualizar unidades de medidas'
         else
            exec filial2.msdb.dbo.sp_start_job N'atualizar unidades de medidas'

      if @opcao = 4
         if @empresa = 1
            exec filial1.msdb.dbo.sp_start_job N'atualizar produtos'
         else
            exec filial2.msdb.dbo.sp_start_job N'atualizar produtos'

      if @opcao = 5
         if @empresa = 1
            exec filial1.msdb.dbo.sp_start_job N'atualizar preco'
         else
            exec filial2.msdb.dbo.sp_start_job N'atualizar preco'
   end
--return

exec [dbo].[SP_ATUALIZAR_PRODUTOS] 2, 1


drop procedure [dbo].[SP_ATUALIZA_FORNECEDORES_50]

create procedure SP_ATUALIZA_FORNECEDORES_50 @res smallint OUTPUT as
   begin
--      insert into pro values(getdate())
--      set @res = 1

--      select * from master..sysservers where srvname='filial2'

      -- se link para servidor remoto não foi encontrado
--      if @@rowcount = 0
--         begin
--            exec master.dbo.sp_addlinkedserver @server = N'filial2', @srvproduct=N'Tanby Deposito', @provider=N'SQLOLEDB', @datasrc=N'192.168.10.7', @location = N'192.168.10.7'

--            exec master.dbo.sp_addlinkedserver @server = N'filial2', @srvproduct=N'Tanby Deposito', @provider=N'SQLNCLI10', @datasrc=N'192.168.10.7'

            -- adiciona um login remoto
--            exec sp_addlinkedsrvlogin 'filial2', 'false', null, 'integros', 'int3gro5@15387'

            -- habilita rpc
--            exec sp_serveroption @server='filial2', @optname='rpc', @optvalue='true'
--            exec sp_serveroption @server='filial2', @optname='rpc out', @optvalue='true'
--         end

      exec filial2.msdb.dbo.sp_start_job N'atualizar fornecedores'
--      exec TESTE_SVR.msdb.dbo.sp_start_job N'atualizar fornecedores'
   end

exec SP_ATUALIZA_FORNECEDORES_50 0

exec sp_addlinkedsrvlogin 'TESTE', 'false', null, 'integros', 'int3gro5@15387'

            -- habilita rpc
exec sp_serveroption @server='TESTE', @optname='rpc', @optvalue='true'
exec sp_serveroption @server='TESTE', @optname='rpc out', @optvalue='true'


select * from master..sysservers



/* Criando o Linked Server */

EXEC master.dbo.sp_addlinkedserver

@server = N'TESTE_SVR', -- Nome do Linked
@srvproduct=N'testeLinkedServer',  -- Descrição
@provider=N'SQLNCLI10', -- Provider para SQL Server Native Client 10.0
@datasrc=N'192.168.10.7' -- Caminho do banco, ou no caso, IP do Servidor

/* Criando o login de acesso do Linked Server*/

EXEC master.dbo.sp_addlinkedsrvlogin

@rmtsrvname=N'TESTE_SVR', -- Nome criado do Linked
@useself=N'False', -- Se outros usuários usarão
@locallogin=N'integros', -- Usuário do banco local que terá acesso
@rmtuser=N'integros', -- login do banco do outro servidor
@rmtpassword='int3gro5@15387' -- senha do banco do outro servidor

exec sp_serveroption @server=N'TESTE_SVR', @optname=N'rpc', @optvalue=N'true'
exec sp_serveroption @server=N'TESTE_SVR', @optname=N'rpc out', @optvalue=N'true'

