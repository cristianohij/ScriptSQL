SELECT  es.session_id,ec.client_net_address,

              es.[program_name],

              es.[host_name],

              es.login_name, *

FROM sys.dm_exec_sessions AS es INNER JOIN sys.dm_exec_connections AS ec

                                                           ON es.session_id = ec.session_id
where host_name='NOTE-CRIS'
ORDER BY ec.client_net_address,  es.[program_name];

select @@SPID