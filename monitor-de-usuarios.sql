select * from MonitorDeUsuarios (nolock)

select distinct loginame from MonitorDeUsuarios (nolock)

select * from MonitorDeUsuarios (nolock) where loginame='si'

select hostname,
       net_address,
       (select rtrim(subString(linha,1,15))
          from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from macgrupo.txt')
         where rtrim(subString(linha,16,12)) collate database_default=net_address collate database_default)
  from MISASPEL.SIBD.dbo.MonitorDeUsuarios
 where loginame='si'
-- group by hostname,net_address

alter table MonitorDeUsuarios add ip_address char(15) default '' with values

select isnull((select rtrim(subString(linha,1,15))
          from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from macgrupo.txt')
         where rtrim(subString(linha,16,12)) collate database_default=net_address collate database_default),'')
  from MISASPEL.SIBD.dbo.MonitorDeUsuarios
 where loginame='si'


-- rodar no servidor de cada unidade
update MonitorDeUsuarios set ip_address=isnull((select rtrim(subString(linha,1,15))
          from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from macgrupo.txt')
         where rtrim(subString(linha,16,12)) collate database_default=net_address collate database_default),'')
  from MonitorDeUsuarios
 where loginame='si'


select hostname,
       net_address,
       ip_address,
       count(*)
  from MISASPEL.SIBD.dbo.MonitorDeUsuarios
 where loginame='si'
 group by hostname,net_address,ip_address