-- 1. Sessões Bloqueadas e Bloqueadores

SELECT
    blocking_session_id AS Sessao_Bloqueadora,
    session_id AS Sessao_Bloqueada,
    wait_type AS Tipo_Espera,
    wait_time AS Tempo_Espera_ms,
    wait_resource AS Recurso_Esperado
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;

-- 2. Visualizar Detalhes dos Locks Ativos

SELECT
    tl.resource_type AS Tipo_Recurso,
    tl.resource_description AS Descricao_Recurso,
    tl.request_mode AS Modo_Bloqueio,
    tl.request_status AS Status_Bloqueio,
    r.command AS Comando_Executado,
    t.text AS SQL_Texto,
    r.session_id AS Sessao
FROM sys.dm_tran_locks AS tl
JOIN sys.dm_exec_requests AS r
    ON tl.request_session_id = r.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t;

--  3. Árvore de Bloqueios (com nomes de usuários e programas)

SELECT
    spid AS Sessao,
    blocked AS Bloqueado_Por,
    loginame AS Usuario,
    hostname AS Host,
    program_name AS Programa,
    status AS Status_Sessao,
    cmd AS Comando_Atual
FROM sys.sysprocesses
WHERE blocked <> 0 OR spid IN (SELECT blocked FROM sys.sysprocesses WHERE blocked <> 0)
ORDER BY Bloqueado_Por, Sessao;

-- 4. Ver a Query que Está Causando o Bloqueio

SELECT
    er.session_id,
    er.status,
    er.command,
    er.wait_type,
    er.blocking_session_id,
    st.text AS Query_SQL
FROM sys.dm_exec_requests AS er
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS st
WHERE er.blocking_session_id <> 0;

--  5. Finalizar Sessão Bloqueadora (⚠️ Use com cuidado!)

KILL [ID_DA_SESSAO];
