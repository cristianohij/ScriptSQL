drop procedure [dbo].[sp_AtualizarPedidosCompras]

-- empresa: 1=tanby matriz; 2=tanby deposito

create procedure [dbo].[sp_AtualizarPedidosCompras] @empresa as smallint as
   begin
      set nocount on

      select * from master..sysservers where srvname='filial2'

      -- se link para servidor remoto não foi encontrado
      if @@rowcount = 0
         begin
            exec master.dbo.sp_addlinkedserver @server = N'filial2', @srvproduct=N'', @provider=N'SQLNCLI', @datasrc=N'192.168.10.7'

            -- adiciona um login remoto
            exec sp_addlinkedsrvlogin 'filial2', 'false', null, 'si', '123'

            -- habilita rpc
            exec sp_serveroption @server='filial1', @optname='rpc', @optvalue='true'
         end

      if @opcao = 1
         if @empresa = 1
            exec filia1.msdb.dbo.sp_start_job N'atualizar fornecedores'
         else
            exec filia2.msdb.dbo.sp_start_job N'atualizar fornecedores'

   end