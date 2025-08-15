execute sp_configure 'Show Advanced Options', 1
reconfigure
execute sp_configure 'Database Mail XPs', 1
reconfigure

execute msdb.dbo.sysmail_add_account_sp
    -- Dados fíxos
    @mailserver_name = 'email-ssl.com.br', -- endereço do servidor de envio de e-mails
    @port = 587, -- porta de comunicação
    @enable_ssl = 1, -- habilitar SSL (criptografia durante o envio de dados)
    -- Dados da sua conta
    @account_name = 'cristiano', -- nome da conta dentro do SQL
    @display_name = 'SQLServer',   -- Nome que aparecerá como remetente do e-mail
    @email_address = 'cristiano@integros.net.br',
    @username = 'cristiano@integros.net.br',
    @password = 'hij@4294756'

execute msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'Integros_Perfil',
    @description = 'Perfil para envio de notificações do SQL.'

-- Associar o perfil a conta
execute msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'Integros_Perfil',
    @account_name = 'cristiano',
    @sequence_number = 1

execute msdb.dbo.sp_send_dbmail
    @profile_name = 'Integros_Perfil',
    @recipients = 'cristiano.hij@gmail.com',
    @subject = 'Teste de envio de e-mail via SQL',
    @body = 'SQL na área',
    @file_attachments = 'c:\integros\temp\produtos.csv'

-- Emails enviados
select * from msdb.dbo.sysmail_mailitems
 
-- Consultar logs do gerenciador de e-mails
select * from msdb.dbo.sysmail_log

-- Remover logs:
declare @hoje datetime = getdate()
execute msdb.dbo.sysmail_delete_mailitems_sp @sent_before = @hoje
execute msdb.dbo.sysmail_delete_log_sp
 
-- Excluir profile:
execute msdb.dbo.sysmail_delete_profile_sp @profile_name = 'Integros_Perfil'
 
-- Excluir conta:
execute msdb.dbo.sysmail_delete_account_sp @account_name = 'cristiano_integros'
