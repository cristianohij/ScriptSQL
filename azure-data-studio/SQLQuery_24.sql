select MUSNOM
       ,count(*)
  from wp.SIBD4.dbo.TBS116 with (nolock)
 where MUSDATLOGIN='20220607'
       and MUSDATLOGOF='17530101'
 group by MUSNOM

select empresa
       ,nome_usuario
       ,sum(contador) as contador
  from (
          select MUSNOM  as nome_usuario
                 ,count(*) as contador
                 ,'BB' as empresa
            from bb.SIBD2.dbo.TBS116 with (nolock)
           where MUSDATLOGIN='20220607'
                 and MUSDATLOGOF='17530101'
          group by MUSNOM
  
          union 

          select MUSNOM
                 ,count(*)
                 ,'MI'
            from mi.SIBD3.dbo.TBS116 with (nolock)
           where MUSDATLOGIN='20220607'
                 and MUSDATLOGOF='17530101'
           group by MUSNOM

          union 

          select MUSNOM
                 ,count(*)
                 ,'PP'
            from pp.SIBD.dbo.TBS116 with (nolock)
           where MUSDATLOGIN='20220607'
                 and MUSDATLOGOF='17530101'
           group by MUSNOM

          union 

          select MUSNOM
                 ,count(*)
                 ,'WP'
            from wp.SIBD4.dbo.TBS116 with (nolock)
           where MUSDATLOGIN='20220607'
                 and MUSDATLOGOF='17530101'
           group by MUSNOM
       ) t 
 group by rollup (empresa, nome_usuario)

declare @data date 

set @data='20220614'

select nome_usuario
       ,sum(contador) as contador
  from (
          select MUSNOM  as nome_usuario
                 ,count(*) as contador
                 ,'BB' as empresa
            from bb.SIBD2.dbo.TBS116 with (nolock)
           where MUSDATLOGIN=@data
                 and MUSDATLOGOF='17530101'
          group by MUSNOM
  
          union 

          select MUSNOM
                 ,count(*)
                 ,'MI'
            from mi.SIBD3.dbo.TBS116 with (nolock)
           where MUSDATLOGIN=@data
                 and MUSDATLOGOF='17530101'
           group by MUSNOM

          union 

          select MUSNOM
                 ,count(*)
                 ,'PP'
            from pp.SIBD.dbo.TBS116 with (nolock)
           where MUSDATLOGIN=@data
                 and MUSDATLOGOF='17530101'
           group by MUSNOM

          union 

          select MUSNOM
                 ,count(*)
                 ,'WP'
            from wp.SIBD4.dbo.TBS116 with (nolock)
           where MUSDATLOGIN=@data
                 and MUSDATLOGOF='17530101'
           group by MUSNOM
       ) t 
 group by nome_usuario

-- ip usuários conectados ao sql server

SELECT  ec.client_net_address,

              es.[program_name],

              es.[host_name],

              es.login_name

FROM sys.dm_exec_sessions AS es INNER JOIN sys.dm_exec_connections AS ec

                                                           ON es.session_id = ec.session_id

ORDER BY ec.client_net_address,  es.[program_name];

select *
  from pp.SIBD.dbo.TBS116 with (nolock)
 where MUSDATLOGIN='20220614'
       and MUSDATLOGOF='17530101'





