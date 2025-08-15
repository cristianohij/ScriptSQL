sp_addlinkedserver 'natura',
   'Jet 4.0',
   'Microsoft.Jet.OLEDB.4.0',
   'C:\GeneXus\modelos\ver90\Integros\documentacao\customizacoes\natura2012.xls',
   null,
   'Excel 5.0'

--Set up login mappings.
EXEC sp_addlinkedsrvlogin natura, FALSE, sa, NULL;
GO

select * from natura...dados$

/* VERIFICANDO O QUE ESTÁ DISPONÍVEL PARA NÓS */
EXEC sp_tables_ex natura
GO

sp_dropserver natura

EXEC sp_addlinkedsrvlogin 'Northwind', 'false',NULL,'ADMIN',NULL



--select * from TBS002 (nolock) where CLINOM Like('%NATURA%')

select * from TBS047 (nolock)
 where CLICOD in(select CLICOD from TBS002 (nolock)
                  where CLINOM Like('%NATURA%')) and
       not exists(select 'ne' from natura2012 (nolock) where TBS047.REQCDC = natura2012.matricula)

select * from TBS047 (nolock) where REQCDC = '88591'

select distinct CLICOD from TBS002 (nolock) where CLINOM Like('%NATURA%')

update TBS047 set REQLIMORC = margem
  from TBS047 (nolock) join natura2012 (nolock) on REQCDC = matricula
 where CLICOD in(select CLICOD from TBS002 (nolock) where CLINOM Like('%NATURA%'))


update TBS047 set REQCDC = Ltrim(REQCDC)

update natura2012 set matricula = Ltrim(matricula)

select * from TBS047 (nolock) join natura2012 (nolock) on REQCDC = matricula order by REQCDC

select * from natura2012 (nolock)
 where not exists(select 'ne' from TBS047 (nolock) where matricula = REQCDC and CLICOD in(select CLICOD from TBS002 (nolock) where CLINOM Like('%NATURA%')))

update TBS047 set REQLIMORC = 0


select distinct matricula from natura2012 

select * from natura2012 a
 where (select count(*) from natura2012 b where b.matricula = a.matricula) > 1
 order by matricula

select * from TBS047 a
 where (select count(*) from TBS047 b where b.REQCDC = a.REQCDC) > 1
 order by REQCDC

