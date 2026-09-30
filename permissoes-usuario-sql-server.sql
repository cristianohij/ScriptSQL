/*
O que esse script faz
Concede as permissões mínimas (VIEW SERVER STATE, VIEW ANY DEFINITION, VIEW DATABASE STATE) para o usuário poder abrir e visualizar o Monitor de Atividade.
Adiciona o usuário à role SQLAgentReaderRole no banco msdb (opcional, só se quiser que ele veja informações de jobs).
*/

-- Troque 'SeuUsuario' pelo nome do usuário ou login
DECLARE @Usuario SYSNAME = N'kaio';

-- Permissões necessárias no servidor
USE master;
GRANT VIEW SERVER STATE TO [kaio];
GRANT VIEW ANY DEFINITION TO [kaio];
GRANT VIEW DATABASE STATE TO [kaio];

-- Permissão de leitura de jobs do SQL Agent (opcional)
USE msdb;
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals dp
    JOIN sys.database_role_members drm ON dp.principal_id = drm.member_principal_id
    JOIN sys.database_principals rp ON drm.role_principal_id = rp.principal_id
    WHERE dp.name = @Usuario
      AND rp.name = 'SQLAgentReaderRole'
)
BEGIN
    EXEC sp_addrolemember N'SQLAgentReaderRole', @Usuario;
END

/*
Explicação
CREATE USER [kaio] FOR LOGIN [kaio] → cria o usuário no banco, ligado ao login já existente no servidor.
O IF NOT EXISTS evita erro se ele já estiver criado.
GRANT VIEW SERVER STATE é a permissão principal para o Activity Monitor funcionar.
O bloco msdb é só para habilitar a visualização de jobs.
*/

DECLARE @Login SYSNAME = N'kaio';

-- No master
USE master;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @Login)
    CREATE USER [kaio] FOR LOGIN [kaio];

GRANT VIEW SERVER STATE TO [kaio];
GRANT VIEW ANY DEFINITION TO [kaio];
GRANT VIEW DATABASE STATE TO [kaio];

-- No msdb (necessário se quiser ver jobs no Activity Monitor)
USE msdb;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @Login)
    CREATE USER [kaio] FOR LOGIN [kaio];

EXEC sp_addrolemember N'SQLAgentReaderRole', @Login;
